import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/quran_database.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/quran_font_service.dart';
import '../services/quran_audio_cache_service.dart';

// ── ลายมุมดาวทอง + เส้นคั่นลายดอกไม้ (ไฟล์เดียวกับที่ใช้ในหน้ารายการซูเราะห์
// AlQuranPage) ใช้ตกแต่งหน้ามุศฮัฟให้เข้าชุดเดียวกันทั้งหมวดอัลกุรอาน ──
const String kMushafCornerAsset = 'image/decor/corner_star.png';
const String kMushafDividerAsset = 'image/decor/flower_divider.png';

List<Widget> _mushafCornerDecor({double size = 34}) {
  Widget img() => Image.asset(kMushafCornerAsset, width: size, height: size,
      errorBuilder: (_, __, ___) => const SizedBox.shrink());
  Widget flip(double sx, double sy, Widget child) => Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(sx, sy, 1),
      child: child);
  return [
    Positioned(top: 6, left: 6, child: img()),
    Positioned(top: 6, right: 6, child: flip(-1, 1, img())),
    Positioned(bottom: 6, left: 6, child: flip(1, -1, img())),
    Positioned(bottom: 6, right: 6, child: flip(-1, -1, img())),
  ];
}

// ── แปลงเลขอารบิก 0-9 (Western) เป็นเลขอินเดีย-อารบิก (Arabic-Indic) ──
// ใช้กับเลขอายะห์ในสัญลักษณ์ปิดท้ายอายะห์ ให้ตรงกับรูปแบบมุศฮัฟจริง
const List<String> _arabicIndicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];

String _toArabicIndic(int number) {
  return number.toString().split('').map((d) => _arabicIndicDigits[int.parse(d)]).join();
}

// ── สัญลักษณ์ปิดท้ายอายะห์ (۝) ──────────────────────────────
// ใส่เลขอายะห์แบบอารบิก-อินเดียไว้ตรงกลางของกราฟิกดอกไม้ 8 กลีบ
// (วาดด้วย _AyahOrnamentPainter ด้านล่าง แทนวงกลมเรียบๆ แบบเดิม)
class _AyahEndMarker extends StatelessWidget {
  final int verseNumber;
  final Color accentColor;
  final QuranFontOption fontOption;

  const _AyahEndMarker({required this.verseNumber, required this.accentColor, required this.fontOption});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: SizedBox(
        width: 30.w,
        height: 30.h,
        child: Stack(alignment: Alignment.center, children: [
          CustomPaint(
            size: Size(30.w, 30.h),
            painter: _AyahOrnamentPainter(accentColor),
          ),
          Text(
            _toArabicIndic(verseNumber),
            textDirection: TextDirection.rtl,
            style: fontOption.builder(
              fontSize: 10.sp,
              height: 1.0,
              color: accentColor,
              weight: FontWeight.bold,
            ),
          ),
        ]),
      ),
    );
  }
}

