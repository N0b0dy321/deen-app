import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../services/islamic_calendar_service.dart';

// ── ป้ายแปลภาษาที่ใช้ร่วมกันหลายจุดในไฟล์นี้ (เดิมประกาศซ้ำ 3 ที่ใน
// home_page.dart เก่า: _todayLabel(), ปุ่ม Today มุมมองฮิจเราะห์, legend) ──
const Map<String, String> kTodayLabels = {
  'en': 'Today', 'th': 'วันนี้', 'ms': 'Hari ini', 'id': 'Hari ini',
  'ar': 'اليوم', 'ur': 'آج', 'bn': 'আজ',
};
const Map<String, String> kIslamicHolidayLabels = {
  'en': 'Islamic Holiday', 'th': 'วันสำคัญอิสลาม', 'ms': 'Hari Kebesaran Islam',
  'id': 'Hari Besar Islam', 'ar': 'مناسبة إسلامية', 'ur': 'اسلامی تہوار', 'bn': 'ইসলামিক উৎসব',
};

// ── Islamic Calendar Card ──────────────────────────
class IslamicCalendarCard extends StatefulWidget {
  final Map<String, dynamic>? hijriData;
  final bool loadFailed;
  final VoidCallback onRetry;
  final LanguageService lang;
  final ThemeService theme;

  const IslamicCalendarCard({
    super.key,
    required this.hijriData,
    required this.loadFailed,
    required this.onRetry,
    required this.lang,
    required this.theme,
  });

  @override
  State<IslamicCalendarCard> createState() => _IslamicCalendarCardState();
}

