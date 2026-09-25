import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import 'lesson_translations.dart';

// ── ลายมุมตกแต่งหัวข้อ (ลายดาวทอง export จาก Canva แบบโปร่งใส) ──
// ใช้ asset เดียว 4 มุม พลิกด้วย Transform แทนที่จะมีไฟล์แยกต่อมุม
// ขนาด/ตำแหน่งผ่านการทดสอบประกอบภาพจริงก่อนแล้ว (เยื้องเข้ามา 6px ไม่ล้นขอบ)
const String kHeaderCornerAsset = 'image/decor/corner_star.png';
// ── ลายดอกไม้คั่น (export จาก Canva แบบโปร่งใส) ใช้คั่นระหว่างกล่องอารบิก
// กับกล่องเนื้อหาในหน้าเนื้อหาบทเรียน ──
const String kFlowerDividerAsset = 'image/decor/flower_divider.png';

List<Widget> headerCornerDecor({double size = 75}) {
  Widget cornerImg() => Image.asset(kHeaderCornerAsset, width: size, height: size,
      errorBuilder: (_, __, ___) => const SizedBox.shrink());
  Widget flipped(double sx, double sy, Widget child) => Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(sx, sy, 1),
      child: child);

  return [
    Positioned(top: 6, left: 6, child: cornerImg()),
    Positioned(top: 6, right: 6, child: flipped(-1, 1, cornerImg())),
    Positioned(bottom: 6, left: 6, child: flipped(1, -1, cornerImg())),
    Positioned(bottom: 6, right: 6, child: flipped(-1, -1, cornerImg())),
  ];
}

// ── ไอคอนหมวดหมู่บทเรียน (ใช้ร่วมกันหลายจุด: การ์ดหมวดหมู่, หัวข้อในหน้า
// เนื้อหาบทเรียน) รวมไว้ที่เดียวแทนที่จะประกาศซ้ำในแต่ละ State class ──
const Map<String, IconData> kLessonCategoryIcons = {
  'pillars': Icons.mosque_outlined,
  'iman': Icons.auto_awesome_outlined,
  'wudhu': Icons.water_drop_outlined,
  'prayer': Icons.self_improvement_outlined,
  'hadith': Icons.menu_book_outlined,
  'adab': Icons.handshake_outlined,
  'history': Icons.account_balance_outlined,
  'fasting': Icons.nightlight_outlined,
  'special_prayer': Icons.mosque,
};

// ── ไอคอนแบบภาพ (silhouette สีขาว export จาก Canva) ใช้แทน Material icon
// เฉพาะบางหมวดหมู่ — ตอนนี้มีแค่ "prayer" (คนละหมาดนั่งดุอาอ์ แทน
// Icons.self_improvement_outlined ที่จริงๆ เป็นท่าโยคะ ไม่ใช่ท่าละหมาด)
// ใช้ ColorFiltered ทาสีทับ silhouette ขาวให้เป็นสีอะไรก็ได้ เหมือน Icon(color:)
const Map<String, String> kLessonCategoryImageIcons = {
  'prayer': 'image/decor/prayer_icon.png',
};