// ── สัญลักษณ์ปิดท้ายอายะห์ (จุดสิ้นสุดอายะห์) ตาม Unicode U+06DD จริง ──
// วาดด้วย CustomPainter จาก path ต้นฉบับของฟอนต์ Scheherazade (แปลงจาก SVG
// path data เป็น Flutter Path โดยตรง) แทนวงกลมเรียบๆ แบบเดิม เพื่อให้ตรงกับ
// รูปดอกไม้ 8 กลีบที่ใช้ในมุศฮัฟจริง ไม่ใช้ font-dependent shaping เพื่อความ
// แน่นอนของรูปทรงในทุกอุปกรณ์
class _AyahOrnamentPainter extends CustomPainter {
  final Color color;
  _AyahOrnamentPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
        ..moveTo(1248.00, 4.00)
        ..quadraticBezierTo(1206.00, -3.00, 1181.50, -11.00)
        ..quadraticBezierTo(1157.00, -19.00, 1138.00, -30.50)
        ..quadraticBezierTo(1119.00, -42.00, 1099.50, -59.50)
        ..quadraticBezierTo(1080.00, -77.00, 1047.00, -103.00)
        ..quadraticBezierTo(979.00, -159.00, 919.50, -189.00)
        ..quadraticBezierTo(860.00, -219.00, 803.00, -238.00)
        ..quadraticBezierTo(764.00, -251.00, 738.50, -267.00)
        ..quadraticBezierTo(713.00, -283.00, 694.00, -304.00)
        ..quadraticBezierTo(675.00, -325.00, 659.50, -351.00)
        ..quadraticBezierTo(644.00, -377.00, 625.00, -410.00)
        ..quadraticBezierTo(606.00, -377.00, 590.50, -351.00)
        ..quadraticBezierTo(575.00, -325.00, 556.00, -304.00)
        ..quadraticBezierTo(537.00, -283.00, 511.50, -267.00)
        ..quadraticBezierTo(486.00, -251.00, 447.00, -238.00)
        ..quadraticBezierTo(390.00, -219.00, 330.50, -189.00)
        ..quadraticBezierTo(271.00, -159.00, 203.00, -103.00)
        ..quadraticBezierTo(170.00, -77.00, 150.50, -59.50)
        ..quadraticBezierTo(131.00, -42.00, 112.00, -30.50)
        ..quadraticBezierTo(93.00, -19.00, 68.00, -11.00)
        ..quadraticBezierTo(43.00, -3.00, 0.00, 4.00)
        ..quadraticBezierTo(29.00, 38.00, 59.50, 61.50)
        ..quadraticBezierTo(90.00, 85.00, 125.00, 92.00)
        ..quadraticBezierTo(77.00, 163.00, 52.00, 246.50)
        ..quadraticBezierTo(27.00, 330.00, 27.00, 421.00)
        ..quadraticBezierTo(27.00, 514.00, 52.00, 597.00)
        ..quadraticBezierTo(77.00, 680.00, 125.00, 751.00)
        ..quadraticBezierTo(90.00, 759.00, 59.50, 782.00)
        ..quadraticBezierTo(29.00, 805.00, 0.00, 839.00)
        ..quadraticBezierTo(43.00, 847.00, 68.00, 855.00)
        ..quadraticBezierTo(93.00, 863.00, 112.00, 874.50)
        ..quadraticBezierTo(131.00, 886.00, 150.50, 903.50)
        ..quadraticBezierTo(170.00, 921.00, 203.00, 948.00)
        ..quadraticBezierTo(271.00, 1001.00, 330.50, 1032.00)
        ..quadraticBezierTo(390.00, 1063.00, 447.00, 1083.00)
        ..quadraticBezierTo(486.00, 1095.00, 511.50, 1111.00)
        ..quadraticBezierTo(537.00, 1127.00, 556.00, 1147.50)
        ..quadraticBezierTo(575.00, 1168.00, 590.50, 1194.50)
        ..quadraticBezierTo(606.00, 1221.00, 625.00, 1255.00)
        ..quadraticBezierTo(644.00, 1221.00, 659.50, 1194.50)
        ..quadraticBezierTo(675.00, 1168.00, 694.00, 1147.50)
        ..quadraticBezierTo(713.00, 1127.00, 738.50, 1111.00)
        ..quadraticBezierTo(764.00, 1095.00, 803.00, 1083.00)
        ..quadraticBezierTo(860.00, 1063.00, 920.00, 1032.00)
        ..quadraticBezierTo(980.00, 1001.00, 1047.00, 948.00)
        ..quadraticBezierTo(1080.00, 921.00, 1099.50, 903.50)
        ..quadraticBezierTo(1119.00, 886.00, 1138.00, 874.50)
        ..quadraticBezierTo(1157.00, 863.00, 1181.50, 855.00)
        ..quadraticBezierTo(1206.00, 847.00, 1248.00, 839.00)
        ..quadraticBezierTo(1220.00, 805.00, 1190.00, 782.00)
        ..quadraticBezierTo(1160.00, 759.00, 1125.00, 751.00)
        ..quadraticBezierTo(1173.00, 680.00, 1198.00, 597.00)
        ..quadraticBezierTo(1223.00, 514.00, 1223.00, 421.00)
        ..quadraticBezierTo(1223.00, 330.00, 1198.00, 246.50)
        ..quadraticBezierTo(1173.00, 163.00, 1125.00, 92.00)
        ..quadraticBezierTo(1160.00, 85.00, 1190.00, 61.50)
        ..quadraticBezierTo(1220.00, 38.00, 1248.00, 4.00)
        ..close()
        ..moveTo(1172.00, 815.00)
        ..quadraticBezierTo(1149.00, 823.00, 1129.50, 834.00)
        ..quadraticBezierTo(1110.00, 845.00, 1092.00, 858.00)
        ..quadraticBezierTo(1074.00, 871.00, 1057.00, 885.50)
        ..quadraticBezierTo(1040.00, 900.00, 1022.00, 915.00)
        ..quadraticBezierTo(957.00, 969.00, 901.00, 997.00)
        ..quadraticBezierTo(845.00, 1025.00, 791.00, 1044.00)
        ..quadraticBezierTo(759.00, 1055.00, 734.50, 1067.50)
        ..quadraticBezierTo(710.00, 1080.00, 691.00, 1096.00)
        ..quadraticBezierTo(672.00, 1112.00, 656.00, 1131.50)
        ..quadraticBezierTo(640.00, 1151.00, 625.00, 1175.00)
        ..quadraticBezierTo(610.00, 1151.00, 594.00, 1131.50)
        ..quadraticBezierTo(578.00, 1112.00, 559.00, 1096.00)
        ..quadraticBezierTo(540.00, 1080.00, 515.50, 1067.50)
        ..quadraticBezierTo(491.00, 1055.00, 459.00, 1044.00)
        ..quadraticBezierTo(405.00, 1025.00, 349.00, 997.00)
        ..quadraticBezierTo(293.00, 969.00, 228.00, 915.00)
        ..quadraticBezierTo(210.00, 900.00, 193.00, 885.50)
        ..quadraticBezierTo(176.00, 871.00, 158.00, 858.00)
        ..quadraticBezierTo(140.00, 845.00, 120.50, 834.00)
        ..quadraticBezierTo(101.00, 823.00, 78.00, 815.00)
        ..quadraticBezierTo(100.00, 799.00, 121.50, 793.50)
        ..quadraticBezierTo(143.00, 788.00, 164.00, 790.50)
        ..quadraticBezierTo(185.00, 793.00, 206.00, 802.50)
        ..quadraticBezierTo(227.00, 812.00, 248.00, 825.00)
        ..quadraticBezierTo(257.00, 814.00, 269.50, 801.00)
        ..quadraticBezierTo(282.00, 788.00, 297.00, 788.00)
        ..quadraticBezierTo(305.00, 788.00, 319.50, 801.50)
        ..quadraticBezierTo(334.00, 815.00, 354.50, 831.00)
        ..quadraticBezierTo(375.00, 847.00, 402.00, 860.50)
        ..quadraticBezierTo(429.00, 874.00, 461.00, 874.00)
        ..quadraticBezierTo(493.00, 874.00, 515.00, 872.00)
        ..quadraticBezierTo(537.00, 870.00, 555.00, 864.00)
        ..quadraticBezierTo(573.00, 858.00, 589.50, 846.50)
        ..quadraticBezierTo(606.00, 835.00, 625.00, 817.00)
        ..quadraticBezierTo(644.00, 835.00, 660.50, 846.50)
        ..quadraticBezierTo(677.00, 858.00, 695.00, 864.00)
        ..quadraticBezierTo(713.00, 870.00, 735.50, 872.00)
        ..quadraticBezierTo(758.00, 874.00, 789.00, 874.00)
        ..quadraticBezierTo(821.00, 874.00, 848.00, 860.50)
        ..quadraticBezierTo(875.00, 847.00, 895.50, 831.00)
        ..quadraticBezierTo(916.00, 815.00, 930.50, 801.50)
        ..quadraticBezierTo(945.00, 788.00, 953.00, 788.00)
        ..quadraticBezierTo(968.00, 788.00, 980.50, 801.00)
        ..quadraticBezierTo(993.00, 814.00, 1002.00, 825.00)
        ..quadraticBezierTo(1023.00, 812.00, 1044.00, 802.50)
        ..quadraticBezierTo(1065.00, 793.00, 1086.50, 790.50)
        ..quadraticBezierTo(1108.00, 788.00, 1129.50, 793.50)
        ..quadraticBezierTo(1151.00, 799.00, 1172.00, 815.00)
        ..close()
        ..moveTo(1194.00, 421.00)
        ..quadraticBezierTo(1194.00, 514.00, 1168.00, 597.00)
        ..quadraticBezierTo(1142.00, 680.00, 1092.00, 749.00)
        ..quadraticBezierTo(1072.00, 749.00, 1053.50, 754.50)
        ..quadraticBezierTo(1035.00, 760.00, 1010.00, 774.00)
        ..quadraticBezierTo(999.00, 763.00, 983.50, 755.00)
        ..quadraticBezierTo(968.00, 747.00, 953.00, 747.00)
        ..quadraticBezierTo(935.00, 747.00, 917.50, 761.00)
        ..quadraticBezierTo(900.00, 775.00, 880.50, 791.50)
        ..quadraticBezierTo(861.00, 808.00, 839.00, 821.50)
        ..quadraticBezierTo(817.00, 835.00, 789.00, 835.00)
        ..quadraticBezierTo(755.00, 835.00, 734.00, 832.00)
        ..quadraticBezierTo(713.00, 829.00, 696.50, 821.00)
        ..quadraticBezierTo(680.00, 813.00, 664.50, 798.00)
        ..quadraticBezierTo(649.00, 783.00, 625.00, 759.00)
        ..quadraticBezierTo(601.00, 783.00, 585.50, 798.00)
        ..quadraticBezierTo(570.00, 813.00, 554.00, 821.00)
        ..quadraticBezierTo(538.00, 829.00, 517.00, 832.00)
        ..quadraticBezierTo(496.00, 835.00, 461.00, 835.00)
        ..quadraticBezierTo(433.00, 835.00, 411.00, 821.50)
        ..quadraticBezierTo(389.00, 808.00, 370.00, 791.50)
        ..quadraticBezierTo(351.00, 775.00, 333.50, 761.00)
        ..quadraticBezierTo(316.00, 747.00, 297.00, 747.00)
        ..quadraticBezierTo(282.00, 747.00, 266.50, 755.00)
        ..quadraticBezierTo(251.00, 763.00, 240.00, 774.00)
        ..quadraticBezierTo(214.00, 760.00, 196.00, 754.50)
        ..quadraticBezierTo(178.00, 749.00, 158.00, 749.00)
        ..quadraticBezierTo(109.00, 680.00, 82.50, 597.00)
        ..quadraticBezierTo(56.00, 514.00, 56.00, 421.00)
        ..quadraticBezierTo(56.00, 330.00, 82.50, 247.50)
        ..quadraticBezierTo(109.00, 165.00, 158.00, 94.00)
        ..quadraticBezierTo(178.00, 96.00, 196.00, 90.00)
        ..quadraticBezierTo(214.00, 84.00, 240.00, 71.00)
        ..quadraticBezierTo(251.00, 80.00, 266.50, 89.00)
        ..quadraticBezierTo(282.00, 98.00, 297.00, 98.00)
        ..quadraticBezierTo(316.00, 98.00, 333.50, 84.50)
        ..quadraticBezierTo(351.00, 71.00, 370.00, 54.50)
        ..quadraticBezierTo(389.00, 38.00, 411.00, 24.00)
        ..quadraticBezierTo(433.00, 10.00, 461.00, 10.00)
        ..quadraticBezierTo(496.00, 10.00, 517.00, 13.00)
        ..quadraticBezierTo(538.00, 16.00, 554.00, 24.00)
        ..quadraticBezierTo(570.00, 32.00, 585.50, 47.00)
        ..quadraticBezierTo(601.00, 62.00, 625.00, 86.00)
        ..quadraticBezierTo(649.00, 62.00, 664.50, 47.00)
        ..quadraticBezierTo(680.00, 32.00, 696.50, 24.00)
        ..quadraticBezierTo(713.00, 16.00, 734.00, 13.00)
        ..quadraticBezierTo(755.00, 10.00, 789.00, 10.00)
        ..quadraticBezierTo(817.00, 10.00, 839.00, 24.00)
        ..quadraticBezierTo(861.00, 38.00, 880.50, 54.50)
        ..quadraticBezierTo(900.00, 71.00, 917.50, 84.50)
        ..quadraticBezierTo(935.00, 98.00, 953.00, 98.00)
        ..quadraticBezierTo(968.00, 98.00, 983.50, 89.00)
        ..quadraticBezierTo(999.00, 80.00, 1010.00, 71.00)
        ..quadraticBezierTo(1035.00, 84.00, 1053.50, 90.00)
        ..quadraticBezierTo(1072.00, 96.00, 1092.00, 94.00)
        ..quadraticBezierTo(1142.00, 165.00, 1168.00, 247.50)
        ..quadraticBezierTo(1194.00, 330.00, 1194.00, 421.00)
        ..close()
        ..moveTo(1172.00, 28.00)
        ..quadraticBezierTo(1129.00, 60.00, 1086.50, 52.50)
        ..quadraticBezierTo(1044.00, 45.00, 1002.00, 20.00)
        ..quadraticBezierTo(993.00, 31.00, 980.50, 44.00)
        ..quadraticBezierTo(968.00, 57.00, 953.00, 57.00)
        ..quadraticBezierTo(945.00, 57.00, 930.50, 43.50)
        ..quadraticBezierTo(916.00, 30.00, 895.50, 13.50)
        ..quadraticBezierTo(875.00, -3.00, 848.00, -17.00)
        ..quadraticBezierTo(821.00, -31.00, 789.00, -31.00)
        ..quadraticBezierTo(758.00, -31.00, 735.50, -28.50)
        ..quadraticBezierTo(713.00, -26.00, 695.00, -19.50)
        ..quadraticBezierTo(677.00, -13.00, 660.50, -1.50)
        ..quadraticBezierTo(644.00, 10.00, 625.00, 28.00)
        ..quadraticBezierTo(606.00, 10.00, 589.50, -1.50)
        ..quadraticBezierTo(573.00, -13.00, 555.00, -19.50)
        ..quadraticBezierTo(537.00, -26.00, 515.00, -28.50)
        ..quadraticBezierTo(493.00, -31.00, 461.00, -31.00)
        ..quadraticBezierTo(429.00, -31.00, 402.00, -17.00)
        ..quadraticBezierTo(375.00, -3.00, 354.50, 13.50)
        ..quadraticBezierTo(334.00, 30.00, 319.50, 43.50)
        ..quadraticBezierTo(305.00, 57.00, 297.00, 57.00)
        ..quadraticBezierTo(282.00, 57.00, 269.50, 44.00)
        ..quadraticBezierTo(257.00, 31.00, 248.00, 20.00)
        ..quadraticBezierTo(206.00, 45.00, 164.00, 52.50)
        ..quadraticBezierTo(122.00, 60.00, 78.00, 28.00)
        ..quadraticBezierTo(101.00, 21.00, 120.50, 10.00)
        ..quadraticBezierTo(140.00, -1.00, 158.00, -14.50)
        ..quadraticBezierTo(176.00, -28.00, 193.00, -42.50)
        ..quadraticBezierTo(210.00, -57.00, 228.00, -72.00)
        ..quadraticBezierTo(293.00, -125.00, 349.00, -153.50)
        ..quadraticBezierTo(405.00, -182.00, 459.00, -199.00)
        ..quadraticBezierTo(491.00, -211.00, 515.50, -224.00)
        ..quadraticBezierTo(540.00, -237.00, 559.00, -252.50)
        ..quadraticBezierTo(578.00, -268.00, 594.00, -287.00)
        ..quadraticBezierTo(610.00, -306.00, 625.00, -330.00)
        ..quadraticBezierTo(640.00, -306.00, 656.00, -287.00)
        ..quadraticBezierTo(672.00, -268.00, 691.00, -252.50)
        ..quadraticBezierTo(710.00, -237.00, 734.50, -224.00)
        ..quadraticBezierTo(759.00, -211.00, 791.00, -199.00)
        ..quadraticBezierTo(845.00, -182.00, 901.00, -153.50)
        ..quadraticBezierTo(957.00, -125.00, 1022.00, -72.00)
        ..quadraticBezierTo(1040.00, -57.00, 1057.00, -42.50)
        ..quadraticBezierTo(1074.00, -28.00, 1092.00, -14.50)
        ..quadraticBezierTo(1110.00, -1.00, 1129.50, 10.00)
        ..quadraticBezierTo(1149.00, 21.00, 1172.00, 28.00)
        ..close()
        ..moveTo(957.00, 884.00)
        ..quadraticBezierTo(964.00, 877.00, 962.50, 869.00)
        ..quadraticBezierTo(961.00, 861.00, 955.50, 856.00)
        ..quadraticBezierTo(950.00, 851.00, 941.50, 850.50)
        ..quadraticBezierTo(933.00, 850.00, 926.00, 858.00)
        ..quadraticBezierTo(906.00, 882.00, 869.50, 902.00)
        ..quadraticBezierTo(833.00, 922.00, 781.00, 933.00)
        ..quadraticBezierTo(772.00, 936.00, 768.50, 943.00)
        ..quadraticBezierTo(765.00, 950.00, 766.50, 957.50)
        ..quadraticBezierTo(768.00, 965.00, 774.50, 969.50)
        ..quadraticBezierTo(781.00, 974.00, 791.00, 972.00)
        ..quadraticBezierTo(847.00, 960.00, 889.00, 937.50)
        ..quadraticBezierTo(931.00, 915.00, 957.00, 884.00)
        ..close()
        ..moveTo(693.00, 970.00)
        ..quadraticBezierTo(693.00, 942.00, 673.00, 922.50)
        ..quadraticBezierTo(653.00, 903.00, 625.00, 903.00)
        ..quadraticBezierTo(597.00, 903.00, 577.00, 922.50)
        ..quadraticBezierTo(557.00, 942.00, 557.00, 970.00)
        ..quadraticBezierTo(557.00, 999.00, 577.00, 1019.50)
        ..quadraticBezierTo(597.00, 1040.00, 625.00, 1040.00)
        ..quadraticBezierTo(653.00, 1040.00, 673.00, 1019.50)
        ..quadraticBezierTo(693.00, 999.00, 693.00, 970.00)
        ..close()
        ..moveTo(469.00, 933.00)
        ..quadraticBezierTo(417.00, 922.00, 380.50, 902.00)
        ..quadraticBezierTo(344.00, 882.00, 324.00, 858.00)
        ..quadraticBezierTo(317.00, 850.00, 309.00, 850.50)
        ..quadraticBezierTo(301.00, 851.00, 295.00, 856.00)
        ..quadraticBezierTo(289.00, 861.00, 287.50, 869.00)
        ..quadraticBezierTo(286.00, 877.00, 293.00, 884.00)
        ..quadraticBezierTo(319.00, 915.00, 361.00, 937.50)
        ..quadraticBezierTo(403.00, 960.00, 459.00, 972.00)
        ..quadraticBezierTo(469.00, 974.00, 475.50, 969.50)
        ..quadraticBezierTo(482.00, 965.00, 483.50, 957.50)
        ..quadraticBezierTo(485.00, 950.00, 481.50, 943.00)
        ..quadraticBezierTo(478.00, 936.00, 469.00, 933.00)
        ..close()
        ..moveTo(957.00, -39.00)
        ..quadraticBezierTo(904.00, -102.00, 791.00, -129.00)
        ..quadraticBezierTo(781.00, -131.00, 774.50, -126.00)
        ..quadraticBezierTo(768.00, -121.00, 766.50, -113.50)
        ..quadraticBezierTo(765.00, -106.00, 768.50, -98.50)
        ..quadraticBezierTo(772.00, -91.00, 781.00, -89.00)
        ..quadraticBezierTo(833.00, -78.00, 869.50, -59.00)
        ..quadraticBezierTo(906.00, -40.00, 926.00, -15.00)
        ..quadraticBezierTo(933.00, -7.00, 941.50, -7.00)
        ..quadraticBezierTo(950.00, -7.00, 955.50, -11.50)
        ..quadraticBezierTo(961.00, -16.00, 962.50, -24.00)
        ..quadraticBezierTo(964.00, -32.00, 957.00, -39.00)
        ..close()
        ..moveTo(693.00, -127.00)
        ..quadraticBezierTo(693.00, -155.00, 673.00, -175.00)
        ..quadraticBezierTo(653.00, -195.00, 625.00, -195.00)
        ..quadraticBezierTo(597.00, -195.00, 577.00, -175.00)
        ..quadraticBezierTo(557.00, -155.00, 557.00, -127.00)
        ..quadraticBezierTo(557.00, -98.00, 577.00, -79.00)
        ..quadraticBezierTo(597.00, -60.00, 625.00, -60.00)
        ..quadraticBezierTo(653.00, -60.00, 673.00, -79.00)
        ..quadraticBezierTo(693.00, -98.00, 693.00, -127.00)
        ..close()
        ..moveTo(469.00, -89.00)
        ..quadraticBezierTo(478.00, -91.00, 481.50, -98.50)
        ..quadraticBezierTo(485.00, -106.00, 483.50, -113.50)
        ..quadraticBezierTo(482.00, -121.00, 475.50, -126.00)
        ..quadraticBezierTo(469.00, -131.00, 459.00, -129.00)
        ..quadraticBezierTo(346.00, -102.00, 293.00, -39.00)
        ..quadraticBezierTo(286.00, -32.00, 287.50, -24.00)
        ..quadraticBezierTo(289.00, -16.00, 295.00, -11.50)
        ..quadraticBezierTo(301.00, -7.00, 309.00, -7.00)
        ..quadraticBezierTo(317.00, -7.00, 324.00, -15.00)
        ..quadraticBezierTo(344.00, -40.00, 380.50, -59.00)
        ..quadraticBezierTo(417.00, -78.00, 469.00, -89.00)
        ..close();
    // กรอบต้นฉบับ: x[0,1248] y[-410,1255] จุดศูนย์กลาง (624, 422.5)
    const pathW = 1248.0;
    const pathH = 1665.0;
    final scale = size.width / pathW < size.height / pathH
        ? size.width / pathW
        : size.height / pathH;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(scale);
    canvas.translate(-624.0, -422.5);
    canvas.drawPath(path, Paint()..color = color..style = PaintingStyle.fill);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _AyahOrnamentPainter oldDelegate) => oldDelegate.color != color;
}

