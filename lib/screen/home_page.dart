import 'package:flutter/material.dart';
import 'dart:async';
import 'NearbyMasjid.dart';
import 'HalalRestaurant.dart';
import 'prayer_time_page.dart';
import 'Al-Quran.dart';
import 'dua_lessons_page.dart';
import '../services/prayer_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'package:DEEN/screen/qibla_page.dart';
import 'package:DEEN/screen/chatbot_page.dart';
import 'package:DEEN/services/Setting_Time.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _prayerData;
  final _lang = LanguageService();
  final _theme = ThemeService();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _lang.init().then((_) => setState(() {}));
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
    _loadPrayerTimes();

    // อัปเดต countdown ทุก 1 วินาที
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_prayerData != null) {
        setState(() {
          _prayerData!['nextPrayer'] =
              PrayerService.calculateNextPrayer(_prayerData!['timings']);
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _lang.removeListener(() => setState(() {}));
    _theme.removeListener(() => setState(() {}));
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    final data = await PrayerService.getPrayerTimes();
    setState(() => _prayerData = data);
  }

  void _toggleLang() => _lang.setLang(_lang.isThai ? 'en' : 'th');

  void _showMoreSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MoreBottomSheet(theme: _theme, lang: _lang),
    );
  }

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
                      _FeatureCard(label: _lang.nearbyMosques, icon: Icons.mosque, theme: _theme,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyMosquesPage()))),
                      _FeatureCard(
                          label: _lang.isThai ? 'ร้านอาหารฮาลาล' : 'Halal Food',
                          icon: Icons.restaurant,
                          theme: _theme,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HalalRestaurantPage()))),
                      _FeatureCard(label: _lang.duaLessons, icon: Icons.self_improvement, theme: _theme,
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuaLessonsPage()))),
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
      bottomNavigationBar: _BottomNavBar(
        lang: _lang,
        theme: _theme,
        onPrayerTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerTimesPage())),
        onMosqueTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyMosquesPage())),
        onMoreTap: _showMoreSheet,
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
              const SizedBox(height: 8),
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

// ── More Bottom Sheet ──────────────────────────────────────
class _MoreBottomSheet extends StatelessWidget {
  final ThemeService theme;
  final LanguageService lang;

  const _MoreBottomSheet({required this.theme, required this.lang});

  @override
  Widget build(BuildContext context) {
    final items = [
      _MoreItem(
        icon: Icons.settings,
        color: const Color(0xFF1B5E20),
        label: lang.isThai ? 'ตั้งค่า' : 'Settings',
        subtitle: lang.isThai ? 'ธีม, ภาษา, เวลาละหมาด' : 'Theme, language, prayer time',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        },
      ),
      _MoreItem(
        icon: Icons.notifications_outlined,
        color: Colors.orange,
        label: lang.isThai ? 'การแจ้งเตือน' : 'Notifications',
        subtitle: lang.isThai ? 'ตั้งค่าการแจ้งเตือน' : 'Manage notifications',
        onTap: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
        },
      ),
      _MoreItem(
        icon: Icons.info_outline,
        color: Colors.blue,
        label: lang.isThai ? 'เกี่ยวกับแอพ' : 'About',
        subtitle: lang.isThai ? 'DEEN v1.0.0' : 'DEEN v1.0.0',
        onTap: () {
          Navigator.pop(context);
          _showAbout(context);
        },
      ),
      _MoreItem(
        icon: Icons.share_outlined,
        color: Colors.purple,
        label: lang.isThai ? 'แชร์แอพ' : 'Share App',
        subtitle: lang.isThai ? 'แนะนำให้เพื่อน' : 'Share with friends',
        onTap: () => Navigator.pop(context),
      ),
      _MoreItem(
        icon: Icons.star_outline,
        color: Colors.amber,
        label: lang.isThai ? 'ให้คะแนน' : 'Rate App',
        subtitle: lang.isThai ? 'ถ้าชอบแอพช่วยให้คะแนนด้วย' : 'Enjoy the app? Leave a review!',
        onTap: () => Navigator.pop(context),
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          const SizedBox(height: 12),
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 16),

          // Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Text(
                  lang.isThai ? 'เพิ่มเติม' : 'More',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Items
          ...items.map((item) => _buildItem(context, item)),

