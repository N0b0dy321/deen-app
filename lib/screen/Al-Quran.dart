import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../services/quran_database.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import '../services/quran_font_service.dart';
import '../services/quran_download_service.dart';
import 'surah_detail_page.dart';

// ── ไอคอนอัลกุรอาน (silhouette ขาว) — path เดียวกับที่ใช้ในการ์ดหน้า Home
// (kQuranIconAsset) แต่คนละไฟล์เลยประกาศแยก ให้โลโก้ตรงกันทั้งแอป
// (เหลือไว้เป็น fallback เผื่อโลโก้ตัวเขียนหลักโหลดไม่ขึ้น)
const String kQuranPageIconAsset = 'image/decor/quran_icon.png';
// ── กรอบเลขลำดับซูเราะห์ ทรงใบโคลเวอร์ 4 กลีบเขียว+ทอง (ไม่ใช่ silhouette
// ขาว มีสีในตัวเองอยู่แล้ว ห้ามทาสีทับ) ใช้แทนวงกลมพื้นเรียบเดิม ──
const String kSurahBadgeAsset = 'image/decor/surah_badge.png';
// ── โลโก้ตัวเขียนอาหรับ "القرآن الكريم" ทรงกลมสีทอง (ดีไซน์ที่ user ส่งมา) ──
// ต้องตั้งชื่อไฟล์นี้ให้ต่างจาก flower_divider.png เดิม (อัปโหลดมาชื่อซ้ำกัน
// ตอนแรกจนไปทับไฟล์เส้นคั่นเดิมโดยไม่ตั้งใจ)
const String kQuranEmblemAsset = 'image/decor/quran_emblem.png';
// ── เส้นคั่นลายดอกไม้ (ไฟล์เดิมที่ใช้ในหน้าบทเรียนอยู่แล้ว — path เดียวกัน) ──
const String kQuranDividerAsset = 'image/decor/flower_divider.png';
// ── ลายมุมดาวทอง (ไฟล์เดิมเหมือนกัน) ──
const String kQuranCornerAsset = 'image/decor/corner_star.png';

List<Widget> _quranCornerDecor({double size = 48}) {
  Widget img() => Image.asset(kQuranCornerAsset, width: size, height: size,
      errorBuilder: (_, __, ___) => const SizedBox.shrink());
  Widget flip(double sx, double sy, Widget child) => Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(sx, sy, 1),
      child: child);
  return [
    Positioned(top: 2, left: 2, child: img()),
    Positioned(top: 2, right: 2, child: flip(-1, 1, img())),
    Positioned(bottom: 2, left: 2, child: flip(1, -1, img())),
    Positioned(bottom: 2, right: 2, child: flip(-1, -1, img())),
  ];
}


