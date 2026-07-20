import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'azan_service.dart';

// Background handler - เขียน stop flag ผ่าน SharedPreferences
@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  if (response.actionId == 'stop_azan') {
    // เขียน flag ให้ main isolate หยุดเสียง
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('azan_stop_flag', true);
    // ปิด notification
    await FlutterLocalNotificationsPlugin().cancel(response.id ?? 0);
  }
}

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();
  static bool _initialized = false;

  static const _channelId = 'prayer_channel';
  static const _channelName = 'Prayer Times';
  static const _channelDesc = 'Prayer time notifications';

  static const _prayers = [
    {'name': 'Fajr',    'nameAr': 'الفجر',  'nameTh': 'ฟัจร์',  'id': 1},
    {'name': 'Dhuhr',   'nameAr': 'الظهر',  'nameTh': 'ซุฮร์',  'id': 2},
    {'name': 'Asr',     'nameAr': 'العصر',  'nameTh': 'อัศร์',  'id': 3},
    {'name': 'Maghrib', 'nameAr': 'المغرب', 'nameTh': 'มัฆริบ', 'id': 4},
    {'name': 'Isha',    'nameAr': 'العشاء', 'nameTh': 'อิชาอ์', 'id': 5},
  ];

  // ── Init ──────────────────────────────────────────
  static Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(android: android, iOS: ios),
      onDidReceiveNotificationResponse: (response) async {
        if (response.actionId == 'stop_azan') {
          // อยู่ใน main isolate หยุดได้เลย
          await AzanService.stopAzan();
          await _plugin.cancel(response.id ?? 0);
        } else {
          await AzanService.playAzan();
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    _initialized = true;
  }

  // ── Request Permission ────────────────────────────
  static Future<void> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
  }

  // ── Notification Details ──────────────────────────
  static NotificationDetails _buildDetails(String body) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: Color(0xFF1B5E20),
        playSound: false,
        enableVibration: true,
        ongoing: false,
        autoCancel: false,
        styleInformation: BigTextStyleInformation(body),
        fullScreenIntent: true,
        actions: [
          AndroidNotificationAction(
            'stop_azan',
            '🔇 Stop Azan',
            cancelNotification: true,
            showsUserInterface: false,
          ),
        ],
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: false,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }

  // ── Schedule Notifications ────────────────────────
  static Future<void> schedulePrayerNotifications({
    required Map<String, dynamic> timings,
    required String timezone,
    required bool isThai,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final enabled = prefs.getBool('notification') ?? true;

    if (!enabled) {
      await cancelAll();
      return;
    }

    try {
      tz.setLocalLocation(tz.getLocation(timezone));
    } catch (_) {
      tz.setLocalLocation(tz.getLocation('Asia/Bangkok'));
    }

    await cancelAll();

    for (final prayer in _prayers) {
      final name = prayer['name'] as String;
      final nameAr = prayer['nameAr'] as String;
      final nameTh = prayer['nameTh'] as String;
      final id = prayer['id'] as int;
      final timeStr = timings[name] as String?;
      if (timeStr == null) continue;

      final parts = timeStr.split(':');
      if (parts.length < 2) continue;

      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;

      final now = tz.TZDateTime.now(tz.local);
      var scheduled = tz.TZDateTime(
        tz.local,
        now.year, now.month, now.day,
        hour, minute,
      );

      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      final title = isThai ? '🕌 $nameTh - $nameAr' : '🕌 $name - $nameAr';
      final body = isThai ? 'ถึงเวลา$nameTh แล้ว' : 'It\'s time for $name prayer';

      await _plugin.zonedSchedule(
        id, title, body, scheduled,
        _buildDetails(body),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    // Pre-download เสียงที่เลือก
    final azanId = await AzanService.getSelectedAzanId();
    if (!await AzanService.isDownloaded(azanId)) {
      try {
        final azan = AzanService.getAzanById(azanId);
        await AzanService.downloadAzan(id: azanId, url: azan['url']!);
      } catch (_) {}
    }
  }

  // ── Cancel All ────────────────────────────────────
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
    await AzanService.stopAzan();
  }

  // ── Test ──────────────────────────────────────────
  static Future<void> showTest() async {
    const body = 'การแจ้งเตือนทำงานปกติ ✅';
    await _plugin.show(99, '🕌 DEEN - Test', body, _buildDetails(body));
    await AzanService.playAzan();
  }
}