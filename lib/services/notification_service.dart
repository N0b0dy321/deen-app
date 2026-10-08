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

  static const _channelId = 'prayer_v2';
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

    // สร้าง channel ของทุกเสียงไว้ล่วงหน้า "ครั้งเดียว" (ไม่ลบ/สร้างใหม่ทุกครั้งอีก)
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    for (final azan in AzanService.azanList) {
      final sound = azan['id']!;
      try {
        await androidPlugin?.createNotificationChannel(AndroidNotificationChannel(
          '${_channelId}_$sound',
          _channelName,
          description: _channelDesc,
          importance: Importance.max,
          playSound: true,
          sound: RawResourceAndroidNotificationSound(sound),
          enableVibration: true,
        ));
      } catch (e) {
        print('CREATE CHANNEL ERROR ($sound): $e');
      }
    }
    _initialized = true;
  }

  /// ขอสิทธิ์แจ้งเตือน (Android 13+) และสิทธิ์ตั้งปลุกตรงเวลา (Android 12+)
  /// สิทธิ์ปลุกตรงเวลาจะเปิดหน้าตั้งค่าเฉพาะตอนที่ยังไม่ได้อนุญาตเท่านั้น
  static Future<void> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;
    try {
      await android.requestNotificationsPermission();
      final canExact = await android.canScheduleExactNotifications() ?? true;
      if (!canExact) {
        await android.requestExactAlarmsPermission();
      }
    } catch (e) {
      print('REQUEST PERMISSION ERROR: $e');
    }
  }

  /// เช็คว่าผู้ใช้ปิดแจ้งเตือนของแอปในระบบไว้หรือไม่ (ใช้เตือนในหน้าตั้งค่าได้)
  static Future<bool> areNotificationsAllowed() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await android?.areNotificationsEnabled() ?? true;
  }

  // ── Build details with azan sound ────────────────
  // เสียงทั้งหมด (Makkah, Madinah, Al-Aqsa) เป็น raw resource ที่ bundle มากับแอป
  // ไฟล์อยู่ที่ android/app/src/main/res/raw/<sound>.mp3
  static NotificationDetails _buildDetails(String body, {required String sound}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        '${_channelId}_$sound', // channel แยกตามเสียง
        _channelName,
        channelDescription: _channelDesc,
        importance: Importance.max,
        priority: Priority.high,
        icon: '@mipmap/ic_launcher',
        color: const Color(0xFF1B5E20),
        sound: RawResourceAndroidNotificationSound(sound),
        playSound: true,
        enableVibration: true,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.public,
        styleInformation: BigTextStyleInformation(body),
        actions: const [
          AndroidNotificationAction(
            'stop_azan',
            'Stop',
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

  // กันการเรียกซ้อนกัน (เช่น เปิดแอป + เปิดหน้าละหมาดพร้อมกัน) ให้ทำทีละรอบ
  static Future<void> _lock = Future.value();

  /// ตั้งแจ้งเตือนวันนี้วันเดียว (คงไว้เพื่อให้โค้ดเดิมยังเรียกได้)
  static Future<void> schedulePrayerNotifications({
    required Map<String, dynamic> timings,
    required String timezone,
    required bool isThai,
  }) {
    final now = DateTime.now();
    final key = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    return scheduleUpcomingNotifications(
      daysTimings: {key: timings},
      timezone: timezone,
      isThai: isThai,
    );
  }

  /// ตั้งแจ้งเตือนล่วงหน้าหลายวันในครั้งเดียว (ไม่ซ้ำรายวันแบบเดิม)
  /// daysTimings: คีย์ 'YYYY-MM-DD' -> timings ของวันนั้น
  /// ทำให้แจ้งเตือนยังเด้งตรงเวลาจริงของแต่ละวัน แม้ผู้ใช้ไม่เปิดแอปหลายวัน
  static Future<void> scheduleUpcomingNotifications({
    required Map<String, Map<String, dynamic>> daysTimings,
    required String timezone,
    required bool isThai,
  }) {
    final run = _lock.then((_) => _doSchedule(daysTimings, timezone, isThai));
    _lock = run.catchError((_) {});
    return run;
  }

  static Future<void> _doSchedule(
    Map<String, Map<String, dynamic>> daysTimings,
    String timezone,
    bool isThai,
  ) async {
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

    final selectedAzan = await AzanService.getSelectedAzanId();

    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    final canExact = await androidPlugin?.canScheduleExactNotifications() ?? true;
    final mode = canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    if (!canExact) {
      print('=== NO EXACT ALARM PERMISSION: ใช้โหมดไม่ตรงเวลาเป๊ะแทน ===');
    }

    final now = tz.TZDateTime.now(tz.local);
    final todayStart = tz.TZDateTime(tz.local, now.year, now.month, now.day);

    final keys = daysTimings.keys.toList()..sort();
    int count = 0;

    for (final dayKey in keys) {
      final dp = dayKey.split('-');
      if (dp.length != 3) continue;
      final y = int.tryParse(dp[0]);
      final m = int.tryParse(dp[1]);
      final d = int.tryParse(dp[2]);
      if (y == null || m == null || d == null) continue;

      final dayIndex = tz.TZDateTime(tz.local, y, m, d).difference(todayStart).inDays;
      if (dayIndex < 0 || dayIndex > 13) continue;

      final timings = daysTimings[dayKey]!;

      for (final prayer in _prayers) {
        final name = prayer['name'] as String;
        final nameAr = prayer['nameAr'] as String;
        final nameTh = prayer['nameTh'] as String;
        final prayerId = prayer['id'] as int;

        final raw = timings[name]?.toString();
        if (raw == null) continue;
        // รองรับรูปแบบ "05:12" และ "05:12 (+07)"
        final match = RegExp(r'(\d{1,2}):(\d{2})').firstMatch(raw);
        if (match == null) continue;
        final hour = int.parse(match.group(1)!);
        final minute = int.parse(match.group(2)!);

        final scheduled = tz.TZDateTime(tz.local, y, m, d, hour, minute);
        if (!scheduled.isAfter(now)) continue; // เวลาที่ผ่านไปแล้วข้าม

        final title = isThai ? '🕌 $nameTh - $nameAr' : '🕌 $name - $nameAr';
        final timeLabel =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        final body = isThai
            ? 'ถึงเวลา$nameTh แล้ว • $timeLabel น.'
            : 'It\'s time for $name prayer • $timeLabel';
        final details = _buildDetails(body, sound: selectedAzan);
        final id = dayIndex * 10 + prayerId;

        try {
          await _plugin.zonedSchedule(
            id, title, body, scheduled, details,
            androidScheduleMode: mode,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
          );
          count++;
        } catch (e) {
          // ถ้าโหมดตรงเวลาถูกปฏิเสธ ลองใหม่แบบไม่ตรงเวลาเป๊ะ ดีกว่าไม่แจ้งเตือนเลย
          print('SCHEDULE ERROR ($name $dayKey): $e');
          try {
            await _plugin.zonedSchedule(
              id, title, body, scheduled, details,
              androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
              uiLocalNotificationDateInterpretation:
                  UILocalNotificationDateInterpretation.absoluteTime,
            );
            count++;
          } catch (e2) {
            print('SCHEDULE RETRY ERROR ($name $dayKey): $e2');
          }
        }
      }
    }

    print('=== SCHEDULED $count PRAYER NOTIFICATIONS ===');
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static Future<void> showTest() async {
    final selectedAzan = await AzanService.getSelectedAzanId();

    const body = 'การแจ้งเตือนทำงานปกติ ✅';
    final details = _buildDetails(body, sound: selectedAzan);
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

    print('=== SCHEDULING TEST FOR: $scheduled ===');

    final details = _buildDetails(
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