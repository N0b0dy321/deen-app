import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

// ══════════════════════════════════════════════════════════════
// ── แคชไฟล์เสียงอ่านอัลกุรอานไว้ในเครื่อง เพื่อให้ฟังซ้ำแบบ offline ──
// ══════════════════════════════════════════════════════════════
//
// ขอบเขต: ดาวน์โหลด "ทีละอายะห์ตามที่ผู้ใช้เปิดฟังจริง" เท่านั้น ไม่ดาวน์
// ทั้งเล่มล่วงหน้า (เสียงอ่านทั้งอัลกุรอาน 114 ซูเราะห์ ต่อ 1 คนอ่าน มีขนาด
// รวมหลัก GB ถ้าดาวน์ทุกคนอ่านพร้อมกันจะหนักเกินไป) — พอผู้ใช้กดเล่นอายะห์
// ไหน จะเช็คแคชก่อน ถ้ามีแล้วเล่นจากไฟล์ในเครื่องทันที (เล่นได้แม้ไม่มีเน็ต)
// ถ้ายังไม่มีจะโหลดจาก URL มาเล่น พร้อมเซฟไฟล์ไว้ในเครื่องเผื่อเปิดซ้ำ
// ในอนาคต (ไม่ต้องโหลดซ้ำอีก ประหยัดทั้งเน็ตและเวลา)
//
// โครงสร้างโฟลเดอร์: <app_docs>/quran_audio/<reciterId>/<surahId>/<ayah>.mp3
// แยกตามนักอ่านด้วย เพราะผู้ใช้สลับนักอ่านได้ในแอป แต่ละคนเสียงไฟล์คนละชุด
class QuranAudioCacheService {
  static Future<Directory> _cacheDir(String reciterId, int surahId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/quran_audio/$reciterId/$surahId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  static Future<File> _cacheFile(String reciterId, int surahId, int verseNumber) async {
    final dir = await _cacheDir(reciterId, surahId);
    return File('${dir.path}/$verseNumber.mp3');
  }

  /// เช็คว่าอายะห์นี้มีไฟล์เสียงแคชไว้ในเครื่องแล้วหรือยัง
  static Future<bool> isCached(String reciterId, int surahId, int verseNumber) async {
    final file = await _cacheFile(reciterId, surahId, verseNumber);
    return file.exists();
  }

  /// คืน path ของไฟล์แคช (ใช้เล่นตรงๆ แบบ offline) ถ้ามี — null ถ้ายังไม่มี
  static Future<String?> getCachedPath(String reciterId, int surahId, int verseNumber) async {
    final file = await _cacheFile(reciterId, surahId, verseNumber);
    return await file.exists() ? file.path : null;
  }

  /// ดาวน์โหลดไฟล์เสียงจาก URL แล้วเซฟลงแคช คืน path ของไฟล์ที่เซฟแล้ว
  /// (เรียกตอนเล่นเสียงครั้งแรกของอายะห์นั้นๆ — ถ้าดาวน์ไม่สำเร็จ โยน
  /// exception กลับไปให้ตัวเรียกจัดการ เช่น แสดง error message ตามเดิม)
  static Future<String> downloadAndCache(
      String reciterId, int surahId, int verseNumber, String audioUrl) async {
    final response = await http.get(Uri.parse(audioUrl)).timeout(const Duration(seconds: 20));
    if (response.statusCode != 200) {
      throw Exception('Failed to download audio: ${response.statusCode}');
    }
    final file = await _cacheFile(reciterId, surahId, verseNumber);
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  /// ลบไฟล์เสียงแคชทั้งหมดของนักอ่านคนหนึ่ง (ใช้เผื่ออนาคตถ้าต้องการปุ่ม
  /// "ล้างแคชเสียง" ในหน้า Settings — ยังไม่ได้ผูก UI ไว้ตอนนี้)
  static Future<void> clearReciterCache(String reciterId) async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/quran_audio/$reciterId');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  /// คำนวณขนาดรวมของแคชเสียงทั้งหมด (ทุกนักอ่าน) เป็นไบต์ — ใช้เผื่อแสดง
  /// ในหน้า Settings ว่าแคชเสียงกินพื้นที่เท่าไรแล้ว
  static Future<int> getTotalCacheSize() async {
    final appDir = await getApplicationDocumentsDirectory();
    final dir = Directory('${appDir.path}/quran_audio');
    if (!await dir.exists()) return 0;
    int total = 0;
    await for (final entity in dir.list(recursive: true, followLinks: false)) {
      if (entity is File) {
        total += await entity.length();
      }
    }
    return total;
  }
}