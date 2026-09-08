import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'notification_service.dart';
import 'language_service.dart';
import 'location_service.dart';
import 'package:geocoding/geocoding.dart';

class PrayerService {
  static const String _cachePrefix = 'prayer_';
  static const String _lastFetchKey = 'prayer_last_fetch';
  // ── เก็บ cache ล่วงหน้ากี่วัน = ใช้งานออฟไลน์ได้กี่วันถ้าไม่มีเน็ตเลย
  // (เดิม 7 วัน ขยับเป็น 14 วันตามที่ต้องการความทนทานออฟไลน์มากขึ้น) ──
  static const int _prefetchDays = 14;

  // ── ล้าง cache ของ "วันที่ผ่านไปแล้ว" ทิ้ง ไม่เก็บสะสมไม่จำกัด ──
  // รันทุกครั้งที่เรียก getPrayerTimes() (ทั้ง fast path จาก cache และ path
  // ที่ต้อง fetch ใหม่) เพราะเป็นแค่เทียบสตริงวันที่ไม่กี่ตัว ไม่กินทรัพยากร
  // ใช้เทียบสตริงตรงๆ ได้เพราะ _dateKey คืนรูปแบบ YYYY-MM-DD (zero-padded)
  // ซึ่งเรียงลำดับตามตัวอักษรตรงกับลำดับเวลาพอดี
  //
  // เก็บ "เมื่อวาน" ไว้เผื่อ 1 วันเสมอ (ไม่ลบทันทีที่ข้ามวัน) เพราะ
  // _loadAnyCache() ด้านล่างใช้ cache ของวันก่อนๆ เป็น fallback ตอนที่
  // fetch ของวันนี้ล้มเหลว — ถ้าลบเมื่อวานทิ้งทันที fallback นี้จะไม่มี
  // อะไรให้ใช้เลยตอนเน็ตมีปัญหาพอดีตอนเปิดวันใหม่
  static Future<void> _cleanupOldCache(SharedPreferences prefs) async {
    final cutoffKey = _dateKey(DateTime.now().subtract(const Duration(days: 1)));
    final keysToRemove = prefs.getKeys().where((k) {
      if (!k.startsWith(_cachePrefix) || k == _lastFetchKey) return false;
      final dateStr = k.substring(_cachePrefix.length);
      return dateStr.compareTo(cutoffKey) < 0;
    }).toList();
    for (final key in keysToRemove) {
      await prefs.remove(key);
    }
    if (keysToRemove.isNotEmpty) {
      print('=== PrayerService: ล้าง cache เก่าทิ้ง ${keysToRemove.length} วัน ===');
    }
  }

  static Future<Map<String, dynamic>?> getPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    await _cleanupOldCache(prefs);
    final todayStr = _dateKey(DateTime.now());

    final cached = prefs.getString('$_cachePrefix$todayStr');
    if (cached != null) {
      final data = json.decode(cached) as Map<String, dynamic>;
      data['nextPrayer'] = calculateNextPrayer(data['timings']);
      data['currentPrayer'] = calculateCurrentPrayer(data['timings']);
      // เผื่อ cache เก่าก่อนมี field นี้ — fallback ธรรมดา ไม่เรียก GPS สด
      data['locationName'] ??= 'ตำแหน่งปัจจุบัน';

      // ── ตั้งแจ้งเตือนแบบไม่รอ (fire-and-forget) ──────────────────
      // เดิม await ตรงนี้ทำให้หน้าเวลาละหมาดต้อง "รอ" platform call ของ
      // การตั้งแจ้งเตือนเสร็จก่อนถึงจะโชว์ข้อมูลได้ ทั้งที่ error ก็แค่
      // print log เฉยๆ ไม่มีอะไรต้องรอผลจริงๆ — เอา await ออกให้ทำงาน
      // เบื้องหลังแทน หน้าจอจะได้ข้อมูลจาก cache ทันทีไม่ต้องรอ
      () async {
        try {
          final isThai = LanguageService().isThai;
          final timezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
          await NotificationService.schedulePrayerNotifications(
            timings: Map<String, dynamic>.from(data['timings']),
            timezone: timezone,
            isThai: isThai,
          );
        } catch (e) {
          print('NOTIFICATION SCHEDULE ERROR (cache): $e');
        }
      }();

      return data;
    }

