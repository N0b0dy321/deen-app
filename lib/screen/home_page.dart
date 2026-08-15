import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'NearbyMasjid.dart';
import 'HalalRestaurant.dart';
import 'dua_lessons_page.dart';
import 'prayer_time_page.dart';
import 'Al-Quran.dart';
import '../services/prayer_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../services/islamic_calendar_service.dart';
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
  Map<String, dynamic>? _hijriData;
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
    _loadHijriDate();

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

  Future<void> _loadHijriDate() async {
    // Prefetch 2 เดือนล่วงหน้า
    IslamicCalendarService.prefetchCalendars();
    final data = await IslamicCalendarService.getTodayHijri();
    if (mounted && data != null) {
      setState(() => _hijriData = data);
    }
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

                  // ── Islamic Calendar ──────────────────
                  _IslamicCalendarCard(
                    hijriData: _hijriData,
                    lang: _lang,
                    theme: _theme,
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
// ── Islamic Calendar Card ──────────────────────────
class _IslamicCalendarCard extends StatefulWidget {
  final Map<String, dynamic>? hijriData;
  final LanguageService lang;
  final ThemeService theme;

  const _IslamicCalendarCard({
    required this.hijriData,
    required this.lang,
    required this.theme,
  });

  @override
  State<_IslamicCalendarCard> createState() => _IslamicCalendarCardState();
}

class _IslamicCalendarCardState extends State<_IslamicCalendarCard> {
  List<Map<String, dynamic>>? _calendarData;

  @override
  void initState() {
    super.initState();
    _loadCalendar();
  }

  Future<void> _loadCalendar() async {
    final now = DateTime.now();
    final data = await IslamicCalendarService.getHijriCalendar(now.month, now.year);
    if (mounted) setState(() => _calendarData = data);
  }

  String _getLabel(String key) {
    final labels = {
      'loading': {'en': 'Loading...', 'th': 'กำลังโหลด...', 'ms': 'Memuatkan...', 'id': 'Memuat...', 'ar': 'جارٍ التحميل...', 'ur': 'لوڈ ہو رہا ہے...', 'bn': 'লোড হচ্ছে...'},
      'today': {'en': 'Today', 'th': 'วันนี้', 'ms': 'Hari ini', 'id': 'Hari ini', 'ar': 'اليوم', 'ur': 'آج', 'bn': 'আজ'},
      'hijri': {'en': 'Hijri', 'th': 'ฮิจเราะห์', 'ms': 'Hijri', 'id': 'Hijriah', 'ar': 'هجري', 'ur': 'ہجری', 'bn': 'হিজরি'},
      'viewCalendar': {'en': 'View Calendar', 'th': 'ดูปฏิทิน', 'ms': 'Lihat Kalendar', 'id': 'Lihat Kalender', 'ar': 'عرض التقويم', 'ur': 'کیلنڈر دیکھیں', 'bn': 'ক্যালেন্ডার দেখুন'},
    };
    return labels[key]?[widget.lang.lang] ?? labels[key]?['en'] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme.isDark;
    final headerColor = isDark ? const Color(0xFF0D2E1A) : const Color(0xFF1B5E20);
    final headerColor2 = isDark ? const Color(0xFF1A4A2A) : const Color(0xFF2E7D32);

    if (widget.hijriData == null) {
      return Container(
        height: 72,
        decoration: BoxDecoration(
          color: widget.theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: isDark ? Border.all(color: ThemeService.darkBorder) : null,
        ),
        child: Center(child: CircularProgressIndicator(color: widget.theme.iconColor, strokeWidth: 2)),
      );
    }

    final hijri = widget.hijriData!['hijri'] as Map<String, dynamic>? ?? {};
    final gregorian = widget.hijriData!['gregorian'] as Map<String, dynamic>? ?? {};
    final holidays = hijri['holidays'] as List<dynamic>? ?? [];
    final hijriDay = hijri['day']?.toString() ?? '';
    final hijriMonthEn = hijri['month']?['en'] as String? ?? '';
    final hijriYear = hijri['year']?.toString() ?? '';
    final hijriMonthName = IslamicCalendarService.getHijriMonthName(hijriMonthEn, widget.lang.lang);
    final gregDay = gregorian['day']?.toString() ?? '';
    final gregMonthEn = gregorian['month']?['en'] as String? ?? '';
    final gregYear = gregorian['year']?.toString() ?? '';
    final weekday = gregorian['weekday']?['en'] as String? ?? '';
    final holiday = IslamicCalendarService.getIslamicHoliday(holidays, widget.lang.lang);
    final now = DateTime.now();

    // Build week strip (current week)
    final weekday0 = now.weekday % 7; // Sun=0
    final weekStart = now.subtract(Duration(days: weekday0));
    final Map<int, Map<String, dynamic>> dayMap = {};
    if (_calendarData != null) {
      for (final day in _calendarData!) {
        final g = day['gregorian'] as Map<String, dynamic>? ?? {};
        final gd = int.tryParse(g['day']?.toString() ?? '0') ?? 0;
        if (gd > 0) dayMap[gd] = day;
      }
    }

    return GestureDetector(
      onTap: () => _showFullCalendar(context),
      child: Container(
        decoration: BoxDecoration(
          color: widget.theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          border: isDark ? Border.all(color: ThemeService.darkBorder) : null,
          boxShadow: [BoxShadow(color: widget.theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(children: [
          // ── Top row: hijri big + info ──
          IntrinsicHeight(
            child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              // Left: Hijri date
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [headerColor, headerColor2])),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_getLabel('hijri'),
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9, letterSpacing: 0.5)),
                  Text(hijriDay,
                      style: const TextStyle(color: Color(0xFFFFD700), fontSize: 32, fontWeight: FontWeight.bold, height: 1.1)),
                  Text(hijriMonthName,
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 9, height: 1.3),
                      textAlign: TextAlign.center),
                  Text('$hijriYear H',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9)),
                ]),
              ),
              // Right: Info
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('$weekday, $gregDay $gregMonthEn $gregYear',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: widget.theme.textColor)),
                    const SizedBox(height: 4),
                    if (holiday != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8)),
                        child: Text('⭐ $holiday',
                            style: const TextStyle(fontSize: 11, color: Color(0xFFD4A017), fontWeight: FontWeight.w600))),
                    ] else
                      Text('$hijriDay $hijriMonthName $hijriYear H',
                          style: TextStyle(fontSize: 11, color: widget.theme.subTextColor)),
                    const SizedBox(height: 8),
                    Row(children: [
                      Icon(Icons.calendar_month_rounded, size: 12, color: widget.theme.iconColor),
                      const SizedBox(width: 4),
                      Text(_getLabel('viewCalendar'),
                          style: TextStyle(fontSize: 11, color: widget.theme.iconColor, fontWeight: FontWeight.w500)),
                      const SizedBox(width: 2),
                      Icon(Icons.chevron_right, size: 14, color: widget.theme.iconColor),
                    ]),
                  ]),
                ),
              ),
            ]),
          ),

          // ── Week strip ──
          Container(
            color: isDark ? const Color(0xFF0D2E1A) : const Color(0xFFE8F5E9),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final d = weekStart.add(Duration(days: i));
                final isToday = d.day == now.day && d.month == now.month;
                final isFri = d.weekday == 5;
                final isSun = d.weekday == 7;
                final hijriD = dayMap[d.day]?['hijri']?['day']?.toString() ?? '';
                const dayLetters = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

                return Column(children: [
                  Text(dayLetters[i],
                      style: TextStyle(fontSize: 9, fontWeight: FontWeight.w600,
                          color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.subTextColor)),
                  const SizedBox(height: 4),
                  isToday
                    ? Container(
                        width: 26, height: 26,
                        decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(7)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('${d.day}', style: const TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold, height: 1)),
                          if (hijriD.isNotEmpty)
                            Text(hijriD, style: TextStyle(fontSize: 6, color: Colors.white.withOpacity(0.8), height: 1.1)),
                        ]))
                    : Column(children: [
                        Text('${d.day}', style: TextStyle(fontSize: 11,
                            color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.textColor)),
                        if (hijriD.isNotEmpty)
                          Text(hijriD, style: TextStyle(fontSize: 7, color: widget.theme.subTextColor, height: 1.1)),
                      ]),
                ]);
              }),
            ),
          ),
        ]),
      ),
    );
  }

  void _showFullCalendar(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _FullCalendarSheet(
        hijriData: widget.hijriData,
        lang: widget.lang,
        theme: widget.theme,
      ),
    );
  }
}

