import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class PrayerService {
  static Future<Map<String, dynamic>?> getPrayerTimes() async {
    try {
      // โหลด settings
      final prefs = await SharedPreferences.getInstance();
      final timezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      final method = prefs.getString('method') ?? '16';

      // ขอ GPS
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final url = Uri.parse(
        'https://api.aladhan.com/v1/timings'
        '?latitude=${position.latitude}'
        '&longitude=${position.longitude}'
        '&method=$method'
        '&timezonestring=$timezone',
      );

      final response = await http.get(url);
      final data = json.decode(response.body);

      if (data['code'] == 200) {
        final timings = data['data']['timings'];
        final date = data['data']['date']['readable'];

        final prayers = [
          {'name': 'Fajr', 'time': timings['Fajr']},
          {'name': 'Dhuhr', 'time': timings['Dhuhr']},
          {'name': 'Asr', 'time': timings['Asr']},
          {'name': 'Maghrib', 'time': timings['Maghrib']},
          {'name': 'Isha', 'time': timings['Isha']},
        ];

        final now = DateTime.now();
        Map<String, dynamic>? nextPrayer;

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
            nextPrayer = {
              'name': prayer['name'],
              'time': prayer['time'],
              'timeUntil': hours > 0
                  ? 'in ${hours}h ${minutes}m'
                  : 'in ${minutes}m',
            };
            break;
          }
        }

        nextPrayer ??= {
          'name': 'Fajr',
          'time': timings['Fajr'],
          'timeUntil': 'Tomorrow',
        };

        return {
          'timings': timings,
          'date': date,
          'nextPrayer': nextPrayer,
          'prayers': prayers,
          'timezone': timezone,
          'method': method,
        };
      }
      return null;
    } catch (e) {
      print('PRAYER ERROR: $e');
      return null;
    }
  }
}