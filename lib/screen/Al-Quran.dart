import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/quran_database.dart';
import 'surah_detail_page.dart';

class AlQuranPage extends StatefulWidget {
  const AlQuranPage({super.key});

  @override
  State<AlQuranPage> createState() => _AlQuranPageState();
}

class _AlQuranPageState extends State<AlQuranPage> {
  List<Map<String, dynamic>> surahs = [];
  bool isLoading = true;
  bool isDownloading = false;
  int downloadProgress = 0;
  int totalSurahs = 114;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    loadSurahs();
  }

  Future<void> loadSurahs() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final hasLocal = await QuranDatabase.hasSurahs();
    if (hasLocal) {
      final local = await QuranDatabase.getSurahs();
      setState(() {
        surahs = local;
        isLoading = false;
      });

      // เช็คว่า download verses ครบหรือยัง
      final allDownloaded = await QuranDatabase.hasAllVerses();
      if (!allDownloaded) {
        _downloadAllVerses(local);
      }
      return;
    }

    // ดึง Surah list ก่อน
    await fetchSurahsFromApi();
  }

  Future<void> fetchSurahsFromApi() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.qurancdn.com/api/qdc/chapters?language=en'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final apiSurahs = data['chapters'] as List;
        await QuranDatabase.saveSurahs(apiSurahs);
        final local = await QuranDatabase.getSurahs();
        setState(() {
          surahs = local;
          isLoading = false;
        });
        // เริ่ม download verses ทั้งหมด
        _downloadAllVerses(local);
      } else {
        setState(() {
          errorMessage = 'Failed to load surahs';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'No internet connection';
        isLoading = false;
      });
    }
  }

  Future<void> _downloadAllVerses(List<Map<String, dynamic>> surahList) async {
    setState(() {
      isDownloading = true;
      downloadProgress = 0;
    });

    for (int i = 0; i < surahList.length; i++) {
      final surahId = surahList[i]['id'] as int;

      // ข้ามถ้ามีแล้ว
      final hasLocal = await QuranDatabase.hasVerses(surahId);
      if (hasLocal) {
        setState(() => downloadProgress = i + 1);
        continue;
      }

      try {
        final response = await http.get(
          Uri.parse(
            'https://api.qurancdn.com/api/qdc/verses/by_chapter/$surahId'
            '?language=en&words=true&translations=131&per_page=300&fields=text_uthmani',
          ),
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          await QuranDatabase.saveVerses(surahId, data['verses'] as List);
        }
      } catch (e) {
        // ถ้าเน็ตหลุดให้หยุดก่อน
        break;
      }

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
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
          : errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      Text(errorMessage,
                          style: const TextStyle(color: Colors.grey)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: fetchSurahsFromApi,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20)),
                        child: const Text('Retry',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Download Progress Banner
                    if (isDownloading)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        color: const Color(0xFF1B5E20).withOpacity(0.1),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.download,
                                    color: Color(0xFF1B5E20), size: 18),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Downloading for offline use... $downloadProgress/$totalSurahs',
                                    style: const TextStyle(
                                        color: Color(0xFF1B5E20),
                                        fontSize: 13),
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

                    // Surah List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: surahs.length,
                        itemBuilder: (context, index) {
                          final surah = surahs[index];
                          return _SurahCard(
                            surah: surah,
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
  final VoidCallback onTap;

  const _SurahCard({required this.surah, required this.onTap});

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
                    '${surah['translated_name'] ?? ''} • ${surah['verses_count']} verses',
                    style: const TextStyle(
                        fontSize: 12, color: Colors.black54),
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