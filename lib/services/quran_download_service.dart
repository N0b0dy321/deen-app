import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:workmanager/workmanager.dart';
import 'quran_database.dart';

// ══════════════════════════════════════════════════════════════
// ── ดาวน์โหลดอัลกุรอาน offline แบบ background (ต่อเนื่องแม้ปิดแอป) ──
// ══════════════════════════════════════════════════════════════
//
// เดิมโค้ดดาวน์โหลดอยู่ใน AlQuranPage (widget) โดยตรง ทำให้พอออกจากหน้านั้น
// (widget dispose) การดาวน์โหลดก็หยุด ต้องเปิดแอปค้างไว้ที่หน้า Al-Quran
// ตลอดเวลาถึงจะโหลดต่อได้ — ย้ายลอจิกทั้งหมดมาไว้ที่นี่เป็น top-level
// function ให้ Android WorkManager เรียกจาก background isolate แยกต่างหาก
// (ไม่ผูกกับ widget/UI เลย) แอปจึงดาวน์โหลดต่อได้แม้ผู้ใช้ปิดแอปอยู่
//
// ข้อจำกัดที่ควรรู้: Android เป็นผู้ตัดสินใจว่าจะรัน background task นี้เมื่อไร
// (อาจหน่วงหรือพักชั่วคราวเพื่อประหยัดแบตเตอรี่ โดยเฉพาะถ้าเปิด battery
// optimization ไว้และไม่ได้เปิดแอปเลยเป็นเวลานาน) งานจึงอาจไม่โหลดรวดเร็ว
// ทันทีเสมอไป แต่จะทยอยโหลดต่อเองเรื่อยๆ จนครบในที่สุด

const String kQuranDownloadTaskName = 'quranOfflineDownload';
const String kQuranDownloadUniqueName = 'quran_offline_download_periodic';

// ── ภาษาที่แอปรองรับ พร้อม edition ของ alquran.cloud ───────────────
// ต้องตรงกับ _languages ใน SurahDetailPage และ al_quran_page.dart ทุกประการ
const Map<String, String> kQuranOfflineEditions = {
  'en': 'en.sahih',
  'th': 'th.thai',
  'ms': 'ms.basmeih',
  'id': 'id.indonesian',
  'ar': 'ar.muyassar',
  'ur': 'ur.jalandhry',
  'bn': 'bn.bengali',
};

// ── Bismillah อักขระอาหรับ (ตัดออกจากอายะห์แรก เหมือนใน SurahDetailPage) ──
final String kQuranBismillah = String.fromCharCodes([
  0x628, 0x650, 0x633, 0x652, 0x645, 0x650, 0x20,
  0x671, 0x644, 0x644, 0x651, 0x64e, 0x647, 0x650, 0x20,
  0x671, 0x644, 0x631, 0x651, 0x64e, 0x62d, 0x652, 0x645, 0x64e, 0x670, 0x646, 0x650, 0x20,
  0x671, 0x644, 0x631, 0x651, 0x64e, 0x62d, 0x650, 0x64a, 0x645, 0x650,
]);

class QuranDownloadService {
  // ── เรียกครั้งเดียวตอนแอปเริ่ม (ใน main.dart) ──────────────────
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
    // รันทุก 15 นาที (ค่าต่ำสุดที่ Android WorkManager รองรับสำหรับ
    // periodic task) — ถ้ารอบไหนโหลดครบหมดแล้วจะเช็คแล้วจบงานเร็วๆ ไม่เปลือง
    await Workmanager().registerPeriodicTask(
      kQuranDownloadUniqueName,
      kQuranDownloadTaskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.keep,
    );
    // ยิงรอบแรกทันทีด้วย (ไม่ต้องรอ 15 นาทีแรกหลังติดตั้ง/เปิดแอปครั้งแรก)
    await Workmanager().registerOneOffTask(
      '${kQuranDownloadUniqueName}_initial',
      kQuranDownloadTaskName,
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.keep,
    );
  }

  // ── ลอจิกดาวน์โหลดจริง ใช้ร่วมกันทั้งตอนรันใน background isolate
  // (ผ่าน WorkManager) และตอนเปิดหน้า Al-Quran อยู่ (โหลดเร็วขึ้นเห็น progress
  // สดๆ ในหน้าได้เลย ไม่ต้องรอ background task รอบถัดไป) ──────────────
  //
  // onProgress: callback ไว้รายงานความคืบหน้ากลับไปที่ UI (ถ้ามี) — ตอนรันจาก
  // background isolate จริงจะไม่มี UI ให้รายงาน จึงส่ง null ได้
  static Future<void> downloadAll({void Function(int done, int total)? onProgress}) async {
    final surahs = await QuranDatabase.getSurahs();
    if (surahs.isEmpty) return; // ยังไม่เคยโหลดรายชื่อซูเราะห์ ข้ามรอบนี้ไปก่อน

    final total = surahs.length * kQuranOfflineEditions.length;
    int done = 0;

    for (final entry in kQuranOfflineEditions.entries) {
      final lang = entry.key;
      final edition = entry.value;

      if (await QuranDatabase.hasAllVersesForLang(lang)) {
        done += surahs.length;
        onProgress?.call(done, total);
        continue;
      }

      for (final surah in surahs) {
        final surahId = surah['id'] as int;
        if (await QuranDatabase.hasVersesByLang(surahId, lang)) {
          done++;
          onProgress?.call(done, total);
          continue;
        }
        try {
          final url =
              'https://api.alquran.cloud/v1/surah/$surahId/editions/quran-uthmani,$edition';
          final response =
              await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
          if (response.statusCode == 200) {
            final data = json.decode(response.body);
            final List editions = data['data'];
            final arabicAyahs = editions[0]['ayahs'] as List;
            final translationAyahs = editions[1]['ayahs'] as List;
            final processedVerses = List.generate(arabicAyahs.length, (i) {
              String arabicText = arabicAyahs[i]['text'] ?? '';
              if (i == 0 && surahId != 1 && surahId != 9) {
                if (arabicText.startsWith(kQuranBismillah)) {
                  arabicText = arabicText.substring(kQuranBismillah.length).trim();
                }
              }
              return {
                'verse_number': arabicAyahs[i]['numberInSurah'],
                'text_uthmani': arabicText,
                'translation': translationAyahs[i]['text'] ?? '',
                'lang': lang,
              };
            });
            await QuranDatabase.saveProcessedVerses(surahId, lang, processedVerses);
          }
        } catch (e) {
          // หมดเน็ตหรือ API ล่มระหว่างทาง — หยุดรอบนี้ไว้ก่อน รอบถัดไป
          // (ไม่ว่าจะเป็น WorkManager เรียกซ้ำเอง หรือเปิดหน้า Al-Quran ใหม่)
          // จะเช็ค hasVersesByLang ด้านบนแล้วมาต่อจากจุดที่ค้างไว้ได้เอง
          return;
        }
        done++;
        onProgress?.call(done, total);
      }
    }
  }
}

// ── ต้องเป็น top-level function (หรือ static) เท่านั้น ───────────────
// เพราะ WorkManager รันใน background isolate แยกจาก isolate หลักของแอป
// ห้ามอ้างอิง state ของ widget ใดๆ ในนี้โดยเด็ดขาด
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == kQuranDownloadTaskName) {
      await QuranDownloadService.downloadAll();
    }
    return Future.value(true);
  });
}