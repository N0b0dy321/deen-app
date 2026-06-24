import 'package:flutter/material.dart';
import 'NearbyMasjid.dart';
import 'prayer_time_page.dart';
import 'Al-Quran.dart';
import '../services/prayer_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'package:DEEN/screen/qibla_page.dart';
import 'package:DEEN/screen/chatbot_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _prayerData;
  final _lang = LanguageService();
  final _theme = ThemeService();

  @override
  void initState() {
    super.initState();
    _lang.init().then((_) => setState(() {}));
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    _lang.removeListener(() => setState(() {}));
    _theme.removeListener(() => setState(() {}));
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    final data = await PrayerService.getPrayerTimes();
    setState(() => _prayerData = data);
  }

  void _toggleLang() => _lang.setLang(_lang.isThai ? 'en' : 'th');

  @override
  Widget build(BuildContext context) {
    final nextPrayer = _prayerData?['nextPrayer'];

    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_lang.nextPrayer,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _theme.textColor)),
                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const PrayerTimesPage())),
                    child: _NextPrayerCard(
                      prayerName: nextPrayer?['name'] ?? '...',
                      time: nextPrayer?['time'] ?? '--:--',
                      timeUntil: nextPrayer?['timeUntil'] ?? _lang.loading,
                      isDark: _theme.isDark,
                    ),
                  ),

                  const SizedBox(height: 16),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: [
                      _FeatureCard(label: _lang.alQuran, icon: Icons.menu_book, theme: _theme,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlQuranPage()))),
                      _FeatureCard(label: _lang.qiblaFinder, icon: Icons.explore, theme: _theme,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaPage()))),
                      _FeatureCard(label: _lang.nearbyMosques, icon: Icons.location_on, theme: _theme,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyMosquesPage()))),
                      _FeatureCard(label: _lang.duaLessons, icon: Icons.self_improvement, theme: _theme,
                          onTap: () {}),
                    ],
                  ),

                  const SizedBox(height: 12),
                  _ChatbotBanner(
                    label: _lang.askChatbot,
                    subtitle: _lang.haveQuestion,
                    theme: _theme,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ChatbotPage())),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavBar(lang: _lang, theme: _theme,
        onPrayerTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerTimesPage())),
        onMosqueTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyMosquesPage())),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _theme.isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A5C32)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
        boxShadow: [
          BoxShadow(
            color: _theme.isDark
                ? const Color(0xFF2ECC71).withOpacity(0.15)
                : Colors.black.withOpacity(0.2),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Dark Mode Button
                  GestureDetector(
                    onTap: () => _theme.toggle(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Icon(
                        _theme.isDark ? Icons.wb_sunny_rounded : Icons.dark_mode_rounded,
                        color: _theme.isDark ? const Color(0xFFFFD700) : Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Language Button
                  GestureDetector(
                    onTap: _toggleLang,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Text(_lang.isThai ? '🇹🇭' : '🇬🇧',
                              style: const TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          Text(_lang.isThai ? 'TH' : 'EN',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold)),
                          const SizedBox(width: 4),
                          const Icon(Icons.swap_horiz, color: Colors.white70, size: 16),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Text('ASSLAMU ALAIKUM',
                  style: TextStyle(
                      color: Color(0xFFFFD700),
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2)),
              const SizedBox(height: 4),
              Text(_lang.welcomeToDeen,
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 13,
                      letterSpacing: 2)),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
class _NextPrayerCard extends StatelessWidget {
  final String prayerName;
  final String time;
  final String timeUntil;
  final bool isDark;

  const _NextPrayerCard({
    required this.prayerName,
    required this.time,
    required this.timeUntil,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A6B35)]
              : [const Color(0xFF1B5E20), const Color(0xFF43A047)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: isDark
            ? Border.all(color: const Color(0xFF2ECC71).withOpacity(0.3), width: 1)
            : null,
        boxShadow: [
          BoxShadow(
            color: isDark
                ? const Color(0xFF2ECC71).withOpacity(0.1)
                : const Color(0xFF1B5E20).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const SizedBox(width: 20),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.nightlight_round, color: Color(0xFFFFA726), size: 32),
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prayerName,
                  style: const TextStyle(
                      color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Text(time,
                      style: const TextStyle(
                          color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(timeUntil,
                        style: const TextStyle(color: Colors.white, fontSize: 12)),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.chevron_right, color: Colors.white54, size: 24),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeService theme;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.label,
    required this.icon,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: theme.isDark
              ? Border.all(color: ThemeService.darkBorder, width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: theme.isDark ? 4 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: theme.iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: theme.iconColor),
            ),
            const SizedBox(height: 10),
            Text(label,
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: theme.textColor),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
class _ChatbotBanner extends StatelessWidget {
  final String label;
  final String subtitle;
  final ThemeService theme;
  final VoidCallback onTap;

  const _ChatbotBanner({
    required this.label,
    required this.subtitle,
    required this.theme,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: theme.isDark
              ? Border.all(color: ThemeService.darkBorder, width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor,
              blurRadius: theme.isDark ? 4 : 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.iconColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.smart_toy, color: theme.iconColor, size: 26),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor)),
                  Text(subtitle,
                      style: TextStyle(fontSize: 12, color: theme.subTextColor)),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: theme.iconColor, size: 26),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final LanguageService lang;
  final ThemeService theme;
  final VoidCallback onPrayerTap;
  final VoidCallback onMosqueTap;

  const _BottomNavBar({
    required this.lang,
    required this.theme,
    required this.onPrayerTap,
    required this.onMosqueTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: theme.iconColor,
      unselectedItemColor: theme.subTextColor,
      backgroundColor: theme.isDark ? const Color(0xFF13202E) : Colors.white,
      type: BottomNavigationBarType.fixed,
      elevation: theme.isDark ? 0 : 8,
      onTap: (index) {
        if (index == 1) onPrayerTap();
        if (index == 2) onMosqueTap();
      },
      items: [
        BottomNavigationBarItem(icon: const Icon(Icons.home_rounded), label: lang.home),
        BottomNavigationBarItem(icon: const Icon(Icons.access_time_rounded), label: lang.prayer),
        BottomNavigationBarItem(icon: const Icon(Icons.mosque_rounded), label: lang.mosques),
        BottomNavigationBarItem(icon: const Icon(Icons.more_horiz_rounded), label: lang.more),
      ],
    );
  }
}