/// ตัวช่วยเรนเดอร์ไอคอนหมวดหมู่ — เช็คก่อนว่ามีไอคอนแบบภาพไหม ถ้ามีใช้ภาพ
/// (ทาสีด้วย ColorFiltered) ถ้าไม่มีใช้ Material icon จาก kLessonCategoryIcons
/// เหมือนเดิม ใช้แทนที่ Icon(kLessonCategoryIcons[catId], ...) ได้ทุกจุด
Widget buildCategoryIcon(String catId, {required double size, required Color color}) {
  final imageAsset = kLessonCategoryImageIcons[catId];
  if (imageAsset != null) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
      child: Image.asset(
        imageAsset,
        width: size, height: size,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(
            kLessonCategoryIcons[catId] ?? Icons.menu_book_outlined,
            size: size, color: color),
      ),
    );
  }
  return Icon(kLessonCategoryIcons[catId] ?? Icons.menu_book_outlined, size: size, color: color);
}

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();

  final List<Map<String, dynamic>> _categories = [
    {'id': 'pillars', 'icon': '🕌',
     'titleEn': '5 Pillars of Islam', 'titleTh': '5 เสาหลักของอิสลาม', 'titleMs': '5 Rukun Islam', 'titleId': '5 Rukun Islam', 'titleAr': 'أركان الإسلام الخمسة', 'titleUr': 'اسلام کے 5 ارکان', 'titleBn': 'ইসলামের ৫ স্তম্ভ',
     'subtitleEn': 'The foundation of Islamic faith', 'subtitleTh': 'รากฐานของศาสนาอิสลาม', 'subtitleMs': 'Asas agama Islam', 'subtitleId': 'Dasar agama Islam', 'subtitleAr': 'أساس الإسلام', 'subtitleUr': 'اسلام کی بنیاد', 'subtitleBn': 'ইসলামের ভিত্তি',
     'color': const Color(0xFF1B5E20), 'lessons': 5},
    {'id': 'iman', 'icon': '💫',
     'titleEn': '6 Pillars of Iman', 'titleTh': '6 หลักอีหม่าน', 'titleMs': '6 Rukun Iman', 'titleId': '6 Rukun Iman', 'titleAr': 'أركان الإيمان الستة', 'titleUr': 'ایمان کے 6 ارکان', 'titleBn': 'ঈমানের ৬ স্তম্ভ',
     'subtitleEn': 'Articles of Islamic faith', 'subtitleTh': 'หลักความเชื่อในอิสลาม', 'subtitleMs': 'Kepercayaan asas Islam', 'subtitleId': 'Kepercayaan dasar Islam', 'subtitleAr': 'عقائد الإيمان', 'subtitleUr': 'ایمان کے عقائد', 'subtitleBn': 'ইসলামী বিশ্বাসের মূলনীতি',
     'color': const Color(0xFF1565C0), 'lessons': 6},
    {'id': 'wudhu', 'icon': '💧',
     'titleEn': 'How to Perform Wudhu', 'titleTh': 'วิธีทำวุฎูอ์', 'titleMs': 'Cara Berwudhu', 'titleId': 'Cara Berwudhu', 'titleAr': 'كيفية الوضوء', 'titleUr': 'وضو کا طریقہ', 'titleBn': 'ওযু করার নিয়ম',
     'subtitleEn': 'Step by step wudhu guide', 'subtitleTh': 'คู่มือวุฎูอ์ทีละขั้นตอน', 'subtitleMs': 'Panduan wudhu langkah demi langkah', 'subtitleId': 'Panduan wudhu langkah demi langkah', 'subtitleAr': 'دليل الوضوء خطوة بخطوة', 'subtitleUr': 'وضو کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে ওযুর গাইড',
     'color': const Color(0xFF0277BD), 'lessons': 8},
    {'id': 'prayer', 'icon': '🙏',
     'titleEn': 'How to Pray', 'titleTh': 'วิธีละหมาด', 'titleMs': 'Cara Solat', 'titleId': 'Cara Sholat', 'titleAr': 'كيفية الصلاة', 'titleUr': 'نماز کا طریقہ', 'titleBn': 'নামাজের পদ্ধতি',
     'subtitleEn': 'Step by step prayer guide', 'subtitleTh': 'คู่มือละหมาดทีละขั้นตอน', 'subtitleMs': 'Panduan solat langkah demi langkah', 'subtitleId': 'Panduan sholat langkah demi langkah', 'subtitleAr': 'دليل الصلاة خطوة بخطوة', 'subtitleUr': 'نماز کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে নামাজের গাইড',
     'color': const Color(0xFF6A1B9A), 'lessons': 7},
    {'id': 'hadith', 'icon': '📜',
     'titleEn': '40 Hadith', 'titleTh': '40 หะดีษ', 'titleMs': '40 Hadith', 'titleId': '40 Hadis', 'titleAr': '٤٠ حديثاً', 'titleUr': '40 احادیث', 'titleBn': '৪০ হাদিস',
     'subtitleEn': 'Key teachings of Prophet Muhammad', 'subtitleTh': 'คำสอนสำคัญของท่านนบี', 'subtitleMs': 'Ajaran utama Nabi Muhammad', 'subtitleId': 'Ajaran utama Nabi Muhammad', 'subtitleAr': 'تعاليم النبي محمد الأساسية', 'subtitleUr': 'نبی محمد کی اہم تعلیمات', 'subtitleBn': 'নবী মুহাম্মদের মূল শিক্ষা',
     'color': const Color(0xFF4E342E), 'lessons': 10},
    {'id': 'adab', 'icon': '🤝',
     'titleEn': 'Islamic Manners', 'titleTh': 'มารยาทอิสลาม', 'titleMs': 'Adab Islam', 'titleId': 'Adab Islam', 'titleAr': 'الآداب الإسلامية', 'titleUr': 'اسلامی آداب', 'titleBn': 'ইসলামী আদব',
     'subtitleEn': 'Etiquette in daily life', 'subtitleTh': 'มารยาทในชีวิตประจำวัน', 'subtitleMs': 'Adab dalam kehidupan harian', 'subtitleId': 'Etika dalam kehidupan sehari-hari', 'subtitleAr': 'الآداب في الحياة اليومية', 'subtitleUr': 'روزمرہ زندگی میں آداب', 'subtitleBn': 'দৈনন্দিন জীবনে শিষ্টাচার',
     'color': const Color(0xFF00695C), 'lessons': 5},
    {'id': 'history', 'icon': '🏛️',
     'titleEn': 'Islamic History', 'titleTh': 'ประวัติศาสตร์อิสลาม', 'titleMs': 'Sejarah Islam', 'titleId': 'Sejarah Islam', 'titleAr': 'التاريخ الإسلامي', 'titleUr': 'اسلامی تاریخ', 'titleBn': 'ইসলামের ইতিহাস',
     'subtitleEn': 'Key events in Islamic history', 'subtitleTh': 'เหตุการณ์สำคัญในประวัติอิสลาม', 'subtitleMs': 'Peristiwa penting dalam sejarah Islam', 'subtitleId': 'Peristiwa penting dalam sejarah Islam', 'subtitleAr': 'أحداث رئيسية في التاريخ الإسلامي', 'subtitleUr': 'اسلامی تاریخ کے اہم واقعات', 'subtitleBn': 'ইসলামের ইতিহাসের গুরুত্বপূর্ণ ঘটনা',
     'color': const Color(0xFFE65100), 'lessons': 6},
    {'id': 'fasting', 'icon': '🌙',
     'titleEn': 'Fasting (Sawm)', 'titleTh': 'การถือศีลอด (เซาม์)', 'titleMs': 'Puasa (Sawm)', 'titleId': 'Puasa (Shaum)', 'titleAr': 'الصيام', 'titleUr': 'روزہ (صوم)', 'titleBn': 'রোজা (সাওম)',
     'subtitleEn': 'The complete guide to Islamic fasting', 'subtitleTh': 'คู่มือการถือศีลอดในอิสลาม', 'subtitleMs': 'Panduan lengkap puasa Islam', 'subtitleId': 'Panduan lengkap puasa Islam', 'subtitleAr': 'الدليل الشامل للصيام الإسلامي', 'subtitleUr': 'اسلامی روزے کی مکمل رہنمائی', 'subtitleBn': 'ইসলামিক রোজার সম্পূর্ণ গাইড',
     'color': const Color(0xFF00838F), 'lessons': 7},
    {'id': 'special_prayer', 'icon': '🕌',
     'titleEn': 'Special Prayers', 'titleTh': 'ละหมาดพิเศษ', 'titleMs': 'Solat Khas', 'titleId': 'Sholat Khusus', 'titleAr': 'الصلوات الخاصة', 'titleUr': 'خصوصی نمازیں', 'titleBn': 'বিশেষ নামাজ',
     'subtitleEn': 'Eid, Funeral, Tarawih and more', 'subtitleTh': 'ละหมาดอีด ญะนาซะห์ ตะรอวีห์ และอื่นๆ', 'subtitleMs': 'Solat Eid, Jenazah, Tarawih dan lain-lain', 'subtitleId': 'Sholat Eid, Jenazah, Tarawih dan lainnya', 'subtitleAr': 'صلاة العيد والجنازة والتراويح وغيرها', 'subtitleUr': 'عید، جنازہ، تراویح اور دیگر نمازیں', 'subtitleBn': 'ঈদ, জানাজা, তারাবি এবং অন্যান্য',
     'color': const Color(0xFF4527A0), 'lessons': 6},
  ];

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(child: ListView.builder(
          padding: EdgeInsets.fromLTRB(
              16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
          itemCount: _categories.length,
          itemBuilder: (_, i) => _buildCard(_categories[i]),
        )),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: _theme.isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A5C32)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
      child: SafeArea(
        child: Stack(children: [
          ...headerCornerDecor(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(children: [
              Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22))]),
              const SizedBox(height: 8),
              const Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 40),
              const SizedBox(height: 8),
              Text(_lang.lang == 'th' ? 'บทเรียน' : 'Lessons',
                  style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(_lang.lang == 'th' ? 'เรียนรู้อิสลามทีละขั้นตอน' : 'Learn Islam step by step',
                  style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> cat) {
    final title = getLangText(cat, 'title', _lang.lang);
    final subtitle = getLangText(cat, 'subtitle', _lang.lang);
    final color = cat['color'] as Color;
    final showGradient = !_theme.isDark;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => LessonDetailPage(category: cat, lang: _lang, theme: _theme))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _theme.cardColor,
          gradient: showGradient
              ? LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Colors.white, color.withOpacity(0.05)])
              : null,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFF0F0F0)),
          boxShadow: [
            BoxShadow(
                color: _theme.isDark ? Colors.black.withOpacity(0.15) : color.withOpacity(0.08),
                blurRadius: 10, offset: const Offset(0, 3))]),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.14),
                border: Border.all(color: color.withOpacity(0.35), width: 1.2)),
              child: Padding(
                padding: const EdgeInsets.all(11),
                child: buildCategoryIcon(cat['id'] as String, size: 24, color: color),
              )),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _theme.textColor)),
              const SizedBox(height: 3),
              Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: _theme.subTextColor, height: 1.4)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('${cat['lessons']} ${_lang.lang == 'th' ? 'บทเรียน' : 'lessons'}',
                    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))),
            ])),
            const SizedBox(width: 8),
            Icon(Icons.chevron_right, size: 18, color: _theme.subTextColor),
          ]),
        ),
      ),
    );
  }
}

