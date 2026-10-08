import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screen/splash_screen.dart';
import 'services/theme_service.dart';
import 'services/language_service.dart';
import 'services/notification_service.dart';
import 'services/azan_service.dart';
import 'services/prayer_service.dart';
import 'services/quran_download_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().init();
  await LanguageService().init();
  await NotificationService.init();
  // ── เริ่มระบบดาวน์โหลดอัลกุรอาน offline แบบ background ──────────
  // ทำงานต่อเนื่องผ่าน Android WorkManager แม้ปิดแอปอยู่ ไม่ต้องเปิดค้างไว้
  // ที่หน้า Al-Quran เหมือนเดิมอีกต่อไป
  await QuranDownloadService.initialize();
  runApp(const MyApp());

  // ขอสิทธิ์แจ้งเตือน "หลัง" แอปขึ้นแล้ว (ไม่บล็อกการเปิดแอป) จากนั้นตั้งแจ้งเตือนใหม่
  // จาก cache ทันที ผู้ใช้ไม่ต้องเปิดหน้าเวลาละหมาดก่อนแจ้งเตือนถึงจะถูกตั้ง
  NotificationService.requestPermission()
      .then((_) => PrayerService.rescheduleNotifications());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _theme = ThemeService();
  final _lang = LanguageService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _theme.addListener(() => setState(() {}));
    _lang.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _theme.removeListener(() => setState(() {}));
    _lang.removeListener(() => setState(() {}));
    AzanService.dispose();
    super.dispose();
  }

  // ตรวจสอบ stop flag เมื่อแอพถูกเปิดขึ้นมา
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkStopFlag();
    }
  }

  Future<void> _checkStopFlag() async {
    await AzanService.checkAndHandleStopFlag();
  }

  @override
  Widget build(BuildContext context) {
    // ── ScreenUtilInit: จุดตั้งค่า "ขนาดจอต้นแบบ" ที่ทุกหน้าในแอปอ้างอิงตาม ──
    // designSize: ขนาดจอที่ตอนออกแบบ UI ไว้ (มาตรฐานทั่วไป ~iPhone 13/14)
    // ต่อไปนี้ทุกหน้าจะใช้ .w / .h / .sp / .r แทนตัวเลข px ตายตัว
    // แล้วระบบจะคำนวณสัดส่วนให้พอดีกับหน้าจอจริงของแต่ละเครื่องอัตโนมัติ
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      // สำคัญ: กัน LateInitializationError ตอนนำทางจากหน้า Splash ไปหน้าอื่น
      // ด้วย custom PageRouteBuilder — บังคับให้ ScreenUtil ดึงค่า MediaQuery
      // ผ่าน InheritedWidget ที่ sync กับ widget tree จริง แทนการ cache แบบ static
      // ที่อาจ race กับการนำทางเร็วๆ ได้
      useInheritedMediaQuery: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Deen',
          debugShowCheckedModeBanner: false,
          theme: _theme.lightTheme,
          darkTheme: _theme.darkTheme,
          themeMode: _theme.isDark ? ThemeMode.dark : ThemeMode.light,
          home: const SplashScreen(),
        );
      },
    );
  }
}