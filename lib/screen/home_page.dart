import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:async';
import 'NearbyMasjid.dart';
import 'HalalRestaurant.dart';
import 'dua_lessons_page.dart';
import 'prayer_time_page.dart';
import 'Al-Quran.dart';
import 'tasbih_page.dart';
import '../services/prayer_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../services/islamic_calendar_service.dart';
import 'package:DEEN/screen/qibla_page.dart';
import 'package:DEEN/screen/chatbot_page.dart';
import 'home_widgets.dart';
import 'islamic_calendar_widgets.dart';

// ── ลายมุมตกแต่งหัวข้อ (ลายดาวทอง export จาก Canva แบบโปร่งใส) ──
// asset เดียวกับที่ใช้ใน lessons_page.dart (คนละไฟล์เลยประกาศแยก ไม่ import
// ข้ามกัน) พลิกด้วย Transform ใช้ซ้ำทั้ง 4 มุมจากไฟล์เดียว
const String kHeaderCornerAsset = 'image/decor/corner_star.png';
// ── ลายเส้นขอบฟ้ามัสยิดสีทอง (export จาก Canva แบบโปร่งใส) ──
// วางไว้ล่างสุดของ header หน้า Home แบบจางๆ เป็นพื้นผิวตกแต่ง
const String kMosqueSkylineAsset = 'image/decor/mosque_skyline.png';
// ── ไอคอนคนละหมาด (silhouette ขาว) — ใช้ร่วมกับ lessons_page.dart
// (การ์ดหมวด "วิธีละหมาด") path เดียวกันเป๊ะ ให้โลโก้ตรงกันทั้งแอป
const String kPrayerIconAsset = 'image/decor/prayer_icon.png';
// ── ไอคอนกิบลัต (silhouette ขาว: เข็มทิศ + กะอ์บะฮ์) ──
const String kQiblaIconAsset = 'image/decor/qibla_icon.png';
// ── ไอคอนมัสยิด (silhouette ขาว) ใช้แทน Icons.mosque ในการ์ด "มัสยิดใกล้เคียง" ──
const String kMosqueIconAsset = 'image/decor/mosque_icon.png';
// ── ไอคอนอัลกุรอาน (silhouette ขาว) ใช้แทน Icons.menu_book ในการ์ด "อัลกุรอาน" ──
const String kQuranIconAsset = 'image/decor/quran_icon.png';
// ── ไอคอนลูกประคำตัสบีฮ์ (silhouette โปร่งใส ที่ผู้ใช้ส่งมาเอง) ใช้แทน
// Icons.fingerprint เดิมในการ์ด "ตัสบีฮ์" ──
const String kTasbihIconAsset = 'image/decor/tasbih_icon.png';

