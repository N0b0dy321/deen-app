import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'package:DEEN/services/Setting_Time.dart';

// ── More Bottom Sheet ──────────────────────────────────────
class MoreBottomSheet extends StatelessWidget {
  final ThemeService theme;
  final LanguageService lang;
  final VoidCallback onSettingsReturn;

  const MoreBottomSheet({
    super.key,
    required this.theme,
    required this.lang,
    required this.onSettingsReturn,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _MoreItem(
        icon: Icons.settings,
        color: const Color(0xFF1B5E20),
        label: lang.isThai ? 'ตั้งค่า' : 'Settings',
        subtitle: lang.isThai ? 'ธีม, ภาษา, เวลาละหมาด' : 'Theme, language, prayer time',
        onTap: () async {
          Navigator.pop(context);
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          // โหลดเวลาละหมาดใหม่เสมอตอนกลับมาจาก Settings
          // (ไม่เช็คว่ากด Save หรือกด back เฉยๆ เพราะการเปลี่ยนตำแหน่งใน sheet
          //  ค้นหาเมืองจะ apply ทันทีอยู่แล้ว โหลดจาก cache ก็เร็ว ไม่มีผลเสีย)
          onSettingsReturn();
        },
      ),
      _MoreItem(
        icon: Icons.notifications_outlined,
        color: Colors.orange,
        label: lang.isThai ? 'การแจ้งเตือน' : 'Notifications',
        subtitle: lang.isThai ? 'ตั้งค่าการแจ้งเตือน' : 'Manage notifications',
        onTap: () async {
          Navigator.pop(context);
          await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
          onSettingsReturn();
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          SizedBox(height: 12.h),
          Container(
            width: 40.w, height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(2.r)),
          ),
          SizedBox(height: 16.h),

          // Title
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  lang.isThai ? 'เพิ่มเติม' : 'More',
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.textColor),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

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
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            Container(
              width: 44.w, height: 44.h,
              decoration: BoxDecoration(
                color: item.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12.r)),
              child: Icon(item.icon, color: item.color, size: 22.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(item.label,
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600, color: theme.textColor)),
              Text(item.subtitle,
                  style: TextStyle(fontSize: 12.sp, color: theme.subTextColor)),
            ])),
            Icon(Icons.chevron_right, color: theme.subTextColor, size: 20.sp),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        title: Row(children: [
          Icon(Icons.mosque, color: Color(0xFF1B5E20), size: 28.sp),
          SizedBox(width: 10.w),
          Text('DEEN', style: TextStyle(color: theme.textColor, fontWeight: FontWeight.bold)),
        ]),
        content: Text(
          lang.isThai
              ? 'แอพอิสลามสำหรับชีวิตประจำวัน\nเวอร์ชัน 1.0.0\nสร้างด้วยใจ ❤️'
              : 'Your Islamic companion app\nVersion 1.0.0\nMade with ❤️',
          style: TextStyle(color: theme.subTextColor, height: 1.6.h),
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
class NextPrayerCard extends StatelessWidget {
  final String prayerName, time, timeUntil;
  final bool isDark;
  const NextPrayerCard({super.key, required this.prayerName, required this.time, required this.timeUntil, required this.isDark});

  // ── เลือกภาพพื้นหลังตามชื่อละหมาดที่กำลังจะถึง (เหมือนหน้า Prayer Times) ──
  // ฟัจร์/มัฆริบ = โทนรุ่งอรุณ-พลบค่ำ, ซุฮร์/อัศร์ = โทนกลางวัน,
  // อิชาอ์ (และกรณีอื่นๆ) = ภาพเดิมที่มีพระจันทร์
  String _getBackground(String name) {
    switch (name) {
      case 'Fajr':
      case 'Maghrib':
        return 'image/prayer/sunrise_sunset.png';
      case 'Dhuhr':
      case 'Asr':
        return 'image/prayer/day.png';
      default:
        return 'image/prayer/prayer_widget_bg.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      // สัดส่วนเดียวกับไฟล์ prayer_widget_bg.png จริง (1920x691)
      // กันไม่ให้ BoxFit.cover ครอปภาพผิดสัดส่วนไปจากที่ออกแบบไว้ใน Figma
      aspectRatio: 1920 / 621,
      child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // ใช้ภาพพื้นหลังที่ออกแบบเอง (มัสยิด+พระจันทร์เสี้ยว/รุ่งอรุณ/กลางวัน
        // แล้วแต่ละหมาดถัดไป) แทน gradient เดิม
        image: DecorationImage(
          image: AssetImage(_getBackground(prayerName)),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: isDark ? Border.all(color: const Color(0xFF2ECC71).withOpacity(0.3)) : null,
        boxShadow: [BoxShadow(
          color: isDark ? const Color(0xFF2ECC71).withOpacity(0.1) : const Color(0xFF1B5E20).withOpacity(0.3),
          blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(children: [
        // เว้นระยะห่างจากขอบซ้ายแบบ "สัดส่วน" ของความกว้างจอ แทนพิกเซลตายตัว
        // (เดิมใช้ SizedBox(width: 130.w) คงที่ ซึ่งบนจอแคบกว่านี้ทำให้ข้อความ
        // เหลือพื้นที่ไม่พอจนล้นจอได้ — ฝั่งซ้ายของภาพพื้นหลังมีมัสยิด/พระจันทร์
        // อยู่แล้ว เลยเว้นสัดส่วนนี้ไว้กันข้อความไปทับภาพ)
        Expanded(
          flex: 34,
          child: const SizedBox(),
        ),
        Expanded(
          flex: 62,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(prayerName,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: Colors.white, fontSize: 26.sp, fontWeight: FontWeight.bold)),
              Row(children: [
                Text(time, style: TextStyle(color: Colors.white, fontSize: 20.sp, fontWeight: FontWeight.w500)),
                SizedBox(width: 8.w),
                Flexible(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10.r)),
                    child: Text(timeUntil,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(color: Colors.white, fontSize: 12.sp))),
                ),
              ]),
            ],
          ),
        ),
        Padding(padding: EdgeInsets.only(right: 16.w),
            child: Icon(Icons.chevron_right, color: Colors.white54, size: 24.sp)),
      ]),
      ),
    );
  }
}

