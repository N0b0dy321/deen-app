import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ── ตัวเลือกฟอนต์อัลกุรอาน (ใช้ร่วมกันทั้ง Settings และ Surah Detail) ──
// แต่ละฟอนต์มีสัดส่วนสระ/ระยะบรรทัดไม่เท่ากัน จึงเก็บ heightMultiplier
// และ fontWeight แยกต่อฟอนต์ เพื่อให้อ่านง่ายในทุกสไตล์
class QuranFontOption {
  final String id;
  final String label;
  final String description;
  final double heightMultiplier;
  final FontWeight weight;
  final TextStyle Function({
    required double fontSize,
    required double height,
    required Color color,
    required FontWeight weight,
  }) builder;

  const QuranFontOption({
    required this.id,
    required this.label,
    required this.description,
    required this.heightMultiplier,
    required this.weight,
    required this.builder,
  });

  TextStyle style({required double fontSize, required Color color}) {
    return builder(fontSize: fontSize, height: heightMultiplier, color: color, weight: weight);
  }
}

final List<QuranFontOption> kQuranFonts = [
  QuranFontOption(
    id: 'amiri',
    label: 'Amiri',
    description: 'สไตล์มุศฮัฟดั้งเดิม (Naskh คลาสสิก)',
    heightMultiplier: 2.2,
    weight: FontWeight.w500,
    builder: ({required fontSize, required height, required color, required weight}) =>
        GoogleFonts.amiri(fontSize: fontSize, height: height, color: color, fontWeight: weight),
  ),
  QuranFontOption(
    id: 'scheherazade',
    label: 'Scheherazade New',
    description: 'Naskh อ่านง่าย เส้นเรียบ',
    heightMultiplier: 2.4,
    weight: FontWeight.w500,
    builder: ({required fontSize, required height, required color, required weight}) =>
        GoogleFonts.scheherazadeNew(fontSize: fontSize, height: height, color: color, fontWeight: weight),
  ),
  QuranFontOption(
    id: 'notoNaskh',
    label: 'Noto Naskh Arabic',
    description: 'ทันสมัย อ่านง่ายที่สุด',
    heightMultiplier: 2.0,
    weight: FontWeight.w500,
    builder: ({required fontSize, required height, required color, required weight}) =>
        GoogleFonts.notoNaskhArabic(fontSize: fontSize, height: height, color: color, fontWeight: weight),
  ),
];

// ── SharedPreferences keys (ใช้ร่วมกันทุกหน้า) ──────────────────
const String kQuranFontPrefKey = 'quran_font';
const String kQuranFontDefault = 'amiri';

const String kQuranFontSizePrefKey = 'quran_font_size';
const double kQuranFontSizeDefault = 24.0;
const double kQuranFontSizeMin = 16.0;
const double kQuranFontSizeMax = 36.0;

QuranFontOption getQuranFont(String id) {
  return kQuranFonts.firstWhere((f) => f.id == id, orElse: () => kQuranFonts.first);
}