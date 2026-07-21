import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'notification_service.dart';
import 'language_service.dart';

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

      // Schedule notifications จาก cache ด้วย
      final isThai = LanguageService().isThai;
      final timezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      await NotificationService.schedulePrayerNotifications(
        timings: Map<String, dynamic>.from(data['timings']),
        timezone: timezone,
        isThai: isThai,
      );

      return data;
    }

    return await _fetchAndCache7Days(prefs);
  }

  static Future<Map<String, dynamic>?> _fetchAndCache7Days(
      SharedPreferences prefs) async {
    try {
      final timezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      final method = prefs.getString('method') ?? '16';

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return _loadAnyCache(prefs);
      }

      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

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

        final url = Uri.parse(
          'https://api.aladhan.com/v1/timings/${date.day}-${date.month}-${date.year}'
          '?latitude=${position.latitude}'
          '&longitude=${position.longitude}'
          '&method=$method'
          '&timezonestring=$timezone',
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

        // ── Schedule Notifications ──
        final isThai = LanguageService().isThai;
        await NotificationService.schedulePrayerNotifications(
          timings: Map<String, dynamic>.from(todayData['timings']),
          timezone: todayData['timezone'] ?? 'Asia/Bangkok',
          isThai: isThai,
        );

        return todayData;
      }

      return _loadAnyCache(prefs);
    } catch (e) {
      print('PRAYER ERROR: $e');
      return _loadAnyCache(prefs);
    }
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
      data['isOffline'] = true;
      return data;
    }
    for (int i = 1; i <= 7; i++) {
      final dateStr = _dateKey(DateTime.now().subtract(Duration(days: i)));
      final old = prefs.getString('$_cachePrefix$dateStr');
      if (old != null) {
        final data = json.decode(old) as Map<String, dynamic>;
        data['nextPrayer'] = calculateNextPrayer(data['timings']);
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