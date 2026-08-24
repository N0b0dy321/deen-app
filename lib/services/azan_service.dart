import 'dart:async';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:audioplayers/audioplayers.dart';

class AzanService {
  static const String _selectedAzanKey = 'selected_azan';

  // ── Preview player (ใช้ฟังตัวอย่างเสียงก่อนเลือก) ─────
  static final AudioPlayer _previewPlayer = AudioPlayer();
  static String? _currentlyPlayingId;

  // รายชื่อเสียงอาซานทั้งหมด
  // type: 'asset' = bundle มากับแอป, 'download' = ต้องโหลดเพิ่ม
  static const List<Map<String, String>> azanList = [
    {
      'id': 'azan_makkah',
      'name': 'Makkah',
      'nameTh': 'มักกะห์',
      'type': 'asset', // ไฟล์อยู่ที่ android/app/src/main/res/raw/
    },
    {
      'id': 'azan_madinah',
      'name': 'Madinah',
      'nameTh': 'มาดีนะห์',
      'type': 'asset', // ไฟล์อยู่ที่ android/app/src/main/res/raw/
    },
    {
      'id': 'azan_aqsa',
      'name': 'Al-Aqsa',
      'nameTh': 'อัลอักซอ',
      'type': 'asset', // ไฟล์อยู่ที่ android/app/src/main/res/raw/
    },
  ];