    return await _fetchAndCache14Days(prefs);
  }

  static Future<Map<String, dynamic>?> _fetchAndCache14Days(
      SharedPreferences prefs) async {
    try {
      final timezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      final method = prefs.getString('method') ?? '3'; // Default: Muslim World League

      // ── หาพิกัดที่จะใช้คำนวณเวลาละหมาด ──────────────────────
      // ลำดับความสำคัญ:
      // 1. ตำแหน่งที่ user ค้นหา/เลือกเองใน Settings (LocationService) ถ้ามี
      // 2. ตำแหน่ง GPS ปัจจุบันของเครื่อง (พฤติกรรมเดิม)
      double latitude;
      double longitude;
      final manualLocation = await LocationService.getSavedLocation();

      if (manualLocation != null) {
        latitude = manualLocation['lat'] as double;
        longitude = manualLocation['lng'] as double;
      } else {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
          if (permission == LocationPermission.denied) return _loadAnyCache(prefs);
        }

        final position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        latitude = position.latitude;
        longitude = position.longitude;
      }

      final now = DateTime.now();
      Map<String, dynamic>? todayData;

      // ── หาชื่อตำแหน่ง "ครั้งเดียว" สำหรับรอบ fetch นี้ แล้วฝังไว้ในทุกวัน
      // ที่ cache ไปด้วยเลย กันปัญหาที่ตอนอ่านจาก cache ทีหลังต้องเรียก GPS +
      // reverse geocoding ใหม่ทุกครั้ง (ของเดิมไม่ได้เก็บ locationName ลง
      // cache blob เลย ทำให้ทุกครั้งที่เข้าหน้านี้ค่า cache ที่อ่านได้มี
      // locationName เป็น null เสมอ ต้องไปเรียก _resolveLocationName() สด
      // ซึ่งช้ามาก — นี่คือสาเหตุที่หน้ายังต้องโหลดทั้งที่ควรเร็วจาก cache) ──
      final locationName = manualLocation != null
          ? manualLocation['name'] as String
          : await _resolveLocationName();

      for (int i = 0; i < _prefetchDays; i++) {
        final date = now.add(Duration(days: i));
        final dateStr = _dateKey(date);

        if (prefs.containsKey('$_cachePrefix$dateStr')) {
          if (i == 0) {
            todayData = json.decode(prefs.getString('$_cachePrefix$dateStr')!);
          }
          continue;
        }

        // เมื่อใช้ตำแหน่งที่เลือกเอง ไม่ส่ง timezonestring ไป —
        // ให้ Aladhan API คำนวณ timezone ที่ถูกต้องจากพิกัดเอง
        // (กันปัญหาเลือกเมืองอื่นแล้วเวลาไม่ขยับเพราะยังใช้ timezone เดิมค้างอยู่)
        final tzParam = manualLocation != null ? '' : '&timezonestring=$timezone';

        final url = Uri.parse(
          'https://api.aladhan.com/v1/timings/${date.day}-${date.month}-${date.year}'
          '?latitude=$latitude'
          '&longitude=$longitude'
          '&method=$method'
          '$tzParam',
        );

        final response =
            await http.get(url).timeout(const Duration(seconds: 10));
        final data = json.decode(response.body);

        if (data['code'] == 200) {
          final dayData = {
            'timings': data['data']['timings'],
            'date': data['data']['date']['readable'],
            'timezone': timezone,
            'method': method,
            'locationName': locationName, // ← เก็บลง cache ด้วยเลย
          };
          await prefs.setString('$_cachePrefix$dateStr', json.encode(dayData));
          if (i == 0) todayData = dayData;
        }
      }

      await prefs.setString(_lastFetchKey, now.toIso8601String());

      if (todayData != null) {
        todayData['nextPrayer'] = calculateNextPrayer(todayData['timings']);
        todayData['currentPrayer'] = calculateCurrentPrayer(todayData['timings']);
        // ใช้ค่าที่หาไว้ครั้งเดียวข้างบนแล้ว ไม่เรียก _resolveLocationName() ซ้ำ
        // (??= เผื่อ todayData มาจาก cache เก่าก่อนมี field นี้)
        todayData['locationName'] ??= locationName;

        // ── Schedule Notifications ──
        // ห่อด้วย try-catch: ถ้าตั้งแจ้งเตือนไม่สำเร็จ (เช่น เสียงที่เลือกไว้หาไฟล์ไม่เจอ)
        // ไม่ควรทำให้การโหลดเวลาละหมาด/หน้าจอค้างไปด้วย
        try {
          final isThai = LanguageService().isThai;
          await NotificationService.schedulePrayerNotifications(
            timings: Map<String, dynamic>.from(todayData['timings']),
            timezone: todayData['timezone'] ?? 'Asia/Bangkok',
            isThai: isThai,
          );
        } catch (e) {
          print('NOTIFICATION SCHEDULE ERROR (fetch): $e');
        }

        return todayData;
      }

      return _loadAnyCache(prefs);
    } catch (e) {
      print('PRAYER ERROR: $e');
      return _loadAnyCache(prefs);
    }
  }

  /// หาชื่อตำแหน่งที่แสดงผลได้ในหน้า Home/Prayer Times
  /// ใช้ package geocoding (placemarkFromCoordinates) เพียงอย่างเดียว — ชื่อเมือง
  /// จะเป็นภาษาตามที่ระบบปฏิบัติการตั้งไว้ (ไม่ผูกกับภาษาที่เลือกในแอป เพราะ
  /// การแปลตามภาษาแอปแบบเป๊ะๆ ต้องใช้ Google Geocoding API ซึ่งบังคับต้องเปิด
  /// Billing บน Google Cloud ก่อน — ตัดสินใจไม่ผูกบัตรจึงใช้ fallback นี้แทน)
  static Future<String> _resolveLocationName() async {
    final manual = await LocationService.getSavedLocation();
    if (manual != null) return manual['name'] as String;

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );
      final placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        final parts = [p.locality, p.administrativeArea, p.country]
            .where((s) => s != null && s.isNotEmpty)
            .toList();
        if (parts.isNotEmpty) return parts.join(', ');
      }
    } catch (_) {}

    return 'ตำแหน่งปัจจุบัน';
  }

  static Map<String, dynamic> calculateNextPrayer(
      Map<String, dynamic> timings) {
    final prayers = [
      {'name': 'Fajr', 'time': timings['Fajr']},
      {'name': 'Dhuhr', 'time': timings['Dhuhr']},
      {'name': 'Asr', 'time': timings['Asr']},
      {'name': 'Maghrib', 'time': timings['Maghrib']},
      {'name': 'Isha', 'time': timings['Isha']},
    ];

    final now = DateTime.now();
    for (var prayer in prayers) {
      final parts = prayer['time']!.split(':');
      final prayerTime = DateTime(
        now.year, now.month, now.day,
        int.parse(parts[0]), int.parse(parts[1]),
      );
      if (prayerTime.isAfter(now)) {
        final diff = prayerTime.difference(now);
        final hours = diff.inHours;
        final minutes = diff.inMinutes % 60;
        return {
          'name': prayer['name'],
          'time': prayer['time'],
          'timeUntil': hours > 0 ? 'in ${hours}h ${minutes}m' : 'in ${minutes}m',
        };
      }
    }

    return {
      'name': 'Fajr',
      'time': timings['Fajr'],
      'timeUntil': 'Tomorrow',
    };
  }

  // ── หาว่า "ตอนนี้" อยู่ในช่วงเวลาละหมาดไหน ──────────────────
  // ต่างจาก calculateNextPrayer ที่หาละหมาด "ถัดไป" ตัวนี้หาว่าเรากำลังอยู่
  // ในช่วงเวลาของละหมาดตัวไหนอยู่ ณ ขณะนี้ (ตั้งแต่เวลาเริ่มของละหมาดนั้น
  // จนถึงก่อนเวลาเริ่มของละหมาดถัดไป)
  //
  // กรณีพิเศษที่ต้องระวัง:
  // 1. Sunrise ไม่ใช่เวลาละหมาด เป็นแค่จุดสิ้นสุดเวลาฟัจร์ ถ้าตอนนี้อยู่ในช่วง
  //    Sunrise ถึงก่อน Dhuhr (เวลาฎุฮา) ต้องบอกว่า isSunrise = true ให้ UI
  //    ไปโชว์ข้อความแยกต่างหาก ไม่ใช่โชว์ "ตอนนี้: Sunrise" เหมือนเป็นละหมาด
  // 2. ถ้าตอนนี้ยังไม่ถึงฟัจร์ของวันนี้เลย (ดึกๆ หลังเที่ยงคืน) แปลว่ายังอยู่
  //    ในช่วงเวลาอิชาอ์ที่ต่อเนื่องมาจากคืนก่อน — ใช้เวลา Isha ของวันนี้แทน
  //    เป็นค่าประมาณเวลาเริ่ม (เวลาละหมาดแทบไม่ขยับข้ามคืน ต่างกันแค่ 1-2 นาที)
  static Map<String, dynamic> calculateCurrentPrayer(
      Map<String, dynamic> timings) {
    final periods = [
      {'name': 'Fajr', 'time': timings['Fajr'], 'isSunrise': false},
      {'name': 'Sunrise', 'time': timings['Sunrise'], 'isSunrise': true},
      {'name': 'Dhuhr', 'time': timings['Dhuhr'], 'isSunrise': false},
      {'name': 'Asr', 'time': timings['Asr'], 'isSunrise': false},
      {'name': 'Maghrib', 'time': timings['Maghrib'], 'isSunrise': false},
      {'name': 'Isha', 'time': timings['Isha'], 'isSunrise': false},
    ];

    final now = DateTime.now();
    DateTime parseTime(String t) {
      final parts = t.split(':');
      return DateTime(now.year, now.month, now.day,
          int.parse(parts[0]), int.parse(parts[1]));
    }

    int currentIndex = -1;
    for (int i = 0; i < periods.length; i++) {
      final t = parseTime(periods[i]['time'] as String);
      if (!t.isAfter(now)) {
        currentIndex = i;
      } else {
        break;
      }
    }

    // ก่อนฟัจร์ของวันนี้ — ยังอยู่ในช่วงอิชาอ์ต่อเนื่องจากคืนก่อน
    if (currentIndex == -1) {
      return {
        'name': 'Isha',
        'startTime': periods.last['time'],
        'endTime': periods[0]['time'],
        'isSunrise': false,
      };
    }

    final current = periods[currentIndex];
    final endTime = currentIndex + 1 < periods.length
        ? periods[currentIndex + 1]['time']
        : periods[0]['time'];

    return {
      'name': current['name'],
      'startTime': current['time'],
      'endTime': endTime,
      'isSunrise': current['isSunrise'],
    };
  }

  static Map<String, dynamic>? _loadAnyCache(SharedPreferences prefs) {
    final todayStr = _dateKey(DateTime.now());
    final cached = prefs.getString('$_cachePrefix$todayStr');
    if (cached != null) {
      final data = json.decode(cached) as Map<String, dynamic>;
      data['nextPrayer'] = calculateNextPrayer(data['timings']);
      data['currentPrayer'] = calculateCurrentPrayer(data['timings']);
      data['locationName'] ??= 'ตำแหน่งปัจจุบัน'; // เผื่อ cache เก่าก่อนมีฟีเจอร์นี้
      data['isOffline'] = true;
      return data;
    }
    for (int i = 1; i <= 7; i++) {
      final dateStr = _dateKey(DateTime.now().subtract(Duration(days: i)));
      final old = prefs.getString('$_cachePrefix$dateStr');
      if (old != null) {
        final data = json.decode(old) as Map<String, dynamic>;
        data['nextPrayer'] = calculateNextPrayer(data['timings']);
        data['currentPrayer'] = calculateCurrentPrayer(data['timings']);
        data['locationName'] ??= 'ตำแหน่งปัจจุบัน';
        data['isOffline'] = true;
        return data;
      }
    }
    return null;
  }

  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    for (int i = -1; i <= 7; i++) {
      await prefs.remove('$_cachePrefix${_dateKey(now.add(Duration(days: i)))}');
    }
    await prefs.remove(_lastFetchKey);
  }

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}