const Map<int, String> _thaiNames = {
  1: 'อัลฟาติฮะห์', 2: 'อัลบะเกาะเราะห์', 3: 'อาลิอิมรอน', 4: 'อันนิสาอ์',
  5: 'อัลมาอิดะห์', 6: 'อัลอันอาม', 7: 'อัลอะอ์รอฟ', 8: 'อัลอันฟาล',
  9: 'อัตเตาบะห์', 10: 'ยูนุส', 11: 'ฮูด', 12: 'ยูซุฟ',
  13: 'อัรเราะอ์ด', 14: 'อิบรอฮีม', 15: 'อัลฮิจร์', 16: 'อันนะฮ์ล',
  17: 'อัลอิสรออ์', 18: 'อัลกะฮ์ฟ', 19: 'มัรยัม', 20: 'ฏอฮา',
  21: 'อัลอันบิยาอ์', 22: 'อัลฮัจญ์', 23: 'อัลมุมินูน', 24: 'อันนูร',
  25: 'อัลฟุรกอน', 26: 'อัชชุอะรออ์', 27: 'อันนัมล์', 28: 'อัลเกาะศอศ',
  29: 'อัลอังกะบูต', 30: 'อัรรูม', 31: 'ลุกมาน', 32: 'อัสสัจดะห์',
  33: 'อัลอะห์ซาบ', 34: 'สะบะอ์', 35: 'ฟาฏิร', 36: 'ยาซีน',
  37: 'อัศศอฟฟาต', 38: 'ศอด', 39: 'อัซซุมัร', 40: 'ฆอฟิร',
  41: 'ฟุศศิลัต', 42: 'อัชชูรอ', 43: 'อัซซุครุฟ', 44: 'อัดดุคอน',
  45: 'อัลญาษิยะห์', 46: 'อัลอะห์กอฟ', 47: 'มุฮัมมัด', 48: 'อัลฟัตห์',
  49: 'อัลฮุญุรอต', 50: 'กอฟ', 51: 'อัษษาริยาต', 52: 'อัฏฏูร',
  53: 'อันนัจม์', 54: 'อัลเกาะมัร', 55: 'อัรเราะห์มาน', 56: 'อัลวากิอะห์',
  57: 'อัลฮะดีด', 58: 'อัลมุญาดะละห์', 59: 'อัลฮัชร์', 60: 'อัลมุมตะฮะนะห์',
  61: 'อัศศอฟฟ์', 62: 'อัลญุมุอะห์', 63: 'อัลมุนาฟิกูน', 64: 'อัตตะฆอบุน',
  65: 'อัฏฏอลาก', 66: 'อัตตะห์รีม', 67: 'อัลมุลก์', 68: 'อัลกอลัม',
  69: 'อัลฮากเกาะห์', 70: 'อัลมะอาริจ', 71: 'นูห์', 72: 'อัลญิน',
  73: 'อัลมุซซัมมิล', 74: 'อัลมุดดัษษิร', 75: 'อัลกิยามะห์', 76: 'อัลอินซาน',
  77: 'อัลมุรสะลาต', 78: 'อันนะบะอ์', 79: 'อันนาซิอาต', 80: 'อะบะสะ',
  81: 'อัตตักวีร', 82: 'อัลอินฟิฏอร', 83: 'อัลมุฏอฟฟิฟีน', 84: 'อัลอินชิกอก',
  85: 'อัลบุรูจ', 86: 'อัฏฏอริก', 87: 'อัลอะอ์ลา', 88: 'อัลฆอชิยะห์',
  89: 'อัลฟัจร์', 90: 'อัลบะลัด', 91: 'อัชชัมส์', 92: 'อัลลัยล์',
  93: 'อัฎฎุฮา', 94: 'อัชชัรห์', 95: 'อัตตีน', 96: 'อัลอะลัก',
  97: 'อัลกอดร์', 98: 'อัลบัยยินะห์', 99: 'อัซซัลซะละห์', 100: 'อัลอาดิยาต',
  101: 'อัลกอริอะห์', 102: 'อัตตะกาษุร', 103: 'อัลอัศร์', 104: 'อัลฮุมะซะห์',
  105: 'อัลฟีล', 106: 'กุรัยช์', 107: 'อัลมาอูน', 108: 'อัลเกาษัร',
  109: 'อัลกาฟิรูน', 110: 'อันนัศร์', 111: 'อัลมะสัด', 112: 'อัลอิคลาศ',
  113: 'อัลฟะลัก', 114: 'อันนาส',
};

int _levenshtein(String a, String b) {
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  final matrix = List.generate(a.length + 1, (i) => List.generate(b.length + 1, (j) => 0));
  for (int i = 0; i <= a.length; i++) matrix[i][0] = i;
  for (int j = 0; j <= b.length; j++) matrix[0][j] = j;
  for (int i = 1; i <= a.length; i++) {
    for (int j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      matrix[i][j] = [matrix[i-1][j]+1, matrix[i][j-1]+1, matrix[i-1][j-1]+cost].reduce(min);
    }
  }
  return matrix[a.length][b.length];
}

bool _fuzzyMatch(String text, String query) {
  text = text.toLowerCase(); query = query.toLowerCase();
  if (text.contains(query)) return true;
  final tolerance = query.length <= 4 ? 1 : 2;
  for (int i = 0; i <= text.length - query.length + tolerance; i++) {
    final end = min(i + query.length + tolerance, text.length);
    if (_levenshtein(text.substring(i, end), query) <= tolerance) return true;
  }
  return false;
}

class AlQuranPage extends StatefulWidget {
  const AlQuranPage({super.key});
  @override
  State<AlQuranPage> createState() => _AlQuranPageState();
}

