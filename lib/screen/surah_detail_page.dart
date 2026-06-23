import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/quran_database.dart';

class SurahDetailPage extends StatefulWidget {
  final int surahId;
  final String surahName;

  const SurahDetailPage({
    super.key,
    required this.surahId,
    required this.surahName,
  });

  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  List<Map<String, dynamic>> verses = [];
  bool isLoading = true;
  String errorMessage = '';

  String _selectedLang = 'en';
  final Map<String, Map<String, dynamic>> _languages = {
    'en': {'label': 'English', 'edition': 'en.sahih', 'flag': '🇬🇧'},
    'th': {'label': 'ภาษาไทย', 'edition': 'th.thai', 'flag': '🇹🇭'},
  };

  @override
  void initState() {
    super.initState();
    loadVerses();
  }

  Future<void> loadVerses() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final hasLocal = await QuranDatabase.hasVersesByLang(widget.surahId, _selectedLang);

    if (hasLocal) {
      final local = await QuranDatabase.getVersesByLang(widget.surahId, _selectedLang);

      // เช็คว่า translation มีข้อมูลจริงๆ ไหม
      final hasTranslation = local.isNotEmpty &&
          (local[0]['translation'] ?? '').toString().isNotEmpty;

      if (hasTranslation) {
        setState(() {
          verses = local;
          isLoading = false;
        });
        return;
      }

      // ถ้า translation ว่าง ลบ cache เก่าแล้วดึงใหม่
      await QuranDatabase.deleteVersesByLang(widget.surahId, _selectedLang);
    }

    await fetchFromApi();
  }

  Future<void> fetchFromApi() async {
    try {
      final edition = _languages[_selectedLang]!['edition'] as String;
      final url =
          'https://api.alquran.cloud/v1/surah/${widget.surahId}/editions/quran-uthmani,$edition';

      final response =
          await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List editions = data['data'];

        final arabicAyahs = editions[0]['ayahs'] as List;
        final translationAyahs = editions[1]['ayahs'] as List;

        final processedVerses = List.generate(arabicAyahs.length, (i) {
          return {
            'verse_number': arabicAyahs[i]['numberInSurah'],
            'text_uthmani': arabicAyahs[i]['text'] ?? '',
            'translation': translationAyahs[i]['text'] ?? '',
            'lang': _selectedLang,
          };
        });

        await QuranDatabase.saveProcessedVerses(
            widget.surahId, _selectedLang, processedVerses);

        final local = await QuranDatabase.getVersesByLang(
            widget.surahId, _selectedLang);

        setState(() {
          verses = local;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load verses';
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

  void _changeLang(String lang) {
    if (lang == _selectedLang) return;
    setState(() => _selectedLang = lang);
    loadVerses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        title: Text(widget.surahName,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: Text(
              _languages[_selectedLang]!['flag'] as String,
              style: const TextStyle(fontSize: 22),
            ),
            onSelected: _changeLang,
            itemBuilder: (context) => _languages.entries.map((entry) {
              final isSelected = entry.key == _selectedLang;
              return PopupMenuItem<String>(
                value: entry.key,
                child: Row(
                  children: [
                    Text(entry.value['flag'] as String,
                        style: const TextStyle(fontSize: 18)),
                    const SizedBox(width: 10),
                    Text(entry.value['label'] as String,
                        style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isSelected
                                ? const Color(0xFF1B5E20)
                                : Colors.black87)),
                    if (isSelected) ...[
                      const Spacer(),
                      const Icon(Icons.check,
                          color: Color(0xFF1B5E20), size: 16),
                    ]
                  ],
                ),
              );
            }).toList(),
          ),
          const SizedBox(width: 4),
        ],
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
                        onPressed: fetchFromApi,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E20)),
                        child: const Text('Retry',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: verses.length,
                  itemBuilder: (context, index) {
                    final verse = verses[index];
                    final translation = verse['translation'] ?? '';
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1B5E20)
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${verse['verse_number']}',
                                  style: const TextStyle(
                                      color: Color(0xFF1B5E20),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                              ),
                              Text(
                                _languages[_selectedLang]!['flag'] as String,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Arabic
                          Text(
                            verse['text_uthmani'] ?? '',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                                fontSize: 24,
                                height: 2.0,
                                color: Colors.black87),
                          ),

                          if (translation.isNotEmpty) ...[
                            const Divider(height: 20),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                translation,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black54,
                                    height: 1.6),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}