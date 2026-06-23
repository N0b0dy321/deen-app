import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PrayerService {
  static const String _cachePrefix = 'prayer_';
  static const String _lastFetchKey = 'prayer_last_fetch';

  // ดึงเวลาละหมาดของวันนี้
  static Future<Map<String, dynamic>?> getPrayerTimes() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayStr = _dateKey(today);

    // เช็ค cache วันนี้ก่อน
    final cached = prefs.getString('$_cachePrefix$todayStr');
    if (cached != null) {
      final data = json.decode(cached) as Map<String, dynamic>;
      data['nextPrayer'] = _calculateNextPrayer(data['timings']);
      return data;
    }

    // ไม่มี cache ดึงจาก API
    return await _fetchAndCache7Days(prefs);
  }

  // ดึง 7 วันล่วงหน้าแล้วบันทึกทั้งหมด
  static Future<Map<String, dynamic>?> _fetchAndCache7Days(SharedPreferences prefs) async {
    try {
      final timezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      final method = prefs.getString('method') ?? '16';

      // ขอ GPS
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return _loadAnyCache(prefs);
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final now = DateTime.now();
      Map<String, dynamic>? todayData;

      // ดึงทีละวัน 7 วัน
      for (int i = 0; i < 7; i++) {
        final date = now.add(Duration(days: i));
        final dateStr = _dateKey(date);

        // ข้ามถ้ามี cache แล้ว
        if (prefs.containsKey('$_cachePrefix$dateStr')) {
          if (i == 0) {
            final cached = prefs.getString('$_cachePrefix$dateStr')!;
            todayData = json.decode(cached);
          }
          continue;
        }

        final url = Uri.parse(
          'https://api.aladhan.com/v1/timings/${date.day}-${date.month}-${date.year}'
          '?latitude=${position.latitude}'
          '&longitude=${position.longitude}'
          '&method=$method'
          '&timezonestring=$timezone',
        );

        final response = await http.get(url).timeout(const Duration(seconds: 10));
        final data = json.decode(response.body);

        if (data['code'] == 200) {
          final timings = data['data']['timings'];
          final dateReadable = data['data']['date']['readable'];

          final dayData = {
            'timings': timings,
            'date': dateReadable,
            'timezone': timezone,
            'method': method,
          };

          // บันทึก cache แต่ละวัน
          await prefs.setString('$_cachePrefix$dateStr', json.encode(dayData));

          if (i == 0) todayData = dayData;
        }
      }

      await prefs.setString(_lastFetchKey, now.toIso8601String());

      if (todayData != null) {
        todayData['nextPrayer'] = _calculateNextPrayer(todayData['timings']);
        return todayData;
      }

      return _loadAnyCache(prefs);
    } catch (e) {
      print('PRAYER ERROR: $e');
      return _loadAnyCache(prefs);
    }
  }

  // คำนวณ nextPrayer
  static Map<String, dynamic> _calculateNextPrayer(Map<String, dynamic> timings) {
    final prayers = [
      {'name': 'Fajr', 'time': timings['Fajr']},
      {'name': 'Dhuhr', 'time': timings['Dhuhr']},
      {'name': 'Asr', 'time': timings['Asr']},
      {'name': 'Maghrib', 'time': timings['Maghrib']},
      {'name': 'Isha', 'time': timings['Isha']},
    ];

    final now = DateTime.now();

    for (var prayer in prayers) {
      final timeParts = prayer['time']!.split(':');
      final prayerTime = DateTime(
        now.year, now.month, now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
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

  // โหลด cache ใดก็ได้ที่มี (กรณีออฟไลน์)
  static Map<String, dynamic>? _loadAnyCache(SharedPreferences prefs) {
    final todayStr = _dateKey(DateTime.now());
    final cached = prefs.getString('$_cachePrefix$todayStr');
    if (cached != null) {
      final data = json.decode(cached) as Map<String, dynamic>;
      data['nextPrayer'] = _calculateNextPrayer(data['timings']);
      data['isOffline'] = true;
      return data;
    }

    // ลองหา cache วันอื่น
    for (int i = 1; i <= 7; i++) {
      final date = DateTime.now().subtract(Duration(days: i));
      final dateStr = _dateKey(date);
      final old = prefs.getString('$_cachePrefix$dateStr');
      if (old != null) {
        final data = json.decode(old) as Map<String, dynamic>;
        data['nextPrayer'] = _calculateNextPrayer(data['timings']);
        data['isOffline'] = true;
        return data;
      }
    }
    return null;
  }

  // ล้าง cache ทั้งหมด (เรียกตอน settings เปลี่ยน)
  static Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    for (int i = -1; i <= 7; i++) {
      final date = now.add(Duration(days: i));
      await prefs.remove('$_cachePrefix${_dateKey(date)}');
    }
    await prefs.remove(_lastFetchKey);
  }

  static String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}