class _AlQuranPageState extends State<AlQuranPage> {
  List<Map<String, dynamic>> surahs = [];
  List<Map<String, dynamic>> filteredSurahs = [];
  bool isLoading = true;
  bool isDownloading = false;
  int downloadProgress = 0;
  int downloadTotal = 114 * kQuranOfflineEditions.length;
  String errorMessage = '';
  // ── ฟอนต์ชื่อซูเราะห์ภาษาอาหรับ ใช้ตัวเดียวกับที่ user เลือกไว้ในหน้า
  // ตั้งค่า (Settings) ให้สอดคล้องกันทั้งแอป แทนที่จะ hardcode ฟอนต์แยก ──
  String _quranFontId = kQuranFontDefault;
  final TextEditingController _searchController = TextEditingController();
  final _lang = LanguageService();
  final _theme = ThemeService();

  @override
  void initState() {
    super.initState();
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
    loadSurahs();
    _loadQuranFont();
    _searchController.addListener(_onSearch);
  }

  Future<void> _loadQuranFont() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString(kQuranFontPrefKey) ?? kQuranFontDefault;
    if (mounted) setState(() => _quranFontId = id);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _lang.removeListener(() => setState(() {}));
    _theme.removeListener(() => setState(() {}));
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) { filteredSurahs = surahs; return; }
      filteredSurahs = surahs.where((surah) {
        final id = surah['id'] as int;
        final name = surah['name_simple'] ?? '';
        final arabic = surah['name_arabic'] ?? '';
        final translated = surah['translated_name'] ?? '';
        final thai = _thaiNames[id] ?? '';
        if (query == '$id') return true;
        if (thai.contains(query)) return true;
        return _fuzzyMatch(name, query) || _fuzzyMatch(translated, query) || _fuzzyMatch(arabic, query);
      }).toList();
    });
  }

  Future<void> loadSurahs() async {
    setState(() { isLoading = true; errorMessage = ''; });
    final hasLocal = await QuranDatabase.hasSurahs();
    if (hasLocal) {
      final local = await QuranDatabase.getSurahs();
      setState(() { surahs = local; filteredSurahs = local; isLoading = false; });
      _downloadAllVersesAllLangs(local);
      return;
    }
    await fetchSurahsFromApi();
  }

  Future<void> fetchSurahsFromApi() async {
    try {
      final response = await http.get(Uri.parse('https://api.qurancdn.com/api/qdc/chapters?language=en'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await QuranDatabase.saveSurahs(data['chapters'] as List);
        final local = await QuranDatabase.getSurahs();
        setState(() { surahs = local; filteredSurahs = local; isLoading = false; });
        _downloadAllVersesAllLangs(local);
      } else {
        setState(() { errorMessage = 'Failed to load surahs'; isLoading = false; });
      }
    } catch (e) {
      setState(() { errorMessage = 'No internet connection'; isLoading = false; });
    }
  }

  // ── ดาวน์โหลดอายะห์ offline ไว้ล่วงหน้า "ครบทุกภาษาที่แอปรองรับ" ─────────
  // ลอจิกจริงย้ายไปไว้ที่ QuranDownloadService กลางแล้ว (ใช้ร่วมกับ
  // background task ของ WorkManager ที่ตั้งไว้ใน main.dart ด้วย) ที่นี่แค่
  // เรียกใช้แล้วรับ progress มาแสดงผล — ประโยชน์คือถ้าผู้ใช้ออกจากหน้านี้ไป
  // (หรือปิดแอปไปเลย) การดาวน์โหลดยังเดินต่อเองใน background ผ่าน
  // WorkManager ได้ ไม่ต้องเปิดค้างหน้า Al-Quran ไว้เหมือนเดิมอีกต่อไป
  Future<void> _downloadAllVersesAllLangs(List<Map<String, dynamic>> surahList) async {
    setState(() { isDownloading = true; downloadProgress = 0; });
    await QuranDownloadService.downloadAll(
      onProgress: (done, total) {
        if (!mounted) return; // ออกจากหน้านี้ไปแล้ว แต่ service ยังทำงานต่อได้
        setState(() {
          downloadProgress = done;
          downloadTotal = total;
        });
      },
    );
    if (mounted) setState(() => isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(
          child: isLoading
              ? Center(child: CircularProgressIndicator(color: _theme.iconColor))
              : errorMessage.isNotEmpty
                  ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Icon(Icons.wifi_off, size: 64.sp, color: _theme.subTextColor),
                      SizedBox(height: 16.h),
                      Text(errorMessage, style: TextStyle(color: _theme.subTextColor)),
                      SizedBox(height: 16.h),
                      ElevatedButton(onPressed: fetchSurahsFromApi,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                        child: Text(_lang.retry, style: const TextStyle(color: Colors.white))),
                    ]))
                  : Column(children: [
                      if (isDownloading)
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                          color: _theme.iconColor.withOpacity(0.1),
                          child: Column(children: [
                            Row(children: [
                              Icon(Icons.download, color: _theme.iconColor, size: 18.sp),
                              SizedBox(width: 8.w),
                              Expanded(child: Text('${_lang.downloadingOffline} $downloadProgress/$downloadTotal',
                                  style: TextStyle(color: _theme.iconColor, fontSize: 13.sp))),
                            ]),
                            SizedBox(height: 6.h),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: LinearProgressIndicator(value: downloadProgress / downloadTotal,
                                  minHeight: 5.h,
                                  backgroundColor: _theme.isDark ? const Color(0xFF2C3E50) : Colors.grey.shade300,
                                  color: _theme.iconColor),
                            ),
                          ]),
                        ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 4.h),
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(color: _theme.textColor),
                          decoration: InputDecoration(
                            hintText: _lang.searchHint,
                            hintStyle: TextStyle(color: _theme.subTextColor, fontSize: 14.sp),
                            prefixIcon: Icon(Icons.search, color: _theme.iconColor),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(icon: Icon(Icons.clear, color: _theme.subTextColor),
                                    onPressed: () => _searchController.clear())
                                : null,
                            filled: true,
                            fillColor: _theme.cardColor,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.r), borderSide: BorderSide.none),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: _theme.isDark ? BorderSide(color: ThemeService.darkBorder) : BorderSide.none),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.r),
                              borderSide: BorderSide(color: const Color(0xFF1B5E20).withOpacity(0.5), width: 1.4)),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 4.h),
                          child: Align(alignment: Alignment.centerLeft,
                            child: Text('${_lang.foundSurahs} ${filteredSurahs.length} ${_lang.surahUnit}',
                                style: TextStyle(fontSize: 12.sp, color: _theme.subTextColor))),
                        ),
                      Expanded(
                        child: filteredSurahs.isEmpty
                            ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(Icons.search_off, size: 64.sp, color: _theme.subTextColor),
                                SizedBox(height: 12.h),
                                Text(_lang.notFound, style: TextStyle(color: _theme.subTextColor)),
                              ]))
                            : ListView.builder(
                                padding: EdgeInsets.fromLTRB(
                                  14.w, 12.h, 14.w, 12.h + MediaQuery.of(context).padding.bottom,
                                ),
                                itemCount: filteredSurahs.length,
                                itemBuilder: (context, index) {
                                  final surah = filteredSurahs[index];
                                  final thaiName = _thaiNames[surah['id']] ?? '';
                                  return _SurahCard(surah: surah, thaiName: thaiName, lang: _lang, theme: _theme,
                                    quranFontId: _quranFontId,
                                    onTap: () => Navigator.push(context, MaterialPageRoute(
                                      builder: (_) => SurahDetailPage(surahId: surah['id'], surahName: surah['name_simple']))));
                                }),
                      ),
                    ]),
        ),
      ]),
    );
  }

  // ── หัวข้อแบบไล่เฉดสี + มุมโค้งด้านล่าง (แพทเทิร์นเดียวกับหน้า Prayer Times,
  // Qibla, Halal Restaurant) แทน AppBar เรียบๆ สีเดียวเดิมที่ทำให้หน้านี้
  // ดูไม่เข้าชุดกับหน้าอื่นในแอปเลย — ใช้ตัวเลขพิกเซลตรงๆ ไม่ผ่าน ScreenUtil
  // (.sp/.h/.w) เหมือนหน้า Qibla/Halal Restaurant/บทเรียนที่ได้สัดส่วนถูกต้อง
  // แล้ว (ก่อนหน้านี้ใช้ ScreenUtil ตามไฟล์เดิม ทำให้แถบใหญ่ผิดปกติ)
  //
  // ── ดีไซน์ตามภาพร่างที่ user ส่งมา: เส้นคั่นลายดอกไม้ + โลโก้ตัวเขียน
  // อาหรับทรงกลม + ชื่อหน้าตัวใหญ่ + เส้นคั่นอีกเส้น + ลายมุมดาวทอง 4 มุม
  // (แทนที่โครงแบบ back+ไอคอนเล็ก+title+subtitle ที่ใช้ร่วมกับหน้าอื่น เพราะ
  // หน้านี้ user อยากให้เป็นดีไซน์เด่นเฉพาะตัว ไม่ต้องเข้าชุดกับหน้าอื่น) ──
  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: _theme.isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A5C32)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
        ),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Stack(children: [
          ..._quranCornerDecor(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(children: [
              Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22)),
              ]),
              const SizedBox(height: 4),
              Image.asset(kQuranDividerAsset, width: 130,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              const SizedBox(height: 6),
              Image.asset(
                kQuranEmblemAsset,
                width: 72, height: 72,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => ColorFiltered(
                  colorFilter: const ColorFilter.mode(Color(0xFFFFD700), BlendMode.srcIn),
                  child: Image.asset(kQuranPageIconAsset, width: 44, height: 44,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 40)),
                ),
              ),
              const SizedBox(height: 6),
              Text(_lang.alQuran.toUpperCase(),
                  style: const TextStyle(color: Color(0xFFEEC97D), fontSize: 19,
                      fontWeight: FontWeight.bold, letterSpacing: 1.0)),
              const SizedBox(height: 6),
              Image.asset(kQuranDividerAsset, width: 130,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              const SizedBox(height: 4),
            ]),
          ),
        ]),
      ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final Map<String, dynamic> surah;
  final String thaiName;
  final LanguageService lang;
  final ThemeService theme;
  final String quranFontId;
  final VoidCallback onTap;

  const _SurahCard({required this.surah, required this.thaiName, required this.lang, required this.theme, required this.quranFontId, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final showGradient = !theme.isDark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        decoration: BoxDecoration(
          color: theme.cardColor,
          gradient: showGradient
              ? LinearGradient(
                  begin: Alignment.topLeft, end: Alignment.bottomRight,
                  colors: [Colors.white, const Color(0xFF1B5E20).withOpacity(0.04)])
              : null,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: theme.isDark ? ThemeService.darkBorder : const Color(0xFFF0F0F0)),
          boxShadow: [BoxShadow(
              color: theme.isDark ? Colors.black.withOpacity(0.15) : const Color(0xFF1B5E20).withOpacity(0.06),
              blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(children: [
            SizedBox(width: 44.w, height: 44.h,
              child: Stack(alignment: Alignment.center, children: [
                Image.asset(kSurahBadgeAsset, width: 44.w, height: 44.h, fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                        decoration: BoxDecoration(
                            color: theme.iconColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.iconColor.withOpacity(0.3), width: 1.2)))),
                Padding(
                  padding: EdgeInsets.only(bottom: 2.h),
                  child: Text('${surah['id']}',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13.sp)),
                ),
              ]),
            ),
            SizedBox(width: 14.w),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(surah['name_simple'] ?? '',
                  style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold, color: theme.textColor)),
              SizedBox(height: 2.h),
              Text(
                lang.isThai && thaiName.isNotEmpty
                    ? '$thaiName • ${surah['verses_count']} ${lang.verses}'
                    : '${surah['translated_name'] ?? ''} • ${surah['verses_count']} ${lang.verses}',
                style: TextStyle(fontSize: 12.sp, color: theme.subTextColor)),
            ])),
            SizedBox(width: 8.w),
            Text(surah['name_arabic'] ?? '',
                textDirection: TextDirection.rtl,
                style: getQuranFont(quranFontId).style(fontSize: 19.sp, color: theme.iconColor)),
          ]),
        ),
      ),
    );
  }
}