class SurahDetailPage extends StatefulWidget {
  final int surahId;
  final String surahName;
  const SurahDetailPage({super.key, required this.surahId, required this.surahName});
  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  List<Map<String, dynamic>> verses = [];
  bool isLoading = true;
  String errorMessage = '';
  String _selectedLang = 'en';
  String _selectedReciter = 'ar.alafasy';
  String _selectedFont = kQuranFontDefault;
  double _quranFontSize = kQuranFontSizeDefault;
  bool _isMushafMode = false;
  final List<TapGestureRecognizer> _mushafRecognizers = [];
  final _theme = ThemeService();
  final _lang = LanguageService();

  // Audio player
  final AudioPlayer _player = AudioPlayer();
  int? _playingVerseNumber;
  bool _isPlaying = false;

  final Map<String, Map<String, dynamic>> _languages = {
    'en': {'label': 'English',          'edition': 'en.sahih',     'flag': '🇬🇧'},
    'th': {'label': 'ภาษาไทย',          'edition': 'th.thai',      'flag': '🇹🇭'},
    'ms': {'label': 'Bahasa Melayu',    'edition': 'ms.basmeih',   'flag': '🇲🇾'},
    'id': {'label': 'Bahasa Indonesia', 'edition': 'id.indonesian', 'flag': '🇮🇩'},
    'ar': {'label': 'العربية',          'edition': 'ar.muyassar',  'flag': '🇸🇦'},
    'ur': {'label': 'اردو',             'edition': 'ur.jalandhry', 'flag': '🇵🇰'},
    'bn': {'label': 'বাংলা',            'edition': 'bn.bengali',   'flag': '🇧🇩'},
  };

