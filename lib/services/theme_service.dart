import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static final ThemeService _instance = ThemeService._internal();
  factory ThemeService() => _instance;
  ThemeService._internal();

  bool _isDark = false;
  bool get isDark => _isDark;

  // ── Dark Mode Colors ──
  static const darkBg = Color(0xFF0F1923);        // Navy dark background
  static const darkCard = Color(0xFF1A2535);       // Card สีน้ำเงินเข้ม
  static const darkCardAlt = Color(0xFF1F2D3D);    // Card alt
  static const darkAccent = Color(0xFF2ECC71);     // เขียว bright
  static const darkAccentSoft = Color(0xFF27AE60); // เขียวนุ่ม
  static const darkText = Color(0xFFECF0F1);       // ขาวนวล
  static const darkSubText = Color(0xFF95A5A6);    // เทานุ่ม
  static const darkBorder = Color(0xFF2C3E50);     // ขอบ

  // ── Light Mode Colors ──
  static const lightBg = Color(0xFFF0F0F0);
  static const lightCard = Colors.white;
  static const lightText = Color(0xFF2C3E50);
  static const lightSubText = Color(0xFF7F8C8D);

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool('dark_mode') ?? false;
    notifyListeners();
  }

  Future<void> toggle() async {
    _isDark = !_isDark;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('dark_mode', _isDark);
    notifyListeners();
  }

  // ── Getters ──
  Color get bgColor => _isDark ? darkBg : lightBg;
  Color get cardColor => _isDark ? darkCard : lightCard;
  Color get cardAltColor => _isDark ? darkCardAlt : lightCard;
  Color get textColor => _isDark ? darkText : lightText;
  Color get subTextColor => _isDark ? darkSubText : lightSubText;
  Color get borderColor => _isDark ? darkBorder : Colors.transparent;
  Color get iconColor => _isDark ? darkAccent : const Color(0xFF1B5E20);
  Color get shadowColor => _isDark ? Colors.black54 : Colors.black12;

  ThemeData get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E20)),
    useMaterial3: true,
    scaffoldBackgroundColor: lightBg,
  );

  ThemeData get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF2ECC71),
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: darkBg,
    cardColor: darkCard,
  );
}