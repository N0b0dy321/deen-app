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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _theme.addListener(() => setState(() {}));
    _lang.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    _theme.removeListener(() => setState(() {}));
    _lang.removeListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: _theme.isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A5C32)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
      child: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22)),
              const SizedBox(width: 12),
              Text(
                _lang.duaLessons,
                style: const TextStyle(color: Color(0xFFFFD700),
                    fontSize: 20, fontWeight: FontWeight.bold)),
            ]),
          ),
          // Tab Bar
          TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFFFD700),
            indicatorWeight: 3,
            labelColor: const Color(0xFFFFD700),
            unselectedLabelColor: Colors.white60,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
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