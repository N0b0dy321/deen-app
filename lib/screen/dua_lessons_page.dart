import 'package:flutter/material.dart';
import 'dart:math';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import 'dua_page.dart';
import 'lessons_page.dart';

// ── ลวดลายเรขาคณิตอาระเบสค์ (ดาวแปดแฉก) ──────────────────────
// วาดจากสี่เหลี่ยมจัตุรัส 2 อันซ้อนกันหมุน 45 องศา เป็นเทคนิคคลาสสิก
// ของลวดลายเรขาคณิตอิสลาม (เช่น ลวดลายบนกระเบื้อง/มินบัรมัสยิด)
// ใช้เป็น overlay จางๆ บน header ให้ดูหรูและมีกลิ่นอายอิสลามมากขึ้น
class _ArabesquePatternPainter extends CustomPainter {
  final Color color;
  const _ArabesquePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.1;

    const spacing = 36.0;
    for (double y = -spacing; y < size.height + spacing; y += spacing) {
      for (double x = -spacing; x < size.width + spacing; x += spacing) {
        _drawEightPointStar(canvas, paint, Offset(x, y), spacing * 0.42);
      }
    }
  }

  void _drawEightPointStar(Canvas canvas, Paint paint, Offset center, double r) {
    final square1 = Path();
    final square2 = Path();
    for (int i = 0; i < 4; i++) {
      final angle1 = (pi / 2) * i;
      final angle2 = (pi / 2) * i + pi / 4;
      final p1 = center + Offset(cos(angle1), sin(angle1)) * r;
      final p2 = center + Offset(cos(angle2), sin(angle2)) * r;
      if (i == 0) {
        square1.moveTo(p1.dx, p1.dy);
        square2.moveTo(p2.dx, p2.dy);
      } else {
        square1.lineTo(p1.dx, p1.dy);
        square2.lineTo(p2.dx, p2.dy);
      }
    }
    square1.close();
    square2.close();
    canvas.drawPath(square1, paint);
    canvas.drawPath(square2, paint);
    // จุดกลางดาวเล็กๆ เพิ่มความประณีต
    canvas.drawCircle(center, 1.4, Paint()..color = paint.color);
  }

  @override
  bool shouldRepaint(covariant _ArabesquePatternPainter oldDelegate) => false;
}

class DuaLessonsPage extends StatefulWidget {
  const DuaLessonsPage({super.key});

  @override
  State<DuaLessonsPage> createState() => _DuaLessonsPageState();
}

class _DuaLessonsPageState extends State<DuaLessonsPage>
    with SingleTickerProviderStateMixin {
  final _theme = ThemeService();
  final _lang = LanguageService();
  late TabController _tabController;

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _theme.isDark;
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context, isDark),
        Expanded(child: TabBarView(
          controller: _tabController,
          children: [
            DuaTab(),
            LessonsTab(),
          ],
        )),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        // เปลี่ยนจากสีพื้นเรียบๆ เป็น gradient เข้มขึ้นเล็กน้อย ให้ดูหรูขึ้น
        // และตัดกับลวดลายเรขาคณิตสีทองได้ชัดเจน
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: isDark
              ? [const Color(0xFF0A2313), const Color(0xFF163F22)]
              : [const Color(0xFF123A1D), const Color(0xFF1B5E20)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24)),
        border: Border.all(color: const Color(0xFFFFD700).withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8, offset: const Offset(0, 3))
        ]),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24)),
        child: Stack(children: [
          // ── ลวดลายอาระเบสค์สีทองจางๆ วางทับพื้นหลัง ──
          Positioned.fill(
            child: CustomPaint(
              painter: _ArabesquePatternPainter(
                color: const Color(0xFFFFD700).withOpacity(0.10)),
            ),
          ),
          SafeArea(
            child: Column(children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
                child: Row(children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                    onPressed: () => Navigator.pop(context)),
                  // ดาวเล็กๆ ประดับข้างชื่อหน้า ให้ความรู้สึกอิสลามิกขึ้น
                  const Text('✦', style: TextStyle(color: Color(0xFFFFD700), fontSize: 14)),
                  const SizedBox(width: 8),
                  Text(
                    _lang.duaLessons,
                    style: const TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3)),
                ])),
              const SizedBox(height: 4),
              // Tab bar
              TabBar(
                controller: _tabController,
                indicatorColor: const Color(0xFFFFD700),
                indicatorWeight: 2,
                indicatorSize: TabBarIndicatorSize.label,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white38,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w600, fontSize: 14),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.normal, fontSize: 14),
                tabs: [
                  Tab(text: _lang.duaTab),
                  Tab(text: _lang.lessonsTab),
                ],
              ),
              // ── เส้นประดับลายเพชรเล็กๆ คั่นก่อนจบ header ──
              const SizedBox(height: 8),
              SizedBox(
                height: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(9, (i) {
                    final isCenter = i == 4;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Transform.rotate(
                        angle: pi / 4,
                        child: Container(
                          width: isCenter ? 7 : 4,
                          height: isCenter ? 7 : 4,
                          color: const Color(0xFFFFD700)
                              .withOpacity(isCenter ? 0.55 : 0.25),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 4),
            ]),
          ),
        ]),
      ),
    );
  }
}