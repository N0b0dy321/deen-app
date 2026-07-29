import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  String _lang = 'en';
  String get lang => _lang;

  // ── Helpers ──────────────────────────────────────
  bool get isThai => _lang == 'th';
  bool get isEnglish => _lang == 'en';
  bool get isMalay => _lang == 'ms';
  bool get isIndonesian => _lang == 'id';
  bool get isArabic => _lang == 'ar';
  bool get isUrdu => _lang == 'ur';
  bool get isBengali => _lang == 'bn';

  // ── Available Languages ───────────────────────────
  static const List<Map<String, String>> availableLanguages = [
    {'code': 'en', 'name': 'English',    'native': 'English',    'flag': '🇬🇧'},
    {'code': 'th', 'name': 'Thai',       'native': 'ภาษาไทย',    'flag': '🇹🇭'},
    {'code': 'ms', 'name': 'Malay',      'native': 'Bahasa Melayu', 'flag': '🇲🇾'},
    {'code': 'id', 'name': 'Indonesian', 'native': 'Bahasa Indonesia', 'flag': '🇮🇩'},
    {'code': 'ar', 'name': 'Arabic',     'native': 'العربية',    'flag': '🇸🇦'},
    {'code': 'ur', 'name': 'Urdu',       'native': 'اردو',       'flag': '🇵🇰'},
    {'code': 'bn', 'name': 'Bengali',    'native': 'বাংলা',      'flag': '🇧🇩'},
  ];

  // ── Init ─────────────────────────────────────────
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

  // ── Translate helper ──────────────────────────────
  String _t(Map<String, String> translations) {
    return translations[_lang] ?? translations['en'] ?? '';
  }

  // ── Home ─────────────────────────────────────────
  String get nextPrayer => _t({
    'en': 'Next Prayer', 'th': 'ละหมาดถัดไป', 'ms': 'Sembahyang Seterusnya',
    'id': 'Sholat Berikutnya', 'ar': 'الصلاة القادمة', 'ur': 'اگلی نماز', 'bn': 'পরবর্তী নামাজ',
  });

  String get alQuran => _t({
    'en': 'Al-Quran', 'th': 'อัลกุรอาน', 'ms': 'Al-Quran',
    'id': 'Al-Quran', 'ar': 'القرآن الكريم', 'ur': 'قرآن کریم', 'bn': 'আল-কুরআন',
  });

  String get qiblaFinder => _t({
    'en': 'Qibla Finder', 'th': 'ค้นหากิบลัต', 'ms': 'Pencari Kiblat',
    'id': 'Pencari Kiblat', 'ar': 'اتجاه القبلة', 'ur': 'قبلہ فائنڈر', 'bn': 'কিবলা খোঁজক',
  });

  String get nearbyMosques => _t({
    'en': 'Nearby Mosques', 'th': 'มัสยิดใกล้เคียง', 'ms': 'Masjid Berhampiran',
    'id': 'Masjid Terdekat', 'ar': 'المساجد القريبة', 'ur': 'قریبی مساجد', 'bn': 'নিকটবর্তী মসজিদ',
  });

  String get duaLessons => _t({
    'en': 'Dua & Lessons', 'th': 'ดุอาและบทเรียน', 'ms': 'Doa & Pelajaran',
    'id': 'Doa & Pelajaran', 'ar': 'الأدعية والدروس', 'ur': 'دعا اور سبق', 'bn': 'দোয়া ও পাঠ',
  });

  String get askChatbot => _t({
    'en': 'Ask the Chatbot', 'th': 'ถามแชทบอต', 'ms': 'Tanya Chatbot',
    'id': 'Tanya Chatbot', 'ar': 'اسأل المساعد', 'ur': 'چیٹ بوٹ سے پوچھیں', 'bn': 'চ্যাটবট জিজ্ঞেস করুন',
  });

  String get haveQuestion => _t({
    'en': 'Have a question?', 'th': 'มีคำถามไหม?', 'ms': 'Ada soalan?',
    'id': 'Ada pertanyaan?', 'ar': 'هل لديك سؤال؟', 'ur': 'کوئی سوال ہے؟', 'bn': 'কোনো প্রশ্ন আছে?',
  });

  String get welcomeToDeen => _t({
    'en': 'WELCOME TO DEEN', 'th': 'ยินดีต้อนรับสู่ DEEN', 'ms': 'SELAMAT DATANG KE DEEN',
    'id': 'SELAMAT DATANG DI DEEN', 'ar': 'مرحباً بك في دين', 'ur': 'DEEN میں خوش آمدید', 'bn': 'DEEN-এ স্বাগতম',
  });

  String get loading => _t({
    'en': 'Loading...', 'th': 'กำลังโหลด...', 'ms': 'Memuatkan...',
    'id': 'Memuat...', 'ar': 'جارٍ التحميل...', 'ur': 'لوڈ ہو رہا ہے...', 'bn': 'লোড হচ্ছে...',
  });

  String get home => _t({
    'en': 'Home', 'th': 'หน้าหลัก', 'ms': 'Utama',
    'id': 'Beranda', 'ar': 'الرئيسية', 'ur': 'ہوم', 'bn': 'হোম',
  });

  String get prayer => _t({
    'en': 'Prayer', 'th': 'ละหมาด', 'ms': 'Sembahyang',
    'id': 'Sholat', 'ar': 'الصلاة', 'ur': 'نماز', 'bn': 'নামাজ',
  });

  String get mosques => _t({
    'en': 'Mosques', 'th': 'มัสยิด', 'ms': 'Masjid',
    'id': 'Masjid', 'ar': 'المساجد', 'ur': 'مساجد', 'bn': 'মসজিদ',
  });

  String get more => _t({
    'en': 'More', 'th': 'เพิ่มเติม', 'ms': 'Lagi',
    'id': 'Lainnya', 'ar': 'المزيد', 'ur': 'مزید', 'bn': 'আরো',
  });

  // ── Al-Quran ──────────────────────────────────────
  String get searchHint => _t({
    'en': 'Search by name or number...', 'th': 'ค้นหาชื่อ, ภาษาไทย, หรือเลข Surah...',
    'ms': 'Cari nama atau nombor...', 'id': 'Cari nama atau nomor...',
    'ar': 'ابحث بالاسم أو الرقم...', 'ur': 'نام یا نمبر سے تلاش کریں...', 'bn': 'নাম বা নম্বর দিয়ে খুঁজুন...',
  });

  String get foundSurahs => _t({
    'en': 'Found', 'th': 'พบ', 'ms': 'Ditemui',
    'id': 'Ditemukan', 'ar': 'وجد', 'ur': 'ملی', 'bn': 'পাওয়া গেছে',
  });

  String get surahUnit => _t({
    'en': 'surah', 'th': 'ซูเราะห์', 'ms': 'surah',
    'id': 'surah', 'ar': 'سورة', 'ur': 'سورہ', 'bn': 'সূরা',
  });

  String get notFound => _t({
    'en': 'No surah found', 'th': 'ไม่พบซูเราะห์ที่ค้นหา', 'ms': 'Tiada surah ditemui',
    'id': 'Surah tidak ditemukan', 'ar': 'لم يتم العثور على السورة', 'ur': 'سورہ نہیں ملی', 'bn': 'কোনো সূরা পাওয়া যায়নি',
  });

  String get retry => _t({
    'en': 'Retry', 'th': 'ลองใหม่', 'ms': 'Cuba Lagi',
    'id': 'Coba Lagi', 'ar': 'إعادة المحاولة', 'ur': 'دوبارہ کوشش کریں', 'bn': 'আবার চেষ্টা করুন',
  });

  String get verses => _t({
    'en': 'verses', 'th': 'อายะห์', 'ms': 'ayat',
    'id': 'ayat', 'ar': 'آيات', 'ur': 'آیات', 'bn': 'আয়াত',
  });

  // ── Prayer Times ──────────────────────────────────
  String get prayerTimes => _t({
    'en': 'Prayer Times', 'th': 'เวลาละหมาด', 'ms': 'Waktu Sembahyang',
    'id': 'Waktu Sholat', 'ar': 'مواقيت الصلاة', 'ur': 'نماز کے اوقات', 'bn': 'নামাজের সময়',
  });

  String get nextPrayerLabel => _t({
    'en': 'Next Prayer', 'th': 'ละหมาดถัดไป', 'ms': 'Sembahyang Seterusnya',
    'id': 'Sholat Berikutnya', 'ar': 'الصلاة القادمة', 'ur': 'اگلی نماز', 'bn': 'পরবর্তী নামাজ',
  });

  String get refresh => _t({
    'en': 'Refresh', 'th': 'รีเฟรช', 'ms': 'Muat Semula',
    'id': 'Muat Ulang', 'ar': 'تحديث', 'ur': 'ریفریش', 'bn': 'রিফ্রেশ',
  });

  String get couldNotLoad => _t({
    'en': 'Could not load prayer times', 'th': 'ไม่สามารถโหลดเวลาละหมาดได้',
    'ms': 'Tidak dapat memuatkan waktu sembahyang', 'id': 'Tidak dapat memuat waktu sholat',
    'ar': 'تعذر تحميل مواقيت الصلاة', 'ur': 'نماز کے اوقات لوڈ نہیں ہو سکے', 'bn': 'নামাজের সময় লোড করা যায়নি',
  });

  String get tryAgain => _t({
    'en': 'Try Again', 'th': 'ลองใหม่', 'ms': 'Cuba Lagi',
    'id': 'Coba Lagi', 'ar': 'حاول مرة أخرى', 'ur': 'دوبارہ کوشش کریں', 'bn': 'আবার চেষ্টা করুন',
  });

  // ── Qibla ─────────────────────────────────────────
  String get qiblaTitle => _t({
    'en': 'Qibla Finder', 'th': 'ค้นหากิบลัต', 'ms': 'Pencari Kiblat',
    'id': 'Pencari Kiblat', 'ar': 'اتجاه القبلة', 'ur': 'قبلہ فائنڈر', 'bn': 'কিবলা খোঁজক',
  });

  String get facingQibla => _t({
    'en': 'Facing Qibla! 🕋', 'th': 'หันหน้าไปทางกิบลัตแล้ว! 🕋', 'ms': 'Menghadap Kiblat! 🕋',
    'id': 'Menghadap Kiblat! 🕋', 'ar': 'أنت تواجه القبلة! 🕋', 'ur': 'قبلہ کی طرف! 🕋', 'bn': 'কিবলামুখী! 🕋',
  });

  String get rotateQibla => _t({
    'en': 'Rotate to find Qibla', 'th': 'หมุนเพื่อหากิบลัต', 'ms': 'Putar untuk cari Kiblat',
    'id': 'Putar untuk menemukan Kiblat', 'ar': 'دوّر للعثور على القبلة', 'ur': 'قبلہ ڈھونڈنے کے لیے گھمائیں', 'bn': 'কিবলা খুঁজতে ঘোরান',
  });

  String get qiblaDirection => _t({
    'en': 'Qibla Direction', 'th': 'ทิศกิบลัต', 'ms': 'Arah Kiblat',
    'id': 'Arah Kiblat', 'ar': 'اتجاه القبلة', 'ur': 'قبلہ کی سمت', 'bn': 'কিবলার দিক',
  });

  String get compass => _t({
    'en': 'Compass', 'th': 'เข็มทิศ', 'ms': 'Kompas',
    'id': 'Kompas', 'ar': 'البوصلة', 'ur': 'کمپاس', 'bn': 'কম্পাস',
  });

  String get fromMakkah => _t({
    'en': 'km from Makkah', 'th': 'กม. จากมักกะห์', 'ms': 'km dari Makkah',
    'id': 'km dari Makkah', 'ar': 'كم من مكة', 'ur': 'مکہ سے کلومیٹر', 'bn': 'মক্কা থেকে কিমি',
  });

  String get holdPhone => _t({
    'en': 'Hold your phone flat and away from metal objects for accurate reading.',
    'th': 'ถือโทรศัพท์ให้ราบและห่างจากโลหะเพื่อความแม่นยำ',
    'ms': 'Pegang telefon rata dan jauh dari logam untuk bacaan tepat.',
    'id': 'Pegang ponsel mendatar dan jauh dari logam untuk pembacaan akurat.',
    'ar': 'أمسك هاتفك بشكل مستوٍ وبعيداً عن المعادن للحصول على قراءة دقيقة.',
    'ur': 'درست پڑھنے کے لیے فون کو سیدھا رکھیں اور دھات سے دور رکھیں۔',
    'bn': 'সঠিক পড়ার জন্য ফোন সমতলভাবে ধরুন এবং ধাতু থেকে দূরে রাখুন।',
  });

  // ── Nearby Mosques ────────────────────────────────
  String get nearbyMosquesTitle => _t({
    'en': 'Nearby Mosques', 'th': 'มัสยิดใกล้เคียง', 'ms': 'Masjid Berhampiran',
    'id': 'Masjid Terdekat', 'ar': 'المساجد القريبة', 'ur': 'قریبی مساجد', 'bn': 'নিকটবর্তী মসজিদ',
  });

  String get foundMosques => _t({
    'en': 'Found mosques nearby', 'th': 'พบมัสยิดใกล้เคียง', 'ms': 'Masjid ditemui berhampiran',
    'id': 'Masjid ditemukan terdekat', 'ar': 'تم العثور على مساجد قريبة', 'ur': 'قریبی مساجد ملیں', 'bn': 'কাছাকাছি মসজিদ পাওয়া গেছে',
  });

  String get gettingLocation => _t({
    'en': 'Getting your location...', 'th': 'กำลังระบุตำแหน่ง...', 'ms': 'Mendapatkan lokasi anda...',
    'id': 'Mendapatkan lokasi Anda...', 'ar': 'جارٍ تحديد موقعك...', 'ur': 'آپ کا مقام مل رہا ہے...', 'bn': 'আপনার অবস্থান পাওয়া হচ্ছে...',
  });

  String get findingMosques => _t({
    'en': 'Finding nearby mosques...', 'th': 'กำลังค้นหามัสยิด...', 'ms': 'Mencari masjid berhampiran...',
    'id': 'Mencari masjid terdekat...', 'ar': 'جارٍ البحث عن المساجد القريبة...', 'ur': 'قریبی مساجد ڈھونڈی جا رہی ہیں...', 'bn': 'কাছের মসজিদ খোঁজা হচ্ছে...',
  });

  String get navigate => _t({
    'en': 'Navigate', 'th': 'นำทาง', 'ms': 'Navigasi',
    'id': 'Navigasi', 'ar': 'التنقل', 'ur': 'نیویگیٹ', 'bn': 'নেভিগেট',
  });

  String get open => _t({
    'en': 'Open', 'th': 'เปิด', 'ms': 'Buka',
    'id': 'Buka', 'ar': 'مفتوح', 'ur': 'کھلا', 'bn': 'খোলা',
  });

  String get closed => _t({
    'en': 'Closed', 'th': 'ปิด', 'ms': 'Tutup',
    'id': 'Tutup', 'ar': 'مغلق', 'ur': 'بند', 'bn': 'বন্ধ',
  });

  String get list => _t({
    'en': 'List', 'th': 'รายการ', 'ms': 'Senarai',
    'id': 'Daftar', 'ar': 'القائمة', 'ur': 'فہرست', 'bn': 'তালিকা',
  });

  String get map => _t({
    'en': 'Map', 'th': 'แผนที่', 'ms': 'Peta',
    'id': 'Peta', 'ar': 'الخريطة', 'ur': 'نقشہ', 'bn': 'মানচিত্র',
  });

  // ── Chatbot ───────────────────────────────────────
  String get islamicAssistant => _t({
    'en': 'Islamic Assistant', 'th': 'ผู้ช่วยอิสลาม', 'ms': 'Pembantu Islam',
    'id': 'Asisten Islam', 'ar': 'المساعد الإسلامي', 'ur': 'اسلامی معاون', 'bn': 'ইসলামিক সহকারী',
  });

  String get askAnything => _t({
    'en': 'Ask me anything about Islam', 'th': 'ถามอะไรก็ได้เกี่ยวกับอิสลาม',
    'ms': 'Tanya apa sahaja tentang Islam', 'id': 'Tanya apa saja tentang Islam',
    'ar': 'اسألني أي شيء عن الإسلام', 'ur': 'اسلام کے بارے میں کچھ بھی پوچھیں', 'bn': 'ইসলাম সম্পর্কে যেকোনো কিছু জিজ্ঞেস করুন',
  });

  String get assalamu => _t({
    'en': 'Assalamu Alaikum! 👋', 'th': 'อัสสะลามุอะลัยกุม! 👋', 'ms': 'Assalamualaikum! 👋',
    'id': 'Assalamualaikum! 👋', 'ar': 'السلام عليكم! 👋', 'ur': 'السلام علیکم! 👋', 'bn': 'আস-সালামু আলাইকুম! 👋',
  });

  String get suggestedQuestions => _t({
    'en': 'Suggested questions:', 'th': 'คำถามแนะนำ:', 'ms': 'Soalan cadangan:',
    'id': 'Pertanyaan yang disarankan:', 'ar': 'أسئلة مقترحة:', 'ur': 'تجویز کردہ سوالات:', 'bn': 'প্রস্তাবিত প্রশ্ন:',
  });

  String get askPlaceholder => _t({
    'en': 'Ask about Islam...', 'th': 'ถามเกี่ยวกับอิสลาม...', 'ms': 'Tanya tentang Islam...',
    'id': 'Tanya tentang Islam...', 'ar': 'اسأل عن الإسلام...', 'ur': 'اسلام کے بارے میں پوچھیں...', 'bn': 'ইসলাম সম্পর্কে জিজ্ঞেস করুন...',
  });

  String get downloadingOffline => _t({
    'en': 'Downloading offline data...', 'th': 'กำลังดาวน์โหลดข้อมูลออฟไลน์...',
    'ms': 'Memuat turun data luar talian...', 'id': 'Mengunduh data offline...',
    'ar': 'جارٍ تنزيل البيانات دون اتصال...', 'ur': 'آف لائن ڈیٹا ڈاؤن لوڈ ہو رہا ہے...', 'bn': 'অফলাইন ডেটা ডাউনলোড হচ্ছে...',
  });
}