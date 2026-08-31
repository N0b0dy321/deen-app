import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../services/quran_database.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'surah_detail_page.dart';

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
  int totalSurahs = 114;
  String errorMessage = '';
  final TextEditingController _searchController = TextEditingController();
  final _lang = LanguageService();
  final _theme = ThemeService();

  @override
  void initState() {
    super.initState();
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
    loadSurahs();
    _searchController.addListener(_onSearch);
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
      final allDownloaded = await QuranDatabase.hasAllVerses();
      if (!allDownloaded) _downloadAllVerses(local);
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
        _downloadAllVerses(local);
      } else {
        setState(() { errorMessage = 'Failed to load surahs'; isLoading = false; });
      }
    } catch (e) {
      setState(() { errorMessage = 'No internet connection'; isLoading = false; });
    }
  }

  Future<void> _downloadAllVerses(List<Map<String, dynamic>> surahList) async {
    setState(() { isDownloading = true; downloadProgress = 0; });
    for (int i = 0; i < surahList.length; i++) {
      final surahId = surahList[i]['id'] as int;
      if (await QuranDatabase.hasVerses(surahId)) { setState(() => downloadProgress = i + 1); continue; }
      try {
        final response = await http.get(Uri.parse(
          'https://api.qurancdn.com/api/qdc/verses/by_chapter/$surahId?language=en&words=true&translations=131&per_page=300&fields=text_uthmani'));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          await QuranDatabase.saveVerses(surahId, data['verses'] as List);
        }
      } catch (e) { break; }
      setState(() => downloadProgress = i + 1);
    }
    setState(() => isDownloading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        title: Text(_lang.alQuran, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
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
                          Expanded(child: Text('${_lang.downloadingOffline} $downloadProgress/$totalSurahs',
                              style: TextStyle(color: _theme.iconColor, fontSize: 13.sp))),
                        ]),
                        SizedBox(height: 6.h),
                        LinearProgressIndicator(value: downloadProgress / totalSurahs,
                            backgroundColor: _theme.isDark ? const Color(0xFF2C3E50) : Colors.grey.shade300,
                            color: _theme.iconColor),
                      ]),
                    ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 4.h),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                      ),
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
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
                            padding: EdgeInsets.all(12.w),
                            itemCount: filteredSurahs.length,
                            itemBuilder: (context, index) {
                              final surah = filteredSurahs[index];
                              final thaiName = _thaiNames[surah['id']] ?? '';
                              return _SurahCard(surah: surah, thaiName: thaiName, lang: _lang, theme: _theme,
                                onTap: () => Navigator.push(context, MaterialPageRoute(
                                  builder: (_) => SurahDetailPage(surahId: surah['id'], surahName: surah['name_simple']))));
                            }),
                  ),
                ]),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final Map<String, dynamic> surah;
  final String thaiName;
  final LanguageService lang;
  final ThemeService theme;
  final VoidCallback onTap;

  const _SurahCard({required this.surah, required this.thaiName, required this.lang, required this.theme, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14.r),
          border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
          boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Row(children: [
          Container(width: 40.w, height: 40.h,
            decoration: BoxDecoration(color: theme.iconColor.withOpacity(0.12), shape: BoxShape.circle),
            child: Center(child: Text('${surah['id']}',
                style: TextStyle(color: theme.iconColor, fontWeight: FontWeight.bold, fontSize: 13.sp)))),
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
          Text(surah['name_arabic'] ?? '',
              style: TextStyle(fontSize: 18.sp, color: theme.iconColor, fontWeight: FontWeight.bold)),
        ]),
      ),
    );
  }
}