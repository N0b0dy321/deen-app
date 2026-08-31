import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/prayer_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'package:DEEN/services/Setting_Time.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});
  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _prayerData;
  final _lang = LanguageService();
  final _theme = ThemeService();

  final List<Map<String, dynamic>> _prayerInfo = [
    {'key': 'Fajr', 'label': 'Fajr', 'labelTh': 'ฟัจร์', 'icon': Icons.wb_twilight, 'arabic': 'الفجر'},
    {'key': 'Sunrise', 'label': 'Sunrise', 'labelTh': 'ดวงอาทิตย์ขึ้น', 'icon': Icons.wb_sunny_outlined, 'arabic': 'الشروق'},
    {'key': 'Dhuhr', 'label': 'Dhuhr', 'labelTh': 'ซุฮร์', 'icon': Icons.wb_sunny, 'arabic': 'الظهر'},
    {'key': 'Asr', 'label': 'Asr', 'labelTh': 'อัศร์', 'icon': Icons.sunny_snowing, 'arabic': 'العصر'},
    {'key': 'Maghrib', 'label': 'Maghrib', 'labelTh': 'มัฆริบ', 'icon': Icons.nights_stay_outlined, 'arabic': 'المغرب'},
    {'key': 'Isha', 'label': 'Isha', 'labelTh': 'อิชาอ์', 'icon': Icons.nightlight, 'arabic': 'العشاء'},
  ];

  @override
  void initState() {
    super.initState();
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
    setState(() => _isLoading = true);
    final data = await PrayerService.getPrayerTimes();
    setState(() { _prayerData = data; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(child: _isLoading
            ? Center(child: CircularProgressIndicator(color: _theme.iconColor))
            : _prayerData == null ? _buildError() : _buildContent()),
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
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24.r), bottomRight: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22.sp)),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                  // โหลดใหม่เสมอตอนกลับมาจาก Settings (ไม่ใช่แค่ตอนกด Save)
                  // เพราะการเลือกตำแหน่งใน location sheet จะ apply ทันทีอยู่แล้ว
                  _loadPrayerTimes();
                },
                child: Icon(Icons.settings, color: Colors.white70, size: 26.sp)),
            ]),
            SizedBox(height: 8.h),
            Icon(Icons.access_time, color: Color(0xFFFFD700), size: 40.sp),
            SizedBox(height: 8.h),
            Text(_lang.prayerTimes,
                style: TextStyle(color: Color(0xFFFFD700), fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            if (_prayerData != null)
              Text(_prayerData!['date'], style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
            // ── ชื่อตำแหน่งที่ใช้คำนวณเวลาละหมาดอยู่ตอนนี้ ──
            if (_prayerData?['locationName'] != null) ...[
              SizedBox(height: 6.h),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.location_on, color: Colors.white70, size: 13.sp),
                SizedBox(width: 4.w),
                Flexible(
                  child: Text(
                    _prayerData!['locationName'] as String,
                    style: TextStyle(color: Colors.white70, fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
            ],
            SizedBox(height: 16.h),
          ]),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final timings = _prayerData!['timings'];
    final nextPrayer = _prayerData!['nextPrayer'];
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(children: [
        // Next Prayer Card — เลย์เอาต์เดียวกับหน้า Home (สัดส่วนภาพถูกต้อง
        // + เว้นพื้นที่ให้มัสยิด/พระจันทร์ในภาพพื้นหลัง ไม่ให้ข้อความไปทับ)
        AspectRatio(
          aspectRatio: 1920 / 620,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: const DecorationImage(
                image: AssetImage('image/prayer/prayer_widget_bg.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: _theme.isDark ? Border.all(color: const Color(0xFF2ECC71).withOpacity(0.3)) : null,
            ),
            child: Row(children: [
              // เว้นพื้นที่ฝั่งซ้ายแบบสัดส่วน (ที่ที่มัสยิด/พระจันทร์อยู่ในภาพ)
              Expanded(flex: 34, child: const SizedBox()),
              Expanded(
                flex: 66,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(_lang.nextPrayerLabel,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white70, fontSize: 11.sp)),
                      Text(nextPrayer['name'],
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: TextStyle(color: Colors.white, fontSize: 22.sp, fontWeight: FontWeight.bold)),
                      SizedBox(height: 2.h),
                      // เวลา + badge อยู่แถวเดียวกัน (เหมือนหน้า Home) แทนการเรียงซ้อนกัน
                      // 4 บรรทัด เพราะพื้นที่การ์ดถูกจำกัดด้วย AspectRatio ไม่พอเรียงซ้อน
                      Row(children: [
                        Text(nextPrayer['time'],
                            style: TextStyle(color: Colors.white, fontSize: 16.sp, fontWeight: FontWeight.w500)),
                        SizedBox(width: 8.w),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20.r)),
                            child: Text(nextPrayer['timeUntil'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(color: Colors.white, fontSize: 11.sp)),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
            ]),
          ),
        ),

        SizedBox(height: 16.h),

        ..._prayerInfo.map((prayer) {
          final time = timings[prayer['key']] ?? '-';
          final isNext = nextPrayer['name'] == prayer['label'];
          final label = _lang.isThai ? prayer['labelTh'] : prayer['label'];
          return Container(
            margin: EdgeInsets.only(bottom: 10.h),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            decoration: BoxDecoration(
              color: isNext ? const Color(0xFF1B5E20) : _theme.cardColor,
              borderRadius: BorderRadius.circular(16.r),
              border: !isNext && _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
              boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(children: [
              Icon(prayer['icon'] as IconData,
                  color: isNext ? Colors.white : _theme.iconColor, size: 24.sp),
              SizedBox(width: 16.w),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,
                    color: isNext ? Colors.white : _theme.textColor)),
                Text(prayer['arabic'], style: TextStyle(fontSize: 12.sp,
                    color: isNext ? Colors.white70 : _theme.subTextColor)),
              ])),
              Text(time, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold,
                  color: isNext ? Colors.white : _theme.iconColor)),
              if (isNext)
                Padding(padding: EdgeInsets.only(left: 8.w),
                  child: Icon(Icons.notifications_active, color: Colors.white, size: 18.sp)),
            ]),
          );
        }),

        SizedBox(height: 16.h),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _loadPrayerTimes,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: Text(_lang.refresh, style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r))),
          ),
        ),
      ]),
    );
  }

  Widget _buildError() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
      SizedBox(height: 16.h),
      Text(_lang.couldNotLoad, style: TextStyle(color: _theme.subTextColor)),
      SizedBox(height: 16.h),
      ElevatedButton(onPressed: _loadPrayerTimes,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
        child: Text(_lang.tryAgain, style: const TextStyle(color: Colors.white))),
    ]));
  }
}