          // Safe area padding
          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, _MoreItem item) {
    return InkWell(
      onTap: item.onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12)),
              child: Icon(item.icon, color: item.color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.label,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: theme.textColor)),
              Text(item.subtitle,
                  style: TextStyle(fontSize: 12, color: theme.subTextColor)),
            ])),
            Icon(Icons.chevron_right, color: theme.subTextColor, size: 20),
          ],
        ),
      ),
    );
  }

  void _showAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Icon(Icons.mosque, color: Color(0xFF1B5E20), size: 28),
          const SizedBox(width: 10),
          Text('DEEN', style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold)),
        ]),
        content: Text(
          lang.isThai
              ? 'แอพอิสลามสำหรับชีวิตประจำวัน\nเวอร์ชัน 1.0.0\nสร้างด้วยใจ ❤️'
              : 'Your Islamic companion app\nVersion 1.0.0\nMade with ❤️',
          style: TextStyle(color: theme.subTextColor, height: 1.6),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(lang.isThai ? 'ปิด' : 'Close',
                style: const TextStyle(color: Color(0xFF1B5E20))),
          ),
        ],
      ),
    );
  }
}

class _MoreItem {
  final IconData icon;
  final Color color;
  final String label;
  final String subtitle;
  final VoidCallback onTap;
  const _MoreItem({required this.icon, required this.color, required this.label, required this.subtitle, required this.onTap});
}

// ── Next Prayer Card ───────────────────────────────────────
class _NextPrayerCard extends StatelessWidget {
  final String prayerName, time, timeUntil;
  final bool isDark;
  const _NextPrayerCard({required this.prayerName, required this.time, required this.timeUntil, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A6B35)]
              : [const Color(0xFF1B5E20), const Color(0xFF43A047)],
          begin: Alignment.centerLeft, end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: isDark ? Border.all(color: const Color(0xFF2ECC71).withOpacity(0.3)) : null,
        boxShadow: [BoxShadow(
          color: isDark ? const Color(0xFF2ECC71).withOpacity(0.1) : const Color(0xFF1B5E20).withOpacity(0.3),
          blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        const SizedBox(width: 20),
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), shape: BoxShape.circle),
          child: const Icon(Icons.nightlight_round, color: Color(0xFFFFA726), size: 32)),
        const SizedBox(width: 16),
        Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(prayerName, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
          Row(children: [
            Text(time, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Text(timeUntil, style: const TextStyle(color: Colors.white, fontSize: 12))),
          ]),
        ]),
        const Spacer(),
        const Padding(padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.chevron_right, color: Colors.white54, size: 24)),
      ]),
    );
  }
}

// ── Feature Card ───────────────────────────────────────────
class _FeatureCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeService theme;
  final VoidCallback onTap;
  const _FeatureCard({required this.label, required this.icon, required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
          boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: theme.isDark ? 4 : 8, offset: const Offset(0, 2))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: theme.iconColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(icon, size: 32, color: theme.iconColor)),
          const SizedBox(height: 10),
          Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.textColor),
              textAlign: TextAlign.center),
        ]),
      ),
    );
  }
}

// ── Chatbot Banner ─────────────────────────────────────────
class _ChatbotBanner extends StatelessWidget {
  final String label, subtitle;
  final ThemeService theme;
  final VoidCallback onTap;
  const _ChatbotBanner({required this.label, required this.subtitle, required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
          boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: theme.isDark ? 4 : 8, offset: const Offset(0, 2))],
        ),
        child: Row(children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: theme.iconColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Icon(Icons.smart_toy, color: theme.iconColor, size: 26)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: theme.textColor)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: theme.subTextColor)),
          ])),
          Icon(Icons.chevron_right, color: theme.iconColor, size: 26),
        ]),
      ),
    );
  }
}

// ── Bottom Nav Bar ─────────────────────────────────────────
class _BottomNavBar extends StatelessWidget {
  final LanguageService lang;
  final ThemeService theme;
  final VoidCallback onPrayerTap;
  final VoidCallback onMosqueTap;
  final VoidCallback onMoreTap;

  const _BottomNavBar({
    required this.lang,
    required this.theme,
    required this.onPrayerTap,
    required this.onMosqueTap,
    required this.onMoreTap,
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
        if (index == 3) onMoreTap();
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