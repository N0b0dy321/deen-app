import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';
import 'services/theme_service.dart';
import 'services/language_service.dart';
import 'services/notification_service.dart';
import 'services/azan_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().init();
  await LanguageService().init();
  await NotificationService.init();
  await NotificationService.requestPermission();
  runApp(const MyApp());
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
    return MaterialApp(
      title: 'Deen',
      debugShowCheckedModeBanner: false,
      theme: _theme.lightTheme,
      darkTheme: _theme.darkTheme,
      themeMode: _theme.isDark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen(),
    );
  }
}