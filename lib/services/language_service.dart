import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  String _lang = 'en';
  String get lang => _lang;
  bool get isThai => _lang == 'th';

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _lang = prefs.getString('app_lang') ?? 'en';
    notifyListeners();
  }

  Future<void> setLang(String lang) async {
    _lang = lang;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_lang', lang);
    notifyListeners();
  }

  // ── Home ──
  String get nextPrayer => isThai ? 'ละหมาดถัดไป' : 'Next Prayer';
  String get alQuran => isThai ? 'อัลกุรอาน' : 'Al-Quran';
  String get qiblaFinder => isThai ? 'ค้นหากิบลัต' : 'Qibla Finder';
  String get nearbyMosques => isThai ? 'มัสยิดใกล้เคียง' : 'Nearby Mosques';
  String get duaLessons => isThai ? 'ดุอาและบทเรียน' : 'Dua & Lessons';
  String get askChatbot => isThai ? 'ถามแชทบอต' : 'Ask the Chatbot';
  String get haveQuestion => isThai ? 'มีคำถามไหม?' : 'Have a question?';
  String get welcomeToDeen => isThai ? 'ยินดีต้อนรับสู่ DEEN' : 'WELCOME TO DEEN';
  String get loading => isThai ? 'กำลังโหลด...' : 'Loading...';
  String get home => isThai ? 'หน้าหลัก' : 'Home';
  String get prayer => isThai ? 'ละหมาด' : 'Prayer';
  String get mosques => isThai ? 'มัสยิด' : 'Mosques';
  String get more => isThai ? 'เพิ่มเติม' : 'More';

  // ── Al-Quran ──
  String get searchHint => isThai ? 'ค้นหาชื่อ, ภาษาไทย, หรือเลข Surah...' : 'Search by name or number...';
  String get foundSurahs => isThai ? 'พบ' : 'Found';
  String get surahUnit => isThai ? 'ซูเราะห์' : 'surah';
  String get notFound => isThai ? 'ไม่พบซูเราะห์ที่ค้นหา' : 'No surah found';
  String get downloadingOffline => isThai ? 'กำลังดาวน์โหลดข้อมูลออฟไลน์...' : 'Downloading offline data...';
  String get retry => isThai ? 'ลองใหม่' : 'Retry';
  String get verses => isThai ? 'อายะห์' : 'verses';

  // ── Prayer Times ──
  String get prayerTimes => isThai ? 'เวลาละหมาด' : 'Prayer Times';
  String get nextPrayerLabel => isThai ? 'ละหมาดถัดไป' : 'Next Prayer';
  String get refresh => isThai ? 'รีเฟรช' : 'Refresh';
  String get couldNotLoad => isThai ? 'ไม่สามารถโหลดเวลาละหมาดได้' : 'Could not load prayer times';
  String get tryAgain => isThai ? 'ลองใหม่' : 'Try Again';

  // ── Qibla ──
  String get qiblaTitle => isThai ? 'ค้นหากิบลัต' : 'Qibla Finder';
  String get facingQibla => isThai ? 'หันหน้าไปทางกิบลัตแล้ว! 🕋' : 'Facing Qibla! 🕋';
  String get rotateQibla => isThai ? 'หมุนเพื่อหากิบลัต' : 'Rotate to find Qibla';
  String get qiblaDirection => isThai ? 'ทิศกิบลัต' : 'Qibla Direction';
  String get compass => isThai ? 'เข็มทิศ' : 'Compass';
  String get fromMakkah => isThai ? 'กม. จากมักกะห์' : 'km from Makkah';
  String get holdPhone => isThai
      ? 'ถือโทรศัพท์ให้ราบและห่างจากโลหะเพื่อความแม่นยำ'
      : 'Hold your phone flat and away from metal objects for accurate reading.';

  // ── Nearby Mosques ──
  String get nearbyMosquesTitle => isThai ? 'มัสยิดใกล้เคียง' : 'Nearby Mosques';
  String get foundMosques => isThai ? 'พบมัสยิดใกล้เคียง' : 'Found mosques nearby';
  String get gettingLocation => isThai ? 'กำลังระบุตำแหน่ง...' : 'Getting your location...';
  String get findingMosques => isThai ? 'กำลังค้นหามัสยิด...' : 'Finding nearby mosques...';
  String get navigate => isThai ? 'นำทาง' : 'Navigate';
  String get open => isThai ? 'เปิด' : 'Open';
  String get closed => isThai ? 'ปิด' : 'Closed';
  String get list => isThai ? 'รายการ' : 'List';
  String get map => isThai ? 'แผนที่' : 'Map';

  // ── Chatbot ──
  String get islamicAssistant => isThai ? 'ผู้ช่วยอิสลาม' : 'Islamic Assistant';
  String get askAnything => isThai ? 'ถามอะไรก็ได้เกี่ยวกับอิสลาม' : 'Ask me anything about Islam';
  String get assalamu => isThai ? 'อัสสะลามุอะลัยกุม! 👋' : 'Assalamu Alaikum! 👋';
  String get suggestedQuestions => isThai ? 'คำถามแนะนำ:' : 'Suggested questions:';
  String get askPlaceholder => isThai ? 'ถามเกี่ยวกับอิสลาม...' : 'Ask about Islam...';
}