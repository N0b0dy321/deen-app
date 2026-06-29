import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../services/quran_database.dart';
import '../services/theme_service.dart';

class SurahDetailPage extends StatefulWidget {
  final int surahId;
  final String surahName;
  const SurahDetailPage({super.key, required this.surahId, required this.surahName});
  @override
  State<SurahDetailPage> createState() => _SurahDetailPageState();
}

class _SurahDetailPageState extends State<SurahDetailPage> {
  List<Map<String, dynamic>> verses = [];
  bool isLoading = true;
  String errorMessage = '';
  String _selectedLang = 'en';
  final _theme = ThemeService();

  final Map<String, Map<String, dynamic>> _languages = {
    'en': {'label': 'English', 'edition': 'en.sahih', 'flag': '🇬🇧'},
    'th': {'label': 'ภาษาไทย', 'edition': 'th.thai', 'flag': '🇹🇭'},
  };

  static final String _bismillah = String.fromCharCodes([
    0x628,0x650,0x633,0x652,0x645,0x650,0x20,
    0x671,0x644,0x644,0x651,0x64e,0x647,0x650,0x20,
    0x671,0x644,0x631,0x651,0x64e,0x62d,0x652,0x645,0x64e,0x670,0x646,0x650,0x20,
    0x671,0x644,0x631,0x651,0x64e,0x62d,0x650,0x64a,0x645,0x650,
  ]);

  @override
  void initState() {
    super.initState();
    _theme.addListener(() => setState(() {}));
    loadVerses();
  }

  @override
  void dispose() {
    _theme.removeListener(() => setState(() {}));
    super.dispose();
  }

  Future<void> loadVerses() async {
    setState(() { isLoading = true; errorMessage = ''; });
    final hasLocal = await QuranDatabase.hasVersesByLang(widget.surahId, _selectedLang);
    if (hasLocal) {
      final local = await QuranDatabase.getVersesByLang(widget.surahId, _selectedLang);
      final hasTranslation = local.isNotEmpty && (local[0]['translation'] ?? '').toString().isNotEmpty;
      if (hasTranslation) {
        if (widget.surahId != 1 && widget.surahId != 9) {
          final firstVerse = local[0]['text_uthmani'] ?? '';
          if (firstVerse.contains(_bismillah)) {
            await QuranDatabase.deleteVersesByLang(widget.surahId, _selectedLang);
            await fetchFromApi();
            return;
          }
        }
        setState(() { verses = local; isLoading = false; });
        return;
      }
      await QuranDatabase.deleteVersesByLang(widget.surahId, _selectedLang);
    }
    await fetchFromApi();
  }

  Future<void> fetchFromApi() async {
    try {
      final edition = _languages[_selectedLang]!['edition'] as String;
      final url = 'https://api.alquran.cloud/v1/surah/${widget.surahId}/editions/quran-uthmani,$edition';
      final response = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List editions = data['data'];
        final arabicAyahs = editions[0]['ayahs'] as List;
        final translationAyahs = editions[1]['ayahs'] as List;
        final processedVerses = List.generate(arabicAyahs.length, (i) {
          String arabicText = arabicAyahs[i]['text'] ?? '';
          if (i == 0 && widget.surahId != 1 && widget.surahId != 9) {
            if (arabicText.startsWith(_bismillah)) {
              arabicText = arabicText.substring(_bismillah.length).trim();
            }
          }
          return {
            'verse_number': arabicAyahs[i]['numberInSurah'],
            'text_uthmani': arabicText,
            'translation': translationAyahs[i]['text'] ?? '',
            'lang': _selectedLang,
          };
        });
        await QuranDatabase.saveProcessedVerses(widget.surahId, _selectedLang, processedVerses);
        final local = await QuranDatabase.getVersesByLang(widget.surahId, _selectedLang);
        setState(() { verses = local; isLoading = false; });
      } else {
        setState(() { errorMessage = 'Failed to load verses'; isLoading = false; });
      }
    } catch (e) {
      setState(() { errorMessage = 'No internet connection'; isLoading = false; });
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
      backgroundColor: _theme.bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        title: Text(widget.surahName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: Text(_languages[_selectedLang]!['flag'] as String, style: const TextStyle(fontSize: 22)),
            color: _theme.cardColor,
            onSelected: _changeLang,
            itemBuilder: (context) => _languages.entries.map((entry) {
              final isSelected = entry.key == _selectedLang;
              return PopupMenuItem<String>(
                value: entry.key,
                child: Row(children: [
                  Text(entry.value['flag'] as String, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 10),
                  Text(entry.value['label'] as String,
                      style: TextStyle(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? _theme.iconColor : _theme.textColor)),
                  if (isSelected) ...[const Spacer(), Icon(Icons.check, color: _theme.iconColor, size: 16)],
                ]),
              );
            }).toList(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator(color: _theme.iconColor))
          : errorMessage.isNotEmpty
              ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(Icons.wifi_off, size: 64, color: _theme.subTextColor),
                  const SizedBox(height: 16),
                  Text(errorMessage, style: TextStyle(color: _theme.subTextColor)),
                  const SizedBox(height: 16),
                  ElevatedButton(onPressed: fetchFromApi,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
                    child: const Text('Retry', style: TextStyle(color: Colors.white))),
                ]))
              : Column(children: [
                  if (widget.surahId != 1 && widget.surahId != 9)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                      child: _theme.isDark
                          ? ColorFiltered(
                              colorFilter: const ColorFilter.mode(Color(0xFF2ECC71), BlendMode.srcIn),
                              child: Image.asset('image/Bismillah.png', height: 100, fit: BoxFit.contain))
                          : Image.asset('image/Bismillah.png', height: 150, fit: BoxFit.contain),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: verses.length,
                      itemBuilder: (context, index) {
                        final verse = verses[index];
                        final translation = verse['translation'] ?? '';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _theme.cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
                            boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _theme.iconColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20)),
                                child: Text('${verse['verse_number']}',
                                    style: TextStyle(color: _theme.iconColor, fontWeight: FontWeight.bold, fontSize: 12)),
                              ),
                              Text(_languages[_selectedLang]!['flag'] as String, style: const TextStyle(fontSize: 14)),
                            ]),
                            const SizedBox(height: 12),
                            Text(verse['text_uthmani'] ?? '',
                                textAlign: TextAlign.right,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(fontSize: 24, height: 2.0, color: _theme.textColor)),
                            if (translation.isNotEmpty) ...[
                              Divider(height: 20, color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200),
                              Align(alignment: Alignment.centerLeft,
                                child: Text(translation, textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 13, color: _theme.subTextColor, height: 1.6))),
                            ],
                          ]),
                        );
                      },
                    ),
                  ),
                ]),
    );
  }
}