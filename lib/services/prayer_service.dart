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

  static Future<Map<String, dynamic>?> getPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final todayStr = _dateKey(DateTime.now());

    final cached = prefs.getString('$_cachePrefix$todayStr');
    if (cached != null) {
      final data = json.decode(cached) as Map<String, dynamic>;
      data['nextPrayer'] = calculateNextPrayer(data['timings']);
      data['locationName'] ??= await _resolveLocationName();

      // Schedule notifications จาก cache ด้วย
      // ห่อด้วย try-catch: ถ้าตั้งแจ้งเตือนไม่สำเร็จ (เช่น เสียงที่เลือกไว้หาไฟล์ไม่เจอ)
      // ไม่ควรทำให้การโหลดเวลาละหมาด/หน้าจอค้างไปด้วย
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

      return data;
    }

    return await _fetchAndCache7Days(prefs);
  }

  static Future<Map<String, dynamic>?> _fetchAndCache7Days(
      SharedPreferences prefs) async {
    try {
      final timezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      final method = prefs.getString('method') ?? '16';

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

      for (int i = 0; i < 7; i++) {
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
          };
          await prefs.setString('$_cachePrefix$dateStr', json.encode(dayData));
          if (i == 0) todayData = dayData;
        }
      }

      await prefs.setString(_lastFetchKey, now.toIso8601String());

      if (todayData != null) {
        todayData['nextPrayer'] = calculateNextPrayer(todayData['timings']);
        todayData['locationName'] = manualLocation != null
            ? manualLocation['name'] as String
            : await _resolveLocationName();

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

  static Map<String, dynamic>? _loadAnyCache(SharedPreferences prefs) {
    final todayStr = _dateKey(DateTime.now());
    final cached = prefs.getString('$_cachePrefix$todayStr');
    if (cached != null) {
      final data = json.decode(cached) as Map<String, dynamic>;
      data['nextPrayer'] = calculateNextPrayer(data['timings']);
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