// ── LessonDetailPage ───────────────────────────────
class LessonDetailPage extends StatelessWidget {
  final Map<String, dynamic> category;
  final LanguageService lang;
  final ThemeService theme;
  const LessonDetailPage({super.key, required this.category, required this.lang, required this.theme});

  @override
  Widget build(BuildContext context) {
    final title = getLangText(category, 'title', lang.lang);
    final color = category['color'] as Color;
    final lessons = LessonData.getLesson(category['id']);

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Column(children: [
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
          child: SafeArea(
            child: Stack(children: [
              ...headerCornerDecor(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(children: [
                  Row(children: [
                    GestureDetector(onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22))]),
                  const SizedBox(height: 8),
                  buildCategoryIcon(category['id'] as String, size: 40, color: Colors.white),
                  const SizedBox(height: 8),
                  Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                ]),
              ),
            ]),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(
                16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
            itemCount: lessons.length,
            itemBuilder: (_, i) {
              final lesson = lessons[i];
              final lessonTitle = getLessonTitle(lesson, category['id'] as String, lang.lang, i);
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      final lessonWithCat = Map<String, dynamic>.from(lesson);
                      lessonWithCat['catId'] = category['id'];
                      return LessonContentPage(
                        lesson: lessonWithCat,
                        color: color,
                        lang: lang,
                        theme: theme,
                        translatedTitle: getLessonTitle(lesson, category['id'] as String, lang.lang, i),
                        allLessons: lessons,
                        categoryId: category['id'] as String,
                        currentIndex: i,
                      );
                    })),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor, borderRadius: BorderRadius.circular(16),
                    border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
                    boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2))]),
                  child: Row(children: [
                    Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                      child: Center(child: Text('${lesson['no']}',
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)))),
                    const SizedBox(width: 14),
                    Expanded(child: Text(lessonTitle,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: theme.textColor))),
                    Icon(Icons.chevron_right, color: theme.subTextColor),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

