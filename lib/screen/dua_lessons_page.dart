import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import 'dua_page.dart';
import 'lessons_page.dart';

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
        color: isDark ? const Color(0xFF0D2E1A) : const Color(0xFF1B5E20),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8, offset: const Offset(0, 3))
        ]),
      child: SafeArea(
        child: Column(children: [
          // Top bar
          Padding(
            padding: const EdgeInsets.fromLTRB(6, 8, 16, 0),
            child: Row(children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context)),
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
        ]),
      ),
    );
  }
}