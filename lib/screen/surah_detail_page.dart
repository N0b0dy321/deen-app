import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/quran_database.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

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
  String _selectedReciter = 'ar.alafasy';
  final _theme = ThemeService();
  final _lang = LanguageService();

  // Audio player
  final AudioPlayer _player = AudioPlayer();
  int? _playingVerseNumber;
  bool _isPlaying = false;

  final Map<String, Map<String, dynamic>> _languages = {
    'en': {'label': 'English',          'edition': 'en.sahih',     'flag': '🇬🇧'},
    'th': {'label': 'ภาษาไทย',          'edition': 'th.thai',      'flag': '🇹🇭'},
    'ms': {'label': 'Bahasa Melayu',    'edition': 'ms.basmeih',   'flag': '🇲🇾'},
    'id': {'label': 'Bahasa Indonesia', 'edition': 'id.indonesian', 'flag': '🇮🇩'},
    'ar': {'label': 'العربية',          'edition': 'ar.muyassar',  'flag': '🇸🇦'},
    'ur': {'label': 'اردو',             'edition': 'ur.jalandhry', 'flag': '🇵🇰'},
    'bn': {'label': 'বাংলা',            'edition': 'bn.bengali',   'flag': '🇧🇩'},
  };

  // รายชื่อนักอ่าน
  final List<Map<String, String>> _reciters = [
    {'id': 'ar.alafasy', 'name': 'Mishary Alafasy'},
    {'id': 'ar.abdurrahmaansudais', 'name': 'Sudais'},
    {'id': 'ar.minshawi', 'name': 'Minshawi'},
    {'id': 'ar.husary', 'name': 'Husary'},
    {'id': 'ar.muhammadayyoub', 'name': 'Muhammad Ayyoub'},
  ];

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

    // ฟัง player state - auto play next verse
    _player.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        if (mounted && _playingVerseNumber != null && _playingVerseNumber! < verses.length) {
          _playVerse(_playingVerseNumber! + 1);
        } else if (mounted) {
          setState(() {
            _isPlaying = false;
            _playingVerseNumber = null;
          });
        }
      }
    });

    _initLangThenLoad();
  }

  // ── เลือกภาษาคำแปลเริ่มต้น ──────────────────────────
  // ลำดับความสำคัญ:
  // 1. ค่าที่ user ตั้งไว้ล่วงหน้าใน Settings > อัลกุรอาน > ภาษาคำแปล (key: quran_translation_lang)
  // 2. ถ้าไม่เคยตั้งไว้ ใช้ภาษาของแอปโดยรวม (พฤติกรรมเดิม)
  Future<void> _initLangThenLoad() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTranslationLang = prefs.getString('quran_translation_lang');
    final resolvedLang = savedTranslationLang ?? _lang.lang;

    if (mounted) {
      setState(() {
        _selectedLang = _languages.containsKey(resolvedLang) ? resolvedLang : 'en';
      });
    }

    loadVerses();
  }

  @override
  void dispose() {
    _theme.removeListener(() => setState(() {}));
    _player.dispose();
    super.dispose();
  }

  // ── Play / Stop ────────────────────────────────────
  Future<void> _playVerse(int verseNumber) async {
    if (_playingVerseNumber == verseNumber && _isPlaying) {
      await _player.stop();
      setState(() { _isPlaying = false; _playingVerseNumber = null; });
      return;
    }

    setState(() { _isPlaying = true; _playingVerseNumber = verseNumber; });

    try {
      final apiUrl = 'https://api.alquran.cloud/v1/ayah/${widget.surahId}:$verseNumber/$_selectedReciter';
      final response = await http.get(Uri.parse(apiUrl)).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final audioUrl = data['data']['audio'] as String;

        await _player.stop();
        await Future.delayed(const Duration(milliseconds: 300));
        await _player.setUrl(audioUrl);
        await _player.play();
      } else {
        throw Exception('API error');
      }
    } catch (e) {
      if (mounted) {
        setState(() { _isPlaying = false; _playingVerseNumber = null; });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ไม่สามารถเล่นเสียงได้'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _stopAudio() async {
    await _player.stop();
    setState(() { _isPlaying = false; _playingVerseNumber = null; });
  }

  // ── Load Verses ────────────────────────────────────
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

  void _changeLang(String lang) async {
    if (lang == _selectedLang) return;
    _stopAudio();
    setState(() => _selectedLang = lang);
    // จำค่านี้ไว้เป็นค่าเริ่มต้นครั้งต่อไปด้วย (sync กับ Settings > อัลกุรอาน)
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('quran_translation_lang', lang);
    loadVerses();
  }

  // ── Reciter Picker ─────────────────────────────────
  void _showReciterPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('เลือกนักอ่าน / Reciter',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
            ),
            const SizedBox(height: 8),
            ..._reciters.map((reciter) {
              final isSelected = _selectedReciter == reciter['id'];
              return ListTile(
                leading: Container(
                  width: 36, height: 36,
                  decoration: BoxDecoration(
                    color: _theme.iconColor.withOpacity(0.12),
                    shape: BoxShape.circle),
                  child: Icon(Icons.record_voice_over, color: _theme.iconColor, size: 18)),
                title: Text(reciter['name']!,
                  style: TextStyle(color: _theme.textColor,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
                onTap: () {
                  setState(() => _selectedReciter = reciter['id']!);
                  _stopAudio();
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B5E20),
        title: Text(widget.surahName,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // ปุ่มเลือกนักอ่าน
          IconButton(
            icon: const Icon(Icons.record_voice_over, color: Colors.white),
            onPressed: _showReciterPicker,
            tooltip: 'เลือกนักอ่าน',
          ),
          // ปุ่มหยุดเสียง
          if (_isPlaying)
            IconButton(
              icon: const Icon(Icons.stop_circle, color: Color(0xFFFFD700)),
              onPressed: _stopAudio,
            ),
          // ปุ่มภาษา
          PopupMenuButton<String>(
            icon: Text(_languages[_selectedLang]!['flag'] as String,
              style: const TextStyle(fontSize: 22)),
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
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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
                  // แสดงนักอ่านที่เลือกอยู่
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    color: _theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFFE8F5E9),
                    child: Row(children: [
                      Icon(Icons.record_voice_over, color: _theme.iconColor, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        _reciters.firstWhere((r) => r['id'] == _selectedReciter)['name']!,
                        style: TextStyle(fontSize: 13, color: _theme.iconColor, fontWeight: FontWeight.w500)),
                      const Spacer(),
                      GestureDetector(
                        onTap: _showReciterPicker,
                        child: Text('เปลี่ยน',
                          style: TextStyle(fontSize: 12, color: _theme.iconColor,
                            decoration: TextDecoration.underline)),
                      ),
                    ]),
                  ),

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
                        final verseNumber = verse['verse_number'] as int;
                        final translation = verse['translation'] ?? '';
                        final isThisPlaying = _playingVerseNumber == verseNumber && _isPlaying;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isThisPlaying
                                ? _theme.iconColor.withOpacity(0.08)
                                : _theme.cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: isThisPlaying
                                ? Border.all(color: _theme.iconColor.withOpacity(0.4))
                                : _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
                            boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
                          ),
                          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                              // ปุ่มเสียง
                              GestureDetector(
                                onTap: () => _playVerse(verseNumber),
                                child: Container(
                                  width: 36, height: 36,
                                  decoration: BoxDecoration(
                                    color: isThisPlaying
                                        ? _theme.iconColor
                                        : _theme.iconColor.withOpacity(0.12),
                                    shape: BoxShape.circle),
                                  child: Icon(
                                    isThisPlaying ? Icons.stop : Icons.play_arrow,
                                    color: isThisPlaying ? Colors.white : _theme.iconColor,
                                    size: 20),
                                ),
                              ),

                              Row(children: [
                                // verse number badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: _theme.iconColor.withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(20)),
                                  child: Text('$verseNumber',
                                    style: TextStyle(color: _theme.iconColor,
                                      fontWeight: FontWeight.bold, fontSize: 12)),
                                ),
                                const SizedBox(width: 8),
                              ]),
                            ]),

                            const SizedBox(height: 12),
                            Text(verse['text_uthmani'] ?? '',
                              textAlign: TextAlign.right,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(fontSize: 24, height: 2.0, color: _theme.textColor)),

                            if (translation.isNotEmpty) ...[
                              Divider(height: 20,
                                color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200),
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
      // ── Player Bar ──────────────────────────────
      bottomNavigationBar: _isPlaying ? _buildPlayerBar() : null,
    );
  }

  Widget _buildPlayerBar() {
    final reciterName = _reciters.firstWhere(
      (r) => r['id'] == _selectedReciter,
      orElse: () => {'name': ''},
    )['name']!;

    return Container(
      height: 72,
      decoration: BoxDecoration(
        color: _theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFF1B5E20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, -2))],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(children: [
        // Icon
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8)),
          child: const Icon(Icons.menu_book, color: Color(0xFFFFD700), size: 20)),
        const SizedBox(width: 12),

        // ข้อมูล
        Expanded(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.surahName} · Ayah $_playingVerseNumber',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              maxLines: 1, overflow: TextOverflow.ellipsis),
            Text(reciterName,
              style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
          ])),

        // Controls
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon: const Icon(Icons.skip_previous, color: Colors.white, size: 24),
          onPressed: () {
            if (_playingVerseNumber != null && _playingVerseNumber! > 1) {
              _playVerse(_playingVerseNumber! - 1);
            }
          },
        ),
        GestureDetector(
          onTap: _stopAudio,
          child: Container(
            width: 36, height: 36,
            decoration: const BoxDecoration(color: Color(0xFFFFD700), shape: BoxShape.circle),
            child: const Icon(Icons.stop, color: Color(0xFF1B5E20), size: 20)),
        ),
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          icon: const Icon(Icons.skip_next, color: Colors.white, size: 24),
          onPressed: () {
            if (_playingVerseNumber != null && _playingVerseNumber! < verses.length) {
              _playVerse(_playingVerseNumber! + 1);
            }
          },
        ),
      ]),
    );
  }
}