// ── LessonContentPage ──────────────────────────────
class LessonContentPage extends StatelessWidget {
  final Map<String, dynamic> lesson;
  final Color color;
  final LanguageService lang;
  final ThemeService theme;
  final String? translatedTitle;
  // ── เพิ่มไว้ทำปุ่มก่อนหน้า/ถัดไป + แถบความคืบหน้า "บทที่ X จาก Y" ──
  final List<Map<String, dynamic>>? allLessons;
  final String? categoryId;
  final int? currentIndex;
  const LessonContentPage({
    super.key,
    required this.lesson,
    required this.color,
    required this.lang,
    required this.theme,
    this.translatedTitle,
    this.allLessons,
    this.categoryId,
    this.currentIndex,
  });

  // ── จัดรูปแบบเนื้อหาให้อ่านง่ายขึ้น: แยกเป็นย่อหน้าตาม \n\n แล้วในแต่ละ
  // ย่อหน้า ถ้าบรรทัดไหนขึ้นต้นด้วย "•" จะเรนเดอร์เป็นแถวบูลเล็ตจริงๆ
  // (จุดกลมสีตามหมวดหมู่ + ข้อความเยื้อง) แทนที่จะปล่อยเป็นตัวอักษร "•" ดิบๆ
  // ปนอยู่ในก้อนข้อความเดียว ──
  // เช็คว่าบรรทัดมีตัวอักษรอาหรับปนอยู่ไหม (ใช้ Unicode range ของอักษรอาหรับ
  // รวม presentation forms ที่พบในข้อความดุอา/อายะห์) ถ้าใช่ ขยายขนาดตัวอักษร
  // ให้ใหญ่ขึ้นชัดเจน + จัดจากขวาไปซ้ายแบบอาหรับจริงๆ แทนที่จะใช้ขนาดเดียวกับ
  // คำอ่าน/ความหมายที่เป็นไทย/อังกฤษ
// ── ต้องมีสัดส่วนตัวอักษรอาหรับ "ส่วนใหญ่" ของบรรทัดจริงๆ ถึงจะนับว่าเป็น
// บรรทัดภาษาอาหรับ (ไม่ใช่แค่เจอตัวอักษรอาหรับตัวเดียวก็จัด RTL ทั้งบรรทัด)
// กันปัญหาสัญลักษณ์ ﷺ (ขอความสันติจงมีแด่ท่าน) ที่ปนอยู่ในประโยคอังกฤษ/ไทย
// แล้วถูกจัดเรียงกลับด้านทั้งประโยคโดยไม่ตั้งใจ
bool _isArabicLine(String line) {
  final arabicRegex = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]');
  final arabicCount = arabicRegex.allMatches(line).length;
  final letterCount = line.replaceAll(RegExp(r'\s'), '').length;
  if (letterCount == 0) return false;
  return arabicCount / letterCount > 0.5;
}

  List<Widget> _buildContentBlocks(String content) {
    final blocks = content.split('\n\n').map((b) => b.trim()).where((b) => b.isNotEmpty).toList();
    final widgets = <Widget>[];
    for (int b = 0; b < blocks.length; b++) {
      final lines = blocks[b].split('\n');
      final lineWidgets = <Widget>[];
      for (final rawLine in lines) {
        final line = rawLine.trim();
        if (line.isEmpty) continue;
        if (line.startsWith('•')) {
          final text = line.replaceFirst('•', '').trim();
          lineWidgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(top: 7, right: 10),
                child: Container(width: 5, height: 5,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle))),
              Expanded(child: Text(text,
                  style: TextStyle(fontSize: 15, color: theme.textColor, height: 1.6))),
            ]),
          ));
        } else if (_isArabicLine(line)) {
          lineWidgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 8, top: 4),
            child: SizedBox(
              width: double.infinity,
              child: Text(line,
                  textDirection: TextDirection.rtl,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: theme.textColor,
                      height: 2.0, fontWeight: FontWeight.w600)),
            ),
          ));
        } else {
          lineWidgets.add(Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(line, style: TextStyle(fontSize: 15, color: theme.textColor, height: 1.6)),
          ));
        }
      }
      widgets.add(Column(crossAxisAlignment: CrossAxisAlignment.start, children: lineWidgets));
      if (b < blocks.length - 1) widgets.add(const SizedBox(height: 14));
    }
    return widgets;
  }

  void _goToLesson(BuildContext context, int index) {
    final lessons = allLessons!;
    final target = lessons[index];
    final targetWithCat = Map<String, dynamic>.from(target);
    targetWithCat['catId'] = categoryId;
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (_) => LessonContentPage(
              lesson: targetWithCat,
              color: color,
              lang: lang,
              theme: theme,
              translatedTitle: getLessonTitle(target, categoryId ?? '', lang.lang, index),
              allLessons: allLessons,
              categoryId: categoryId,
              currentIndex: index,
            )));
  }

  @override
  Widget build(BuildContext context) {
    final title = translatedTitle ?? (lang.lang == 'th' ? lesson['titleTh'] : lesson['titleEn']);
    final catId = lesson['catId'] as String? ?? '';
    final lessonNo = lesson['no'] as int? ?? 0;
    final content = getLessonContent(lesson, catId, lang.lang, lessonNo);
    final arabic = lesson['arabic'] ?? '';
    final hasNav = allLessons != null && currentIndex != null && allLessons!.length > 1;
    final total = allLessons?.length ?? 0;

    // Wudhu images (lesson 1 = conditions/intention, lesson 8 = closing dua —
    // both text-only, no photo needed)
    const wudhuImages = {
      2: ['image/wudhu/wudhu_2a_hands.jpg', 'image/wudhu/wudhu_2b_hands.jpg'],
      3: ['image/wudhu/wudhu_3a_mouth.jpg', 'image/wudhu/wudhu_3b_nose.jpg'],
      4: ['image/wudhu/wudhu_4a_face.jpg', 'image/wudhu/wudhu_4b_face.jpg'],
      5: ['image/wudhu/wudhu_5a_arm.jpg', 'image/wudhu/wudhu_5b_arm.jpg'],
      6: ['image/wudhu/wudhu_6a_head.jpg', 'image/wudhu/wudhu_6b_ear.jpg'],
      7: ['image/wudhu/wudhu_7a_feet.jpg', 'image/wudhu/wudhu_7b_feet.jpg'],
    };
    const prayerImages = {
      2: ['image/prayer/prayer_2_takbir.png'],
      3: ['image/prayer/prayer_3_qiraah.png'],
      4: ['image/prayer/prayer_4_ruku.png'],
      5: ['image/prayer/prayer_6_sujud.png',
          'image/prayer/prayer_7_juloos.png'],
      6: ['image/prayer/prayer_9_tashahhud1.png',
          'image/prayer/prayer_11_salam1.png',
          'image/prayer/prayer_12_salam2.png'],
      7: ['image/prayer/prayer_12_salam2.png'],
    };
    final List<String>? prayerImageList = catId == 'prayer'
        ? prayerImages[lessonNo]
        : catId == 'wudhu'
            ? wudhuImages[lessonNo]
            : null;

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Column(children: [
        // ── หัวข้อแบบไล่เฉดสีตามหมวดหมู่ + มุมโค้งด้านล่าง (แพทเทิร์นเดียวกับ
        // หน้าอื่นๆ ในแอป) แทน AppBar เรียบๆ สีเดียวเดิม ──
        Container(
          width: double.infinity,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.75)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
          child: SafeArea(
            bottom: false,
            child: Stack(children: [
              ...headerCornerDecor(size: 45),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Row(children: [
                    GestureDetector(onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20)),
                    const Spacer(),
                    if (total > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(20)),
                        child: Text(
                          lang.lang == 'th' ? 'บทที่ $lessonNo จาก $total' : 'Lesson $lessonNo of $total',
                          style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600))),
                  ]),
                  const SizedBox(height: 14),
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Container(width: 46, height: 46,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.16), borderRadius: BorderRadius.circular(13)),
                        child: Padding(
                          padding: const EdgeInsets.all(11),
                          child: buildCategoryIcon(catId, size: 24, color: Colors.white),
                        )),
                    const SizedBox(width: 14),
                    Expanded(child: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(title,
                          style: const TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold, height: 1.3)),
                    )),
                  ]),
                  if (total > 0) ...[
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: total > 0 ? lessonNo / total : 0,
                        minHeight: 4,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                  ],
                ]),
              ),
            ]),
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
                20, 20, 20, 12 + MediaQuery.of(context).padding.bottom),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Prayer image(s)
              if (prayerImageList != null && prayerImageList.isNotEmpty) ...[
                if (prayerImageList.length == 1)
                  Container(
                    height: 200,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: theme.isDark ? const Color(0xFF0D2E1A) : const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.15))),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(prayerImageList[0], fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => Center(
                              child: Icon(Icons.image_not_supported_outlined,
                                  color: theme.subTextColor, size: 40)))))
                else ...[
                  Row(children: [
                    for (int i = 0; i < prayerImageList.length; i++) ...[
                      Expanded(
                        child: Container(
                          height: 180,
                          margin: EdgeInsets.only(
                            right: i < prayerImageList.length - 1 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: theme.isDark ? const Color(0xFF0D2E1A) : const Color(0xFFF1F8E9),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: color.withOpacity(0.15))),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: Image.asset(prayerImageList[i], fit: BoxFit.contain,
                                errorBuilder: (_, __, ___) => Center(
                                    child: Icon(Icons.image_not_supported_outlined,
                                        color: theme.subTextColor, size: 32))))),
                      ),
                    ],
                  ]),
                  const SizedBox(height: 20),
                ],
              ],
              if (arabic.isNotEmpty) ...[
                Container(
                  width: double.infinity,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    color: theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: color.withOpacity(0.3))),
                  child: Column(children: [
                    // แถบทองบางๆ บนสุด เป็นจุดตกแต่งเล็กๆ แยกกล่องอารบิกให้
                    // เด่นออกมาจากกล่องเนื้อหาด้านล่าง
                    Container(height: 4, width: double.infinity, color: const Color(0xFFFFD700).withOpacity(0.6)),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(arabic, textAlign: TextAlign.center, textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 24, height: 2.0, color: theme.textColor)),
                        ),
                        if (getLessonTrans(lesson, lang.lang).isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(getLessonTrans(lesson, lang.lang),
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 13, color: theme.subTextColor,
                                  fontStyle: FontStyle.italic, height: 1.6)),
                        ],
                      ]),
                    ),
                  ]),
                ),
                // ── ลายดอกไม้คั่น (asset จริงจาก Canva) แทนช่องว่างเปล่าๆ
                // ระหว่างกล่องอารบิกกับกล่องเนื้อหา ──
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: FractionallySizedBox(
                      widthFactor: 0.85,
                      child: AspectRatio(
                        aspectRatio: 900 / 110,
                        child: Image.asset(kFlowerDividerAsset, fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => const SizedBox.shrink()),
                      ),
                    ),
                  ),
                ),
              ],
              Container(
                width: double.infinity, padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: theme.cardColor, borderRadius: BorderRadius.circular(16),
                  border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
                  boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2))]),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildContentBlocks(content)),
              ),
              const SizedBox(height: 24),

              // ── ปุ่มก่อนหน้า/ถัดไป — ให้เรียนต่อเนื่องได้โดยไม่ต้องกลับไปหน้าลิสต์ ──
              if (hasNav)
                Row(children: [
                  Expanded(
                    child: currentIndex! > 0
                        ? OutlinedButton.icon(
                            onPressed: () => _goToLesson(context, currentIndex! - 1),
                            icon: Icon(Icons.chevron_left, color: color, size: 18),
                            label: Text(lang.lang == 'th' ? 'ก่อนหน้า' : 'Previous',
                                style: TextStyle(color: color, fontWeight: FontWeight.w600)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              side: BorderSide(color: color.withOpacity(0.4)),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  if (currentIndex! > 0 && currentIndex! < total - 1) const SizedBox(width: 12),
                  Expanded(
                    child: currentIndex! < total - 1
                        ? ElevatedButton.icon(
                            onPressed: () => _goToLesson(context, currentIndex! + 1),
                            icon: const Icon(Icons.chevron_right, color: Colors.white, size: 18),
                            label: Text(lang.lang == 'th' ? 'ถัดไป' : 'Next',
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              padding: const EdgeInsets.symmetric(vertical: 13),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ]),
              const SizedBox(height: 20),
            ]),
          ),
        ),
      ]),
    );
  }
}

