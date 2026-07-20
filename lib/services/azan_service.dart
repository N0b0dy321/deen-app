import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AzanService {
  static final AudioPlayer _player = AudioPlayer();
  static Timer? _autoStopTimer;
  static Timer? _stopCheckTimer;
  static const String _selectedAzanKey = 'selected_azan';
  static const String _stopFlagKey = 'azan_stop_flag';
  static const Duration _autoStopDuration = Duration(minutes: 3);

  static const List<Map<String, String>> azanList = [
    {
      'id': 'pashaii',
      'name': 'Majid Pashaii',
      'nameTh': 'มาจิด ปาชาอี',
      'url': 'https://archive.org/download/adhans_sunnah/Athan_Majid_Pashaii.mp3',
    },
    {
      'id': 'mishari',
      'name': 'Mishari Rashid',
      'nameTh': 'มิชารี ราชิด',
      'url': 'https://archive.org/download/adhans_sunnah/adhan_mishari.mp3',
    },
    {
      'id': 'madina_1952',
      'name': 'Madinah (Classic)',
      'nameTh': 'มาดีนะห์ (คลาสสิก)',
      'url': 'https://archive.org/download/adhans_sunnah/adhan_madina_1952.mp3',
    },
    {
      'id': 'salman',
      'name': 'Salman Al-Utaybi',
      'nameTh': 'ซัลมาน อัล-อุตัยบี',
      'url': 'https://archive.org/download/adhans_sunnah/salman_utaybi.mp3',
    },
  ];

  // ── Get/Set Selected Azan ──────────────────────────
  static Future<String> getSelectedAzanId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedAzanKey) ?? 'pashaii';
  }

  static Future<void> setSelectedAzan(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_selectedAzanKey, id);
  }

  static Map<String, String> getAzanById(String id) {
    return azanList.firstWhere(
      (a) => a['id'] == id,
      orElse: () => azanList[0],
    );
  }

  // ── Local Path ─────────────────────────────────────
  static Future<String> _getLocalPath(String id) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/azan_$id.mp3';
  }

  // ── Check Downloaded ───────────────────────────────
  static Future<bool> isDownloaded(String id) async {
    final path = await _getLocalPath(id);
    return File(path).exists();
  }

  // ── Download ───────────────────────────────────────
  static Future<void> downloadAzan({
    required String id,
    required String url,
    Function(double)? onProgress,
  }) async {
    final path = await _getLocalPath(id);
    if (await File(path).exists()) return;

    final dio = Dio();
    try {
      await dio.download(
        url, path,
        onReceiveProgress: (received, total) {
          if (total > 0 && onProgress != null) {
            onProgress(received / total);
          }
        },
      );
    } catch (e) {
      final file = File(path);
      if (await file.exists()) await file.delete();
      rethrow;
    }
  }

  static Future<void> deleteAzan(String id) async {
    final path = await _getLocalPath(id);
    final file = File(path);
    if (await file.exists()) await file.delete();
  }

  // ── Set Stop Flag (จาก background) ────────────────
  static Future<void> requestStop() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_stopFlagKey, true);
  }

  static Future<void> _clearStopFlag() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_stopFlagKey);
  }

  // ── Play ───────────────────────────────────────────
  static Future<void> playAzan({String? id}) async {
    id ??= await getSelectedAzanId();
    final path = await _getLocalPath(id);
    final file = File(path);

    if (!await file.exists()) {
      final azan = getAzanById(id);
      await downloadAzan(id: id, url: azan['url']!);
    }

    // Reset stop flag
    await _clearStopFlag();
    _autoStopTimer?.cancel();
    _stopCheckTimer?.cancel();

    await _player.stop();
    await _player.setFilePath(path);
    await _player.play();

    // Auto stop หลัง 3 นาที
    _autoStopTimer = Timer(_autoStopDuration, () async {
      await stopAzan();
    });

    // ตรวจสอบ stop flag ทุก 0.5 วินาที
    _stopCheckTimer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      final prefs = await SharedPreferences.getInstance();
      final shouldStop = prefs.getBool(_stopFlagKey) ?? false;
      if (shouldStop) {
        await stopAzan();
      }
    });

    // หยุดเมื่อเสียงจบ
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _autoStopTimer?.cancel();
        _stopCheckTimer?.cancel();
        _player.stop();
      }
    });
  }

  // ── Stop ───────────────────────────────────────────
  static Future<void> stopAzan() async {
    _autoStopTimer?.cancel();
    _autoStopTimer = null;
    _stopCheckTimer?.cancel();
    _stopCheckTimer = null;
    await _clearStopFlag();
    await _player.stop();
  }

  // ── Preview ────────────────────────────────────────
  static Future<void> previewAzan(String id) async {
    await playAzan(id: id);
  }

  // ── Dispose ────────────────────────────────────────
  static void dispose() {
    _autoStopTimer?.cancel();
    _stopCheckTimer?.cancel();
    _player.dispose();
  }
}