List<Widget> headerCornerDecor({double size = 38}) {
  Widget cornerImg() => Image.asset(kHeaderCornerAsset, width: size, height: size,
      errorBuilder: (_, __, ___) => const SizedBox.shrink());
  Widget flipped(double sx, double sy, Widget child) => Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(sx, sy, 1),
      child: child);

  return [
    Positioned(top: 2, left: 2, child: cornerImg()),
    Positioned(top: 2, right: 2, child: flipped(-1, 1, cornerImg())),
    Positioned(bottom: 2, left: 2, child: flipped(1, -1, cornerImg())),
    Positioned(bottom: 2, right: 2, child: flipped(-1, -1, cornerImg())),
  ];
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, dynamic>? _prayerData;
  bool _prayerLoadFailed = false; // แยกสถานะ "โหลดไม่สำเร็จ" ออกจาก "กำลังโหลด"
  // (ก่อนหน้านี้ไม่มี flag นี้ ทำให้ถ้า fetch ครั้งแรกล้มเหลว (สิทธิ์ตำแหน่ง/
  // เน็ตมีปัญหา) แล้วไม่เคยมี cache มาก่อนเลย การ์ดจะค้าง "..." / "--:--"
  // ตลอดไปแบบเงียบๆ ไม่มีทางรู้ว่าล้มเหลว หรือกดลองใหม่ได้ยังไง)
  Map<String, dynamic>? _hijriData;
  bool _hijriLoadFailed = false; // แยกสถานะ "โหลดไม่สำเร็จ" ออกจาก "กำลังโหลด"
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
    // Load today first (fast), then prefetch in background
    print('=== _loadHijriDate: เริ่มพยายามโหลดปฏิทินฮิจเราะห์ ===');
    setState(() => _hijriLoadFailed = false);
    final data = await IslamicCalendarService.getTodayHijri();
    if (!mounted) return;
    if (data != null) {
      print('=== _loadHijriDate: โหลดสำเร็จ ===');
      setState(() { _hijriData = data; _hijriLoadFailed = false; });
      // Prefetch next month in background (don't await) — ทำเฉพาะตอนโหลดสำเร็จ
      IslamicCalendarService.prefetchCalendars();
    } else {
      // โหลดไม่สำเร็จ (เช่น เน็ตหลุด/API ตอบช้า) — ต้องบอกสถานะนี้ชัดๆ
      // ไม่งั้นการ์ดจะค้างแสดง spinner ตลอดไปโดยไม่มีทางรู้ว่าล้มเหลว
      // (ดู error ที่แท้จริงได้จาก log บรรทัด "Islamic calendar error: ..."
      //  ที่ print ไว้แล้วใน islamic_calendar_service.dart)
      print('=== _loadHijriDate: โหลดไม่สำเร็จ (data == null) ===');
      setState(() => _hijriLoadFailed = true);
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
    print('=== _loadPrayerTimes: เริ่มพยายามโหลดเวลาละหมาด ===');
    setState(() => _prayerLoadFailed = false);
    final data = await PrayerService.getPrayerTimes();
    if (!mounted) return;
    if (data != null) {
      print('=== _loadPrayerTimes: โหลดสำเร็จ ===');
      setState(() { _prayerData = data; _prayerLoadFailed = false; });
    } else {
      // โหลดไม่สำเร็จ (เช่น ปฏิเสธสิทธิ์ตำแหน่ง / เน็ตมีปัญหา / API error) และ
      // ไม่เคยมี cache จากครั้งก่อนเลย — ต้องโชว์สถานะนี้ชัดๆ ไม่ค้าง "..."
      // เงียบๆ ตลอดไป (ดู error จริงได้จาก log "PRAYER ERROR: ..." ใน
      // prayer_service.dart)
      print('=== _loadPrayerTimes: โหลดไม่สำเร็จ (data == null) ===');
      setState(() => _prayerLoadFailed = true);
    }
  }

  void _showMoreSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => MoreBottomSheet(
        theme: _theme,
        lang: _lang,
        onSettingsReturn: _loadPrayerTimes,
      ),
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
              padding: EdgeInsets.fromLTRB(
                  16.w, 16.w, 16.w, 16.w + MediaQuery.of(context).padding.bottom),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(_lang.nextPrayer,
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: _theme.textColor)),
                  SizedBox(height: 10.h),

                  _prayerData == null && _prayerLoadFailed
                      ? GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () {
                            print('=== ผู้ใช้กดปุ่ม retry เวลาละหมาด ===');
                            _loadPrayerTimes();
                          },
                          child: Container(
                            height: 90.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: _theme.cardColor,
                              borderRadius: BorderRadius.circular(18.r),
                              border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
                            ),
                            child: Center(
                              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(Icons.refresh, size: 18.sp, color: _theme.subTextColor),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Text(
                                    _lang.isThai
                                        ? 'โหลดเวลาละหมาดไม่สำเร็จ · แตะเพื่อลองใหม่'
                                        : 'Could not load prayer times · Tap to retry',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 12.sp, color: _theme.subTextColor),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                        )
                      : GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const PrayerTimesPage())),
                          child: NextPrayerCard(
                            prayerName: nextPrayer?['name'] ?? '...',
                            time: nextPrayer?['time'] ?? '--:--',
                            timeUntil: nextPrayer?['timeUntil'] ?? _lang.loading,
                            isDark: _theme.isDark,
                          ),
                        ),

                  // ── ชื่อตำแหน่งที่ใช้คำนวณเวลาละหมาดอยู่ตอนนี้ ──
                  if (_prayerData?['locationName'] != null) ...[
                    SizedBox(height: 8.h),
                    Row(children: [
                      Icon(Icons.location_on, size: 14.sp, color: _theme.subTextColor),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          _prayerData!['locationName'] as String,
                          style: TextStyle(fontSize: 12.sp, color: _theme.subTextColor),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ]),
                  ],

                  SizedBox(height: 16.h),

                  // ── Islamic Calendar ──────────────────
                  IslamicCalendarCard(
                    hijriData: _hijriData,
                    loadFailed: _hijriLoadFailed,
                    onRetry: _loadHijriDate,
                    lang: _lang,
                    theme: _theme,
                  ),

                  SizedBox(height: 16.h),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.1,
                    children: [
                      FeatureCard(
                          label: _lang.alQuran,
                          icon: Icons.menu_book,
                          imageAsset: kQuranIconAsset,
                          theme: _theme,
                          color: const Color(0xFF1B5E20),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlQuranPage()))),
                      FeatureCard(
                          label: _lang.qiblaFinder,
                          icon: Icons.explore,
                          imageAsset: kQiblaIconAsset,
                          tintImage: false,
                          iconSize: 44, // ← ปรับขนาดเฉพาะไอคอนกิบลัตตรงนี้ (ไม่กระทบการ์ดอื่น)
                          theme: _theme,
                          color: const Color(0xFF0277BD),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const QiblaPage()))),
                      FeatureCard(
                          label: _lang.nearbyMosques,
                          icon: Icons.mosque,
                          imageAsset: kMosqueIconAsset,
                          theme: _theme,
                          color: const Color(0xFF6A1B9A),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyMosquesPage()))),
                      FeatureCard(
                          label: _lang.isThai ? 'ร้านอาหารฮาลาล' : 'Halal Food',
                          icon: Icons.restaurant,
                          theme: _theme,
                          color: const Color(0xFFE65100),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HalalRestaurantPage()))),
                      FeatureCard(
                          label: _lang.duaLessons,
                          icon: Icons.self_improvement,
                          imageAsset: kPrayerIconAsset,
                          theme: _theme,
                          color: const Color(0xFF00838F),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DuaLessonsPage()))),
                      FeatureCard(
                          label: _lang.isThai ? 'ตัสบีฮ์' : 'Tasbih',
                          icon: Icons.fingerprint,
                          imageAsset: kTasbihIconAsset,
                          theme: _theme,
                          color: const Color(0xFFB8860B),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TasbihPage()))),
                    ],
                  ),

                  SizedBox(height: 12.h),
                  ChatbotBanner(
                    label: _lang.askChatbot,
                    subtitle: _lang.haveQuestion,
                    theme: _theme,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const ChatbotPage())),
                  ),
                  SizedBox(height: 12.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        lang: _lang,
        theme: _theme,
        onPrayerTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const PrayerTimesPage())),
        onMosqueTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NearbyMosquesPage())),
        onMoreTap: _showMoreSheet,
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    final greetings = {
      'th': hour < 12 ? 'อรุณสวัสดิ์' : hour < 17 ? 'สวัสดีตอนบ่าย' : 'สวัสดีตอนเย็น',
      'en': hour < 12 ? 'Good Morning' : hour < 17 ? 'Good Afternoon' : 'Good Evening',
      'ms': hour < 12 ? 'Selamat Pagi' : hour < 17 ? 'Selamat Tengah Hari' : 'Selamat Petang',
      'id': hour < 12 ? 'Selamat Pagi' : hour < 17 ? 'Selamat Siang' : 'Selamat Sore',
      'ar': hour < 12 ? 'صباح الخير' : hour < 17 ? 'مساء الخير' : 'مساء النور',
      'ur': hour < 12 ? 'صبح بخیر' : hour < 17 ? 'دوپہر بخیر' : 'شام بخیر',
      'bn': hour < 12 ? 'শুভ সকাল' : hour < 17 ? 'শুভ দুপুর' : 'শুভ সন্ধ্যা',
    };
    return greetings[_lang.lang] ?? greetings['en']!;
  }

  Widget _buildHeader() {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    // ── ใช้ service กลางแปลชื่อวัน/เดือนเกรกอเรียนแทน hardcode อังกฤษตายตัว
    // (Dart's DateTime.weekday: Monday=1..Sunday=7 → %7 แปลงเป็น Sunday=0..Saturday=6)
    final weekdayShort = IslamicCalendarService.getWeekdayShortLabels(_lang.lang)[now.weekday % 7];
    final monthShort = IslamicCalendarService.getGregorianMonthName(now.month, _lang.lang);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _theme.isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A5C32)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16, offset: const Offset(0, 4)),
        ],
      ),
      child: SafeArea(
        child: Stack(children: [
          // ── ลายเส้นขอบฟ้ามัสยิดสีทอง (จางๆ) แปะไว้ล่างสุดของ Stack
          // ให้ทุกอย่าง (ลายมุม + ข้อความ) render ทับข้างบนอีกที ──
          Positioned(
            left: 0, right: 0, bottom: 0,
            height: 80.h,
            child: ClipRect(
              child: Opacity(
                opacity: 0.22,
                child: Image.asset(
                  kMosqueSkylineAsset,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),
            ),
          ),
          ...headerCornerDecor(),
          Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left: greeting
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('As-salamu Alaykum',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13.sp, letterSpacing: 0.5)),
                SizedBox(height: 4.h),
                Text(_getGreeting(),
                    style: TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4.h),
                Text(_lang.welcomeToDeen,
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12.sp)),
              ])),
              // Right: clock
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text(timeStr,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 1)),
                Text(
                  '$weekdayShort, ${now.day} $monthShort',
                  style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11.sp)),
              ]),
            ],
          ),
          ),
        ]),
      ),
    );
  }
}