// ── LessonsTab (ใช้ใน DuaLessonsPage) ────────────
class LessonsTab extends StatefulWidget {
  const LessonsTab({super.key});
  @override
  State<LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<LessonsTab> {
  final _theme = ThemeService();
  final _lang = LanguageService();

  final List<Map<String, dynamic>> _categories = [
    {'id': 'pillars', 'icon': '🕌',
     'titleEn': '5 Pillars of Islam', 'titleTh': '5 เสาหลักของอิสลาม', 'titleMs': '5 Rukun Islam', 'titleId': '5 Rukun Islam', 'titleAr': 'أركان الإسلام الخمسة', 'titleUr': 'اسلام کے 5 ارکان', 'titleBn': 'ইসলামের ৫ স্তম্ভ',
     'subtitleEn': 'The foundation of Islamic faith', 'subtitleTh': 'รากฐานของศาสนาอิสลาม', 'subtitleMs': 'Asas agama Islam', 'subtitleId': 'Dasar agama Islam', 'subtitleAr': 'أساس الإسلام', 'subtitleUr': 'اسلام کی بنیاد', 'subtitleBn': 'ইসলামের ভিত্তি',
     'color': const Color(0xFF1B5E20), 'lessons': 5},
    {'id': 'iman', 'icon': '💫',
     'titleEn': '6 Pillars of Iman', 'titleTh': '6 หลักอีหม่าน', 'titleMs': '6 Rukun Iman', 'titleId': '6 Rukun Iman', 'titleAr': 'أركان الإيمان الستة', 'titleUr': 'ایمان کے 6 ارکان', 'titleBn': 'ঈমানের ৬ স্তম্ভ',
     'subtitleEn': 'Articles of Islamic faith', 'subtitleTh': 'หลักความเชื่อในอิสลาม', 'subtitleMs': 'Kepercayaan asas Islam', 'subtitleId': 'Kepercayaan dasar Islam', 'subtitleAr': 'عقائد الإيمان', 'subtitleUr': 'ایمان کے عقائد', 'subtitleBn': 'ইসলামী বিশ্বাসের মূলনীতি',
     'color': const Color(0xFF1565C0), 'lessons': 6},
    {'id': 'wudhu', 'icon': '💧',
     'titleEn': 'How to Perform Wudhu', 'titleTh': 'วิธีทำวุฎูอ์', 'titleMs': 'Cara Berwudhu', 'titleId': 'Cara Berwudhu', 'titleAr': 'كيفية الوضوء', 'titleUr': 'وضو کا طریقہ', 'titleBn': 'ওযু করার নিয়ম',
     'subtitleEn': 'Step by step wudhu guide', 'subtitleTh': 'คู่มือวุฎูอ์ทีละขั้นตอน', 'subtitleMs': 'Panduan wudhu langkah demi langkah', 'subtitleId': 'Panduan wudhu langkah demi langkah', 'subtitleAr': 'دليل الوضوء خطوة بخطوة', 'subtitleUr': 'وضو کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে ওযুর গাইড',
     'color': const Color(0xFF0277BD), 'lessons': 8},
    {'id': 'prayer', 'icon': '🙏',
     'titleEn': 'How to Pray', 'titleTh': 'วิธีละหมาด', 'titleMs': 'Cara Solat', 'titleId': 'Cara Sholat', 'titleAr': 'كيفية الصلاة', 'titleUr': 'نماز کا طریقہ', 'titleBn': 'নামাজের পদ্ধতি',
     'subtitleEn': 'Step by step prayer guide', 'subtitleTh': 'คู่มือละหมาดทีละขั้นตอน', 'subtitleMs': 'Panduan solat langkah demi langkah', 'subtitleId': 'Panduan sholat langkah demi langkah', 'subtitleAr': 'دليل الصلاة خطوة بخطوة', 'subtitleUr': 'نماز کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে নামাজের গাইড',
     'color': const Color(0xFF6A1B9A), 'lessons': 7},
    {'id': 'hadith', 'icon': '📜',
     'titleEn': '40 Hadith', 'titleTh': '40 หะดีษ', 'titleMs': '40 Hadith', 'titleId': '40 Hadis', 'titleAr': '٤٠ حديثاً', 'titleUr': '40 احادیث', 'titleBn': '৪০ হাদিস',
     'subtitleEn': 'Key teachings of Prophet Muhammad', 'subtitleTh': 'คำสอนสำคัญของท่านนบี', 'subtitleMs': 'Ajaran utama Nabi Muhammad', 'subtitleId': 'Ajaran utama Nabi Muhammad', 'subtitleAr': 'تعاليم النبي محمد الأساسية', 'subtitleUr': 'نبی محمد کی اہم تعلیمات', 'subtitleBn': 'নবী মুহাম্মদের মূল শিক্ষা',
     'color': const Color(0xFF4E342E), 'lessons': 40},
    {'id': 'adab', 'icon': '🤝',
     'titleEn': 'Islamic Manners', 'titleTh': 'มารยาทอิสลาม', 'titleMs': 'Adab Islam', 'titleId': 'Adab Islam', 'titleAr': 'الآداب الإسلامية', 'titleUr': 'اسلامی آداب', 'titleBn': 'ইসলামী আদব',
     'subtitleEn': 'Etiquette in daily life', 'subtitleTh': 'มารยาทในชีวิตประจำวัน', 'subtitleMs': 'Adab dalam kehidupan harian', 'subtitleId': 'Etika dalam kehidupan sehari-hari', 'subtitleAr': 'الآداب في الحياة اليومية', 'subtitleUr': 'روزمرہ زندگی میں آداب', 'subtitleBn': 'দৈনন্দিন জীবনে শিষ্টাচার',
     'color': const Color(0xFF00695C), 'lessons': 5},
    {'id': 'history', 'icon': '🏛️',
     'titleEn': 'Islamic History', 'titleTh': 'ประวัติศาสตร์อิสลาม', 'titleMs': 'Sejarah Islam', 'titleId': 'Sejarah Islam', 'titleAr': 'التاريخ الإسلامي', 'titleUr': 'اسلامی تاریخ', 'titleBn': 'ইসলামের ইতিহাস',
     'subtitleEn': 'Key events in Islamic history', 'subtitleTh': 'เหตุการณ์สำคัญในประวัติอิสลาม', 'subtitleMs': 'Peristiwa penting dalam sejarah Islam', 'subtitleId': 'Peristiwa penting dalam sejarah Islam', 'subtitleAr': 'أحداث رئيسية في التاريخ الإسلامي', 'subtitleUr': 'اسلامی تاریخ کے اہم واقعات', 'subtitleBn': 'ইসলামের ইতিহাসের গুরুত্বপূর্ণ ঘটনা',
     'color': const Color(0xFFE65100), 'lessons': 6},
    {'id': 'fasting', 'icon': '🌙',
     'titleEn': 'Fasting (Sawm)', 'titleTh': 'การถือศีลอด (เซาม์)', 'titleMs': 'Puasa (Sawm)', 'titleId': 'Puasa (Shaum)', 'titleAr': 'الصيام', 'titleUr': 'روزہ (صوم)', 'titleBn': 'রোজা (সাওম)',
     'subtitleEn': 'The complete guide to Islamic fasting', 'subtitleTh': 'คู่มือการถือศีลอดในอิสลาม', 'subtitleMs': 'Panduan lengkap puasa Islam', 'subtitleId': 'Panduan lengkap puasa Islam', 'subtitleAr': 'الدليل الشامل للصيام الإسلامي', 'subtitleUr': 'اسلامی روزے کی مکمل رہنمائی', 'subtitleBn': 'ইসলামিক রোজার সম্পূর্ণ গাইড',
     'color': const Color(0xFF00838F), 'lessons': 7},
    {'id': 'special_prayer', 'icon': '🕌',
     'titleEn': 'Special Prayers', 'titleTh': 'ละหมาดพิเศษ', 'titleMs': 'Solat Khas', 'titleId': 'Sholat Khusus', 'titleAr': 'الصلوات الخاصة', 'titleUr': 'خصوصی نمازیں', 'titleBn': 'বিশেষ নামাজ',
     'subtitleEn': 'Eid, Funeral, Tarawih and more', 'subtitleTh': 'ละหมาดอีด ญะนาซะห์ ตะรอวีห์ และอื่นๆ', 'subtitleMs': 'Solat Eid, Jenazah, Tarawih dan lain-lain', 'subtitleId': 'Sholat Eid, Jenazah, Tarawih dan lainnya', 'subtitleAr': 'صلاة العيد والجنازة والتراويح وغيرها', 'subtitleUr': 'عید، جنازہ، تراویح اور دیگر نمازیں', 'subtitleBn': 'ঈদ, জানাজা, তারাবি এবং অন্যান্য',
     'color': const Color(0xFF4527A0), 'lessons': 6},
  ];

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, 16 + MediaQuery.of(context).padding.bottom),
      itemCount: _categories.length,
      itemBuilder: (_, i) {
        final cat = _categories[i];
        final title = getLangText(cat, 'title', _lang.lang);
        final subtitle = getLangText(cat, 'subtitle', _lang.lang);
        final color = cat['color'] as Color;
        final showGradient = !_theme.isDark;
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => LessonDetailPage(category: cat, lang: _lang, theme: _theme))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: _theme.cardColor,
              gradient: showGradient
                  ? LinearGradient(
                      begin: Alignment.topLeft, end: Alignment.bottomRight,
                      colors: [Colors.white, color.withOpacity(0.05)])
                  : null,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFF0F0F0)),
              boxShadow: [
                BoxShadow(
                    color: _theme.isDark ? Colors.black.withOpacity(0.15) : color.withOpacity(0.08),
                    blurRadius: 10, offset: const Offset(0, 3))]),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color.withOpacity(0.14),
                    border: Border.all(color: color.withOpacity(0.35), width: 1.2)),
                  child: Padding(
                    padding: const EdgeInsets.all(11),
                    child: buildCategoryIcon(cat['id'] as String, size: 24, color: color),
                  )),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _theme.textColor)),
                  const SizedBox(height: 3),
                  Text(subtitle, maxLines: 2, overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: _theme.subTextColor, height: 1.4)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('${cat['lessons']} ${_lang.lang == 'th' ? 'บทเรียน' : 'lessons'}',
                        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))),
                ])),
                const SizedBox(width: 8),
                Icon(Icons.chevron_right, size: 18, color: _theme.subTextColor),
              ]),
            ),
          ),
        );
      },
    );
  }
}