// ── Feature Card ───────────────────────────────────────────
class FeatureCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final ThemeService theme;
  final VoidCallback onTap;
  final Color? color;
  // ── ไอคอนแบบภาพ (silhouette ขาว) ใช้แทน Material icon ถ้ามีค่านี้ —
  // เช่น การ์ด "ดุอาอ์และบทเรียน" ใช้โลโก้เดียวกับหมวด "วิธีละหมาด"
  final String? imageAsset;
  // ── true (ค่าเริ่มต้น) = ทาสีทับ silhouette ด้วยสีการ์ด (ใช้กับภาพขาวล้วน)
  // false = ใช้สีต้นฉบับของภาพเอง ไม่ทาทับ (เช่นไอคอนกิบลัตที่มีสีในตัว) ──
  final bool tintImage;
  // ── ขนาดไอคอน ปรับแยกทีละการ์ดได้ (ค่าเริ่มต้น 44 เท่าของเดิม) ──
  final double iconSize;
  const FeatureCard({super.key, required this.label, required this.icon, required this.theme, required this.onTap, this.color, this.imageAsset, this.tintImage = true, this.iconSize = 44});

  @override
  Widget build(BuildContext context) {
    final c = color ?? theme.iconColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: theme.isDark ? ThemeService.darkBorder : c.withOpacity(0.15)),
          boxShadow: theme.isDark ? null : [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Padding(
            padding: EdgeInsets.all(10.w),
            child: imageAsset == null
                ? Icon(icon, size: iconSize.sp, color: c)
                : (tintImage
                    ? ColorFiltered(
                        colorFilter: ColorFilter.mode(c, BlendMode.srcIn),
                        child: Image.asset(imageAsset!, width: iconSize.sp, height: iconSize.sp,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(icon, size: iconSize.sp, color: c)),
                      )
                    : Image.asset(imageAsset!, width: iconSize.sp, height: iconSize.sp,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(icon, size: iconSize.sp, color: c)))),
          SizedBox(height: 10.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: Text(label,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w600, color: theme.textColor),
                textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis)),
        ]),
      ),
    );
  }
}

// ── Chatbot Banner ─────────────────────────────────────────
class ChatbotBanner extends StatelessWidget {
  final String label, subtitle;
  final ThemeService theme;
  final VoidCallback onTap;
  const ChatbotBanner({super.key, required this.label, required this.subtitle, required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: theme.isDark
                ? [const Color(0xFF0D3B1E), const Color(0xFF1A4A2A)]
                : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [BoxShadow(
              color: const Color(0xFF1B5E20).withOpacity(0.3),
              blurRadius: 12, offset: const Offset(0, 4))],
        ),
        child: Row(children: [
          Container(
            width: 48.w, height: 48.h,
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12.r)),
            child: Icon(Icons.smart_toy, color: Colors.white, size: 26.sp)),
          SizedBox(width: 14.w),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(
                fontSize: 15.sp, fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 2.h),
            Text(subtitle, style: TextStyle(
                fontSize: 12.sp, color: Colors.white.withOpacity(0.75))),
          ])),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20.r)),
            child: Text('Chat', style: TextStyle(
                color: Colors.white, fontSize: 12.sp, fontWeight: FontWeight.w600))),
        ]),
      ),
    );
  }
}

// ── Bottom Nav Bar ─────────────────────────────────────────
class BottomNavBar extends StatelessWidget {
  final LanguageService lang;
  final ThemeService theme;
  final VoidCallback onPrayerTap;
  final VoidCallback onMosqueTap;
  final VoidCallback onMoreTap;

  const BottomNavBar({
    super.key,
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