import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'azan_service.dart';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse response) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('azan_stop_flag', true);
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
        await AzanService.stopAzan();
        await _plugin.cancel(response.id ?? 0);
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
    _initialized = true;
  }

  static Future<void> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestNotificationsPermission();
    await android?.requestExactAlarmsPermission();
  }

  // ── Build details with azan sound ────────────────
  // เสียงทั้งหมด (Makkah, Madinah, Al-Aqsa) เป็น raw resource ที่ bundle มากับแอป
  // ไฟล์อยู่ที่ android/app/src/main/res/raw/<sound>.mp3
  static Future<NotificationDetails> _buildDetails(
    String body, {
    String sound = 'azan_makkah',
  }) async {
    final soundObj = RawResourceAndroidNotificationSound(sound);

    return NotificationDetails(
      android: AndroidNotificationDetails(
        '${_channelId}_$sound', // channel แยกตามเสียง
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFF1B5E20),
        sound: soundObj,
        playSound: true,
        enableVibration: true,
        ongoing: false,
        autoCancel: true,
        styleInformation: BigTextStyleInformation(body),
        fullScreenIntent: true,
        actions: const [
          AndroidNotificationAction(
            'stop_azan',
            '🔇 Stop',
            cancelNotification: true,
            showsUserInterface: false,
          ),
        ],
      ),
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        interruptionLevel: InterruptionLevel.timeSensitive,
      ),
    );
  }

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

    // ดึงเสียงที่เลือก
    final selectedAzan = await AzanService.getSelectedAzanId();

    // ── ลบ channel เก่าทิ้งก่อนเสมอ ──────────────────────────
    // Android จะ "ล็อก" เสียงของ notification channel ไว้ถาวรตั้งแต่ครั้งแรกที่สร้าง
    // (แก้เสียงทีหลังไม่ได้ ต้องลบแล้วสร้างใหม่เท่านั้น) เพราะ channel id ผูกกับชื่อเสียง
    // (${_channelId}_$sound) ถ้าเคยสร้าง channel นี้มาก่อนด้วยเสียงที่ error/fallback
    // ก็ต้องลบทิ้งเพื่อให้สร้างใหม่ด้วยเสียงที่ถูกต้อง
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.deleteNotificationChannel('${_channelId}_$selectedAzan');

    final now = tz.TZDateTime.now(tz.local);
    print('=== NOW: $now ===');

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

      var scheduled = tz.TZDateTime(
        tz.local,
        now.year, now.month, now.day,
        hour, minute,
      );

      if (scheduled.isBefore(now)) {
        scheduled = scheduled.add(const Duration(days: 1));
      }

      print('=== SCHEDULING $name at $scheduled ===');

      final title = isThai ? '🕌 $nameTh - $nameAr' : '🕌 $name - $nameAr';
      final body = isThai ? 'ถึงเวลา$nameTh แล้ว' : 'It\'s time for $name prayer';

      final details = await _buildDetails(body, sound: selectedAzan);

      await _plugin.zonedSchedule(
        id, title, body, scheduled,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }

    print('=== ALL PRAYERS SCHEDULED ===');
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> showTest() async {
    final selectedAzan = await AzanService.getSelectedAzanId();

    // ลบ channel เก่าทิ้งก่อน กันเสียงค้างจากรอบก่อนหน้า (ดูคำอธิบายใน schedulePrayerNotifications)
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.deleteNotificationChannel('${_channelId}_$selectedAzan');

    const body = 'การแจ้งเตือนทำงานปกติ ✅';
    final details = await _buildDetails(body, sound: selectedAzan);
    await _plugin.show(
      99,
      '🕌 DEEN - Test',
      body,
      details,
    );
  }

  static Future<void> scheduleTestIn1Min() async {
    final now = tz.TZDateTime.now(tz.local);
    final scheduled = now.add(const Duration(minutes: 1));
    final selectedAzan = await AzanService.getSelectedAzanId();

    // ลบ channel เก่าทิ้งก่อน กันเสียงค้างจากรอบก่อนหน้า
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.deleteNotificationChannel('${_channelId}_$selectedAzan');

    print('=== SCHEDULING TEST FOR: $scheduled ===');

    final details = await _buildDetails(
      'การแจ้งเตือนแบบ schedule ทำงานปกติ ✅',
      sound: selectedAzan,
    );

    await _plugin.zonedSchedule(
      98,
      '🕌 DEEN - Scheduled Test',
      'การแจ้งเตือนแบบ schedule ทำงานปกติ ✅',
      scheduled,
      details,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    print('=== TEST SCHEDULED DONE ===');
  }
}