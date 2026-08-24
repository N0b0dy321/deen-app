import 'package:flutter/material.dart';
import '../services/azan_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';

/// หน้าเลือกเสียงอาซาน
/// - กดปุ่ม play เพื่อฟังตัวอย่างเสียงก่อนเลือก
/// - เสียงที่ต้องโหลด (type: download) จะมีปุ่มโหลดพร้อม progress bar
/// - เลือกเสียงได้ด้วยการแตะที่การ์ด (ต้องโหลดเสร็จก่อนถึงจะเลือกได้)
class AzanSelectionPage extends StatefulWidget {
  const AzanSelectionPage({super.key});

  @override
  State<AzanSelectionPage> createState() => _AzanSelectionPageState();
}

class _AzanSelectionPageState extends State<AzanSelectionPage> {
  final _lang = LanguageService();
  final _theme = ThemeService();

  String? _selectedId;
  String? _playingId;

  // สถานะการโหลดของแต่ละเสียง: 'idle' | 'downloading' | 'downloaded'
  final Map<String, String> _downloadStatus = {};
  final Map<String, double> _downloadProgress = {};

  @override
  void initState() {
    super.initState();
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
    _init();
  }

  @override
  void dispose() {
    _lang.removeListener(() => setState(() {}));
    _theme.removeListener(() => setState(() {}));
    AzanService.stopPreview();
    super.dispose();
  }

  Future<void> _init() async {
    final selected = await AzanService.getSelectedAzanId();
    for (final azan in AzanService.azanList) {
      final id = azan['id']!;
      if (azan['type'] == 'asset') {
        _downloadStatus[id] = 'downloaded';
      } else {
        final downloaded = await AzanService.isDownloaded(id);
        _downloadStatus[id] = downloaded ? 'downloaded' : 'idle';
      }
    }
    if (mounted) setState(() => _selectedId = selected);
  }

  Future<void> _togglePlay(String id) async {
    if (_playingId == id) {
      await AzanService.stopPreview();
      setState(() => _playingId = null);
      return;
    }
    try {
      await AzanService.playPreview(id, onComplete: () {
        if (mounted) setState(() => _playingId = null);
      });
      setState(() => _playingId = id);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_lang.isThai ? 'เล่นเสียงไม่ได้: กรุณาโหลดก่อน' : 'Cannot play: please download first')),
        );
      }
    }
  }

  Future<void> _download(String id, String url) async {
    setState(() {
      _downloadStatus[id] = 'downloading';
      _downloadProgress[id] = 0;
    });
    try {
      await AzanService.downloadAzan(
        id,
        url,
        onProgress: (received, total) {
          if (total > 0 && mounted) {
            setState(() => _downloadProgress[id] = received / total);
          }
        },
      );
      if (mounted) setState(() => _downloadStatus[id] = 'downloaded');
    } catch (e) {
      if (mounted) {
        setState(() => _downloadStatus[id] = 'idle');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_lang.isThai ? 'โหลดเสียงไม่สำเร็จ' : 'Download failed')),
        );
      }
    }
  }

  Future<void> _select(String id) async {
    if (_downloadStatus[id] != 'downloaded') return;
    await AzanService.setSelectedAzan(id);
    setState(() => _selectedId = id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      appBar: AppBar(
        backgroundColor: _theme.bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: _theme.textColor),
        title: Text(
          _lang.isThai ? 'เลือกเสียงอาซาน' : 'Select Azan Sound',
          style: TextStyle(color: _theme.textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: AzanService.azanList.length,
        itemBuilder: (context, index) {
          final azan = AzanService.azanList[index];
          final id = azan['id']!;
          final name = _lang.isThai ? azan['nameTh']! : azan['name']!;
          final isDownloadType = azan['type'] == 'download';
          final status = _downloadStatus[id] ?? 'idle';
          final isSelected = _selectedId == id;
          final isPlaying = _playingId == id;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: isSelected ? const Color(0xFF1B5E20) : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(color: _theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2)),
              ],
            ),
            child: Row(
              children: [
                // ── ปุ่มเล่น/หยุดฟังตัวอย่าง ──
                GestureDetector(
                  onTap: () => _togglePlay(id),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isPlaying
                          ? const Color(0xFF1B5E20)
                          : const Color(0xFF1B5E20).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                      color: isPlaying ? Colors.white : const Color(0xFF1B5E20),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // ── ชื่อเสียง + สถานะโหลด ──
                Expanded(
                  child: GestureDetector(
                    onTap: () => _select(id),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(name,
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: _theme.textColor)),
                        const SizedBox(height: 4),
                        if (status == 'downloading')
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _downloadProgress[id],
                              minHeight: 5,
                              backgroundColor: _theme.isDark
                                  ? Colors.white12
                                  : Colors.black12,
                              color: const Color(0xFF1B5E20),
                            ),
                          )
                        else
                          Text(
                            status == 'downloaded'
                                ? (_lang.isThai ? 'พร้อมใช้งาน' : 'Ready')
                                : (_lang.isThai ? 'ยังไม่ได้โหลด' : 'Not downloaded'),
                            style: TextStyle(fontSize: 12, color: _theme.subTextColor),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // ── ปุ่มโหลด / เครื่องหมายเลือกแล้ว ──
                _buildTrailing(id, azan, status, isSelected),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrailing(
    String id,
    Map<String, String> azan,
    String status,
    bool isSelected,
  ) {
    if (status == 'downloading') {
      return SizedBox(
        width: 36,
        height: 36,
        child: CircularProgressIndicator(
          value: _downloadProgress[id],
          strokeWidth: 3,
          color: const Color(0xFF1B5E20),
        ),
      );
    }

    if (status == 'idle') {
      return GestureDetector(
        onTap: () => _download(id, azan['url']!),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20).withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.download_rounded, color: Color(0xFF1B5E20), size: 22),
        ),
      );
    }

    // downloaded
    if (isSelected) {
      return const Icon(Icons.check_circle, color: Color(0xFF1B5E20), size: 26);
    }
    return GestureDetector(
      onTap: () => _select(id),
      child: Icon(Icons.radio_button_unchecked, color: _theme.subTextColor, size: 26),
    );
  }
}