  static Future<String> getSelectedAzanId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_selectedAzanKey) ?? 'azan_makkah';
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

  // ── Download management ───────────────────────────

  /// path สำหรับเก็บไฟล์ที่โหลดมา
  static Future<String> _localFilePath(String id) async {
    final dir = await getApplicationDocumentsDirectory();
    return '${dir.path}/$id.mp3';
  }

  /// เช็คว่าเสียงนี้โหลดไว้แล้วหรือยัง (ใช้กับ type: download เท่านั้น)
  static Future<bool> isDownloaded(String id) async {
    final path = await _localFilePath(id);
    return File(path).exists();
  }

  /// โหลดไฟล์เสียงจาก url มาเก็บไว้ในเครื่อง
  /// onProgress: (received, total) เอาไว้แสดง progress bar
  static Future<void> downloadAzan(
    String id,
    String url, {
    void Function(int received, int total)? onProgress,
  }) async {
    final path = await _localFilePath(id);
    final request = http.Request('GET', Uri.parse(url));
    final response = await http.Client().send(request);

    if (response.statusCode != 200) {
      throw Exception('Download failed: ${response.statusCode}');
    }

    final total = response.contentLength ?? 0;
    int received = 0;
    final file = File(path);
    final sink = file.openWrite();

    await response.stream.listen(
      (chunk) {
        sink.add(chunk);
        received += chunk.length;
        onProgress?.call(received, total);
      },
      onDone: () async {
        await sink.close();
      },
      onError: (e) async {
        await sink.close();
        if (await file.exists()) await file.delete();
        throw e;
      },
      cancelOnError: true,
    ).asFuture();
  }

  /// ลบไฟล์เสียงที่โหลดไว้ (คืนพื้นที่)
  static Future<void> deleteDownloadedAzan(String id) async {
    final path = await _localFilePath(id);
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// path ที่จะเอาไปเล่นเสียงจริง — คืนทั้ง asset path หรือ local file path
  /// ใช้ตอน play เสียง ให้เช็คก่อนว่าเป็น asset หรือ file
  static Future<String> getAzanPlayPath(String id) async {
    final azan = getAzanById(id);
    if (azan['type'] == 'asset') {
      return 'assets/audio/$id.mp3'; // หรือ path asset ที่ใช้จริงในโปรเจกต์
    } else {
      return _localFilePath(id);
    }
  }

  // ── Preview playback (ฟังตัวอย่างก่อนเลือก) ───────────

  static StreamSubscription? _completeSub;

  /// id ของเสียงที่กำลังเล่นอยู่ตอนนี้ (null = ไม่มีเสียงเล่นอยู่)
  static String? get currentlyPlayingId => _currentlyPlayingId;

  /// เล่นตัวอย่างเสียง id ที่ระบุ
  /// ถ้ามีเสียงอื่นเล่นอยู่จะหยุดตัวเก่าก่อนอัตโนมัติ
  /// onComplete: callback เมื่อเล่นจบเอง (ใช้อัปเดต UI ปุ่ม play/stop)
  ///
  /// โยน Exception ที่มีข้อความจริงจากตัวเล่นเสียง (ไม่ใช่ข้อความทั่วไป)
  /// เพื่อให้ debug ง่ายขึ้นถ้ายังเล่นไม่ได้อีก
  static Future<void> playPreview(String id, {void Function()? onComplete}) async {
    // เคลียร์ listener เก่าทุกครั้งก่อนเริ่มเล่นใหม่ กัน callback ซ้อนจากรอบก่อน
    await _completeSub?.cancel();
    _completeSub = null;

    try {
      await _previewPlayer.stop();
    } catch (_) {
      // ไม่มีอะไรกำลังเล่นอยู่ก็ไม่เป็นไร ข้ามได้
    }

    final azan = getAzanById(id);

    if (azan['type'] == 'download' && !(await isDownloaded(id))) {
      throw Exception('ยังไม่ได้โหลดเสียงนี้ ($id)');
    }

    _currentlyPlayingId = id;

    try {
      if (azan['type'] == 'asset') {
        // path นี้อ้างอิงจาก assets/ ตามที่ประกาศใน pubspec.yaml
        // ไฟล์จริงต้องอยู่ที่ assets/audio/<id>.mp3
        await _previewPlayer.play(AssetSource('audio/$id.mp3'));
      } else {
        final path = await _localFilePath(id);
        final exists = await File(path).exists();
        if (!exists) {
          throw Exception('ไม่พบไฟล์เสียงที่โหลดไว้: $path');
        }
        await _previewPlayer.play(DeviceFileSource(path));
      }
    } catch (e) {
      _currentlyPlayingId = null;
      // ส่งข้อความ error จริงออกไป ไม่ห่อด้วยข้อความทั่วไป
      throw Exception('เล่นเสียง "$id" ไม่สำเร็จ: $e');
    }

    _completeSub = _previewPlayer.onPlayerComplete.listen((_) {
      _currentlyPlayingId = null;
      onComplete?.call();
    });
  }

  /// หยุดฟังตัวอย่างเสียงที่กำลังเล่นอยู่
  static Future<void> stopPreview() async {
    await _completeSub?.cancel();
    _completeSub = null;
    try {
      await _previewPlayer.stop();
    } catch (_) {}
    _currentlyPlayingId = null;
  }

  /// เช็คว่า id นี้กำลังเล่นตัวอย่างอยู่หรือไม่
  static bool isPreviewPlaying(String id) => _currentlyPlayingId == id;

  /// stream ตำแหน่งปัจจุบันของเสียงที่กำลังเล่น (อัปเดตหลายครั้งต่อวินาที)
  /// ใช้ทำ progress bar ใน UI
  static Stream<Duration> get positionStream => _previewPlayer.onPositionChanged;

  /// stream ความยาวทั้งหมดของเสียงที่กำลังเล่น (ยิงครั้งเดียวตอนเริ่มเล่น)
  static Stream<Duration> get durationStream => _previewPlayer.onDurationChanged;

  // ── Stop flag via SharedPreferences ───────────────
  static Future<void> requestStop() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('azan_stop_flag', true);
  }

  static Future<void> stopAzan() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('azan_stop_flag');
  }

  static Future<void> checkAndHandleStopFlag() async {
    final prefs = await SharedPreferences.getInstance();
    final shouldStop = prefs.getBool('azan_stop_flag') ?? false;
    if (shouldStop) {
      await stopAzan();
    }
  }

  static void dispose() {
    _previewPlayer.dispose();
  }
}