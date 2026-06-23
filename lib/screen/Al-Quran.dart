import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import '../services/quran_database.dart';
import 'surah_detail_page.dart';

// ชื่อภาษาไทยของแต่ละ Surah
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

// Fuzzy search ด้วย Levenshtein Distance
int _levenshtein(String a, String b) {
  if (a.isEmpty) return b.length;
  if (b.isEmpty) return a.length;
  final matrix = List.generate(
    a.length + 1,
    (i) => List.generate(b.length + 1, (j) => 0),
  );
  for (int i = 0; i <= a.length; i++) matrix[i][0] = i;
  for (int j = 0; j <= b.length; j++) matrix[0][j] = j;
  for (int i = 1; i <= a.length; i++) {
    for (int j = 1; j <= b.length; j++) {
      final cost = a[i - 1] == b[j - 1] ? 0 : 1;
      matrix[i][j] = [
        matrix[i - 1][j] + 1,
        matrix[i][j - 1] + 1,
        matrix[i - 1][j - 1] + cost,
      ].reduce(min);
    }
  }
  return matrix[a.length][b.length];
}

bool _fuzzyMatch(String text, String query) {
  text = text.toLowerCase();
  query = query.toLowerCase();
  if (text.contains(query)) return true;
  // ถ้าคำสั้น tolerance น้อย
  final tolerance = query.length <= 4 ? 1 : 2;
  // เช็คทีละ substring
  for (int i = 0; i <= text.length - query.length + tolerance; i++) {
    final end = min(i + query.length + tolerance, text.length);
    final sub = text.substring(i, end);
    if (_levenshtein(sub, query) <= tolerance) return true;
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

  @override
  void initState() {
    super.initState();
    loadSurahs();
    _searchController.addListener(_onSearch);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearch() {
    final query = _searchController.text.trim();
    setState(() {
      if (query.isEmpty) {
        filteredSurahs = surahs;
        return;
      }

      filteredSurahs = surahs.where((surah) {
        final id = surah['id'] as int;
        final name = surah['name_simple'] ?? '';
        final arabic = surah['name_arabic'] ?? '';
        final translated = surah['translated_name'] ?? '';
        final thai = _thaiNames[id] ?? '';

        // ค้นหาเลข Surah
        if (query == '$id') return true;

        // ค้นหาภาษาไทย (exact + fuzzy)
        if (thai.contains(query)) return true;

        // Fuzzy search ชื่อ
        return _fuzzyMatch(name, query) ||
            _fuzzyMatch(translated, query) ||
            _fuzzyMatch(arabic, query);
      }).toList();
    });
  }

  Future<void> loadSurahs() async {
    setState(() { isLoading = true; errorMessage = ''; });

    final hasLocal = await QuranDatabase.hasSurahs();
    if (hasLocal) {
      final local = await QuranDatabase.getSurahs();
      setState(() {
        surahs = local;
        filteredSurahs = local;
        isLoading = false;
      });
      final allDownloaded = await QuranDatabase.hasAllVerses();
      if (!allDownloaded) _downloadAllVerses(local);
      return;
    }
    await fetchSurahsFromApi();
  }

  Future<void> fetchSurahsFromApi() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.qurancdn.com/api/qdc/chapters?language=en'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        await QuranDatabase.saveSurahs(data['chapters'] as List);
        final local = await QuranDatabase.getSurahs();
        setState(() {
          surahs = local;
          filteredSurahs = local;
          isLoading = false;
        });
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
      if (await QuranDatabase.hasVerses(surahId)) {
        setState(() => downloadProgress = i + 1);
        continue;
      }
      try {
        final response = await http.get(Uri.parse(
          'https://api.qurancdn.com/api/qdc/verses/by_chapter/$surahId'
          '?language=en&words=true&translations=131&per_page=300&fields=text_uthmani',
        ));
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
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        title: const Text('Al-Quran',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(errorMessage, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchSurahsFromApi,
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                        child: const Text('Retry', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Download Progress
                    if (isDownloading)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        color: const Color(0xFF1B5E20).withOpacity(0.1),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.download, color: Color(0xFF1B5E20), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Downloading offline data... $downloadProgress/$totalSurahs',
                                    style: const TextStyle(color: Color(0xFF1B5E20), fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: downloadProgress / totalSurahs,
                              backgroundColor: Colors.grey.shade300,
                              color: const Color(0xFF1B5E20),
                            ),
                          ],
                        ),
                      ),

                    // Search Bar
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'ค้นหาชื่อ, ภาษาไทย, หรือเลข Surah...',
                          hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF1B5E20)),
                          suffixIcon: _searchController.text.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear, color: Colors.grey),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        ),
                      ),
                    ),

                    // Result count
                    if (_searchController.text.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'พบ ${filteredSurahs.length} ซูเราะห์',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),

                    // Surah List
                    Expanded(
                      child: filteredSurahs.isEmpty
                          ? const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search_off, size: 64, color: Colors.grey),
                                  SizedBox(height: 12),
                                  Text('ไม่พบซูเราะห์ที่ค้นหา',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: filteredSurahs.length,
                              itemBuilder: (context, index) {
                                final surah = filteredSurahs[index];
                                final thaiName = _thaiNames[surah['id']] ?? '';
                                return _SurahCard(
                                  surah: surah,
                                  thaiName: thaiName,
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => SurahDetailPage(
                                        surahId: surah['id'],
                                        surahName: surah['name_simple'],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                    ),
                  ],
                ),
    );
  }
}

class _SurahCard extends StatelessWidget {
  final Map<String, dynamic> surah;
  final String thaiName;
  final VoidCallback onTap;

  const _SurahCard({required this.surah, required this.thaiName, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF1B5E20).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text('${surah['id']}',
                    style: const TextStyle(
                        color: Color(0xFF1B5E20),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(surah['name_simple'] ?? '',
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87)),
                  const SizedBox(height: 2),
                  Text(
                    thaiName.isNotEmpty
                        ? '$thaiName • ${surah['verses_count']} อายะห์'
                        : '${surah['translated_name'] ?? ''} • ${surah['verses_count']} verses',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),
            Text(surah['name_arabic'] ?? '',
                style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF1B5E20),
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}