import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AzanService {
  static const String _selectedAzanKey = 'selected_azan';

  // รายชื่อเสียงอาซาน (ชื่อต้องตรงกับไฟล์ใน android/app/src/main/res/raw/)
  static const List<Map<String, String>> azanList = [
    {
      'id': 'azan_makkah',
      'name': 'Makkah',
      'nameTh': 'มักกะห์',
    },
    // เพิ่มเสียงอื่นๆ ได้ที่นี่เมื่อมีไฟล์
    // {
    //   'id': 'azan_madinah',
    //   'name': 'Madinah',
    //   'nameTh': 'มาดีนะห์',
    // },
  ];

  static Future<String> getSelectedAzanId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedAzanKey) ?? 'azan_makkah';
  }

  static Future<void> setSelectedAzan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedAzanKey, id);
  }

  static Map<String, String> getAzanById(String id) {
    return azanList.firstWhere(
      (a) => a['id'] == id,
      orElse: () => azanList[0],
    );
  }

  // ── Stop flag via SharedPreferences ───────────────
  static Future<void> requestStop() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('azan_stop_flag', true);
  }

  static Future<void> stopAzan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('azan_stop_flag');
  }

  static Future<void> checkAndHandleStopFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldStop = prefs.getBool('azan_stop_flag') ?? false;
    if (shouldStop) {
      await stopAzan();
    }
  }

  static void dispose() {}
}