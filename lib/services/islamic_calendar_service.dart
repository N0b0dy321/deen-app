import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class IslamicCalendarService {
  static const _baseUrl = 'https://api.aladhan.com/v1';
  static const _cachePrefix = 'hijri_calendar_';

  // ดึงปฏิทินฮิจเราะห์ทั้งเดือน
  static Future<List<Map<String, dynamic>>?> getHijriCalendar(int month, int year) async {
    final cacheKey = '$_cachePrefix${year}_$month';
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(cacheKey);

    if (cached != null) {
      final data = json.decode(cached) as List;
      return data.cast<Map<String, dynamic>>();
    }

    try {
      final res = await http.get(
        Uri.parse('$_baseUrl/gToHCalendar/$month/$year'),
      ).timeout(const Duration(seconds: 15));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        if (data['code'] == 200) {
          final calendar = (data['data'] as List).cast<Map<String, dynamic>>();
          await prefs.setString(cacheKey, json.encode(calendar));
          return calendar;
        }
      }
    } catch (e) {
      print('Islamic calendar error: $e');
    }
    return null;
  }

  // ดึงปฏิทิน 2 เดือนล่วงหน้าและ cache ไว้
  static Future<void> prefetchCalendars() async {
    final now = DateTime.now();
    for (int i = 0; i < 2; i++) {
      final date = DateTime(now.year, now.month + i);
      await getHijriCalendar(date.month, date.year);
    }
  }

  // แปลงวันที่ Gregorian เป็น Hijri
  static Future<Map<String, dynamic>?> getTodayHijri() async {
    final now = DateTime.now();
    final calendar = await getHijriCalendar(now.month, now.year);
    if (calendar == null) return null;

    final today = calendar.firstWhere(
      (d) => d['gregorian']['day'] == now.day.toString(),
      orElse: () => {},
    );
    return today.isEmpty ? null : today;
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
    final holiday = holidays.first;
    final name = holiday['name'] as String? ?? '';

    final translations = {
      "New Year's Day": {'th': 'วันขึ้นปีใหม่ฮิจเราะห์', 'ms': "Tahun Baru Islam", 'id': 'Tahun Baru Hijriah', 'ar': 'رأس السنة الهجرية', 'ur': 'اسلامی نیا سال', 'bn': 'ইসলামিক নববর্ষ'},
      'Ashura': {'th': 'วันอาชูรอ', 'ms': 'Hari Asyura', 'id': 'Hari Asyura', 'ar': 'يوم عاشوراء', 'ur': 'یوم عاشورہ', 'bn': 'আশুরা'},
      'Mawlid al-Nabi': {'th': 'วันเมาลิดนบี', 'ms': 'Maulidur Rasul', 'id': 'Maulid Nabi', 'ar': 'المولد النبوي', 'ur': 'عید میلاد النبی', 'bn': 'মিলাদুন্নবী'},
      'Isra': {'th': 'วันอิสรออ์และมิอ์รอจ', 'ms': "Isra' Mikraj", 'id': "Isra' Mi'raj", 'ar': 'الإسراء والمعراج', 'ur': 'شب معراج', 'bn': 'ইসরা ও মিরাজ'},
      'Laylat al-Qadr': {'th': 'คืนลัยลาตุลก็อดร์', 'ms': 'Lailatul Qadar', 'id': 'Lailatul Qadar', 'ar': 'ليلة القدر', 'ur': 'لیلۃ القدر', 'bn': 'লাইলাতুল কদর'},
      'Eid al-Fitr': {'th': 'วันอีดุลฟิฏร์', 'ms': 'Hari Raya Aidilfitri', 'id': 'Idul Fitri', 'ar': 'عيد الفطر', 'ur': 'عید الفطر', 'bn': 'ঈদুল ফিতর'},
      'Eid al-Adha': {'th': 'วันอีดุลอัฎฮา', 'ms': 'Hari Raya Aidiladha', 'id': 'Idul Adha', 'ar': 'عيد الأضحى', 'ur': 'عید الاضحیٰ', 'bn': 'ঈদুল আযহা'},
      'Arafat': {'th': 'วันอะรอฟะห์', 'ms': 'Hari Arafah', 'id': 'Hari Arafah', 'ar': 'يوم عرفة', 'ur': 'یوم عرفہ', 'bn': 'আরাফার দিন'},
    };

    for (final entry in translations.entries) {
      if (name.contains(entry.key)) {
        return translations[entry.key]![lang] ?? name;
      }
    }
    return name.isNotEmpty ? name : null;
  }
}