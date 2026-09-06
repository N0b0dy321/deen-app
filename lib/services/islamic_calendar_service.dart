import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IslamicCalendarService {
  static const _baseUrl = 'https://api.aladhan.com/v1';
  static const _cachePrefix = 'hijri_calendar_';

  // Safe cast helper
  static Map<String, dynamic> _safeMap(dynamic d) {
    if (d is Map<String, dynamic>) return d;
    if (d is Map) return d.map((k, v) => MapEntry(k.toString(), v));
    return {};
  }

  static List<Map<String, dynamic>> _parseCalendar(List<dynamic> data) {
    return data.map((e) => _safeMap(e)).toList();
  }

  // ดึงปฏิทินฮิจเราะห์ทั้งเดือน
  static Future<List<Map<String, dynamic>>?> getHijriCalendar(int month, int year) async {
    print('=== IslamicCalendarService.getHijriCalendar($month, $year) called ===');
    final cacheKey = '$_cachePrefix${year}_$month';
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(cacheKey);

    if (cached != null) {
      try {
        final data = json.decode(cached) as List;
        // สำคัญ: ปฏิทินจริงต้องมีอย่างน้อย ๆ 28 วัน ถ้า cache เป็น list ว่าง
        // หรือสั้นผิดปกติ (เช่น จากความล้มเหลวเก่าที่เคย cache ค่าว่างไว้ผิดๆ)
        // ต้องไม่เชื่อ cache นี้ ต้องลบทิ้งแล้วไปดึงใหม่จาก network แทน
        // ไม่งั้นจะติดอยู่กับ cache เสียตลอดไปแบบไม่มีวันได้ข้อมูลจริง
        if (data.length >= 28) {
          print('=== IslamicCalendarService: ใช้ cache (${data.length} วัน) ===');
          return _parseCalendar(data);
        } else {
          print('=== IslamicCalendarService: cache สั้นผิดปกติ (${data.length} รายการ) ทิ้งแล้วโหลดใหม่ ===');
          await prefs.remove(cacheKey);
        }
      } catch (e) {
        // Cache corrupt, delete and re-fetch
        print('=== IslamicCalendarService: cache เสีย ($e) ทิ้งแล้วโหลดใหม่ ===');
        await prefs.remove(cacheKey);
      }
    }

    try {
      final url = '$_baseUrl/gToHCalendar/$month/$year';
      print('=== IslamicCalendarService: GET $url ===');
      final res = await http.get(
        Uri.parse(url),
      ).timeout(const Duration(seconds: 15));

      print('=== IslamicCalendarService: HTTP status = ${res.statusCode} ===');

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['code'] == 200) {
          final raw = data['data'] as List;
          final calendar = _parseCalendar(raw);
          await prefs.setString(cacheKey, json.encode(raw));
          return calendar;
        } else {
          // API ตอบ 200 แต่ตัว payload บอกว่าไม่สำเร็จ (เช่น parameter ผิด)
          print('=== IslamicCalendarService: API code ไม่ใช่ 200 -> ${data['code']}, status: ${data['status']} ===');
        }
      } else {
        // HTTP status ไม่ใช่ 200 เลย (เช่น 404, 429 rate limit, 500)
        print('=== IslamicCalendarService: HTTP ไม่ใช่ 200, body: ${res.body} ===');
      }
    } catch (e) {
      print('Islamic calendar error: $e');
    }
    return null;
  }

  // ดึงปฏิทินล่วงหน้าและ cache ไว้ (parallel)
  // จำนวนเดือน: เดือนปัจจุบัน + ล่วงหน้าอีก 5 เดือน = รวม 6 เดือน
  static const int prefetchMonthCount = 6;

  static Future<void> prefetchCalendars() async {
    final now = DateTime.now();
    // Run all months in parallel
    await Future.wait([
      for (int i = 0; i < prefetchMonthCount; i++)
        getHijriCalendar(
          DateTime(now.year, now.month + i).month,
          DateTime(now.year, now.month + i).year,
        ),
    ]);
  }

  // ══════════════════════════════════════════════════════════════
  // ── ปฏิทินแบบอิงเดือนฮิจเราะห์เป็นหลัก (สลับมุมมองได้จากปุ่ม "ฮิจเราะห์"
  // ในหน้าปฏิทินเต็ม) — ต่างจาก getHijriCalendar ที่อิงเดือนเกรกอเรียนเป็นหลัก
  // ตัวนี้จะได้ข้อมูลครบ "1 เดือนฮิจเราะห์เป๊ะๆ" ไม่มีเดือนอื่นคาบเกี่ยวปนมาเลย
  // แก้ปัญหา user งงเรื่องเดือนคาบเกี่ยวได้ตรงจุดที่สุด ──
  // ══════════════════════════════════════════════════════════════

  static Future<List<Map<String, dynamic>>?> getHijriToGregorianCalendar(int hijriMonth, int hijriYear) async {
    final cacheKey = '${_cachePrefix}h2g_${hijriYear}_$hijriMonth';
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(cacheKey);

    if (cached != null) {
      try {
        final data = json.decode(cached) as List;
        // เดือนฮิจเราะห์สั้นสุด 29 วัน กันเคส cache เสีย/ค่าว่างแบบเดียวกับ getHijriCalendar
        if (data.length >= 29) {
          return _parseCalendar(data);
        } else {
          await prefs.remove(cacheKey);
        }
      } catch (e) {
        await prefs.remove(cacheKey);
      }
    }

    try {
      final url = '$_baseUrl/hToGCalendar/$hijriMonth/$hijriYear';
      final res = await http.get(Uri.parse(url)).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['code'] == 200) {
          final raw = data['data'] as List;
          final calendar = _parseCalendar(raw);
          await prefs.setString(cacheKey, json.encode(raw));
          return calendar;
        }
      }
    } catch (e) {
      print('Hijri-to-Gregorian calendar error: $e');
    }
    return null;
  }

  // ชื่อเดือนฮิจเราะห์ 1-12 เรียงตามลำดับปฏิทิน ใช้แปลงจากเลขเดือน (1-12) ที่ผู้ใช้
  // กด prev/next ในมุมมองฮิจเราะห์ ไปเป็นชื่อเดือนที่แปลแล้วได้ทันที
  // โดยไม่ต้องรอข้อมูลจาก API โหลดเสร็จก่อน (โชว์หัวข้อได้ทันทีตอนสลับเดือน)
  static const List<String> _hijriMonthEnByNumber = [
    'Muharram', 'Safar', 'Rabi al-awwal', 'Rabi al-thani', 'Jumada al-ula', 'Jumada al-akhirah',
    'Rajab', "Sha'ban", 'Ramadan', 'Shawwal', "Dhu al-Qa'dah", 'Dhu al-Hijjah',
  ];

  static String getHijriMonthNameByNumber(int number, String lang) {
    if (number < 1 || number > 12) return '';
    return getHijriMonthName(_hijriMonthEnByNumber[number - 1], lang);
  }

  // แปลงวันที่ Gregorian เป็น Hijri
  static Future<Map<String, dynamic>?> getTodayHijri() async {
    final now = DateTime.now();
    final calendar = await getHijriCalendar(now.month, now.year);
    if (calendar == null) return null;

    try {
      final today = calendar.firstWhere(
        (d) {
          final greg = _safeMap(d['gregorian']);
          // เทียบเป็นตัวเลขแทนสตริง กัน mismatch จาก zero-padding
          // (Aladhan มักตอบวันที่แบบ "01" แต่ now.day.toString() ได้แค่ "1")
          final gregDay = int.tryParse(greg['day']?.toString() ?? '');
          return gregDay == now.day;
        },
        orElse: () => {},
      );
      return today.isEmpty ? null : today;
    } catch (e) {
      print('getTodayHijri error: $e');
      return null;
    }
  }

  // ชื่อเดือนฮิจเราะห์ภาษาต่างๆ
  static String getHijriMonthName(String month, String lang) {
    final months = {
      'Muharram':   {'th': 'มุฮัรรอม',  'ms': 'Muharram',  'id': 'Muharram',  'ar': 'محرم',     'ur': 'محرم',    'bn': 'মুহাররম'},
      'Safar':      {'th': 'ซอฟัร',     'ms': 'Safar',     'id': 'Safar',     'ar': 'صفر',      'ur': 'صفر',     'bn': 'সফর'},
      'Rabi al-awwal': {'th': 'รอบีอุลเอาวัล', 'ms': "Rabi' al-Awwal", 'id': "Rabi'ul Awal", 'ar': 'ربيع الأول', 'ur': 'ربیع الاول', 'bn': 'রবিউল আউয়াল'},
      'Rabi al-thani': {'th': 'รอบีอุษษานี', 'ms': "Rabi' al-Akhir", 'id': "Rabi'ul Akhir", 'ar': 'ربيع الثاني', 'ur': 'ربیع الثانی', 'bn': 'রবিউস সানি'},
      'Jumada al-ula': {'th': 'ญุมาดัลอูลา', 'ms': 'Jumada al-Ula', 'id': 'Jumadil Ula', 'ar': 'جمادى الأولى', 'ur': 'جمادی الاول', 'bn': 'জুমাদাল উলা'},
      'Jumada al-akhirah': {'th': 'ญุมาดัลอาคิเราะห์', 'ms': 'Jumada al-Akhirah', 'id': 'Jumadil Akhir', 'ar': 'جمادى الآخرة', 'ur': 'جمادی الثانی', 'bn': 'জুমাদাস সানি'},
      'Rajab':      {'th': 'รอญับ',     'ms': 'Rejab',     'id': 'Rajab',     'ar': 'رجب',      'ur': 'رجب',     'bn': 'রজব'},
      "Sha'ban":    {'th': 'ชะอ์บาน',   'ms': "Sha'ban",   'id': "Sya'ban",   'ar': 'شعبان',    'ur': 'شعبان',   'bn': 'শাবান'},
      'Ramadan':    {'th': 'รอมฎอน',    'ms': 'Ramadan',   'id': 'Ramadhan',  'ar': 'رمضان',    'ur': 'رمضان',   'bn': 'রমজান'},
      'Shawwal':    {'th': 'เชาวาล',    'ms': 'Syawal',    'id': 'Syawal',    'ar': 'شوال',     'ur': 'شوال',    'bn': 'শাওয়াল'},
      "Dhu al-Qa'dah": {'th': 'ซุลเกาอ์ดะห์', 'ms': "Zulkaedah", 'id': "Dzul Qa'dah", 'ar': 'ذو القعدة', 'ur': 'ذوالقعدہ', 'bn': 'জিলকদ'},
      'Dhu al-Hijjah': {'th': 'ซุลฮิจญะห์', 'ms': 'Zulhijjah', 'id': 'Dzul Hijjah', 'ar': 'ذو الحجة', 'ur': 'ذوالحجہ', 'bn': 'জিলহজ'},
    };

    for (final entry in months.entries) {
      if (month.toLowerCase().contains(entry.key.toLowerCase()) ||
          entry.key.toLowerCase().contains(month.toLowerCase())) {
        return months[entry.key]![lang] ?? months[entry.key]!['en'] ?? month;
      }
    }
    return month;
  }

  // วันสำคัญอิสลาม
  static String? getIslamicHoliday(List<dynamic> holidays, String lang) {
    if (holidays.isEmpty) return null;
    // holidays can be List<String> or List<Map>
    String name = '';
    final holiday = holidays.first;
    if (holiday is String) {
      name = holiday;
    } else if (holiday is Map) {
      name = holiday['name']?.toString() ?? '';
    } else {
      name = holiday.toString();
    }
    if (name.isEmpty) return null;
    return _translateHolidayName(name, lang);
  }

  static String _translateHolidayName(String name, String lang) {
    for (final entry in _holidayTranslations.entries) {
      if (name.contains(entry.key)) {
        return _holidayTranslations[entry.key]![lang] ?? name;
      }
    }
    return name;
  }

  static const Map<String, Map<String, String>> _holidayTranslations = {
    // ── ปีใหม่ฮิจเราะห์ (1 มุฮัรรอม) ──
    "New Year's Day": {'th': 'วันขึ้นปีใหม่ฮิจเราะห์', 'ms': "Tahun Baru Islam", 'id': 'Tahun Baru Hijriah', 'ar': 'رأس السنة الهجرية', 'ur': 'اسلامی نیا سال', 'bn': 'ইসলামিক নববর্ষ'},
    'Islamic New Year': {'th': 'วันขึ้นปีใหม่ฮิจเราะห์', 'ms': "Tahun Baru Islam", 'id': 'Tahun Baru Hijriah', 'ar': 'رأس السنة الهجرية', 'ur': 'اسلامی نیا سال', 'bn': 'ইসলামিক নববর্ষ'},
    // ── วันอาชูรอ (10 มุฮัรรอม) ──
    'Ashura': {'th': 'วันอาชูรอ', 'ms': 'Hari Asyura', 'id': 'Hari Asyura', 'ar': 'يوم عاشوراء', 'ur': 'یوم عاشورہ', 'bn': 'আশুরা'},
    // ── วันเมาลิดนบี (12 รอบีอุลเอาวัล) ──
    'Mawlid al-Nabi': {'th': 'วันเมาลิดนบี', 'ms': 'Maulidur Rasul', 'id': 'Maulid Nabi', 'ar': 'المولد النبوي', 'ur': 'عید میلاد النبی', 'bn': 'মিলাদুন্নবী'},
    'Mawlid': {'th': 'วันเมาลิดนบี', 'ms': 'Maulidur Rasul', 'id': 'Maulid Nabi', 'ar': 'المولد النبوي', 'ur': 'عید میلاد النبی', 'bn': 'মিলাদুন্নবী'},
    // ── วันอิสรออ์และมิอ์รอจ (27 รอญับ) ──
    'Isra': {'th': 'วันอิสรออ์และมิอ์รอจ', 'ms': "Isra' Mikraj", 'id': "Isra' Mi'raj", 'ar': 'الإسراء والمعراج', 'ur': 'شب معراج', 'bn': 'ইসরা ও মিরাজ'},
    // ── วันนิสฟูชะอ์บาน (15 ชะอ์บาน) — รู้จักกันในชื่อ Shab-e-Barat ในอูรดู/เบงกาลี ──
    'Nusfu Sha': {'th': 'วันนิสฟูชะอ์บาน', 'ms': 'Nisfu Syaaban', 'id': "Nisfu Sya'ban", 'ar': 'ليلة النصف من شعبان', 'ur': 'شب برأت', 'bn': 'শবে বরাত'},
    'Nisfu Sha': {'th': 'วันนิสฟูชะอ์บาน', 'ms': 'Nisfu Syaaban', 'id': "Nisfu Sya'ban", 'ar': 'ليلة النصف من شعبان', 'ur': 'شب برأت', 'bn': 'শবে বরাত'},
    'Mid-Sha': {'th': 'วันนิสฟูชะอ์บาน', 'ms': 'Nisfu Syaaban', 'id': "Nisfu Sya'ban", 'ar': 'ليلة النصف من شعبان', 'ur': 'شب برأت', 'bn': 'শবে বরাত'},
    // ── วันแรกของเดือนรอมฎอน (1 รอมฎอน) ──
    '1st day of Ramadan': {'th': 'วันแรกของเดือนรอมฎอน', 'ms': 'Hari Pertama Ramadan', 'id': 'Hari Pertama Ramadhan', 'ar': 'أول أيام رمضان', 'ur': 'رمضان کا پہلا دن', 'bn': 'রমজানের প্রথম দিন'},
    // ── วันนุซุลอัลกุรอาน (17 รอมฎอน) ──
    'Nuzul Al-Quran': {'th': 'วันนุซุลอัลกุรอาน', 'ms': 'Nuzul Al-Quran', 'id': "Nuzulul Qur'an", 'ar': 'نزول القرآن', 'ur': 'نزول قرآن', 'bn': 'নুযূলুল কুরআন'},
    'Nuzul Al Quran': {'th': 'วันนุซุลอัลกุรอาน', 'ms': 'Nuzul Al-Quran', 'id': "Nuzulul Qur'an", 'ar': 'نزول القرآن', 'ur': 'نزول قرآن', 'bn': 'নুযূলুল কুরআন'},
    // ── คืนลัยลาตุลก็อดร์ (10 คืนคี่สุดท้ายของรอมฎอน) ──
    'Laylat al-Qadr': {'th': 'คืนลัยลาตุลก็อดร์', 'ms': 'Lailatul Qadar', 'id': 'Lailatul Qadar', 'ar': 'ليلة القدر', 'ur': 'لیلۃ القدر', 'bn': 'লাইলাতুল কদর'},
    // ── วันอีดุลฟิฏร์ (1 เชาวาล) ──
    'Eid al-Fitr': {'th': 'วันอีดุลฟิฏร์', 'ms': 'Hari Raya Aidilfitri', 'id': 'Idul Fitri', 'ar': 'عيد الفطر', 'ur': 'عید الفطر', 'bn': 'ঈদুল ফিতর'},
    // ── วันอะรอฟะห์ (9 ซุลฮิจญะห์) — API อาจสะกด Arafah หรือ Arafat แล้วแต่เวอร์ชัน ──
    'Arafat': {'th': 'วันอะรอฟะห์', 'ms': 'Hari Arafah', 'id': 'Hari Arafah', 'ar': 'يوم عرفة', 'ur': 'یوم عرفہ', 'bn': 'আরাফার দিন'},
    'Arafah': {'th': 'วันอะรอฟะห์', 'ms': 'Hari Arafah', 'id': 'Hari Arafah', 'ar': 'يوم عرفة', 'ur': 'یوم عرفہ', 'bn': 'আরাফার দিন'},
    // ── วันอีดุลอัฎฮา (10 ซุลฮิจญะห์) ──
    'Eid al-Adha': {'th': 'วันอีดุลอัฎฮา', 'ms': 'Hari Raya Aidiladha', 'id': 'Idul Adha', 'ar': 'عيد الأضحى', 'ur': 'عید الاضحیٰ', 'bn': 'ঈদুল আযহা'},
    // ── วันตัชรีก (11-13 ซุลฮิจญะห์) — สะกดได้ทั้ง Tashriq/Tashreeq ──
    'Tashriq': {'th': 'วันตัชรีก', 'ms': 'Hari Tasyrik', 'id': 'Hari Tasyrik', 'ar': 'أيام التشريق', 'ur': 'ایام تشریق', 'bn': 'আইয়ামে তাশরিক'},
    'Tashreeq': {'th': 'วันตัชรีก', 'ms': 'Hari Tasyrik', 'id': 'Hari Tasyrik', 'ar': 'أيام التشريق', 'ur': 'ایام تشریق', 'bn': 'আইয়ামে তাশরিক'},
  };

  // ══════════════════════════════════════════════════════════════
  // ── ฝั่งเกรกอเรียน: ชื่อเดือน / ชื่อวัน (แก้บั๊กที่ก่อนหน้านี้ hardcode
  // เป็นภาษาอังกฤษตายตัวในทุกที่ที่แสดงปฏิทิน ทำให้ไม่เปลี่ยนตามภาษาแอป) ──
  // ══════════════════════════════════════════════════════════════

  static const Map<String, List<String>> _gregorianMonths = {
    'en': ['January','February','March','April','May','June','July','August','September','October','November','December'],
    'th': ['มกราคม','กุมภาพันธ์','มีนาคม','เมษายน','พฤษภาคม','มิถุนายน','กรกฎาคม','สิงหาคม','กันยายน','ตุลาคม','พฤศจิกายน','ธันวาคม'],
    'ms': ['Januari','Februari','Mac','April','Mei','Jun','Julai','Ogos','September','Oktober','November','Disember'],
    'id': ['Januari','Februari','Maret','April','Mei','Juni','Juli','Agustus','September','Oktober','November','Desember'],
    'ar': ['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'],
    'ur': ['جنوری','فروری','مارچ','اپریل','مئی','جون','جولائی','اگست','ستمبر','اکتوبر','نومبر','دسمبر'],
    'bn': ['জানুয়ারি','ফেব্রুয়ারি','মার্চ','এপ্রিল','মে','জুন','জুলাই','আগস্ট','সেপ্টেম্বর','অক্টোবর','নভেম্বর','ডিসেম্বর'],
  };

  /// month: 1-12
  static String getGregorianMonthName(int month, String lang) {
    final list = _gregorianMonths[lang] ?? _gregorianMonths['en']!;
    if (month < 1 || month > 12) return '';
    return list[month - 1];
  }

  // ชื่อวันเต็ม เรียงเริ่มจากวันอาทิตย์ (index 0) ถึงวันเสาร์ (index 6)
  static const Map<String, List<String>> _weekdayFullNames = {
    'en': ['Sunday','Monday','Tuesday','Wednesday','Thursday','Friday','Saturday'],
    'th': ['วันอาทิตย์','วันจันทร์','วันอังคาร','วันพุธ','วันพฤหัสบดี','วันศุกร์','วันเสาร์'],
    'ms': ['Ahad','Isnin','Selasa','Rabu','Khamis','Jumaat','Sabtu'],
    'id': ['Minggu','Senin','Selasa','Rabu','Kamis','Jumat','Sabtu'],
    'ar': ['الأحد','الإثنين','الثلاثاء','الأربعاء','الخميس','الجمعة','السبت'],
    'ur': ['اتوار','پیر','منگل','بدھ','جمعرات','جمعہ','ہفتہ'],
    'bn': ['রবিবার','সোমবার','মঙ্গলবার','বুধবার','বৃহস্পতিবার','শুক্রবার','শনিবার'],
  };

  /// weekday0Sun: 0=อาทิตย์ ... 6=เสาร์ (ใช้สูตร `DateTime.weekday % 7` แปลงได้เลย
  /// เพราะ Dart ให้ Monday=1..Sunday=7 อยู่แล้ว)
  static String getWeekdayName(int weekday0Sun, String lang) {
    final list = _weekdayFullNames[lang] ?? _weekdayFullNames['en']!;
    return list[weekday0Sun % 7];
  }

  // ตัวย่อวันในสัปดาห์ (ใช้กับ week strip และหัวตารางปฏิทินเต็ม)
  // เรียงเริ่มจากวันอาทิตย์เหมือนกัน
  static const Map<String, List<String>> _weekdayShortLabels = {
    'en': ['S', 'M', 'T', 'W', 'T', 'F', 'S'],
    'th': ['อา', 'จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส'],
    'ms': ['Ah', 'Is', 'Se', 'Ra', 'Kh', 'Ju', 'Sa'],
    'id': ['Mg', 'Sn', 'Sl', 'Rb', 'Km', 'Jm', 'Sb'],
    'ar': ['ح', 'ن', 'ث', 'ر', 'خ', 'ج', 'س'],
    'ur': ['ا', 'پ', 'م', 'ب', 'ج', 'ج', 'ہ'],
    'bn': ['রবি', 'সোম', 'মঙ্গ', 'বুধ', 'বৃহ', 'শুক্র', 'শনি'],
  };

  static List<String> getWeekdayShortLabels(String lang) {
    return _weekdayShortLabels[lang] ?? _weekdayShortLabels['en']!;
  }
}