  // รายชื่อนักอ่าน
  final List<Map<String, String>> _reciters = [
    {'id': 'ar.alafasy', 'name': 'Mishary Alafasy'},
    {'id': 'ar.abdurrahmaansudais', 'name': 'Sudais'},
    {'id': 'ar.minshawi', 'name': 'Minshawi'},
    {'id': 'ar.husary', 'name': 'Husary'},
    {'id': 'ar.muhammadayyoub', 'name': 'Muhammad Ayyoub'},
  ];

  static final String _bismillah = String.fromCharCodes([
    0x628,0x650,0x633,0x652,0x645,0x650,0x20,
    0x671,0x644,0x644,0x651,0x64e,0x647,0x650,0x20,
    0x671,0x644,0x631,0x651,0x64e,0x62d,0x652,0x645,0x64e,0x670,0x646,0x650,0x20,
    0x671,0x644,0x631,0x651,0x64e,0x62d,0x650,0x64a,0x645,0x650,
  ]);

  @override
  void initState() {
    super.initState();
    _theme.addListener(() => setState(() {}));

    // ฟัง player state - auto play next verse
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        if (mounted && _playingVerseNumber != null && _playingVerseNumber! < verses.length) {
          _playVerse(_playingVerseNumber! + 1);
        } else if (mounted) {
          setState(() {
            _isPlaying = false;
            _playingVerseNumber = null;
          });
        }
      }
    });

    _initLangThenLoad();
  }

  // ── เลือกภาษาคำแปลเริ่มต้น ──────────────────────────
  // ลำดับความสำคัญ:
  // 1. ค่าที่ user ตั้งไว้ล่วงหน้าใน Settings > อัลกุรอาน > ภาษาคำแปล (key: quran_translation_lang)
  // 2. ถ้าไม่เคยตั้งไว้ ใช้ภาษาของแอปโดยรวม (พฤติกรรมเดิม)
  Future<void> _initLangThenLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTranslationLang = prefs.getString('quran_translation_lang');
    final resolvedLang = savedTranslationLang ?? _lang.lang;
    final savedFont = prefs.getString(kQuranFontPrefKey) ?? kQuranFontDefault;
    final savedFontSize = prefs.getDouble(kQuranFontSizePrefKey) ?? kQuranFontSizeDefault;
    final savedMushafMode = prefs.getBool('quran_mushaf_mode') ?? false;

    if (mounted) {
      setState(() {
        _selectedLang = _languages.containsKey(resolvedLang) ? resolvedLang : 'en';
        _selectedFont = kQuranFonts.any((f) => f.id == savedFont) ? savedFont : kQuranFontDefault;
        _quranFontSize = savedFontSize.clamp(kQuranFontSizeMin, kQuranFontSizeMax);
        _isMushafMode = savedMushafMode;
      });
    }

    loadVerses();
  }

  void _changeFont(String fontId) async {
    if (fontId == _selectedFont) return;
    setState(() => _selectedFont = fontId);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(kQuranFontPrefKey, fontId);
  }

  // ── สลับโหมดอ่าน: การ์ดทีละอายะห์+คำแปล  ⇆  มุศฮัฟต่อเนื่อง (อาหรับล้วน) ──
  void _toggleMushafMode() async {
    setState(() => _isMushafMode = !_isMushafMode);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('quran_mushaf_mode', _isMushafMode);
  }

  // ── Font Picker ─────────────────────────────────────
  void _showFontPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(width: 40.w, height: 4.h,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2.r))),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('เลือกฟอนต์อัลกุรอาน / Quran Font',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _theme.textColor)),
              ),
              SizedBox(height: 8.h),
              ...kQuranFonts.map((font) {
                final isSelected = _selectedFont == font.id;
                return ListTile(
                  title: Text(
                    'بِسْمِ اللَّهِ',
                    textDirection: TextDirection.rtl,
                    style: font.style(fontSize: 22.sp, color: _theme.textColor),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 4.h),
                    child: Text('${font.label} · ${font.description}',
                      style: TextStyle(color: _theme.subTextColor, fontSize: 12.sp,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  ),
                  trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
                  onTap: () {
                    _changeFont(font.id);
                    Navigator.pop(context);
                  },
                );
              }),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _theme.removeListener(() => setState(() {}));
    for (final r in _mushafRecognizers) { r.dispose(); }
    _player.dispose();
    super.dispose();
  }

  // ── Play / Stop ────────────────────────────────────
  // ── เล่นเสียงอายะห์ — เช็คแคชในเครื่องก่อนเสมอ ──────────────────
  // ถ้าเคยโหลดอายะห์นี้ (ของนักอ่านคนนี้) มาแล้ว จะเล่นจากไฟล์ในเครื่อง
  // ทันที ไม่ยิง request เลย (เล่นได้แม้ไม่มีเน็ต) ถ้ายังไม่เคยโหลด จะดึง
  // URL จาก API มาเล่นแบบสตรีมตามเดิม พร้อมดาวน์โหลดเก็บไว้เป็นแคชเบื้อง
  // หลังแบบไม่บล็อก UI เผื่อเปิดฟังซ้ำอายะห์เดิมในอนาคต
  Future<void> _playVerse(int verseNumber) async {
    if (_playingVerseNumber == verseNumber && _isPlaying) {
      await _player.stop();
      setState(() { _isPlaying = false; _playingVerseNumber = null; });
      return;
    }

    setState(() { _isPlaying = true; _playingVerseNumber = verseNumber; });

    try {
      // ── ขั้นที่ 1: มีแคชอยู่แล้วไหม — เล่นจากไฟล์ในเครื่องตรงๆ เลย ──
      final cachedPath = await QuranAudioCacheService.getCachedPath(
          _selectedReciter, widget.surahId, verseNumber);
      if (cachedPath != null) {
        await _player.stop();
        await Future.delayed(const Duration(milliseconds: 300));
        await _player.setFilePath(cachedPath);
        await _player.play();
        return;
      }

      // ── ขั้นที่ 2: ยังไม่มีแคช — ดึง URL เสียงจาก API แล้วเล่นแบบสตรีมตามเดิม ──
      final apiUrl = 'https://api.alquran.cloud/v1/ayah/${widget.surahId}:$verseNumber/$_selectedReciter';
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final audioUrl = data['data']['audio'] as String;

        await _player.stop();
        await Future.delayed(const Duration(milliseconds: 300));
        await _player.setUrl(audioUrl);
        await _player.play();

        // ── ขั้นที่ 3: ดาวน์โหลดเก็บแคชเบื้องหลัง ไม่ต้องรอ ไม่กระทบการเล่นเสียง
        // ปัจจุบัน — ครั้งหน้าที่เปิดอายะห์นี้ซ้ำ (นักอ่านคนเดิม) จะได้เล่น
        // จากแคชทันทีโดยไม่ต้องใช้เน็ตอีก ──
        QuranAudioCacheService.downloadAndCache(
                _selectedReciter, widget.surahId, verseNumber, audioUrl)
            .catchError((_) {
          // โหลดแคชไม่สำเร็จ (เช่นเน็ตหลุดระหว่างดาวน์) ไม่เป็นไร แค่จะต้อง
          // สตรีมใหม่ตอนเปิดฟังครั้งหน้า — ไม่กระทบการเล่นเสียงที่กำลังเล่นอยู่
          return '';
        });
      } else {
        throw Exception('API error');
      }
    } catch (e) {
      if (mounted) {
        setState(() { _isPlaying = false; _playingVerseNumber = null; });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถเล่นเสียงได้'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _stopAudio() async {
    await _player.stop();
    setState(() { _isPlaying = false; _playingVerseNumber = null; });
  }

  // ── Load Verses ────────────────────────────────────
  Future<void> loadVerses() async {
    setState(() { isLoading = true; errorMessage = ''; });
    final hasLocal = await QuranDatabase.hasVersesByLang(widget.surahId, _selectedLang);
    if (hasLocal) {
      final local = await QuranDatabase.getVersesByLang(widget.surahId, _selectedLang);
      final hasTranslation = local.isNotEmpty && (local[0]['translation'] ?? '').toString().isNotEmpty;
      if (hasTranslation) {
        if (widget.surahId != 1 && widget.surahId != 9) {
          final firstVerse = local[0]['text_uthmani'] ?? '';
          if (firstVerse.contains(_bismillah)) {
            await QuranDatabase.deleteVersesByLang(widget.surahId, _selectedLang);
            await fetchFromApi();
            return;
          }
        }
        setState(() { verses = local; isLoading = false; });
        return;
      }
      await QuranDatabase.deleteVersesByLang(widget.surahId, _selectedLang);
    }
    await fetchFromApi();
  }

  Future<void> fetchFromApi() async {
    try {
      final edition = _languages[_selectedLang]!['edition'] as String;
      final url = 'https://api.alquran.cloud/v1/surah/${widget.surahId}/editions/quran-uthmani,$edition';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List editions = data['data'];
        final arabicAyahs = editions[0]['ayahs'] as List;
        final translationAyahs = editions[1]['ayahs'] as List;
        final processedVerses = List.generate(arabicAyahs.length, (i) {
          String arabicText = arabicAyahs[i]['text'] ?? '';
          if (i == 0 && widget.surahId != 1 && widget.surahId != 9) {
            if (arabicText.startsWith(_bismillah)) {
              arabicText = arabicText.substring(_bismillah.length).trim();
            }
          }
          return {
            'verse_number': arabicAyahs[i]['numberInSurah'],
            'text_uthmani': arabicText,
            'translation': translationAyahs[i]['text'] ?? '',
            'lang': _selectedLang,
          };
        });
        await QuranDatabase.saveProcessedVerses(widget.surahId, _selectedLang, processedVerses);
        final local = await QuranDatabase.getVersesByLang(widget.surahId, _selectedLang);
        setState(() { verses = local; isLoading = false; });
      } else {
        setState(() { errorMessage = 'Failed to load verses'; isLoading = false; });
      }
    } catch (e) {
      setState(() { errorMessage = 'No internet connection'; isLoading = false; });
    }
  }

  void _changeLang(String lang) async {
    if (lang == _selectedLang) return;
    _stopAudio();
    setState(() => _selectedLang = lang);
    // จำค่านี้ไว้เป็นค่าเริ่มต้นครั้งต่อไปด้วย (sync กับ Settings > อัลกุรอาน)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quran_translation_lang', lang);
    loadVerses();
  }

  // ── Reciter Picker ─────────────────────────────────
  void _showReciterPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 12.h),
              Container(width: 40.w, height: 4.h,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2.r))),
              SizedBox(height: 16.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Text('เลือกนักอ่าน / Reciter',
                  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: _theme.textColor)),
              ),
              SizedBox(height: 8.h),
              ..._reciters.map((reciter) {
                final isSelected = _selectedReciter == reciter['id'];
                return ListTile(
                  leading: Container(
                    width: 36.w, height: 36.h,
                    decoration: BoxDecoration(
                      color: _theme.iconColor.withOpacity(0.12),
                      shape: BoxShape.circle),
                    child: Icon(Icons.record_voice_over, color: _theme.iconColor, size: 18.sp)),
                  title: Text(reciter['name']!,
                    style: TextStyle(color: _theme.textColor,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
                  onTap: () {
                    setState(() => _selectedReciter = reciter['id']!);
                    _stopAudio();
                    Navigator.pop(context);
                  },
                );
              }),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        title: Text(widget.surahName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // ปุ่มสลับโหมดอ่าน: การ์ด+คำแปล ⇆ มุศฮัฟต่อเนื่อง
          IconButton(
            icon: Icon(_isMushafMode ? Icons.view_agenda_outlined : Icons.auto_stories,
                color: Colors.white),
            onPressed: _toggleMushafMode,
            tooltip: _isMushafMode ? 'มุมมองรายการ+คำแปล' : 'มุมมองอ่านต่อเนื่อง (มุศฮัฟ)',
          ),
          // ปุ่มเลือกฟอนต์
          IconButton(
            icon: const Icon(Icons.text_fields, color: Colors.white),
            onPressed: _showFontPicker,
            tooltip: 'เลือกฟอนต์',
          ),
          // ปุ่มเลือกนักอ่าน
          IconButton(
            icon: const Icon(Icons.record_voice_over, color: Colors.white),
            onPressed: _showReciterPicker,
            tooltip: 'เลือกนักอ่าน',
          ),
          // ปุ่มหยุดเสียง
          if (_isPlaying)
            IconButton(
              icon: const Icon(Icons.stop_circle, color: Color(0xFFFFD700)),
              onPressed: _stopAudio,
            ),
          // ปุ่มภาษา
          PopupMenuButton<String>(
            icon: Text(_languages[_selectedLang]!['flag'] as String,
              style: TextStyle(fontSize: 22.sp)),
            color: _theme.cardColor,
            onSelected: _changeLang,
            itemBuilder: (context) => _languages.entries.map((entry) {
              final isSelected = entry.key == _selectedLang;
              return PopupMenuItem<String>(
                value: entry.key,
                child: Row(children: [
                  Text(entry.value['flag'] as String, style: TextStyle(fontSize: 18.sp)),
                  SizedBox(width: 10.w),
                  Text(entry.value['label'] as String,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? _theme.iconColor : _theme.textColor)),
                  if (isSelected) ...[const Spacer(), Icon(Icons.check, color: _theme.iconColor, size: 16.sp)],
                ]),
              );
            }).toList(),
          ),
          SizedBox(width: 4.w),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: _theme.iconColor))
          : errorMessage.isNotEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.wifi_off, size: 64.sp, color: _theme.subTextColor),
                  SizedBox(height: 16.h),
                  Text(errorMessage, style: TextStyle(color: _theme.subTextColor)),
                  SizedBox(height: 16.h),
                  ElevatedButton(onPressed: fetchFromApi,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                    child: const Text('Retry', style: TextStyle(color: Colors.white))),
                ]))
              : Column(children: [
                  if (widget.surahId != 1 && widget.surahId != 9)
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0.h),
                      child: _theme.isDark
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(Color(0xFF2ECC71), BlendMode.srcIn),
                              child: Image.asset('image/Bismillah.png', height: 100.h, fit: BoxFit.contain))
                          : Image.asset('image/Bismillah.png', height: 150.h, fit: BoxFit.contain),
                    ),

                  Expanded(
                    child: _isMushafMode ? _buildMushafView() : _buildVerseListView(),
                  ),
                ]),
      // ── Player Bar ──────────────────────────────
      bottomNavigationBar: _isPlaying ? _buildPlayerBar() : null,
    );
  }

  // ── โหมดการ์ดทีละอายะห์ + คำแปล (ของเดิม) ──────────────
  Widget _buildVerseListView() {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        12.w, 12.w, 12.w, 12.w + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: verses.length,
      itemBuilder: (context, index) {
        final verse = verses[index];
        final verseNumber = verse['verse_number'] as int;
        final translation = verse['translation'] ?? '';
        final isThisPlaying = _playingVerseNumber == verseNumber && _isPlaying;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: isThisPlaying
                ? _theme.iconColor.withOpacity(0.08)
                : _theme.cardColor,
            borderRadius: BorderRadius.circular(14.r),
            border: isThisPlaying
                ? Border.all(color: _theme.iconColor.withOpacity(0.4))
                : _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
            boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              // ปุ่มเสียง
              GestureDetector(
                onTap: () => _playVerse(verseNumber),
                child: Container(
                  width: 36.w, height: 36.h,
                  decoration: BoxDecoration(
                    color: isThisPlaying
                        ? _theme.iconColor
                        : _theme.iconColor.withOpacity(0.12),
                    shape: BoxShape.circle),
                  child: Icon(
                    isThisPlaying ? Icons.stop : Icons.play_arrow,
                    color: isThisPlaying ? Colors.white : _theme.iconColor,
                    size: 20.sp),
                ),
              ),

              Row(children: [
                // verse number badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: _theme.iconColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20.r)),
                  child: Text('$verseNumber',
                    style: TextStyle(color: _theme.iconColor,
                      fontWeight: FontWeight.bold, fontSize: 12.sp)),
                ),
                SizedBox(width: 8.w),
              ]),
            ]),

            SizedBox(height: 12.h),
            // ข้อความอาหรับ (ฟอนต์ Amiri) + สัญลักษณ์ปิดท้ายอายะห์แบบดั้งเดิม (วงกลมเลขอายะห์)
            // ต่อท้ายด้วย WidgetSpan เพื่อให้อยู่ในบรรทัดเดียวกับข้อความ
            // และอยู่ตำแหน่งท้ายอายะห์ตามทิศทาง RTL (ฝั่งซ้ายของบรรทัด)
            Text.rich(
              TextSpan(children: [
                TextSpan(
                  text: verse['text_uthmani'] ?? '',
                  style: getQuranFont(_selectedFont).style(
                    fontSize: _quranFontSize.sp,
                    color: _theme.textColor,
                  ),
                ),
                WidgetSpan(child: SizedBox(width: 6.w)),
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: _AyahEndMarker(
                    verseNumber: verseNumber,
                    accentColor: _theme.iconColor,
                    fontOption: getQuranFont(_selectedFont),
                  ),
                ),
              ]),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),

            if (translation.isNotEmpty) ...[
              Divider(height: 20.h,
                color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200),
              Align(alignment: Alignment.centerLeft,
                child: Text(translation, textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 13.sp, color: _theme.subTextColor, height: 1.6.h))),
            ],
          ]),
        );
      },
    );
  }

  // ── โหมดมุศฮัฟต่อเนื่อง: อาหรับล้วนไหลต่อกันแบบหน้าอัลกุรอานจริง ──────
  // จัดบรรทัดแบบ justify เหมือนคัมภีร์จริง ไม่มีคำแปลคั่น กดที่อายะห์ไหน
  // ก็เล่นเสียงอายะห์นั้นได้เลย (แถบไฮไลต์อ่อนๆ ตอนกำลังเล่น)
  Widget _buildMushafView() {
    for (final r in _mushafRecognizers) { r.dispose(); }
    _mushafRecognizers.clear();

    final spans = <InlineSpan>[];
    for (final verse in verses) {
      final verseNumber = verse['verse_number'] as int;
      final isThisPlaying = _playingVerseNumber == verseNumber && _isPlaying;
      final recognizer = TapGestureRecognizer()..onTap = () => _playVerse(verseNumber);
      _mushafRecognizers.add(recognizer);

      spans.add(TextSpan(
        text: verse['text_uthmani'] ?? '',
        recognizer: recognizer,
        style: getQuranFont(_selectedFont).style(
          fontSize: _quranFontSize.sp,
          color: _theme.textColor,
        ).copyWith(
          backgroundColor: isThisPlaying ? _theme.iconColor.withOpacity(0.20) : null,
        ),
      ));
      spans.add(const TextSpan(text: ' '));
      spans.add(WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: GestureDetector(
          onTap: () => _playVerse(verseNumber),
          child: _AyahEndMarker(
            verseNumber: verseNumber,
            accentColor: _theme.isDark ? const Color(0xFFEEC97D) : const Color(0xFF1B5E20),
            fontOption: getQuranFont(_selectedFont),
          ),
        ),
      ));
      spans.add(const TextSpan(text: '  '));
    }

    final goldLine = _theme.isDark ? const Color(0xFFC9A24B) : const Color(0xFFB8902E);
    final pageBg = _theme.isDark ? const Color(0xFF14261A) : const Color(0xFFFBF6E9);
    final pageBorder = _theme.isDark ? const Color(0xFF3E5A44) : const Color(0xFFE0CFA0);

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        14.w, 14.h, 14.w, 14.h + MediaQuery.of(context).padding.bottom,
      ),
      child: Container(
        width: double.infinity,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: pageBg,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: pageBorder, width: 1.4),
          boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 10, offset: const Offset(0, 3))],
        ),
        // ── กรอบทองชั้นในซ้อนอีกชั้น เลียนแบบกรอบตกแต่งหน้ามุศฮัฟจริง ──
        child: Container(
          margin: EdgeInsets.all(6.w),
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: goldLine.withOpacity(0.55), width: 1),
          ),
          child: Stack(children: [
            ..._mushafCornerDecor(size: 30.w),
            Column(children: [
              // ── แถบชื่อซูเราะห์ทรงกรอบ ล้อมด้วยเส้นคั่นลายดอกไม้ทั้งสองข้าง
              // (ดีไซน์เดียวกับป้ายชื่อซูเราะห์ในหน้ามุศฮัฟจริง) ──
              Image.asset(kMushafDividerAsset, width: 90.w,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              SizedBox(height: 6.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: goldLine.withOpacity(0.7), width: 1.2),
                  color: goldLine.withOpacity(0.08),
                ),
                child: Text(widget.surahName,
                    style: TextStyle(color: goldLine, fontSize: 15.sp,
                        fontWeight: FontWeight.bold, letterSpacing: 0.6)),
              ),
              SizedBox(height: 6.h),
              Image.asset(kMushafDividerAsset, width: 90.w,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              SizedBox(height: 18.h),
              // ── เนื้ออายะห์ไหลต่อเนื่อง ──
              Text.rich(
                TextSpan(children: spans),
                textAlign: TextAlign.justify,
                textDirection: TextDirection.rtl,
                style: const TextStyle(height: 2.1),
              ),
              SizedBox(height: 14.h),
              Image.asset(kMushafDividerAsset, width: 70.w,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
            ]),
          ]),
        ),
      ),
    );
  }

  Widget _buildPlayerBar() {
    final reciterName = _reciters.firstWhere(
      (r) => r['id'] == _selectedReciter,
      orElse: () => {'name': ''},
    )['name']!;

    return SafeArea(
      top: false,
      child: Container(
        height: 72.h,
        decoration: BoxDecoration(
          color: _theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFF1B5E20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, -2))],
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Row(children: [
          // Icon
          Container(
            width: 40.w, height: 40.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(8.r)),
            child: Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 20.sp)),
          SizedBox(width: 12.w),

          // ข้อมูล
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.surahName} · Ayah $_playingVerseNumber',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp),
                maxLines: 1, overflow: TextOverflow.ellipsis),
              Text(reciterName,
                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11.sp)),
            ])),

          // Controls
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: Icon(Icons.skip_previous, color: Colors.white, size: 24.sp),
            onPressed: () {
              if (_playingVerseNumber != null && _playingVerseNumber! > 1) {
                _playVerse(_playingVerseNumber! - 1);
              }
            },
          ),
          GestureDetector(
            onTap: _stopAudio,
            child: Container(
              width: 36.w, height: 36.h,
              decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
              child: Icon(Icons.stop, color: Color(0xFF1B5E20), size: 20.sp)),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
            icon: Icon(Icons.skip_next, color: Colors.white, size: 24.sp),
            onPressed: () {
              if (_playingVerseNumber != null && _playingVerseNumber! < verses.length) {
                _playVerse(_playingVerseNumber! + 1);
              }
            },
          ),
        ]),
      ),
    );
  }
}