import 'package:flutter/material.dart';
import 'screen/splash_screen.dart';
import 'services/theme_service.dart';
import 'services/language_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ThemeService().init();
  await LanguageService().init();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _theme = ThemeService();
  final _lang = LanguageService();

  @override
  void initState() {
    super.initState();
    _theme.addListener(() => setState(() {}));
    _lang.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _theme.removeListener(() => setState(() {}));
    _lang.removeListener(() => setState(() {}));
    super.dispose();
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