class _IslamicCalendarCardState extends State<IslamicCalendarCard> {
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
      'today': kTodayLabels,
      'hijri': {'en': 'Hijri', 'th': 'ฮิจเราะห์', 'ms': 'Hijri', 'id': 'Hijriah', 'ar': 'هجري', 'ur': 'ہجری', 'bn': 'হিজরি'},
      'viewCalendar': {'en': 'View Calendar', 'th': 'ดูปฏิทิน', 'ms': 'Lihat Kalendar', 'id': 'Lihat Kalender', 'ar': 'عرض التقويم', 'ur': 'کیلنڈر دیکھیں', 'bn': 'ক্যালেন্ডার দেখুন'},
      'loadFailed': {'en': 'Could not load calendar', 'th': 'โหลดปฏิทินไม่สำเร็จ', 'ms': 'Gagal memuat kalendar', 'id': 'Gagal memuat kalender', 'ar': 'تعذر تحميل التقويم', 'ur': 'کیلنڈر لوڈ نہیں ہوسکا', 'bn': 'ক্যালেন্ডার লোড করা যায়নি'},
      'tapToRetry': {'en': 'Tap to retry', 'th': 'แตะเพื่อลองใหม่', 'ms': 'Ketik untuk cuba lagi', 'id': 'Ketuk untuk coba lagi', 'ar': 'اضغط لإعادة المحاولة', 'ur': 'دوبارہ کوشش کے لیے ٹیپ کریں', 'bn': 'আবার চেষ্টা করতে ট্যাপ করুন'},
    };
    return labels[key]?[widget.lang.lang] ?? labels[key]?['en'] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.theme.isDark;
    final headerColor = isDark ? const Color(0xFF0D2E1A) : const Color(0xFF1B5E20);
    final headerColor2 = isDark ? const Color(0xFF1A4A2A) : const Color(0xFF2E7D32);

    // โหลดไม่สำเร็จ (เช่น เน็ตหลุด) — ต้องมีทางออกให้ user กดลองใหม่
    // แทนที่จะปล่อยให้ spinner หมุนค้างตลอดไปแบบไม่มีความหมาย
    if (widget.loadFailed && widget.hijriData == null) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque, // บังคับให้พื้นที่ทั้งการ์ดรับแตะได้แน่นอน
        onTap: () {
          print('=== ผู้ใช้กดปุ่ม retry ปฏิทิน ===');
          widget.onRetry();
        },
        child: Container(
          height: 72.h,
          decoration: BoxDecoration(
            color: widget.theme.cardColor,
            borderRadius: BorderRadius.circular(18.r),
            border: isDark ? Border.all(color: ThemeService.darkBorder) : null,
          ),
          child: Center(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.refresh, size: 18.sp, color: widget.theme.subTextColor),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  '${_getLabel('loadFailed')} · ${_getLabel('tapToRetry')}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(fontSize: 12.sp, color: widget.theme.subTextColor),
                ),
              ),
            ]),
          ),
        ),
      );
    }

    if (widget.hijriData == null) {
      return Container(
        height: 72.h,
        decoration: BoxDecoration(
          color: widget.theme.cardColor,
          borderRadius: BorderRadius.circular(18.r),
          border: isDark ? Border.all(color: ThemeService.darkBorder) : null,
        ),
        child: Center(child: CircularProgressIndicator(color: widget.theme.iconColor, strokeWidth: 2.w)),
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
    final gregYear = gregorian['year']?.toString() ?? '';
    final holiday = IslamicCalendarService.getIslamicHoliday(holidays, widget.lang.lang);
    final now = DateTime.now();
    // ── ใช้ service กลางแปลชื่อวัน/เดือนเกรกอเรียนแทน ['en'] ตรงๆ
    // (ก่อนหน้านี้เป็นสาเหตุที่ทำให้ตรงนี้ไม่เปลี่ยนภาษาตามแอปเลย) ──
    final weekday = IslamicCalendarService.getWeekdayName(now.weekday % 7, widget.lang.lang);
    final gregMonthName = IslamicCalendarService.getGregorianMonthName(now.month, widget.lang.lang);

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

    // ตัวย่อวันในสัปดาห์ตามภาษาปัจจุบัน (แทน hardcode ['S','M','T','W','T','F','S'])
    final dayLetters = IslamicCalendarService.getWeekdayShortLabels(widget.lang.lang);

    return GestureDetector(
      onTap: () => _showFullCalendar(context),
      child: Container(
        decoration: BoxDecoration(
          color: widget.theme.cardColor,
          borderRadius: BorderRadius.circular(18.r),
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
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [headerColor, headerColor2])),
                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Text(_getLabel('hijri'),
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9.sp, letterSpacing: 0.5)),
                  Text(hijriDay,
                      style: TextStyle(color: Color(0xFFFFD700), fontSize: 32.sp, fontWeight: FontWeight.bold, height: 1.1.h)),
                  Text(hijriMonthName,
                      style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 9.sp, height: 1.3.h),
                      textAlign: TextAlign.center),
                  Text('$hijriYear H',
                      style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 9.sp)),
                ]),
              ),
              // Right: Info
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text('$weekday, $gregDay $gregMonthName $gregYear',
                        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: widget.theme.textColor),
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    SizedBox(height: 4.h),
                    if (holiday != null) ...[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8.r)),
                        child: Text('⭐ $holiday',
                            style: TextStyle(fontSize: 11.sp, color: Color(0xFFD4A017), fontWeight: FontWeight.w600))),
                    ] else
                      Text('$hijriDay $hijriMonthName $hijriYear H',
                          style: TextStyle(fontSize: 11.sp, color: widget.theme.subTextColor)),
                    SizedBox(height: 8.h),
                    Row(children: [
                      Icon(Icons.calendar_month_rounded, size: 12.sp, color: widget.theme.iconColor),
                      SizedBox(width: 4.w),
                      Text(_getLabel('viewCalendar'),
                          style: TextStyle(fontSize: 11.sp, color: widget.theme.iconColor, fontWeight: FontWeight.w500)),
                      SizedBox(width: 2.w),
                      Icon(Icons.chevron_right, size: 14.sp, color: widget.theme.iconColor),
                    ]),
                  ]),
                ),
              ),
            ]),
          ),

          // ── Week strip ──
          Container(
            color: isDark ? const Color(0xFF0D2E1A) : const Color(0xFFE8F5E9),
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (i) {
                final d = weekStart.add(Duration(days: i));
                final isToday = d.day == now.day && d.month == now.month;
                final isFri = d.weekday == 5;
                final isSun = d.weekday == DateTime.sunday;
                // Only show hijri if same month as calendar data
                String hijriD = '';
                if (d.month == now.month && dayMap.containsKey(d.day)) {
                  hijriD = (dayMap[d.day]?['hijri'] as Map?)?['day']?.toString() ?? '';
                }

                return Column(children: [
                  Text(dayLetters[i],
                      style: TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w600,
                          color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.subTextColor)),
                  SizedBox(height: 4.h),
                  isToday
                    ? Container(
                        width: 26.w, height: 26.h,
                        decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(7.r)),
                        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('${d.day}', style: TextStyle(fontSize: 10.sp, color: Colors.white, fontWeight: FontWeight.bold, height: 1.h)),
                          if (hijriD.isNotEmpty)
                            Text(hijriD, style: TextStyle(fontSize: 6.sp, color: Colors.white.withOpacity(0.8), height: 1.1.h)),
                        ]))
                    : Column(children: [
                        Text('${d.day}', style: TextStyle(fontSize: 11.sp,
                            color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.textColor)),
                        if (hijriD.isNotEmpty)
                          Text(hijriD, style: TextStyle(fontSize: 7.sp, color: widget.theme.subTextColor, height: 1.1.h)),
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
  bool _loadFailed = false; // แยกสถานะ "โหลดไม่สำเร็จ" ออกจาก "กำลังโหลด"

  // ── มุมมองฮิจเราะห์ (สลับได้จากปุ่มด้านบน) — แก้ปัญหาเดือนคาบเกี่ยว
  // ตรงจุดที่สุด เพราะโหมดนี้จะโชว์ครบ 1 เดือนฮิจเราะห์เป๊ะๆ ไม่มีเดือนอื่นปนมา ──
  bool _isHijriView = false;
  late int _hijriMonth;
  late int _hijriYear;
  late int _todayHijriMonth;
  late int _todayHijriYear;
  List<Map<String, dynamic>>? _hijriViewData;
  bool _hijriViewLoading = false;
  bool _hijriViewLoadFailed = false;

  @override
  void initState() {
    super.initState();
    _displayMonth = DateTime.now();
    // ตั้งต้นเดือนฮิจเราะห์จากข้อมูล "วันนี้" ที่ส่งมาจากการ์ดหน้า Home อยู่แล้ว
    // ไม่ต้องยิง API ซ้ำ
    final todayHijri = widget.hijriData?['hijri'] as Map<String, dynamic>?;
    _hijriMonth = int.tryParse(todayHijri?['month']?['number']?.toString() ?? '') ?? 1;
    _hijriYear = int.tryParse(todayHijri?['year']?.toString() ?? '') ?? 1447;
    _todayHijriMonth = _hijriMonth;
    _todayHijriYear = _hijriYear;
    _loadCalendar();
  }

  Future<void> _loadCalendar() async {
    setState(() { _loading = true; _loadFailed = false; });
    final data = await IslamicCalendarService.getHijriCalendar(
        _displayMonth.month, _displayMonth.year);
    if (!mounted) return;
    if (data != null) {
      setState(() { _calendarData = data; _loading = false; _loadFailed = false; });
    } else {
      // โหลดไม่สำเร็จและไม่มี cache ของเดือนนี้เลย (เช่น เดือนที่ยังไม่เคย
      // prefetch ไว้ + ตอนนี้ไม่มีเน็ต) — ต้องโชว์สถานะนี้ชัดๆ ไม่ปล่อยให้
      // ตารางว่างเปล่าดูเหมือนพังเงียบๆ
      setState(() { _loading = false; _loadFailed = true; });
    }
  }

  void _changeMonth(int delta) {
    setState(() {
      _displayMonth = DateTime(_displayMonth.year, _displayMonth.month + delta);
      _calendarData = null;
    });
    _loadCalendar();
  }

  Future<void> _loadHijriViewCalendar() async {
    setState(() { _hijriViewLoading = true; _hijriViewLoadFailed = false; });
    final data = await IslamicCalendarService.getHijriToGregorianCalendar(_hijriMonth, _hijriYear);
    if (!mounted) return;
    if (data != null) {
      setState(() { _hijriViewData = data; _hijriViewLoading = false; _hijriViewLoadFailed = false; });
    } else {
      setState(() { _hijriViewLoading = false; _hijriViewLoadFailed = true; });
    }
  }

  void _changeHijriMonth(int delta) {
    setState(() {
      _hijriMonth += delta;
      if (_hijriMonth > 12) { _hijriMonth = 1; _hijriYear++; }
      if (_hijriMonth < 1) { _hijriMonth = 12; _hijriYear--; }
      _hijriViewData = null;
    });
    _loadHijriViewCalendar();
  }

  void _toggleViewMode(bool toHijri) {
    if (toHijri == _isHijriView) return;
    setState(() => _isHijriView = toHijri);
    if (toHijri && _hijriViewData == null) _loadHijriViewCalendar();
  }

  String _todayLabel() => kTodayLabels[widget.lang.lang] ?? 'Today';

  // ── สถานะ "โหลดเดือนนี้ไม่สำเร็จ" (เช่น เดือนที่ยังไม่เคย prefetch ไว้
  // ล่วงหน้า + ตอนนี้ไม่มีเน็ต) ให้กดแตะเพื่อลองใหม่ได้ แทนที่จะปล่อยตาราง
  // ว่างเปล่าดูเหมือนพังเงียบๆ (ใช้ร่วมกันทั้งมุมมองเกรกอเรียนและฮิจเราะห์) ──
  Widget _buildRetryState({required VoidCallback onRetry}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onRetry,
      child: Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.cloud_off_rounded, size: 32.sp, color: widget.theme.subTextColor),
          SizedBox(height: 10.h),
          Text(
            {'en':'Could not load this month','th':'โหลดเดือนนี้ไม่สำเร็จ','ms':'Gagal memuat bulan ini','id':'Gagal memuat bulan ini','ar':'تعذر تحميل هذا الشهر','ur':'اس مہینے کو لوڈ نہیں کیا جا سکا','bn':'এই মাসটি লোড করা যায়নি'}[widget.lang.lang]
                ?? 'Could not load this month',
            style: TextStyle(fontSize: 13.sp, color: widget.theme.subTextColor)),
          SizedBox(height: 4.h),
          Text(
            {'en':'Tap to retry','th':'แตะเพื่อลองใหม่','ms':'Ketik untuk cuba lagi','id':'Ketuk untuk coba lagi','ar':'اضغط لإعادة المحاولة','ur':'دوبارہ کوشش کے لیے ٹیپ کریں','bn':'আবার চেষ্টা করতে ট্যাপ করুন'}[widget.lang.lang]
                ?? 'Tap to retry',
            style: TextStyle(fontSize: 11.sp, color: widget.theme.iconColor, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  // ปุ่มเดียวในชุด segmented switch เกรกอเรียน/ฮิจเราะห์
  Widget _viewToggleButton({required String label, required bool selected, required Color headerColor, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? headerColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8.r)),
        alignment: Alignment.center,
        child: Text(label, style: TextStyle(
            fontSize: 12.sp, fontWeight: FontWeight.w600,
            color: selected ? Colors.white : widget.theme.subTextColor)),
      ),
    );
  }

  // ── แตะวันไหนในตาราง ดูรายละเอียดวันนั้นแบบเต็ม (เกรกอเรียน + ฮิจเราะห์
  // + วันสำคัญถ้ามี) ให้หน้าปฏิทินเต็มใช้งานได้จริงมากขึ้น ไม่ใช่แค่ดูเฉยๆ
  // รับ item ตรงๆ แล้วดึงข้อมูลเกรกอเรียนจากตัว item เอง (ไม่พึ่ง _displayMonth)
  // เพื่อให้ใช้ได้ทั้งมุมมองเกรกอเรียนและมุมมองฮิจเราะห์ ──
  void _showDayDetail(Map<String, dynamic> item) {
    final headerColor = widget.theme.isDark ? const Color(0xFF0D2E1A) : const Color(0xFF1B5E20);
    final headerColor2 = widget.theme.isDark ? const Color(0xFF1A4A2A) : const Color(0xFF2E7D32);

    final g = item['gregorian'] as Map<String, dynamic>? ?? {};
    final h = item['hijri'] as Map<String, dynamic>? ?? {};

    final gDay = int.tryParse(g['day']?.toString() ?? '') ?? 0;
    final gMonthNum = int.tryParse(g['month']?['number']?.toString() ?? '') ?? 0;
    final gYear = int.tryParse(g['year']?.toString() ?? '') ?? 0;
    final weekdayIdx = (gDay > 0 && gMonthNum > 0 && gYear > 0)
        ? DateTime(gYear, gMonthNum, gDay).weekday % 7
        : 0;
    final weekdayName = IslamicCalendarService.getWeekdayName(weekdayIdx, widget.lang.lang);
    final gregMonthName = gMonthNum > 0
        ? IslamicCalendarService.getGregorianMonthName(gMonthNum, widget.lang.lang)
        : '';

    final hijriDayNum = h['day']?.toString() ?? '';
    final hMonthEn = h['month']?['en'] as String? ?? '';
    final hijriMonthName = IslamicCalendarService.getHijriMonthName(hMonthEn, widget.lang.lang);
    final hijriYearStr = h['year']?.toString() ?? '';
    final hols = h['holidays'] as List<dynamic>? ?? [];
    final holidayName = IslamicCalendarService.getIslamicHoliday(hols, widget.lang.lang);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: widget.theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        contentPadding: EdgeInsets.zero,
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [headerColor, headerColor2],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r))),
            child: Column(children: [
              Text(weekdayName,
                  style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 12.sp)),
              SizedBox(height: 4.h),
              Text('$gDay $gregMonthName $gYear',
                  style: TextStyle(color: Color(0xFFFFD700), fontSize: 18.sp, fontWeight: FontWeight.bold)),
              if (hijriDayNum.isNotEmpty) ...[
                SizedBox(height: 6.h),
                Text('$hijriDayNum $hijriMonthName $hijriYearStr H',
                    style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12.sp)),
              ],
            ]),
          ),
          Padding(
            padding: EdgeInsets.all(20.w),
            child: holidayName != null
                ? Row(children: [
                    const Text('⭐', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 8.w),
                    Expanded(child: Text(holidayName,
                        style: TextStyle(color: widget.theme.textColor, fontSize: 14.sp, fontWeight: FontWeight.w600))),
                  ])
                : Text(
                    {'en':'No Islamic holiday on this day','th':'ไม่มีวันสำคัญอิสลามในวันนี้','ms':'Tiada hari kebesaran Islam','id':'Tidak ada hari besar Islam','ar':'لا توجد مناسبة إسلامية','ur':'اس دن کوئی اسلامی تہوار نہیں','bn':'এই দিনে কোনো ইসলামিক উৎসব নেই'}[widget.lang.lang]
                        ?? 'No Islamic holiday on this day',
                    style: TextStyle(color: widget.theme.subTextColor, fontSize: 13.sp)),
          ),
        ]),
        actionsPadding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: widget.theme.iconColor, fontWeight: FontWeight.w600))),
        ],
      ),
    );
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
    // วันสำคัญในเดือนนี้ทั้งหมด (day -> ชื่อวันสำคัญที่แปลแล้ว) ใช้ทำลิสต์
    // "วันสำคัญเดือนนี้" ด้านล่างตาราง ให้หน้าปฏิทินเต็มมีประโยชน์มากขึ้น
    final Map<int, String> holidaysThisMonth = {};
    if (_calendarData != null) {
      for (final day in _calendarData!) {
        final g = day['gregorian'] as Map<String, dynamic>? ?? {};
        final gd = int.tryParse(g['day']?.toString() ?? '0') ?? 0;
        if (gd > 0) {
          dayMap[gd] = day;
          final h = day['hijri'] as Map<String, dynamic>? ?? {};
          final hols = h['holidays'] as List<dynamic>? ?? [];
          if (hols.isNotEmpty) {
            final name = IslamicCalendarService.getIslamicHoliday(hols, widget.lang.lang);
            if (name != null) holidaysThisMonth[gd] = name;
          }
        }
      }
    }
    final holidayDays = holidaysThisMonth.keys.toSet();

    // Get hijri info for displayed month
    String hijriMonthName = '';
    String hijriYear = '';
    if (dayMap[15] != null) {
      final h = dayMap[15]!['hijri'] as Map<String, dynamic>? ?? {};
      final hMonthEn = h['month']?['en'] as String? ?? '';
      hijriMonthName = IslamicCalendarService.getHijriMonthName(hMonthEn, widget.lang.lang);
      hijriYear = h['year']?.toString() ?? '';
    }

    // ── ใช้ service กลางแทน map ชื่อเดือนที่ hardcode ซ้ำในไฟล์นี้ก่อนหน้า ──
    final gregMonthName = IslamicCalendarService.getGregorianMonthName(_displayMonth.month, widget.lang.lang);
    final gregYear = _displayMonth.year.toString();

    final firstDay = DateTime(_displayMonth.year, _displayMonth.month, 1);
    final startOffset = firstDay.weekday % 7;
    final daysInMonth = DateTime(_displayMonth.year, _displayMonth.month + 1, 0).day;
    // ── ตัวย่อวันในสัปดาห์ตามภาษาปัจจุบัน (แทน hardcode ['S','M','T','W','T','F','S']
    // ที่ทำให้หัวตารางไม่เปลี่ยนภาษาตามแอปมาก่อนหน้านี้) ──
    final dayLabels = IslamicCalendarService.getWeekdayShortLabels(widget.lang.lang);

    // ── เดือนฮิจเราะห์ไม่ยาวพอดีเท่าเดือนเกรกอเรียน (29-30 วัน vs 28-31 วัน)
    // ทำให้บางวันต้น/ท้ายเดือนในตารางนี้ อาจเป็นคนละเดือนฮิจเราะห์กับที่โชว์
    // อยู่ในหัวข้อ (hijriMonthName) ถ้าไม่มีสัญญาณบอก user จะงงว่าทำไมเลขวัน
    // ฮิจเราะห์เด้งจาก 29 กลับไป 1 กลางตาราง — เลยหาให้ว่าวันไหนเป็น "คนละเดือน"
    // กับเดือนหลัก และวันไหนคือจุดเริ่มต้นของเดือนใหม่พอดี (ใส่ label ตรงนั้น)
    final String primaryHijriMonthEn = dayMap[15] != null
        ? ((dayMap[15]!['hijri'] as Map?)?['month']?['en'] as String? ?? '')
        : '';
    final Map<int, String> monthTransitionLabels = {}; // day -> ชื่อเดือนฮิจเราะห์ใหม่ที่แปลแล้ว
    String? prevHijriMonthEn;
    for (int d = 1; d <= daysInMonth; d++) {
      final mEn = (dayMap[d]?['hijri'] as Map?)?['month']?['en'] as String? ?? '';
      if (mEn.isEmpty) continue;
      if (prevHijriMonthEn != null && mEn != prevHijriMonthEn) {
        monthTransitionLabels[d] = IslamicCalendarService.getHijriMonthName(mEn, widget.lang.lang);
      }
      prevHijriMonthEn = mEn;
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      maxChildSize: 0.92,
      minChildSize: 0.5,
      builder: (_, ctrl) => Container(
        decoration: BoxDecoration(
          color: widget.theme.cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r))),
        child: Column(children: [
          // Handle
          Center(child: Container(
            margin: EdgeInsets.only(top: 10.h, bottom: 8.h),
            width: 40.w, height: 4.h,
            decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2.r)))),

          // ── ปุ่มสลับมุมมอง เกรกอเรียน / ฮิจเราะห์ ──
          // แก้ปัญหาเดือนคาบเกี่ยว: มุมมองฮิจเราะห์จะโชว์ครบ 1 เดือนฮิจเราะห์
          // เป๊ะๆ ไม่มีเดือนอื่นปนมาเลย ให้ user เลือกดูแบบไหนก็ได้ตามสะดวก
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0D2E1A) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(10.r)),
              child: Row(children: [
                Expanded(child: _viewToggleButton(
                  label: {'en':'Gregorian','th':'เกรกอเรียน','ms':'Gregorian','id':'Masehi','ar':'ميلادي','ur':'عیسوی','bn':'গ্রেগরিয়ান'}[widget.lang.lang] ?? 'Gregorian',
                  selected: !_isHijriView,
                  headerColor: headerColor,
                  onTap: () => _toggleViewMode(false),
                )),
                Expanded(child: _viewToggleButton(
                  label: {'en':'Hijri','th':'ฮิจเราะห์','ms':'Hijri','id':'Hijriah','ar':'هجري','ur':'ہجری','bn':'হিজরি'}[widget.lang.lang] ?? 'Hijri',
                  selected: _isHijriView,
                  headerColor: headerColor,
                  onTap: () => _toggleViewMode(true),
                )),
              ]),
            ),
          ),
          SizedBox(height: 10.h),

          if (_isHijriView) ...[
            // ══════════════ มุมมองฮิจเราะห์ ══════════════
            // Header with nav buttons (นับตามเดือนฮิจเราะห์)
            Container(
              margin: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 12.h),
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [headerColor, headerColor2],
                    begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(14.r)),
              child: Row(children: [
                GestureDetector(
                  onTap: () => _changeHijriMonth(-1),
                  child: Container(
                    width: 32.w, height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r)),
                    child: Icon(Icons.chevron_left, color: Colors.white, size: 20.sp))),
                SizedBox(width: 12.w),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  if (_hijriViewData != null && _hijriViewData!.isNotEmpty)
                    Builder(builder: (_) {
                      final firstG = _hijriViewData!.first['gregorian'] as Map<String, dynamic>? ?? {};
                      final lastG = _hijriViewData!.last['gregorian'] as Map<String, dynamic>? ?? {};
                      final fMonth = int.tryParse(firstG['month']?['number']?.toString() ?? '') ?? 0;
                      final lMonth = int.tryParse(lastG['month']?['number']?.toString() ?? '') ?? 0;
                      final fName = fMonth > 0 ? IslamicCalendarService.getGregorianMonthName(fMonth, widget.lang.lang) : '';
                      final lName = lMonth > 0 ? IslamicCalendarService.getGregorianMonthName(lMonth, widget.lang.lang) : '';
                      final rangeText = fName == lName
                          ? '$fName ${firstG['year']}'
                          : '$fName - $lName ${lastG['year']}';
                      return Text(rangeText,
                          style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11.sp));
                    }),
                  Text('${IslamicCalendarService.getHijriMonthNameByNumber(_hijriMonth, widget.lang.lang)} $_hijriYear H',
                      style: TextStyle(color: Color(0xFFFFD700), fontSize: 17.sp, fontWeight: FontWeight.bold)),
                ])),
                if (!(_hijriMonth == _todayHijriMonth && _hijriYear == _todayHijriYear))
                  GestureDetector(
                    onTap: () {
                      setState(() { _hijriMonth = _todayHijriMonth; _hijriYear = _todayHijriYear; });
                      _loadHijriViewCalendar();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(8.r)),
                      child: Text(_todayLabel(),
                          style: TextStyle(color: Colors.white, fontSize: 11.sp)))),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () => _changeHijriMonth(1),
                  child: Container(
                    width: 32.w, height: 32.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r)),
                    child: Icon(Icons.chevron_right, color: Colors.white, size: 20.sp))),
              ]),
            ),

            // Day labels (ใช้ตัวย่อวันชุดเดียวกันทั้งสองมุมมอง)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(children: List.generate(7, (i) {
                final isFri = i == 5;
                final isSun = i == 0;
                return Expanded(child: Text(
                    IslamicCalendarService.getWeekdayShortLabels(widget.lang.lang)[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600,
                        color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.subTextColor)));
              })),
            ),
            SizedBox(height: 6.h),

            // Grid — ครบ 1 เดือนฮิจเราะห์เป๊ะๆ ไม่มีเดือนอื่นปนมา
            Expanded(child: _hijriViewLoadFailed
              ? _buildRetryState(onRetry: _loadHijriViewCalendar)
              : _hijriViewLoading || _hijriViewData == null
                ? Center(child: CircularProgressIndicator(color: widget.theme.iconColor, strokeWidth: 2.w))
                : Builder(builder: (_) {
                  final data = _hijriViewData!;
                  final firstG = data.first['gregorian'] as Map<String, dynamic>? ?? {};
                  final fd = int.tryParse(firstG['day']?.toString() ?? '') ?? 1;
                  final fm = int.tryParse(firstG['month']?['number']?.toString() ?? '') ?? 1;
                  final fy = int.tryParse(firstG['year']?.toString() ?? '') ?? DateTime.now().year;
                  final hijriStartOffset = DateTime(fy, fm, fd).weekday % 7;
                  final now = DateTime.now();

                  return SingleChildScrollView(
                    controller: ctrl,
                    padding: EdgeInsets.fromLTRB(12.w, 0.h, 12.w, 20.h),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7, childAspectRatio: 1.1),
                      itemCount: hijriStartOffset + data.length,
                      itemBuilder: (_, idx) {
                        if (idx < hijriStartOffset) return const SizedBox();
                        final item = data[idx - hijriStartOffset];
                        final h = item['hijri'] as Map<String, dynamic>? ?? {};
                        final g = item['gregorian'] as Map<String, dynamic>? ?? {};
                        final hijriDayNum = h['day']?.toString() ?? '${idx - hijriStartOffset + 1}';
                        final gDayStr = g['day']?.toString() ?? '';
                        final gMonthNum = int.tryParse(g['month']?['number']?.toString() ?? '') ?? 0;
                        final gYear = int.tryParse(g['year']?.toString() ?? '') ?? 0;
                        final gDayInt = int.tryParse(gDayStr) ?? 0;
                        final isToday = gDayInt > 0 && gDayInt == now.day && gMonthNum == now.month && gYear == now.year;
                        final hols = h['holidays'] as List<dynamic>? ?? [];
                        final hasHoliday = hols.isNotEmpty;
                        final weekdayIdx = (hijriStartOffset + (idx - hijriStartOffset)) % 7;
                        final isFri = weekdayIdx == 5;
                        final isSun = weekdayIdx == 0;

                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => _showDayDetail(item),
                          child: Container(
                            decoration: isFri
                                ? BoxDecoration(
                                    color: (isDark ? const Color(0xFF2ECC71) : const Color(0xFF1B5E20))
                                        .withOpacity(isDark ? 0.06 : 0.04),
                                    borderRadius: BorderRadius.circular(8.r))
                                : null,
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              isToday
                                ? Container(
                                    width: 34.w, height: 34.h,
                                    decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(9.r)),
                                    child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                      Text(hijriDayNum, style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.bold, height: 1.h)),
                                      if (gDayStr.isNotEmpty)
                                        Text('$gDayStr/$gMonthNum', style: TextStyle(fontSize: 7.sp, color: Colors.white.withOpacity(0.8), height: 1.1.h)),
                                    ]))
                                : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text(hijriDayNum, style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600,
                                        color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.textColor)),
                                    if (gDayStr.isNotEmpty)
                                      Text('$gDayStr/$gMonthNum', style: TextStyle(fontSize: 8.sp, color: widget.theme.subTextColor, height: 1.1.h)),
                                  ]),
                              if (hasHoliday)
                                Container(width: 4.w, height: 4.h, margin: EdgeInsets.only(top: 1.h),
                                    decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle)),
                            ]),
                          ),
                        );
                      },
                    ),
                  );
                })),
          ] else ...[
          // ══════════════ มุมมองเกรกอเรียน (ของเดิม) ══════════════
          // Header with nav buttons
          Container(
            margin: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 12.h),
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [headerColor, headerColor2],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(14.r)),
            child: Row(children: [
              // Prev button
              GestureDetector(
                onTap: () => _changeMonth(-1),
                child: Container(
                  width: 32.w, height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r)),
                  child: Icon(Icons.chevron_left, color: Colors.white, size: 20.sp))),
              SizedBox(width: 12.w),
              // Month info
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                if (hijriMonthName.isNotEmpty)
                  Text('$hijriMonthName $hijriYear H',
                      style: TextStyle(color: Colors.white.withOpacity(0.75), fontSize: 11.sp)),
                Text('$gregMonthName $gregYear',
                    style: TextStyle(color: Color(0xFFFFD700), fontSize: 17.sp, fontWeight: FontWeight.bold)),
              ])),
              // Today button
              if (!isCurrentMonth)
                GestureDetector(
                  onTap: () { setState(() => _displayMonth = DateTime.now()); _loadCalendar(); },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8.r)),
                    child: Text(_todayLabel(),
                        style: TextStyle(color: Colors.white, fontSize: 11.sp)))),
              SizedBox(width: 8.w),
              // Next button
              GestureDetector(
                onTap: () => _changeMonth(1),
                child: Container(
                  width: 32.w, height: 32.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8.r)),
                  child: Icon(Icons.chevron_right, color: Colors.white, size: 20.sp))),
            ]),
          ),

          // Day labels
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(children: List.generate(7, (i) {
              final isFri = i == 5;
              final isSun = i == 0;
              return Expanded(child: Text(dayLabels[i], textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w600,
                      color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.subTextColor)));
            })),
          ),
          SizedBox(height: 6.h),

          // Grid or loading
          Expanded(child: _loadFailed
            ? _buildRetryState(onRetry: _loadCalendar)
            : _loading
              ? Center(child: CircularProgressIndicator(color: widget.theme.iconColor, strokeWidth: 2.w))
              : SingleChildScrollView(
                controller: ctrl,
                padding: EdgeInsets.fromLTRB(12.w, 0.h, 12.w, 20.h),
                child: Column(children: [
                  GridView.builder(
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

                      // ── วันนี้อยู่คนละเดือนฮิจเราะห์กับที่โชว์ในหัวข้อไหม
                      // (เช่น หัวบอก "รอมฎอน" แต่ 2 วันท้ายตารางเป็น "เชาวาล" ไปแล้ว)
                      // ถ้าใช่ ทำเลขฮิจเราะห์เป็นสีเหลืองทองแทนสีปกติ ให้สังเกตง่าย
                      // โดยไม่ต้องกดเข้าไปดูทีละวัน ──
                      final dayHijriMonthEn = (dayData?['hijri'] as Map?)?['month']?['en'] as String? ?? '';
                      final isOtherHijriMonth = dayHijriMonthEn.isNotEmpty &&
                          primaryHijriMonthEn.isNotEmpty &&
                          dayHijriMonthEn != primaryHijriMonthEn;
                      final hijriNumColor = isOtherHijriMonth
                          ? const Color(0xFFC9971A)
                          : widget.theme.subTextColor;
                      final transitionLabel = monthTransitionLabels[day];

                      // ── แตะดูรายละเอียดวันนั้นได้ (ทำให้หน้าปฏิทินเต็ม
                      // ใช้งานได้จริง ไม่ใช่แค่ดูเฉยๆ) ──
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: dayData != null ? () => _showDayDetail(dayData) : null,
                        child: Container(
                          decoration: isFri
                              ? BoxDecoration(
                                  color: (isDark ? const Color(0xFF2ECC71) : const Color(0xFF1B5E20))
                                      .withOpacity(isDark ? 0.06 : 0.04),
                                  borderRadius: BorderRadius.circular(8.r))
                              : null,
                          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                            // ── ป้ายชื่อเดือนฮิจเราะห์ใหม่ ติดเฉพาะวันแรกที่เดือนเปลี่ยน
                            // (ไม่ใช่ทุกวันของ "คนละเดือน" กันรก) ──
                            if (transitionLabel != null)
                              Container(
                                margin: EdgeInsets.only(bottom: 1.h),
                                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFC9971A).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4.r)),
                                child: Text(transitionLabel,
                                    maxLines: 1, overflow: TextOverflow.ellipsis,
                                    style: TextStyle(fontSize: 6.5.sp, color: const Color(0xFFC9971A), fontWeight: FontWeight.bold)),
                              ),
                            isToday
                              ? Container(
                                  width: 34.w, height: 34.h,
                                  decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(9.r)),
                                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                    Text('$day', style: TextStyle(fontSize: 11.sp, color: Colors.white, fontWeight: FontWeight.bold, height: 1.h)),
                                    if (hijriDayNum.isNotEmpty)
                                      Text(hijriDayNum, style: TextStyle(
                                          fontSize: 7.sp,
                                          color: isOtherHijriMonth ? const Color(0xFFFFE28A) : Colors.white.withOpacity(0.8),
                                          height: 1.1.h)),
                                  ]))
                              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text('$day', style: TextStyle(fontSize: 13.sp,
                                      color: isFri ? const Color(0xFF2E7D32) : isSun ? Colors.red.shade400 : widget.theme.textColor)),
                                  if (hijriDayNum.isNotEmpty)
                                    Text(hijriDayNum, style: TextStyle(fontSize: 8.sp, color: hijriNumColor, height: 1.1.h,
                                        fontWeight: isOtherHijriMonth ? FontWeight.bold : FontWeight.normal)),
                                ]),
                            if (hasHoliday)
                              Container(width: 4.w, height: 4.h, margin: EdgeInsets.only(top: 1.h),
                                  decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle)),
                          ]),
                        ),
                      );
                    },
                  ),

                  // ── ลิสต์วันสำคัญในเดือนนี้ (ถ้ามี) ให้เห็นภาพรวมทั้งเดือน
                  // โดยไม่ต้องไล่แตะทีละวัน ── เพิ่มความ "ใช้งานได้จริง" ให้หน้านี้
                  if (holidaysThisMonth.isNotEmpty) ...[
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        {'en':'This month','th':'วันสำคัญเดือนนี้','ms':'Bulan ini','id':'Bulan ini','ar':'هذا الشهر','ur':'اس مہینے','bn':'এই মাসে'}[widget.lang.lang]
                            ?? 'This month',
                        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: widget.theme.subTextColor)),
                    ),
                    SizedBox(height: 8.h),
                    ...(holidaysThisMonth.entries.toList()..sort((a, b) => a.key.compareTo(b.key))).map((e) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFD700).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r)),
                          child: Row(children: [
                            Container(
                              width: 32.w, height: 32.h,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(8.r)),
                              child: Text('${e.key}', style: TextStyle(color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.bold))),
                            SizedBox(width: 10.w),
                            Expanded(child: Text(e.value,
                                style: TextStyle(fontSize: 12.5.sp, color: widget.theme.textColor, fontWeight: FontWeight.w500))),
                            const Text('⭐', style: TextStyle(fontSize: 14)),
                          ]),
                        ),
                      );
                    }),
                  ],
                ]),
              )),
          ], // ปิด else ของมุมมองเกรกอเรียน

          // Legend
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0.h, 16.w, 16.h),
            child: Wrap(
              spacing: 12.w,
              runSpacing: 6.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 12.w, height: 12.h, decoration: BoxDecoration(color: headerColor, borderRadius: BorderRadius.circular(3.r))),
                  SizedBox(width: 4.w),
                  Text(_todayLabel(), style: TextStyle(fontSize: 11.sp, color: widget.theme.subTextColor)),
                ]),
                Row(mainAxisSize: MainAxisSize.min, children: [
                  Container(width: 6.w, height: 6.h, decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle)),
                  SizedBox(width: 4.w),
                  Text(
                    kIslamicHolidayLabels[widget.lang.lang] ?? 'Islamic Holiday',
                    style: TextStyle(fontSize: 11.sp, color: widget.theme.subTextColor)),
                ]),
                // ── คำอธิบายสีเหลืองทอง: วันที่อยู่คนละเดือนฮิจเราะห์กับหัวข้อ
                // (จุดที่ user เคยงงว่าทำไมเลขฮิจเราะห์เด้งจาก 29 กลับไป 1)
                // ไม่เกี่ยวข้องในมุมมองฮิจเราะห์ (ที่นั่นมีแต่เดือนเดียวเป๊ะๆ) ──
                if (!_isHijriView)
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('12', style: TextStyle(fontSize: 10.sp, color: const Color(0xFFC9971A), fontWeight: FontWeight.bold)),
                    SizedBox(width: 4.w),
                    Flexible(child: Text(
                      {'en':'Different Hijri month','th':'คนละเดือนฮิจเราะห์','ms':'Bulan Hijri lain','id':'Bulan Hijriah lain','ar':'شهر هجري مختلف','ur':'مختلف ہجری مہینہ','bn':'ভিন্ন হিজরি মাস'}[widget.lang.lang]
                          ?? 'Different Hijri month',
                      style: TextStyle(fontSize: 11.sp, color: widget.theme.subTextColor))),
                  ]),
              ],
            ),
          ),

          // ── เผื่อพื้นที่ด้านล่างให้ gesture bar / home indicator ──
          // (แผ่นชีทนี้ maxChildSize สูงถึง 0.92 ของจอ มีโอกาสให้ legend
          // แถวสุดท้ายไปติดขอบจอในเครื่องที่ใช้ gesture navigation)
          SizedBox(height: MediaQuery.of(context).padding.bottom + 8.h),
        ]),
      ),
    );
  }
}