// ── Full Calendar Bottom Sheet ─────────────────────
class _FullCalendarSheet extends StatefulWidget {
  final Map<String, dynamic>? hijriData;
  final LanguageService lang;
  final ThemeService theme;

  const _FullCalendarSheet({
    required this.hijriData,
    required this.lang,
    required this.theme,
  });

  @override
  State<_FullCalendarSheet> createState() => _FullCalendarSheetState();
}

class _FullCalendarSheetState extends State<_FullCalendarSheet> {
  late DateTime _displayMonth;
  List<Map<String, dynamic>>? _calendarData;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime.now();
    _loadCalendar();
  }

  Future<void> _loadCalendar() async {
    setState(() => _loading = true);
    final data = await IslamicCalendarService.getHijriCalendar(
        _displayMonth.month, _displayMonth.year);
    if (mounted) setState(() { _calendarData = data; _loading = false; });
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
      _calendarData = null;
    });
    _loadCalendar();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme.isDark;
    final headerColor = isDark ? const Color(0xFF0D2E1A) : const Color(0xFF1B5E20);
    final headerColor2 = isDark ? const Color(0xFF1A4A2A) : const Color(0xFF2E7D32);
    final now = DateTime.now();
    final isCurrentMonth = _displayMonth.month == now.month && _displayMonth.year == now.year;

    // Build dayMap from calendar data
    final Map<int, Map<String, dynamic>> dayMap = {};
    Set<int> holidayDays = {};
    if (_calendarData != null) {
      for (final day in _calendarData!) {
        final g = day['gregorian'] as Map<String, dynamic>? ?? {};
        final gd = int.tryParse(g['day']?.toString() ?? '0') ?? 0;
        if (gd > 0) {
          dayMap[gd] = day;
          final h = day['hijri'] as Map<String, dynamic>? ?? {};
          final hols = h['holidays'] as List<dynamic>? ?? [];
          if (hols.isNotEmpty) holidayDays.add(gd);
        }
      }
    }

    // Get hijri info for displayed month
    String hijriMonthName = '';
    String hijriYear = '';
    if (dayMap[15] != null) {
      final h = dayMap[15]!['hijri'] as Map<String, dynamic>? ?? {};
      final hMonthEn = h['month']?['en'] as String? ?? '';
      hijriMonthName = IslamicCalendarService.getHijriMonthName(hMonthEn, widget.lang.lang);
      hijriYear = h['year']?.toString() ?? '';
    }

    final monthNames = {
      'en': ['January','February','March','April','May','June','July','August','September','October','November','December'],
      'th': ['มกราคม','กุมภาพันธ์','มีนาคม','เมษายน','พฤษภาคม','มิถุนายน','กรกฎาคม','สิงหาคม','กันยายน','ตุลาคม','พฤศจิกายน','ธันวาคม'],
      'ms': ['Januari','Februari','Mac','April','Mei','Jun','Julai','Ogos','September','Oktober','November','Disember'],
      'id': ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'],
      'ar': ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'],
      'ur': ['جنوری','فروری','مارچ','اپریل','مئی','جون','جولائی','اگست','ستمبر','اکتوبر','نومبر','دسمبر'],
      'bn': ['জানুয়ারি','ফেব্রুয়ারি','মার্চ','এপ্রিল','মে','জুন','জুলাই','আগস্ট','সেপ্টেম্বর','অক্টোবর','নভেম্বর','ডিসেম্বর'],
    };
    final langMonths = monthNames[widget.lang.lang] ?? monthNames['en']!;
    final gregMonthName = langMonths[_displayMonth.month - 1];
    final gregYear = _displayMonth.year.toString();

    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final startOffset = firstDay.weekday % 7;
    final daysInMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    const dayLabels = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: widget.theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
        child: Column(children: [
          // Handle
          Center(child: Container(
            margin: const EdgeInsets.only(top: 10, bottom: 8),
            width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)))),

          // Header with nav buttons
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [headerColor, headerColor2],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14)),
            child: Row(children: [
              // Prev button
              GestureDetector(
                onTap: () => _changeMonth(-1),
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.chevron_left, color: Colors.white, size: 20))),
              const SizedBox(width: 12),
              // Month info
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (hijriMonthName.isNotEmpty)
                  Text('$hijriMonthName $hijriYear H',
                      style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11)),
                Text('$gregMonthName $gregYear',
                    style: const TextStyle(color: Color(0xFFFFD700), fontSize: 17, fontWeight: FontWeight.bold)),
              ])),
              // Today button
              if (!isCurrentMonth)
                GestureDetector(
                  onTap: () { setState(() => _displayMonth = DateTime.now()); _loadCalendar(); },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      {'en':'Today','th':'วันนี้','ms':'Hari ini','id':'Hari ini','ar':'اليوم','ur':'آج','bn':'আজ'}[widget.lang.lang] ?? 'Today',
                      style: const TextStyle(color: Colors.white, fontSize: 11)))),
              const SizedBox(width: 8),
              // Next button
              GestureDetector(
                onTap: () => _changeMonth(1),
                child: Container(
                  width: 32, height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.chevron_right, color: Colors.white, size: 20))),
            ]),
          ),

          // Day labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(children: List.generate(7, (i) {
              final isFri = i == 5;
              final isSun = i == 0;
              return Expanded(child: Text(dayLabels[i], textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600,
                      color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.subTextColor)));
            })),
          ),
          const SizedBox(height: 6),

          // Grid or loading
          Expanded(child: _loading
            ? Center(child: CircularProgressIndicator(color: widget.theme.iconColor, strokeWidth: 2))
            : SingleChildScrollView(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 7, childAspectRatio: 1.1),
                  itemCount: startOffset + daysInMonth,
                  itemBuilder: (_, idx) {
                    if (idx < startOffset) return const SizedBox();
                    final day = idx - startOffset + 1;
                    final isToday = isCurrentMonth && day == now.day;
                    final dayData = dayMap[day];
                    String hijriDayNum = '';
                    if (dayData != null) {
                      final hMap = dayData['hijri'] as Map<String, dynamic>?;
                      hijriDayNum = hMap?['day']?.toString() ?? '';
                    }
                    final hasHoliday = holidayDays.contains(day);
                    final weekdayIdx = (startOffset + day - 1) % 7;
                    final isFri = weekdayIdx == 5;
                    final isSun = weekdayIdx == 0;

                    return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      isToday
                        ? Container(
                            width: 34, height: 34,
                            decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(9)),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Text('$day', style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold, height: 1)),
                              if (hijriDayNum.isNotEmpty)
                                Text(hijriDayNum, style: TextStyle(fontSize: 7, color: Colors.white.withOpacity(0.8), height: 1.1)),
                            ]))
                        : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            Text('$day', style: TextStyle(fontSize: 13,
                                color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.textColor)),
                            if (hijriDayNum.isNotEmpty)
                              Text(hijriDayNum, style: TextStyle(fontSize: 8, color: widget.theme.subTextColor, height: 1.1)),
                          ]),
                      if (hasHoliday)
                        Container(width: 4, height: 4, margin: const EdgeInsets.only(top: 1),
                            decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle)),
                    ]);
                  },
                ),
              )),

          // Legend
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(children: [
              Container(width: 12, height: 12, decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(3))),
              const SizedBox(width: 4),
              Text(
                {'en':'Today','th':'วันนี้','ms':'Hari ini','id':'Hari ini','ar':'اليوم','ur':'آج','bn':'আজ'}[widget.lang.lang] ?? 'Today',
                style: TextStyle(fontSize: 11, color: widget.theme.subTextColor)),
              const SizedBox(width: 12),
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle)),
              const SizedBox(width: 4),
              Text(
                {'en':'Islamic Holiday','th':'วันสำคัญอิสลาม','ms':'Hari Kebesaran Islam','id':'Hari Besar Islam','ar':'مناسبة إسلامية','ur':'اسلامی تہوار','bn':'ইসলামিক উৎসব'}[widget.lang.lang] ?? 'Islamic Holiday',
                style: TextStyle(fontSize: 11, color: widget.theme.subTextColor)),
            ]),
          ),
        ]),
      ),
    );
  }
}


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