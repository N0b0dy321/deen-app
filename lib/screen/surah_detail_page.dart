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
  bool isOffline = false;
  String errorMessage = '';

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

    // โหลดจาก local ก่อน
    final hasLocal = await QuranDatabase.hasVerses(widget.surahId);
    if (hasLocal) {
      final local = await QuranDatabase.getVerses(widget.surahId);
      setState(() {
        verses = local;
        isLoading = false;
        isOffline = false;
      });
      return;
    }

    // ถ้าไม่มี local ดึงจาก API
    await fetchFromApi();
  }

  Future<void> fetchFromApi() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.qurancdn.com/api/qdc/verses/by_chapter/${widget.surahId}'
          '?language=en&words=true&translations=131&per_page=300&fields=text_uthmani',
        ),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final apiVerses = data['verses'] as List;

        // บันทึกลง local
        await QuranDatabase.saveVerses(widget.surahId, apiVerses);

        // โหลดจาก local อีกครั้ง
        final local = await QuranDatabase.getVerses(widget.surahId);
        setState(() {
          verses = local;
          isLoading = false;
          isOffline = false;
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
        isOffline = true;
      });
    }
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
          if (isOffline)
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.wifi_off, color: Colors.white70, size: 20),
            ),
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
                          // Verse number
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
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Arabic text
                          Text(
                            verse['text_uthmani'] ?? '',
                            textAlign: TextAlign.right,
                            textDirection: TextDirection.rtl,
                            style: const TextStyle(
                                fontSize: 24,
                                height: 2.0,
                                color: Colors.black87),
                          ),
                          const Divider(height: 20),

                          // Translation
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              verse['translation'] ?? '',
                              textAlign: TextAlign.left,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.black54,
                                  height: 1.6),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}