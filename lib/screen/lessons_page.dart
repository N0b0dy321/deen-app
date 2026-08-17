import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

const Map<String, Map<String, List<String>>> kLessonTitleTranslations = {
  'ms': {
    'pillars': ['Syahadah (Pengakuan Iman)', 'Solat (Sembahyang)', 'Zakat (Derma)', 'Sawm (Puasa)', 'Haji (Ziarah)'],
    'iman': ['Percaya kepada Allah', 'Percaya kepada Malaikat', 'Percaya kepada Kitab Suci', 'Percaya kepada Nabi', 'Percaya kepada Hari Kiamat', 'Percaya kepada Qada dan Qadar'],
    'wudhu': ['Cara Berwudhu'],
    'prayer': ['Syarat Solat', 'Niat dan Takbir', 'Bacaan dalam Berdiri', 'Rukuk', 'Sujud', 'Tahiyat dan Salam', 'Zikir Selepas Solat'],
    'hadith': ['Amal Bergantung pada Niat', 'Islam Dibina atas Lima', 'Halal dan Haram Jelas', 'Tidak Beriman Sempurna', 'Agama adalah Keikhlasan', 'Tinggalkan yang Tidak Perlu', 'Senyum adalah Sedekah', 'Kasih Sayang kepada Semua', 'Mukmin yang Kuat', 'Menghilangkan Mudarat'],
    'adab': ['Salam Islam', 'Adab Makan dan Minum', 'Menghormati Ibu Bapa', 'Kejujuran', 'Kebersihan (Taharah)'],
    'history': ['Nabi Muhammad - Awal Kehidupan', 'Wahyu Pertama', 'Hijrah ke Madinah', 'Peperangan Penting', 'Empat Khalifah', 'Penyebaran Islam'],
    'fasting': ['Kelebihan Puasa', 'Syarat Puasa', 'Perkara yang Membatalkan Puasa', 'Adab Berpuasa', 'Puasa Sunat', 'Lailatul Qadr', 'Zakat Fitrah'],
    'special_prayer': ['Solat Eidulfitri', 'Solat Eiduladha', 'Solat Jenazah', 'Solat Tarawih', 'Solat Istisqa (Minta Hujan)', 'Solat Kusuf/Khusuf (Gerhana)'],
  },
  'id': {
    'pillars': ['Syahadat (Ikrar Iman)', 'Sholat (Sembahyang)', 'Zakat (Amal)', 'Shaum (Puasa)', 'Haji (Ziarah)'],
    'iman': ['Iman kepada Allah', 'Iman kepada Malaikat', 'Iman kepada Kitab Suci', 'Iman kepada Nabi', 'Iman kepada Hari Kiamat', 'Iman kepada Qada dan Qadar'],
    'wudhu': ['Cara Berwudhu'],
    'prayer': ['Syarat Sholat', 'Niat dan Takbir', 'Bacaan dalam Berdiri', 'Ruku', 'Sujud', 'Tasyahud dan Salam', 'Dzikir Setelah Sholat'],
    'hadith': ['Amal Tergantung Niat', 'Islam Dibangun atas Lima', 'Halal dan Haram Jelas', 'Tidak Beriman Sempurna', 'Agama adalah Ketulusan', 'Tinggalkan yang Tidak Perlu', 'Senyum adalah Sedekah', 'Kasih Sayang kepada Semua', 'Mukmin yang Kuat', 'Menghilangkan Kemudharatan'],
    'adab': ['Salam Islam', 'Adab Makan dan Minum', 'Menghormati Orang Tua', 'Kejujuran', 'Kebersihan (Thaharah)'],
    'history': ['Nabi Muhammad - Kehidupan Awal', 'Wahyu Pertama', 'Hijrah ke Madinah', 'Perang Penting', 'Empat Khalifah', 'Penyebaran Islam'],
    'fasting': ['Keutamaan Puasa', 'Syarat Puasa', 'Hal yang Membatalkan Puasa', 'Adab Berpuasa', 'Puasa Sunnah', 'Lailatul Qadr', 'Zakat Fitrah'],
    'special_prayer': ['Sholat Idul Fitri', 'Sholat Idul Adha', 'Sholat Jenazah', 'Sholat Tarawih', 'Sholat Istisqa (Minta Hujan)', 'Sholat Kusuf/Khusuf (Gerhana)'],
  },
  'ar': {
    'pillars': ['الشهادة (الإقرار بالإيمان)', 'الصلاة', 'الزكاة', 'الصوم', 'الحج'],
    'iman': ['الإيمان بالله', 'الإيمان بالملائكة', 'الإيمان بالكتب', 'الإيمان بالأنبياء', 'الإيمان باليوم الآخر', 'الإيمان بالقضاء والقدر'],
    'wudhu': ['كيفية الوضوء'],
    'prayer': ['شروط الصلاة', 'النية والتكبير', 'القراءة في القيام', 'الركوع', 'السجود', 'التشهد والسلام', 'الأذكار بعد الصلاة'],
    'hadith': ['الأعمال بالنيات', 'بني الإسلام على خمس', 'الحلال بين والحرام بين', 'لا يؤمن أحدكم', 'الدين النصيحة', 'ترك ما لا يعنيك', 'التبسم صدقة', 'الرحمة بالخلق', 'المؤمن القوي', 'لا ضرر ولا ضرار'],
    'adab': ['السلام الإسلامي', 'آداب الأكل والشرب', 'احترام الوالدين', 'الصدق والأمانة', 'الطهارة'],
    'history': ['النبي محمد - حياته الأولى', 'الوحي الأول', 'الهجرة إلى المدينة', 'المعارك الكبرى', 'الخلفاء الراشدون الأربعة', 'انتشار الإسلام'],
    'fasting': ['فضل الصيام', 'شروط الصيام', 'مبطلات الصيام', 'آداب الصيام', 'الصيام المستحب', 'ليلة القدر', 'زكاة الفطر'],
    'special_prayer': ['صلاة عيد الفطر', 'صلاة عيد الأضحى', 'صلاة الجنازة', 'صلاة التراويح', 'صلاة الاستسقاء', 'صلاة الكسوف والخسوف'],
  },
  'ur': {
    'pillars': ['شہادت (ایمان کا اقرار)', 'نماز', 'زکوٰۃ', 'روزہ', 'حج'],
    'iman': ['اللہ پر ایمان', 'فرشتوں پر ایمان', 'کتابوں پر ایمان', 'نبیوں پر ایمان', 'قیامت کے دن پر ایمان', 'تقدیر پر ایمان'],
    'wudhu': ['وضو کا طریقہ'],
    'prayer': ['نماز کی شرائط', 'نیت اور تکبیر', 'قیام میں تلاوت', 'رکوع', 'سجدہ', 'تشہد اور سلام', 'نماز کے بعد اذکار'],
    'hadith': ['اعمال کا دارومدار نیتوں پر', 'اسلام پانچ چیزوں پر بنا ہے', 'حلال اور حرام واضح ہیں', 'کامل ایمان', 'دین خیرخواہی ہے', 'غیر ضروری چھوڑنا', 'مسکراہٹ صدقہ ہے', 'تمام مخلوق پر رحم', 'مضبوط مومن', 'نقصان نہ پہنچانا'],
    'adab': ['اسلامی سلام', 'کھانے پینے کے آداب', 'والدین کا احترام', 'سچائی اور دیانتداری', 'پاکیزگی (طہارت)'],
    'history': ['نبی محمد - ابتدائی زندگی', 'پہلی وحی', 'مدینہ کی طرف ہجرت', 'اہم غزوات', 'چار خلفائے راشدین', 'اسلام کا پھیلاؤ'],
    'fasting': ['روزے کی فضیلت', 'روزے کی شرائط', 'روزہ توڑنے والی چیزیں', 'روزے کے آداب', 'نفل روزے', 'لیلۃ القدر', 'زکاۃ الفطر'],
    'special_prayer': ['عید الفطر کی نماز', 'عید الاضحیٰ کی نماز', 'نماز جنازہ', 'تراویح', 'نماز استسقاء', 'نماز کسوف/خسوف'],
  },
  'bn': {
    'pillars': ['শাহাদাহ (ঈমানের স্বীকৃতি)', 'সালাত (নামাজ)', 'যাকাত', 'সাওম (রোজা)', 'হজ'],
    'iman': ['আল্লাহর প্রতি ঈমান', 'ফেরেশতাদের প্রতি ঈমান', 'কিতাবসমূহের প্রতি ঈমান', 'নবীদের প্রতি ঈমান', 'কিয়ামত দিবসের প্রতি ঈমান', 'তাকদীরের প্রতি ঈমান'],
    'wudhu': ['ওযু করার নিয়ম'],
    'prayer': ['নামাজের শর্তসমূহ', 'নিয়ত ও তাকবির', 'দাঁড়ানো অবস্থায় তিলাওয়াত', 'রুকু', 'সিজদাহ', 'তাশাহহুদ ও সালাম', 'নামাজের পরের যিকির'],
    'hadith': ['আমল নিয়তের উপর নির্ভরশীল', 'ইসলাম পাঁচটি স্তম্ভের উপর প্রতিষ্ঠিত', 'হালাল ও হারাম স্পষ্ট', 'পরিপূর্ণ ঈমান', 'দ্বীন হলো কল্যাণকামিতা', 'অপ্রয়োজনীয় ছেড়ে দেওয়া', 'হাসি সদকাহ', 'সকল সৃষ্টির প্রতি দয়া', 'শক্তিশালী মুমিন', 'ক্ষতি না করা'],
    'adab': ['ইসলামী সালাম', 'খাওয়া-দাওয়ার আদব', 'পিতামাতার প্রতি সম্মান', 'সততা ও সত্যবাদিতা', 'পবিত্রতা (তাহারাহ)'],
    'history': ['নবী মুহাম্মদ - প্রারম্ভিক জীবন', 'প্রথম ওহী', 'মদিনায় হিজরত', 'গুরুত্বপূর্ণ যুদ্ধসমূহ', 'চার খলিফা', 'ইসলামের বিস্তার'],
    'fasting': ['রোজার ফযীলত', 'রোজার শর্তসমূহ', 'রোজা ভাঙার কারণ', 'রোজার আদব', 'নফল রোজা', 'লাইলাতুল কদর', 'যাকাতুল ফিতর'],
    'special_prayer': ['ঈদুল ফিতরের নামাজ', 'ঈদুল আযহার নামাজ', 'জানাজার নামাজ', 'তারাবির নামাজ', 'ইস্তিসকার নামাজ', 'কুসুফ/খুসুফের নামাজ'],
  },
};


String _getLangText(Map<String, dynamic> map, String key, String lang) {
  final langKey = '${key}${lang[0].toUpperCase()}${lang.substring(1)}';
  if (map.containsKey(langKey) && map[langKey] != null) return map[langKey] as String;
  if (lang == 'th' && map.containsKey('${key}Th')) return map['${key}Th'] as String;
  return map['${key}En'] as String? ?? '';
}

String _getLessonTitle(Map<String, dynamic> lesson, String catId, String lang, int index) {
  if (lang == 'th') return lesson['titleTh'] as String? ?? lesson['titleEn'] as String? ?? '';
  final langTitles = kLessonTitleTranslations[lang];
  if (langTitles != null && langTitles.containsKey(catId)) {
    final titles = langTitles[catId]!;
    if (index < titles.length) return titles[index];
  }
  return lesson['titleEn'] as String? ?? '';
}

String _getLessonContent(Map<String, dynamic> lesson, String catId, String lang, int lessonNo) {
  if (lang == 'th') return lesson['contentTh'] as String? ?? lesson['contentEn'] as String? ?? '';
  final catMap = kLessonContentTranslations[catId];
  if (catMap != null) {
    final langMap = catMap[lang];
    if (langMap != null && langMap.containsKey(lessonNo)) {
      return langMap[lessonNo]!['content'] ?? lesson['contentEn'] as String? ?? '';
    }
  }
  return lesson['contentEn'] as String? ?? '';
}

// ── Lesson Content Translations ────────────────────
const Map<String, Map<String, Map<int, Map<String, String>>>> kLessonContentTranslations = {
  'pillars': {
    'ms': {
      1: {'title': 'Syahadah', 'content': 'Syahadah adalah pengakuan iman:\n"Tiada tuhan selain Allah, dan Muhammad adalah utusan Allah"\n\n• Mengesahkan keesaan Allah (Tauhid)\n• Mengakui Muhammad sebagai nabi terakhir\n• Mesti diucapkan dengan pemahaman penuh'},
      2: {'title': 'Solat', 'content': 'Muslim diwajibkan solat lima waktu sehari:\n\n1. Subuh - 2 rakaat\n2. Zohor - 4 rakaat\n3. Asar - 4 rakaat\n4. Maghrib - 3 rakaat\n5. Isyak - 4 rakaat\n\nWudhu diperlukan sebelum solat.'},
      3: {'title': 'Zakat', 'content': 'Zakat adalah pemberian wajib sebahagian harta.\n\n• Kadar 2.5% daripada simpanan setahun\n• Menyucikan harta dan membantu yang memerlukan\n• Penerima: fakir miskin, penghutang, musafir'},
      4: {'title': 'Sawm (Puasa)', 'content': 'Puasa Ramadan wajib bagi semua Muslim dewasa.\n\n• Menahan dari makan, minum dari subuh hingga maghrib\n• Ramadan adalah bulan ke-9 kalendar Islam\n• Puasa mengajar kesabaran dan empati'},
      5: {'title': 'Haji', 'content': 'Haji adalah ziarah ke Mekah, wajib sekali seumur hidup.\n\n• Dilakukan pada bulan Zulhijjah\n• Ibadat utama: Tawaf, Saie, Wukuf di Arafah\n• Lebih 2 juta Muslim menunaikan haji setiap tahun'},
    },
    'id': {
      1: {'title': 'Syahadat', 'content': 'Syahadat adalah ikrar iman:\n"Tidak ada tuhan selain Allah, dan Muhammad adalah utusan Allah"\n\n• Menegaskan keesaan Allah (Tauhid)\n• Mengakui Muhammad sebagai nabi terakhir\n• Harus diucapkan dengan pemahaman penuh'},
      2: {'title': 'Shalat', 'content': 'Muslim diwajibkan shalat lima waktu sehari:\n\n1. Subuh - 2 rakaat\n2. Dzuhur - 4 rakaat\n3. Ashar - 4 rakaat\n4. Maghrib - 3 rakaat\n5. Isya - 4 rakaat\n\nWudhu diperlukan sebelum shalat.'},
      3: {'title': 'Zakat', 'content': 'Zakat adalah pemberian wajib sebagian harta.\n\n• Kadar 2.5% dari tabungan selama satu tahun\n• Menyucikan harta dan membantu yang membutuhkan\n• Penerima: fakir miskin, penghutang, musafir'},
      4: {'title': 'Shaum (Puasa)', 'content': 'Puasa Ramadhan wajib bagi semua Muslim dewasa.\n\n• Menahan dari makan, minum dari subuh hingga maghrib\n• Ramadhan adalah bulan ke-9 kalender Islam\n• Puasa mengajarkan kesabaran dan empati'},
      5: {'title': 'Haji', 'content': 'Haji adalah ziarah ke Mekah, wajib sekali seumur hidup.\n\n• Dilakukan pada bulan Dzulhijjah\n• Ibadah utama: Tawaf, Sai, Wukuf di Arafah\n• Lebih dari 2 juta Muslim menunaikan haji setiap tahun'},
    },
    'ar': {
      1: {'title': 'الشهادة', 'content': 'الشهادة هي الإقرار بالإيمان:\n"لا إله إلا الله محمد رسول الله"\n\n• تؤكد وحدانية الله\n• تعترف بمحمد ﷺ خاتم الأنبياء\n• يجب أن تُقال بإيمان كامل'},
      2: {'title': 'الصلاة', 'content': 'يجب على المسلم الصلاة خمس مرات في اليوم:\n\n1. الفجر - ركعتان\n2. الظهر - أربع ركعات\n3. العصر - أربع ركعات\n4. المغرب - ثلاث ركعات\n5. العشاء - أربع ركعات\n\nالوضوء شرط قبل الصلاة.'},
      3: {'title': 'الزكاة', 'content': 'الزكاة هي إعطاء نسبة محددة من المال.\n\n• النسبة 2.5٪ من المدخرات لحول كامل\n• تطهر المال وتساعد المحتاجين\n• المستحقون: الفقراء والغارمون وأبناء السبيل'},
      4: {'title': 'الصوم', 'content': 'صيام رمضان واجب على جميع المسلمين البالغين.\n\n• الامتناع عن الأكل والشرب من الفجر إلى المغرب\n• رمضان هو الشهر التاسع في التقويم الإسلامي\n• الصوم يعلم الصبر والتعاطف'},
      5: {'title': 'الحج', 'content': 'الحج هو الزيارة إلى مكة، واجب مرة في العمر لمن استطاع.\n\n• يُؤدى في شهر ذي الحجة\n• الشعائر: الطواف والسعي والوقوف بعرفة\n• أكثر من 2 مليون مسلم يؤدون الحج سنوياً'},
    },
    'ur': {
      1: {'title': 'شہادت', 'content': 'شہادت ایمان کا اقرار ہے:\n"اللہ کے سوا کوئی معبود نہیں اور محمد ﷺ اللہ کے رسول ہیں"\n\n• اللہ کی وحدانیت کا اقرار\n• محمد ﷺ کو آخری نبی تسلیم کرنا'},
      2: {'title': 'نماز', 'content': 'مسلمان پر دن میں پانچ وقت نماز فرض ہے:\n\n1. فجر - 2 رکعات\n2. ظہر - 4 رکعات\n3. عصر - 4 رکعات\n4. مغرب - 3 رکعات\n5. عشاء - 4 رکعات'},
      3: {'title': 'زکوٰۃ', 'content': 'زکوٰۃ مال کا ایک حصہ صدقہ میں دینا فرض ہے۔\n\n• سال بھر کی بچت پر 2.5 فیصد\n• مال کو پاک کرتی ہے\n• مستحقین: فقراء، قرض دار، مسافر'},
      4: {'title': 'روزہ', 'content': 'رمضان کا روزہ تمام بالغ مسلمانوں پر فرض ہے۔\n\n• فجر سے مغرب تک پرہیز\n• رمضان نواں اسلامی مہینہ ہے\n• روزہ صبر اور ہمدردی سکھاتا ہے'},
      5: {'title': 'حج', 'content': 'حج مکہ کا سفر ہے، استطاعت رکھنے والے پر ایک بار فرض۔\n\n• ذی الحجہ میں ادا کیا جاتا ہے\n• ارکان: طواف، سعی، وقوف عرفات\n• ہر سال 20 لاکھ سے زائد مسلمان'},
    },
    'bn': {
      1: {'title': 'শাহাদাহ', 'content': 'শাহাদাহ হলো ঈমানের স্বীকৃতি:\n"আল্লাহ ছাড়া কোনো ইলাহ নেই এবং মুহাম্মদ আল্লাহর রাসূল"\n\n• আল্লাহর একত্বের স্বীকৃতি\n• মুহাম্মদ ﷺ-কে শেষ নবী হিসেবে স্বীকার'},
      2: {'title': 'সালাত', 'content': 'মুসলিমদের দিনে পাঁচ ওয়াক্ত নামাজ পড়তে হয়:\n\n1. ফজর - ২ রাকাত\n2. যোহর - ৪ রাকাত\n3. আসর - ৪ রাকাত\n4. মাগরিব - ৩ রাকাত\n5. ইশা - ৪ রাকাত'},
      3: {'title': 'যাকাত', 'content': 'যাকাত হলো সম্পদের একটি অংশ বাধ্যতামূলকভাবে দান।\n\n• এক বছরের সঞ্চয়ের ২.৫%\n• সম্পদ পবিত্র করে\n• প্রাপক: গরীব, ঋণগ্রস্ত, মুসাফির'},
      4: {'title': 'সাওম (রোজা)', 'content': 'রমজানের রোজা সকল প্রাপ্তবয়স্ক মুসলিমের জন্য ফরজ।\n\n• ফজর থেকে মাগরিব পর্যন্ত বিরত\n• রমজান নবম ইসলামী মাস\n• ধৈর্য ও সহানুভূতি শেখায়'},
      5: {'title': 'হজ', 'content': 'হজ হলো মক্কায় তীর্থযাত্রা, সামর্থ্যবানের জন্য একবার ফরজ।\n\n• জিলহজ মাসে পালন\n• মূল ইবাদত: তাওয়াফ, সাঈ, আরাফাত\n• প্রতি বছর ২০ লক্ষেরও বেশি মুসলিম'},
    },
  },
  'iman': {
    'ms': {
      1: {'title': 'Percaya kepada Allah', 'content': 'Percaya kepada keesaan Allah (Tauhid).\n\nAllah adalah:\n• Tuhan yang Maha Esa\n• Maha Mengetahui\n• Maha Berkuasa\n• Maha Penyayang\n• Mempunyai 99 nama indah'},
      2: {'title': 'Percaya kepada Malaikat', 'content': 'Malaikat dicipta dari cahaya.\n\nMalaikat utama:\n• Jibril - Menyampaikan wahyu\n• Mikail - Mengawal rezeki\n• Israfil - Meniup sangkakala\n• Izrail - Malaikat maut'},
      3: {'title': 'Percaya kepada Kitab Suci', 'content': 'Muslim percaya kepada semua kitab:\n• Taurat - Nabi Musa\n• Zabur - Nabi Daud\n• Injil - Nabi Isa\n• Al-Quran - Nabi Muhammad (terakhir)\n\nHanya Al-Quran yang kekal tidak berubah.'},
      4: {'title': 'Percaya kepada Nabi', 'content': 'Allah mengutus 124,000 nabi.\n\nNabi utama:\n• Adam - Manusia pertama\n• Ibrahim - Bapa para nabi\n• Musa - Menerima Taurat\n• Isa - Menerima Injil\n• Muhammad ﷺ - Nabi terakhir'},
      5: {'title': 'Percaya kepada Hari Kiamat', 'content': 'Setiap jiwa akan dihisab.\n\nPeristiwa:\n• Sangkakala ditiup\n• Semua jiwa dibangkitkan\n• Amal ditimbang\n• Orang soleh masuk Syurga\n• Orang jahat masuk Neraka'},
      6: {'title': 'Percaya kepada Qada dan Qadar', 'content': 'Allah mengetahui segala sesuatu.\n\n4 Peringkat Qadar:\n1. Ilmu Allah\n2. Ditulis di Luh Mahfuz\n3. Kehendak Allah\n4. Penciptaan Allah'},
    },
    'id': {
      1: {'title': 'Iman kepada Allah', 'content': 'Percaya kepada keesaan Allah (Tauhid).\n\nAllah adalah:\n• Tuhan Yang Maha Esa\n• Maha Mengetahui\n• Maha Kuasa\n• Maha Penyayang\n• Memiliki 99 nama indah'},
      2: {'title': 'Iman kepada Malaikat', 'content': 'Malaikat diciptakan dari cahaya.\n\nMalaikat utama:\n• Jibril - Menyampaikan wahyu\n• Mikail - Mengatur rezeki\n• Israfil - Meniup sangkakala\n• Izrail - Malaikat kematian'},
      3: {'title': 'Iman kepada Kitab Suci', 'content': 'Muslim percaya pada semua kitab:\n• Taurat - Nabi Musa\n• Zabur - Nabi Dawud\n• Injil - Nabi Isa\n• Al-Quran - Nabi Muhammad (terakhir)\n\nHanya Al-Quran yang tetap tidak berubah.'},
      4: {'title': 'Iman kepada Nabi', 'content': 'Allah mengutus 124.000 nabi.\n\nNabi utama:\n• Adam - Manusia pertama\n• Ibrahim - Bapak para nabi\n• Musa - Menerima Taurat\n• Isa - Menerima Injil\n• Muhammad ﷺ - Nabi terakhir'},
      5: {'title': 'Iman kepada Hari Kiamat', 'content': 'Setiap jiwa akan diadili.\n\nPeristiwa:\n• Sangkakala ditiup\n• Semua jiwa dibangkitkan\n• Amal ditimbang\n• Orang saleh masuk Surga\n• Orang jahat masuk Neraka'},
      6: {'title': 'Iman kepada Qada dan Qadar', 'content': 'Allah mengetahui segalanya.\n\n4 Tingkatan Qadar:\n1. Ilmu Allah\n2. Ditulis di Lauh Mahfuz\n3. Kehendak Allah\n4. Penciptaan Allah'},
    },
    'ar': {
      1: {'title': 'الإيمان بالله', 'content': 'الإيمان بوحدانية الله.\n\nالله هو:\n• الإله الواحد\n• عليم بكل شيء\n• قادر على كل شيء\n• رحيم بعباده\n• له 99 اسماً حسناً'},
      2: {'title': 'الإيمان بالملائكة', 'content': 'الملائكة خُلقوا من نور.\n\nأبرز الملائكة:\n• جبريل - الوحي\n• ميكائيل - الرزق\n• إسرافيل - الصور\n• عزرائيل - الموت'},
      3: {'title': 'الإيمان بالكتب', 'content': 'يؤمن المسلم بجميع الكتب:\n• التوراة - موسى\n• الزبور - داود\n• الإنجيل - عيسى\n• القرآن - محمد ﷺ (الأخير)\n\nالقرآن محفوظ من التحريف.'},
      4: {'title': 'الإيمان بالأنبياء', 'content': 'أرسل الله 124,000 نبي.\n\nأبرز الأنبياء:\n• آدم - أول إنسان\n• إبراهيم - أبو الأنبياء\n• موسى - التوراة\n• عيسى - الإنجيل\n• محمد ﷺ - خاتم الأنبياء'},
      5: {'title': 'الإيمان باليوم الآخر', 'content': 'ستُحاسَب كل نفس.\n\nالأحداث:\n• نفخ الصور\n• بعث الأرواح\n• وزن الأعمال\n• الجنة للمؤمنين\n• النار للكافرين'},
      6: {'title': 'الإيمان بالقضاء والقدر', 'content': 'الله يعلم كل شيء.\n\n4 مراتب القدر:\n1. علم الله\n2. الكتابة في اللوح المحفوظ\n3. مشيئة الله\n4. خلق الله'},
    },
    'ur': {
      1: {'title': 'اللہ پر ایمان', 'content': 'اللہ کی وحدانیت پر ایمان۔\n\nاللہ ہے:\n• ایک خدا\n• سب کچھ جاننے والا\n• سب پر قادر\n• بے حد مہربان\n• 99 خوبصورت نام'},
      2: {'title': 'فرشتوں پر ایمان', 'content': 'فرشتے نور سے بنے ہیں۔\n\nاہم فرشتے:\n• جبریل - وحی\n• میکائیل - رزق\n• اسرافیل - صور\n• عزرائیل - موت'},
      3: {'title': 'کتابوں پر ایمان', 'content': 'مسلمان تمام کتابوں پر ایمان رکھتے ہیں:\n• تورات - موسی علیہ السلام\n• زبور - داود علیہ السلام\n• انجیل - عیسی علیہ السلام\n• قرآن - محمد ﷺ (آخری)'},
      4: {'title': 'نبیوں پر ایمان', 'content': 'اللہ نے 124,000 نبی بھیجے۔\n\nاہم نبی:\n• آدم - پہلے انسان\n• ابراہیم - انبیاء کے باپ\n• موسی - تورات\n• عیسی - انجیل\n• محمد ﷺ - آخری نبی'},
      5: {'title': 'قیامت پر ایمان', 'content': 'ہر روح کا حساب ہوگا۔\n\nواقعات:\n• صور پھونکا جائے گا\n• ارواح اٹھائی جائیں گی\n• اعمال تولے جائیں گے\n• نیک جنت میں\n• بد جہنم میں'},
      6: {'title': 'تقدیر پر ایمان', 'content': 'اللہ ہر چیز جانتا ہے۔\n\nقدر کے 4 درجے:\n1. اللہ کا علم\n2. لوح محفوظ میں لکھا\n3. اللہ کی مرضی\n4. اللہ کی تخلیق'},
    },
    'bn': {
      1: {'title': 'আল্লাহর প্রতি ঈমান', 'content': 'আল্লাহর একত্বে বিশ্বাস।\n\nআল্লাহ হলেন:\n• একমাত্র ইলাহ\n• সর্বজ্ঞ\n• সর্বশক্তিমান\n• পরম দয়ালু\n• ৯৯টি সুন্দর নাম'},
      2: {'title': 'ফেরেশতাদের প্রতি ঈমান', 'content': 'ফেরেশতারা আলো থেকে সৃষ্ট।\n\nপ্রধান ফেরেশতা:\n• জিবরাঈল - ওহী\n• মীকাঈল - রিজিক\n• ইসরাফীল - শিঙা\n• আযরাঈল - মৃত্যু'},
      3: {'title': 'কিতাবসমূহের প্রতি ঈমান', 'content': 'মুসলিমরা সকল কিতাবে বিশ্বাস রাখেন:\n• তাওরাত - মূসা আ.\n• যাবুর - দাউদ আ.\n• ইনজিল - ঈসা আ.\n• কুরআন - মুহাম্মদ ﷺ (সর্বশেষ)'},
      4: {'title': 'নবীদের প্রতি ঈমান', 'content': 'আল্লাহ ১,২৪,০০০ নবী পাঠিয়েছেন।\n\nপ্রধান নবী:\n• আদম আ. - প্রথম মানুষ\n• ইবরাহীম আ. - নবীদের পিতা\n• মূসা আ. - তাওরাত\n• ঈসা আ. - ইনজিল\n• মুহাম্মদ ﷺ - শেষ নবী'},
      5: {'title': 'কিয়ামত দিবসের প্রতি ঈমান', 'content': 'প্রতিটি আত্মার বিচার হবে।\n\nঘটনাবলী:\n• শিঙা ফোঁকা হবে\n• আত্মা পুনরুত্থিত হবে\n• আমল ওজন হবে\n• নেককার জান্নাতে\n• পাপীরা জাহান্নামে'},
      6: {'title': 'তাকদীরের প্রতি ঈমান', 'content': 'আল্লাহ সব কিছু জানেন।\n\nক্বাদরের ৪ স্তর:\n1. আল্লাহর ইলম\n2. লাওহে মাহফুজে লিপিবদ্ধ\n3. আল্লাহর ইচ্ছা\n4. আল্লাহর সৃষ্টি'},
    },
  },
  'adab': {
    'ms': {
      1: {'title': 'Salam Islam', 'content': 'Memberi salam adalah amalan terbaik.\n\nTahap salam:\n1. "Assalamualaikum"\n2. "+ Warahmatullah"\n3. "+ Wabarakatuh"\n\nAdab:\n• Yang muda kepada yang tua\n• Membalas salam adalah wajib'},
      2: {'title': 'Adab Makan dan Minum', 'content': '• Bismillah sebelum makan\n• Makan dengan tangan kanan\n• Jangan membazir\n• Makan secara sederhana\n• Alhamdulillah selepas makan'},
      3: {'title': 'Menghormati Ibu Bapa', 'content': 'Kewajipan terpenting selepas menyembah Allah.\n\n• Bercakap dengan sopan\n• Taat dalam perkara yang dibenarkan\n• Sentiasa berdoa untuk mereka\n\n"Syurga di bawah tapak kaki ibu"'},
      4: {'title': 'Kejujuran', 'content': '"Kejujuran membawa kepada kebaikan, kebaikan membawa kepada syurga."\n\nAmalkan kejujuran dalam:\n• Perbualan harian\n• Urusan perniagaan\n• Janji dan komitmen'},
      5: {'title': 'Kebersihan (Taharah)', 'content': '"Kebersihan adalah sebahagian daripada iman"\n\nJenis penyucian:\n1. Wudhu\n2. Mandi wajib\n3. Tayammum\n\nTermasuk kebersihan hati dari hasad, sombong dan riak.'},
    },
    'id': {
      1: {'title': 'Salam Islam', 'content': 'Memberi salam adalah amalan terbaik.\n\nTingkatan salam:\n1. "Assalamualaikum"\n2. "+ Warahmatullah"\n3. "+ Wabarakatuh"\n\nAdab:\n• Yang muda kepada yang tua\n• Membalas salam adalah wajib'},
      2: {'title': 'Adab Makan dan Minum', 'content': '• Bismillah sebelum makan\n• Makan dengan tangan kanan\n• Jangan membuang makanan\n• Makan secukupnya\n• Alhamdulillah setelah makan'},
      3: {'title': 'Menghormati Orang Tua', 'content': 'Kewajiban terpenting setelah menyembah Allah.\n\n• Berbicara dengan sopan\n• Taat dalam hal yang diperbolehkan\n• Selalu berdoa untuk mereka\n\n"Surga di bawah telapak kaki ibu"'},
      4: {'title': 'Kejujuran', 'content': '"Kejujuran membawa kepada kebaikan, kebaikan membawa kepada surga."\n\nPraktikkan kejujuran dalam:\n• Percakapan sehari-hari\n• Urusan bisnis\n• Janji dan komitmen'},
      5: {'title': 'Kebersihan (Thaharah)', 'content': '"Kebersihan adalah sebagian dari iman"\n\nJenis penyucian:\n1. Wudhu\n2. Mandi wajib\n3. Tayammum\n\nTermasuk kebersihan hati dari hasad, sombong dan riya.'},
    },
    'ar': {
      1: {'title': 'السلام الإسلامي', 'content': 'نشر السلام من أفضل الأعمال.\n\nدرجات السلام:\n1. "السلام عليكم"\n2. "+ ورحمة الله"\n3. "+ وبركاته"\n\nآداب: الأصغر يبدأ، رد السلام واجب'},
      2: {'title': 'آداب الأكل والشرب', 'content': '• قل بسم الله قبل الأكل\n• الأكل باليد اليمنى\n• لا إسراف\n• الاعتدال في الأكل\n• قل الحمد لله بعد الأكل'},
      3: {'title': 'احترام الوالدين', 'content': 'من أهم الواجبات بعد عبادة الله.\n\n• التحدث بأدب\n• الطاعة في المعروف\n• الدعاء لهما دائماً\n\n"الجنة تحت أقدام الأمهات"'},
      4: {'title': 'الصدق والأمانة', 'content': '"الصدق يهدي إلى البر، والبر يهدي إلى الجنة."\n\nالتزم بالصدق في:\n• الحديث اليومي\n• المعاملات التجارية\n• الوعود'},
      5: {'title': 'الطهارة', 'content': '"الطهور شطر الإيمان"\n\nأنواع الطهارة:\n1. الوضوء\n2. الغسل\n3. التيمم\n\nتشمل طهارة القلب من الحسد والكبر والرياء.'},
    },
    'ur': {
      1: {'title': 'اسلامی سلام', 'content': 'سلام پھیلانا بہترین عمل ہے۔\n\nسلام کے درجے:\n1. "السلام علیکم"\n2. "+ ورحمۃ اللہ"\n3. "+ وبرکاتہ"\n\nچھوٹا بڑے کو سلام کرے، جواب واجب ہے'},
      2: {'title': 'کھانے پینے کے آداب', 'content': '• بسم اللہ سے شروع\n• دائیں ہاتھ سے کھائیں\n• ضائع نہ کریں\n• اعتدال سے کھائیں\n• الحمد للہ کہیں'},
      3: {'title': 'والدین کا احترام', 'content': 'اللہ کی عبادت کے بعد سب سے اہم فریضہ۔\n\n• نرم لہجے میں بات\n• جائز امور میں اطاعت\n• ہمیشہ دعا\n\n"جنت ماں کے قدموں تلے"'},
      4: {'title': 'سچائی', 'content': '"سچائی نیکی کی طرف، نیکی جنت کی طرف لے جاتی ہے۔"\n\nسچائی:\n• روزمرہ گفتگو میں\n• تجارت میں\n• وعدوں میں'},
      5: {'title': 'پاکیزگی (طہارت)', 'content': '"پاکیزگی نصف ایمان ہے"\n\nطہارت کی اقسام:\n1. وضو\n2. غسل\n3. تیمم\n\nدل کی پاکیزگی بھی ضروری ہے۔'},
    },
    'bn': {
      1: {'title': 'ইসলামী সালাম', 'content': 'সালাম প্রচার করা সেরা আমল।\n\nসালামের স্তর:\n1. "আস-সালামু আলাইকুম"\n2. "+ ওয়া রাহমাতুল্লাহ"\n3. "+ ওয়া বারাকাতুহু"\n\nছোট বড়কে সালাম দেবে, জবাব ওয়াজিব'},
      2: {'title': 'খাওয়া-দাওয়ার আদব', 'content': '• বিসমিল্লাহ বলে শুরু\n• ডান হাতে খান\n• অপচয় করবেন না\n• পরিমিত খান\n• আলহামদুলিল্লাহ বলুন'},
      3: {'title': 'পিতামাতার সম্মান', 'content': 'আল্লাহর ইবাদতের পরে সবচেয়ে গুরুত্বপূর্ণ।\n\n• বিনয়ের সাথে কথা\n• আনুগত্য করুন\n• সর্বদা দোয়া করুন\n\n"জান্নাত মায়ের পায়ের নিচে"'},
      4: {'title': 'সততা', 'content': '"সততা নেকীর দিকে, নেকী জান্নাতের দিকে নিয়ে যায়।"\n\nসততা অনুশীলন:\n• দৈনন্দিন কথায়\n• ব্যবসায়\n• প্রতিশ্রুতিতে'},
      5: {'title': 'পবিত্রতা (তাহারাহ)', 'content': '"পরিষ্কার-পরিচ্ছন্নতা ঈমানের অর্ধেক"\n\nপবিত্রতার প্রকারভেদ:\n1. ওযু\n2. গোসল\n3. তায়াম্মুম\n\nঅন্তরের পবিত্রতাও জরুরি।'},
    },
  },
  'prayer': {
    'ms': {
      1: {'title': 'Syarat Solat', 'content': 'Sebelum solat, syarat berikut mesti dipenuhi:\n\n1. Beragama Islam\n2. Berakal dan baligh\n3. Dalam keadaan suci (Wudhu)\n4. Pakaian dan tempat bersih\n5. Menghadap kiblat\n6. Waktu solat telah masuk\n7. Niat dalam hati'},
      2: {'title': 'Niat dan Takbir', 'content': 'Memulakan solat:\n\n1. Berdiri menghadap kiblat\n2. Buat niat dalam hati\n3. Angkat kedua tangan ke paras telinga\n4. Ucap Takbiratul Ihram: "Allahu Akbar"\n5. Letakkan tangan kanan atas tangan kiri di dada'},
      3: {'title': 'Bacaan dalam Berdiri', 'content': 'Selepas Takbir, baca:\n\n1. Doa Iftitah (sunat)\n2. Surah Al-Fatihah (wajib setiap rakaat)\n3. Surah atau ayat tambahan\n\nTanpa Al-Fatihah solat tidak sah.'},
      4: {'title': 'Rukuk', 'content': 'Melakukan Rukuk:\n\n1. Ucap "Allahu Akbar" sambil membongkok\n2. Bongkok dengan belakang lurus, tangan di lutut\n3. Baca: "Subhana Rabbiyal Adhim" (3 kali)\n4. Bangun sambil ucap: "Samiallahu liman hamidah"\n5. Ucap: "Rabbana lakal hamd"'},
      5: {'title': 'Sujud', 'content': 'Melakukan Sujud:\n\n1. Ucap "Allahu Akbar" ketika turun\n2. 7 anggota badan menyentuh lantai:\n   - Dahi dan hidung\n   - Kedua tapak tangan\n   - Kedua lutut\n   - Hujung kedua kaki\n3. Baca: "Subhana Rabbiyal Ala" (3 kali)\n4. Bangun ucap "Allahu Akbar"\n5. Duduk sebentar, kemudian sujud kedua'},
      6: {'title': 'Tahiyat dan Salam', 'content': 'Duduk terakhir:\n\n1. Baca At-Tahiyyat\n2. Baca Selawat Ibrahimiyyah\n3. Baca doa sebelum salam\n4. Beri salam:\n   - Pusing kanan: "Assalamu Alaikum Warahmatullah"\n   - Pusing kiri: "Assalamu Alaikum Warahmatullah"\n\nSolat selesai!'},
      7: {'title': 'Zikir Selepas Solat', 'content': 'Zikir yang disyorkan:\n\n1. "Astaghfirullah" 3 kali\n2. Ayatul Kursi\n3. "Subhanallah" 33 kali\n4. "Alhamdulillah" 33 kali\n5. "Allahu Akbar" 33 kali'},
    },
    'id': {
      1: {'title': 'Syarat Sholat', 'content': 'Sebelum sholat, syarat berikut harus dipenuhi:\n\n1. Beragama Islam\n2. Berakal dan baligh\n3. Dalam keadaan suci (Wudhu)\n4. Pakaian dan tempat bersih\n5. Menghadap kiblat\n6. Waktu sholat sudah masuk\n7. Niat dalam hati'},
      2: {'title': 'Niat dan Takbir', 'content': 'Memulai sholat:\n\n1. Berdiri menghadap kiblat\n2. Buat niat dalam hati\n3. Angkat kedua tangan setinggi telinga\n4. Ucap Takbiratul Ihram: "Allahu Akbar"\n5. Letakkan tangan kanan di atas tangan kiri di dada'},
      3: {'title': 'Bacaan dalam Berdiri', 'content': 'Setelah Takbir, baca:\n\n1. Doa Iftitah (sunnah)\n2. Surah Al-Fatihah (wajib setiap rakaat)\n3. Surah atau ayat tambahan\n\nTanpa Al-Fatihah sholat tidak sah.'},
      4: {'title': 'Ruku', 'content': 'Melakukan Ruku:\n\n1. Ucap "Allahu Akbar" sambil membungkuk\n2. Bungkuk dengan punggung lurus, tangan di lutut\n3. Baca: "Subhana Rabbiyal Adhim" (3 kali)\n4. Bangkit sambil ucap: "Samiallahu liman hamidah"\n5. Ucap: "Rabbana lakal hamd"'},
      5: {'title': 'Sujud', 'content': 'Melakukan Sujud:\n\n1. Ucap "Allahu Akbar" saat turun\n2. 7 anggota badan menyentuh lantai:\n   - Dahi dan hidung\n   - Kedua telapak tangan\n   - Kedua lutut\n   - Ujung kedua kaki\n3. Baca: "Subhana Rabbiyal Ala" (3 kali)\n4. Bangkit ucap "Allahu Akbar"\n5. Duduk sebentar, lalu sujud kedua'},
      6: {'title': 'Tasyahud dan Salam', 'content': 'Duduk terakhir:\n\n1. Baca At-Tahiyyat\n2. Baca Shalawat Ibrahimiyyah\n3. Baca doa sebelum salam\n4. Beri salam:\n   - Putar kanan: "Assalamu Alaikum Warahmatullah"\n   - Putar kiri: "Assalamu Alaikum Warahmatullah"\n\nSholat selesai!'},
      7: {'title': 'Dzikir Setelah Sholat', 'content': 'Dzikir yang dianjurkan:\n\n1. "Astaghfirullah" 3 kali\n2. Ayatul Kursi\n3. "Subhanallah" 33 kali\n4. "Alhamdulillah" 33 kali\n5. "Allahu Akbar" 33 kali'},
    },
    'ar': {
      1: {'title': 'شروط الصلاة', 'content': 'قبل الصلاة يجب توفر:\n\n1. الإسلام\n2. العقل والبلوغ\n3. الطهارة (الوضوء)\n4. طهارة الثوب والمكان\n5. استقبال القبلة\n6. دخول وقت الصلاة\n7. النية في القلب'},
      2: {'title': 'النية والتكبير', 'content': 'بدء الصلاة:\n\n1. قف مستقبلاً القبلة\n2. انوِ في قلبك\n3. ارفع يديك إلى أذنيك\n4. قل تكبيرة الإحرام: "الله أكبر"\n5. ضع اليمنى على اليسرى على الصدر'},
      3: {'title': 'القراءة في القيام', 'content': 'بعد التكبير اقرأ:\n\n1. دعاء الاستفتاح (مستحب)\n2. سورة الفاتحة (ركن في كل ركعة)\n3. سورة أو آيات إضافية\n\nبدون الفاتحة لا تصح الصلاة.'},
      4: {'title': 'الركوع', 'content': 'أداء الركوع:\n\n1. قل "الله أكبر" وأنت راكع\n2. استوِ في الركوع، يداك على ركبتيك\n3. قل: "سبحان ربي العظيم" (3 مرات)\n4. ارفع قائلاً: "سمع الله لمن حمده"\n5. قل: "ربنا لك الحمد"'},
      5: {'title': 'السجود', 'content': 'أداء السجود:\n\n1. قل "الله أكبر" وأنت نازل\n2. 7 أعضاء تلمس الأرض:\n   - الجبهة والأنف\n   - الكفان\n   - الركبتان\n   - أطراف القدمين\n3. قل: "سبحان ربي الأعلى" (3 مرات)\n4. ارفع قائلاً "الله أكبر"\n5. اجلس ثم اسجد ثانياً'},
      6: {'title': 'التشهد والسلام', 'content': 'الجلسة الأخيرة:\n\n1. اقرأ التحيات\n2. اقرأ الصلاة الإبراهيمية\n3. ادعُ قبل السلام\n4. أدِّ السلام:\n   - يميناً: "السلام عليكم ورحمة الله"\n   - يساراً: "السلام عليكم ورحمة الله"\n\nانتهت الصلاة!'},
      7: {'title': 'الأذكار بعد الصلاة', 'content': 'الأذكار المستحبة:\n\n1. "أستغفر الله" 3 مرات\n2. آية الكرسي\n3. "سبحان الله" 33 مرة\n4. "الحمد لله" 33 مرة\n5. "الله أكبر" 33 مرة'},
    },
    'ur': {
      1: {'title': 'نماز کی شرائط', 'content': 'نماز سے پہلے یہ شرائط ضروری ہیں:\n\n1. مسلمان ہونا\n2. عاقل اور بالغ ہونا\n3. پاکیزہ ہونا (وضو)\n4. کپڑے اور جگہ پاک ہو\n5. قبلہ رخ ہونا\n6. نماز کا وقت داخل ہو\n7. دل میں نیت'},
      2: {'title': 'نیت اور تکبیر', 'content': 'نماز شروع کرنا:\n\n1. قبلہ رخ کھڑے ہوں\n2. دل میں نیت کریں\n3. کانوں تک ہاتھ اٹھائیں\n4. تکبیر تحریمہ: "اللہ اکبر"\n5. سینے پر دائیں ہاتھ بائیں پر رکھیں'},
      3: {'title': 'قیام میں قرآت', 'content': 'تکبیر کے بعد پڑھیں:\n\n1. ثناء (سنت)\n2. سورہ فاتحہ (ہر رکعت میں فرض)\n3. اضافی سورہ یا آیات\n\nبغیر فاتحہ نماز نہیں ہوتی۔'},
      4: {'title': 'رکوع', 'content': 'رکوع کرنا:\n\n1. "اللہ اکبر" کہتے ہوئے جھکیں\n2. کمر سیدھی، ہاتھ گھٹنوں پر\n3. "سبحان ربی العظیم" (3 بار)\n4. "سمع اللہ لمن حمدہ" کہتے ہوئے اٹھیں\n5. "ربنا لک الحمد" کہیں'},
      5: {'title': 'سجدہ', 'content': 'سجدہ کرنا:\n\n1. "اللہ اکبر" کہتے ہوئے جھکیں\n2. 7 اعضاء زمین سے لگیں:\n   - پیشانی اور ناک\n   - دونوں ہتھیلیاں\n   - دونوں گھٹنے\n   - پاؤں کے انگلیاں\n3. "سبحان ربی الاعلی" (3 بار)\n4. "اللہ اکبر" کہتے اٹھیں'},
      6: {'title': 'تشہد اور سلام', 'content': 'آخری بیٹھک:\n\n1. التحیات پڑھیں\n2. درود ابراہیمی پڑھیں\n3. سلام سے پہلے دعا\n4. سلام پھیریں:\n   - دائیں: "السلام علیکم ورحمۃ اللہ"\n   - بائیں: "السلام علیکم ورحمۃ اللہ"\n\nنماز مکمل!'},
      7: {'title': 'نماز کے بعد اذکار', 'content': 'مستحب اذکار:\n\n1. "استغفر اللہ" 3 بار\n2. آیۃ الکرسی\n3. "سبحان اللہ" 33 بار\n4. "الحمد للہ" 33 بار\n5. "اللہ اکبر" 33 بار'},
    },
    'bn': {
      1: {'title': 'নামাজের শর্তসমূহ', 'content': 'নামাজের আগে শর্তসমূহ পূরণ করতে হবে:\n\n1. মুসলিম হওয়া\n2. সুস্থ মস্তিষ্ক ও প্রাপ্তবয়স্ক\n3. পবিত্র অবস্থায় থাকা (ওযু)\n4. কাপড় ও স্থান পবিত্র\n5. কিবলামুখী হওয়া\n6. নামাজের সময় হওয়া\n7. মনে নিয়ত করা'},
      2: {'title': 'নিয়ত ও তাকবির', 'content': 'নামাজ শুরু করা:\n\n1. কিবলামুখী হয়ে দাঁড়ান\n2. মনে নিয়ত করুন\n3. কানের লতি পর্যন্ত হাত তুলুন\n4. তাকবিরে তাহরিমা: "আল্লাহু আকবার"\n5. ডান হাত বাম হাতের উপর বুকে রাখুন'},
      3: {'title': 'দাঁড়ানো অবস্থায় তিলাওয়াত', 'content': 'তাকবিরের পরে পড়ুন:\n\n1. দোয়া ইফতিতাহ (সুন্নত)\n2. সূরা আল-ফাতিহা (প্রতি রাকাতে ওয়াজিব)\n3. অতিরিক্ত সূরা বা আয়াত\n\nআল-ফাতিহা ছাড়া নামাজ হয় না।'},
      4: {'title': 'রুকু', 'content': 'রুকু করা:\n\n1. "আল্লাহু আকবার" বলে ঝুঁকুন\n2. পিঠ সোজা, হাত হাঁটুতে\n3. "সুবহানা রব্বিয়াল আযীম" (৩ বার)\n4. "সামিআল্লাহু লিমান হামিদাহ" বলে উঠুন\n5. "রব্বানা লাকাল হামদ" বলুন'},
      5: {'title': 'সিজদাহ', 'content': 'সিজদাহ করা:\n\n1. "আল্লাহু আকবার" বলে নামুন\n2. ৭টি অঙ্গ মাটি স্পর্শ করবে:\n   - কপাল ও নাক\n   - উভয় হাতের তালু\n   - উভয় হাঁটু\n   - উভয় পায়ের আঙুল\n3. "সুবহানা রব্বিয়াল আলা" (৩ বার)\n4. "আল্লাহু আকবার" বলে উঠুন'},
      6: {'title': 'তাশাহহুদ ও সালাম', 'content': 'শেষ বৈঠক:\n\n1. আত-তাহিয়্যাত পড়ুন\n2. দরুদে ইবরাহিম পড়ুন\n3. সালামের আগে দোয়া\n4. সালাম ফেরান:\n   - ডানে: "আস-সালামু আলাইকুম ওয়া রাহমাতুল্লাহ"\n   - বামে: "আস-সালামু আলাইকুম ওয়া রাহমাতুল্লাহ"\n\nনামাজ সম্পন্ন!'},
      7: {'title': 'নামাজের পরের যিকির', 'content': 'সুপারিশকৃত যিকির:\n\n1. "আস্তাগফিরুল্লাহ" ৩ বার\n2. আয়াতুল কুরসী\n3. "সুবহানাল্লাহ" ৩৩ বার\n4. "আলহামদুলিল্লাহ" ৩৩ বার\n5. "আল্লাহু আকবার" ৩৩ বার'},
    },
  },
  'fasting': {
    'ms': {
      1: {'title': 'Kelebihan Puasa', 'content': 'Allah berfirman dalam Hadis Qudsi:\n"Setiap amalan anak Adam adalah untuknya kecuali puasa; ia untuk-Ku dan Aku yang membalasnya."\n\nKelebihan puasa:\n• Menyucikan jiwa dan badan\n• Mengajar kesabaran dan kawalan diri\n• Membangunkan empati terhadap golongan miskin\n• Ganjaran berlipat ganda dari Allah\n• Pintu Rayyan di Syurga hanya untuk orang yang berpuasa'},
      2: {'title': 'Syarat Puasa', 'content': 'Yang wajib berpuasa:\n• Muslim, berakal dan baligh\n• Sihat (tidak sakit teruk)\n• Tidak bermusafir\n\nYang dikecualikan:\n• Yang sakit - ganti kemudian\n• Musafir - ganti kemudian\n• Wanita hamil/menyusu - ganti atau bayar fidyah\n• Warga tua - bayar fidyah\n• Kanak-kanak - tidak wajib\n\nFidyah = memberi makan seorang fakir setiap hari yang ditinggalkan'},
      3: {'title': 'Perkara yang Membatalkan Puasa', 'content': 'Perkara yang batalkan puasa:\n• Makan atau minum dengan sengaja\n• Hubungan seksual\n• Muntah dengan sengaja\n• Haid atau nifas\n\nPerkara yang TIDAK batalkan puasa:\n• Makan atau minum secara tidak sengaja (lupa)\n• Berkumur atau menghirup air ke hidung\n• Suntikan (untuk tujuan perubatan)\n• Menggunakan titisan mata\n• Mencium pasangan (tanpa menelan)'},
      4: {'title': 'Adab Berpuasa', 'content': 'Amalan sunat semasa berpuasa:\n• Makan sahur (makan sebelum fajar)\n• Lewatkan sahur hingga hampir Subuh\n• Segera berbuka ketika Maghrib\n• Berbuka dengan kurma dan air\n• Perbanyak bacaan Al-Quran\n• Tingkatkan sedekah\n• Solat Tarawih\n• Elakkan kata-kata buruk dan pertengkaran\n• Banyak berdoa terutama waktu berbuka'},
      5: {'title': 'Puasa Sunat', 'content': 'Puasa sunat yang digalakkan:\n\n• 6 hari Syawal (selepas Ramadan)\n  → Seperti puasa setahun penuh\n• Isnin dan Khamis\n  → Nabi berpuasa pada hari ini\n• 3 Hari Putih (13, 14, 15 setiap bulan)\n• Hari Arafah (9 Zulhijjah)\n  → Menghapus dosa 2 tahun\n• Hari Asyura (10 Muharram)\n  → Menghapus dosa 1 tahun'},
      6: {'title': 'Lailatul Qadr', 'content': '"Malam Kemuliaan lebih baik daripada seribu bulan" (Al-Quran 97:3)\n\nFakta penting:\n• Jatuh pada 10 malam terakhir ganjil Ramadan (21, 23, 25, 27, 29)\n• Paling berkemungkinan malam ke-27\n• Malaikat turun dan kedamaian merata\n• Ibadat malam ini = ibadat 83 tahun\n\nCara mencarinya:\n• Solat Tarawih dan Tahajjud\n• Banyak membaca Al-Quran\n• Banyak berdoa\n• Bersedekah\n• Iktikaf (duduk di masjid)'},
      7: {'title': 'Zakat Fitrah', 'content': 'Zakat Fitrah adalah sedekah wajib di akhir Ramadan.\n\n"Nabi mewajibkan Zakat Fitrah sebagai penyucian bagi orang yang berpuasa dan sebagai makanan bagi golongan miskin."\n\nHukum:\n• Wajib ke atas setiap Muslim yang ada lebihan makanan\n• Kadar: 1 Sa (kira-kira 2.5-3 kg) makanan asasi atau nilai tunainya\n• Mesti dibayar sebelum solat Eid\n• Diberikan kepada fakir miskin\n\nTujuan:\n• Menyucikan orang yang berpuasa\n• Membawa kegembiraan kepada golongan miskin pada Eid'},
    },
    'id': {
      1: {'title': 'Keutamaan Puasa', 'content': 'Allah berfirman dalam Hadis Qudsi:\n"Setiap amalan anak Adam adalah untuknya kecuali puasa; itu untuk-Ku dan Aku yang membalasnya."\n\nKeutamaan puasa:\n• Menyucikan jiwa dan raga\n• Mengajarkan kesabaran dan pengendalian diri\n• Mengembangkan empati terhadap kaum miskin\n• Pahala berlipat ganda dari Allah\n• Pintu Rayyan di Surga hanya untuk orang yang berpuasa'},
      2: {'title': 'Syarat Puasa', 'content': 'Yang wajib berpuasa:\n• Muslim, berakal dan baligh\n• Sehat (tidak sakit parah)\n• Tidak dalam perjalanan\n\nYang dikecualikan:\n• Yang sakit - qadha kemudian\n• Musafir - qadha kemudian\n• Wanita hamil/menyusui - qadha atau bayar fidyah\n• Orang tua - bayar fidyah\n• Anak-anak - belum wajib\n\nFidyah = memberi makan seorang fakir setiap hari yang ditinggalkan'},
      3: {'title': 'Hal yang Membatalkan Puasa', 'content': 'Yang membatalkan puasa:\n• Makan atau minum dengan sengaja\n• Hubungan seksual\n• Muntah dengan sengaja\n• Haid atau nifas\n\nYang TIDAK membatalkan puasa:\n• Makan atau minum karena lupa\n• Berkumur atau menghirup air ke hidung\n• Suntikan (untuk tujuan medis)\n• Menggunakan tetes mata\n• Mencium pasangan (tanpa menelan)'},
      4: {'title': 'Adab Berpuasa', 'content': 'Amalan sunnah saat berpuasa:\n• Makan sahur (makan sebelum fajar)\n• Akhirkan sahur hingga hampir Subuh\n• Segera berbuka saat Maghrib\n• Berbuka dengan kurma dan air\n• Perbanyak bacaan Al-Quran\n• Tingkatkan sedekah\n• Sholat Tarawih\n• Hindari perkataan buruk dan pertengkaran\n• Banyak berdoa terutama waktu berbuka'},
      5: {'title': 'Puasa Sunnah', 'content': 'Puasa sunnah yang dianjurkan:\n\n• 6 hari Syawal (setelah Ramadhan)\n  → Seperti puasa setahun penuh\n• Senin dan Kamis\n  → Nabi berpuasa pada hari ini\n• 3 Hari Putih (13, 14, 15 setiap bulan)\n• Hari Arafah (9 Dzulhijjah)\n  → Menghapus dosa 2 tahun\n• Hari Asyura (10 Muharram)\n  → Menghapus dosa 1 tahun'},
      6: {'title': 'Lailatul Qadr', 'content': '"Malam Kemuliaan lebih baik dari seribu bulan" (Al-Quran 97:3)\n\nFakta penting:\n• Jatuh pada 10 malam terakhir ganjil Ramadhan (21, 23, 25, 27, 29)\n• Paling mungkin malam ke-27\n• Malaikat turun dan kedamaian merata\n• Ibadah malam ini = ibadah 83 tahun\n\nCara mencarinya:\n• Sholat Tarawih dan Tahajjud\n• Banyak membaca Al-Quran\n• Banyak berdoa\n• Bersedekah\n• Iktikaf (berdiam di masjid)'},
      7: {'title': 'Zakat Fitrah', 'content': 'Zakat Fitrah adalah sedekah wajib di akhir Ramadhan.\n\n"Nabi mewajibkan Zakat Fitrah sebagai penyucian bagi orang yang berpuasa dan sebagai makanan bagi golongan miskin."\n\nHukum:\n• Wajib bagi setiap Muslim yang memiliki kelebihan makanan\n• Kadar: 1 Sa (sekitar 2.5-3 kg) makanan pokok atau nilai uangnya\n• Harus dibayar sebelum sholat Eid\n• Diberikan kepada fakir miskin\n\nTujuan:\n• Menyucikan orang yang berpuasa\n• Membawa kebahagiaan bagi kaum miskin di Eid'},
    },
    'ar': {
      1: {'title': 'فضل الصيام', 'content': 'قال الله في الحديث القدسي:\n"كل عمل ابن آدم له إلا الصيام فإنه لي وأنا أجزي به."\n\nفضائل الصيام:\n• يطهر الروح والجسد\n• يعلم الصبر والضبط النفسي\n• ينمي التعاطف مع الفقراء\n• مضاعفة الثواب من الله\n• باب الريان في الجنة للصائمين فقط'},
      2: {'title': 'شروط الصيام', 'content': 'من يجب عليه الصوم:\n• مسلم، عاقل، بالغ\n• صحيح (غير مريض مرضاً شديداً)\n• غير مسافر\n\nالمعذورون:\n• المريض - يقضي لاحقاً\n• المسافر - يقضي لاحقاً\n• الحامل والمرضع - تقضي أو تفتدي\n• العجوز - يفتدي\n• الأطفال - غير واجب\n\nالفدية = إطعام مسكين عن كل يوم'},
      3: {'title': 'مبطلات الصيام', 'content': 'مبطلات الصيام:\n• الأكل والشرب عمداً\n• الجماع\n• التقيؤ عمداً\n• الحيض والنفاس\n\nما لا يفطر:\n• الأكل والشرب ناسياً\n• المضمضة والاستنشاق\n• الحقنة للعلاج\n• قطرة العين\n• تقبيل الزوجة دون ابتلاع'},
      4: {'title': 'آداب الصيام', 'content': 'السنن أثناء الصيام:\n• تناول السحور (الأكل قبل الفجر)\n• تأخير السحور حتى قرب الفجر\n• الإفطار فور المغرب\n• الإفطار على تمر وماء\n• الإكثار من قراءة القرآن\n• الإكثار من الصدقة\n• صلاة التراويح\n• تجنب الكلام السيئ والجدال\n• الإكثار من الدعاء خاصة عند الإفطار'},
      5: {'title': 'الصيام المستحب', 'content': 'الصيام المستحب:\n\n• 6 أيام من شوال (بعد رمضان)\n  ← كصيام السنة كاملة\n• الاثنين والخميس\n  ← كان النبي يصومهما\n• الأيام البيض (13 و14 و15 من كل شهر)\n• يوم عرفة (9 ذو الحجة)\n  ← يكفر ذنوب سنتين\n• يوم عاشوراء (10 محرم)\n  ← يكفر ذنوب سنة'},
      6: {'title': 'ليلة القدر', 'content': '"لَيْلَةُ الْقَدْرِ خَيْرٌ مِّنْ أَلْفِ شَهْرٍ" (القدر: 3)\n\nحقائق مهمة:\n• في العشر الأواخر الفردية من رمضان (21، 23، 25، 27، 29)\n• أرجحها ليلة 27\n• تنزل الملائكة وتسود السلامة\n• العبادة فيها = عبادة 83 سنة\n\nكيف تتحراها:\n• صلاة التراويح والتهجد\n• الإكثار من قراءة القرآن\n• الإكثار من الدعاء\n• الصدقة\n• الاعتكاف في المسجد'},
      7: {'title': 'زكاة الفطر', 'content': 'زكاة الفطر صدقة واجبة في ختام رمضان.\n\n"فرض رسول الله زكاة الفطر طهرة للصائم من اللغو والرفث وطعمة للمساكين."\n\nالأحكام:\n• واجبة على كل مسلم يملك فضلاً عن قوته\n• المقدار: صاع (2.5-3 كجم تقريباً) من الطعام الأساسي أو ما يعادله\n• تُخرج قبل صلاة العيد\n• تُعطى للفقراء والمساكين\n\nالغرض:\n• تطهير الصائم\n• إدخال السرور على الفقراء في العيد'},
    },
    'ur': {
      1: {'title': 'روزے کی فضیلت', 'content': 'اللہ نے حدیث قدسی میں فرمایا:\n"ابن آدم کا ہر عمل اس کے لیے ہے سوائے روزے کے، وہ میرے لیے ہے اور میں ہی اس کا بدلہ دوں گا۔"\n\nروزے کی فضیلتیں:\n• روح اور جسم کو پاک کرتا ہے\n• صبر اور نفس پر قابو سکھاتا ہے\n• غریبوں سے ہمدردی پیدا کرتا ہے\n• اللہ کی طرف سے کئی گنا اجر\n• جنت میں ریان کا دروازہ صرف روزہ داروں کے لیے'},
      2: {'title': 'روزے کی شرائط', 'content': 'جن پر روزہ فرض ہے:\n• مسلمان، عاقل اور بالغ\n• صحت مند (شدید بیمار نہ ہو)\n• مسافر نہ ہو\n\nمعذور افراد:\n• بیمار - بعد میں قضا\n• مسافر - بعد میں قضا\n• حاملہ/دودھ پلانے والی - قضا یا فدیہ\n• بوڑھا - فدیہ\n• بچے - واجب نہیں\n\nفدیہ = ہر چھوٹے روزے کے بدلے ایک مسکین کو کھانا'},
      3: {'title': 'روزہ توڑنے والی چیزیں', 'content': 'روزہ توڑنے والی چیزیں:\n• جان بوجھ کر کھانا پینا\n• جنسی تعلق\n• جان بوجھ کر قے کرنا\n• حیض یا نفاس\n\nجو روزہ نہیں توڑتیں:\n• بھول کر کھانا پینا\n• کلی یا ناک میں پانی ڈالنا\n• علاج کے لیے انجیکشن\n• آنکھ کے قطرے\n• بیوی کا بوسہ (نگلنے کے بغیر)'},
      4: {'title': 'روزے کے آداب', 'content': 'روزے کے دوران سنت اعمال:\n• سحری کھانا (فجر سے پہلے)\n• سحری کو فجر کے قریب تک مؤخر کرنا\n• مغرب کے وقت فوری افطار\n• کھجور اور پانی سے افطار\n• قرآن کی کثرت سے تلاوت\n• صدقہ بڑھانا\n• تراویح پڑھنا\n• بری باتوں اور جھگڑے سے بچنا\n• کثرت سے دعا خاص طور پر افطار کے وقت'},
      5: {'title': 'نفل روزے', 'content': 'مستحب نفل روزے:\n\n• شوال کے 6 روزے (رمضان کے بعد)\n  ← پورے سال روزے رکھنے کے برابر\n• پیر اور جمعرات\n  ← نبی ان دنوں روزہ رکھتے تھے\n• ایام بیض (ہر مہینے کی 13، 14، 15)\n• عرفہ کا روزہ (9 ذی الحجہ)\n  ← دو سال کے گناہ معاف\n• عاشورہ کا روزہ (10 محرم)\n  ← ایک سال کے گناہ معاف'},
      6: {'title': 'لیلۃ القدر', 'content': '"شب قدر ہزار مہینوں سے بہتر ہے" (القرآن 97:3)\n\naہم حقائق:\n• رمضان کے آخری 10 طاق راتوں میں (21، 23، 25، 27، 29)\n• سب سے زیادہ امکان 27ویں رات\n• فرشتے اترتے ہیں اور سلامتی چھا جاتی ہے\n• اس رات کی عبادت = 83 سال کی عبادت\n\nتلاش کیسے کریں:\n• تراویح اور تہجد پڑھیں\n• کثرت سے قرآن پڑھیں\n• کثرت سے دعا کریں\n• صدقہ کریں\n• اعتکاف (مسجد میں بیٹھنا)'},
      7: {'title': 'زکاۃ الفطر', 'content': 'زکاۃ الفطر رمضان کے اختتام پر واجب صدقہ ہے۔\n\n"نبی نے زکاۃ الفطر روزہ دار کو لغو اور فحش باتوں سے پاک کرنے اور مساکین کے لیے کھانے کے طور پر مقرر فرمایا۔"\n\nاحکام:\n• ہر اس مسلمان پر واجب جو اپنی ضرورت سے زیادہ کھانا رکھتا ہو\n• مقدار: 1 صاع (تقریباً 2.5-3 کلو) بنیادی غذا یا اس کی قیمت\n• عید کی نماز سے پہلے ادا کی جائے\n• فقراء اور مساکین کو دی جائے\n\nمقصد:\n• روزہ دار کو پاک کرنا\n• عید پر غریبوں کو خوشی دینا'},
    },
    'bn': {
      1: {'title': 'রোজার ফযীলত', 'content': 'আল্লাহ হাদিসে কুদসীতে বলেছেন:\n"আদম সন্তানের প্রতিটি আমল তার জন্য, রোজা ছাড়া; তা আমার জন্য এবং আমিই তার প্রতিদান দেব।"\n\nরোজার ফযীলত:\n• আত্মা ও শরীর পবিত্র করে\n• ধৈর্য ও আত্মনিয়ন্ত্রণ শেখায়\n• গরিবদের প্রতি সহানুভূতি জাগায়\n• আল্লাহর পক্ষ থেকে বহুগুণ পুরস্কার\n• জান্নাতের রাইয়ান দরজা শুধু রোজাদারদের জন্য'},
      2: {'title': 'রোজার শর্তসমূহ', 'content': 'যাদের উপর রোজা ফরজ:\n• মুসলিম, সুস্থ মস্তিষ্ক ও প্রাপ্তবয়স্ক\n• সুস্বাস্থ্য (মারাত্মক অসুস্থ নয়)\n• মুসাফির নয়\n\nযারা মাফ:\n• অসুস্থ - পরে কাজা\n• মুসাফির - পরে কাজা\n• গর্ভবতী/দুধপানকারী - কাজা বা ফিদিয়া\n• বৃদ্ধ - ফিদিয়া\n• শিশু - ফরজ নয়\n\nফিদিয়া = প্রতিটি মিস করা রোজার জন্য একজন গরিবকে খাওয়ানো'},
      3: {'title': 'রোজা ভাঙার কারণ', 'content': 'যা রোজা ভাঙে:\n• ইচ্ছাকৃত খাওয়া বা পান করা\n• যৌন সম্পর্ক\n• ইচ্ছাকৃত বমি করা\n• হায়েয বা নিফাস\n\nযা রোজা ভাঙে না:\n• ভুলে খাওয়া বা পান করা\n• কুলি বা নাকে পানি দেওয়া\n• চিকিৎসার জন্য ইনজেকশন\n• চোখের ড্রপ ব্যবহার\n• স্ত্রীকে চুম্বন (গিলে না ফেললে)'},
      4: {'title': 'রোজার আদব', 'content': 'রোজার সময় সুন্নত আমল:\n• সাহরি খাওয়া (ফজরের আগে)\n• সাহরি ফজরের কাছ পর্যন্ত দেরি করা\n• মাগরিবে সঙ্গে সঙ্গে ইফতার\n• খেজুর ও পানি দিয়ে ইফতার\n• বেশি বেশি কুরআন তিলাওয়াত\n• সদকা বাড়ানো\n• তারাবির নামাজ\n• খারাপ কথা ও ঝগড়া থেকে বিরত\n• বেশি বেশি দোয়া বিশেষত ইফতারের সময়'},
      5: {'title': 'নফল রোজা', 'content': 'প্রস্তাবিত নফল রোজা:\n\n• শাওয়ালের ৬ রোজা (রমজানের পরে)\n  ← পুরো বছর রোজার সমান\n• সোমবার ও বৃহস্পতিবার\n  ← নবী এই দিনগুলোতে রোজা রাখতেন\n• আইয়ামে বিজ (প্রতি মাসের ১৩, ১৪, ১৫)\n• আরাফার দিন (৯ জিলহজ)\n  ← দুই বছরের গুনাহ মাফ\n• আশুরার দিন (১০ মুহাররম)\n  ← এক বছরের গুনাহ মাফ'},
      6: {'title': 'লাইলাতুল কদর', 'content': '"শবে কদর হাজার মাসের চেয়ে উত্তম" (কুরআন ৯৭:৩)\n\nগুরুত্বপূর্ণ তথ্য:\n• রমজানের শেষ ১০ বিজোড় রাতে (২১, ২৩, ২৫, ২৭, ২৯)\n• সবচেয়ে বেশি সম্ভাবনা ২৭তম রাতে\n• ফেরেশতারা নামেন এবং শান্তি বিরাজ করে\n• এই রাতের ইবাদত = ৮৩ বছরের ইবাদত\n\nকীভাবে খুঁজবেন:\n• তারাবি ও তাহাজ্জুদ পড়ুন\n• বেশি বেশি কুরআন পড়ুন\n• বেশি বেশি দোয়া করুন\n• সদকা দিন\n• ইতিকাফ (মসজিদে অবস্থান)'},
      7: {'title': 'যাকাতুল ফিতর', 'content': 'যাকাতুল ফিতর রমজানের শেষে ওয়াজিব সদকা।\n\n"নবী যাকাতুল ফিতর নির্ধারণ করেছেন রোজাদারকে অনর্থক কথা ও অশ্লীলতা থেকে পবিত্র করতে এবং গরিবদের খাবার হিসেবে।"\n\nবিধান:\n• প্রতিটি মুসলিমের উপর ওয়াজিব যার প্রয়োজনের বাইরে খাবার আছে\n• পরিমাণ: ১ সা (প্রায় ২.৫-৩ কেজি) প্রধান খাবার বা সমপরিমাণ অর্থ\n• ঈদের নামাজের আগে আদায় করতে হবে\n• গরিব ও অভাবীদের দিতে হবে\n\nউদ্দেশ্য:\n• রোজাদারকে পবিত্র করা\n• ঈদে গরিবদের আনন্দ দেওয়া'},
    },
  },
  'special_prayer': {
    'ms': {
      1: {'title': 'Solat Eidulfitri', 'content': 'Solat Aidilfitri dilakukan pada 1 Syawal selepas Ramadan.\n\nHukum: Sunat Muakkadah\n\nCara solat:\n1. Niat solat Eid\n2. Takbiratul Ihram\n3. Rakaat pertama: 7 takbir tambahan\n4. Baca Al-Fatihah + Surah Al-Ala\n5. Rakaat kedua: 5 takbir tambahan\n6. Baca Al-Fatihah + Surah Al-Ghashiyah\n7. Imam sampaikan 2 khutbah selepas solat\n\nSunat Eid:\n• Makan sebelum pergi solat Eidulfitri\n• Mandi dan pakai pakaian terbaik\n• Baca takbir dalam perjalanan\n• Ambil jalan berbeza pergi dan balik'},
      2: {'title': 'Solat Eiduladha', 'content': 'Solat Aidiladha dilakukan pada 10 Zulhijjah.\n\nCara sama seperti solat Eidulfitri.\n\nPerbezaan:\n• JANGAN makan sebelum solat (sunat makan selepas)\n• Qurban dilakukan selepas solat\n• Hari qurban: 10, 11, 12, 13 Zulhijjah\n\nHukum qurban:\n• Sunat Muakkadah bagi yang mampu\n• Haiwan: unta, lembu, kerbau, kambing, biri-biri\n• Daging dibahagi 3 bahagian:\n  - Untuk diri sendiri dan keluarga\n  - Untuk sanak saudara dan rakan\n  - Untuk fakir miskin'},
      3: {'title': 'Solat Jenazah', 'content': 'Solat jenazah adalah Fardhu Kifayah.\n\nSyarat:\n• Si mati mestilah Muslim\n• Jenazah mesti dimandikan dan dikafankan\n\nCara solat:\n1. Berdiri menghadap kiblat\n2. Takbir pertama: baca Al-Fatihah\n3. Takbir kedua: baca selawat ke atas Nabi\n4. Takbir ketiga: baca doa untuk si mati\n   "Allahummaghfir lahu warhamhu wa afihi wa\'fu anhu"\n5. Takbir keempat: doa pendek atau diam\n6. Beri salam kanan dan kiri\n\nCatatan:\n• Tiada rukuk atau sujud\n• Semua dilakukan dalam keadaan berdiri'},
      4: {'title': 'Solat Tarawih', 'content': 'Tarawih ialah solat malam khas pada bulan Ramadan.\n\nHukum: Sunat Muakkadah\n\nBilangan rakaat:\n• Paling umum: 20 rakaat\n• Juga sah: 8 rakaat\n• Witir: 1 atau 3 rakaat di akhir\n\nCara:\n• Solat 2 rakaat setiap set\n• Rehat pendek (tarwihah) antara set\n• Khatam Al-Quran dalam Ramadan\n\nKelebihan:\n• "Sesiapa yang mendirikan solat Ramadan dengan iman dan mengharap pahala, diampunkan dosanya yang lalu" (Bukhari)'},
      5: {'title': 'Solat Istisqa', 'content': 'Solat Istisqa dilakukan untuk memohon hujan semasa kemarau.\n\nCara:\n• 2 rakaat seperti solat Eid\n• Imam sampaikan 2 khutbah\n• Perbanyak doa dan istighfar\n• Hadap kiblat semasa berdoa\n\nDoa Istisqa:\n"Allahummasqina ghaysan mughithan marian marian nafian ghayra dharr"\n\nSyarat doa dimakbulkan:\n• Taubat sebelum solat\n• Bersedekah kepada fakir\n• Selesaikan pertikaian dan kezaliman'},
      6: {'title': 'Solat Kusuf/Khusuf', 'content': '"Matahari dan bulan adalah dua tanda dari tanda-tanda Allah. Ia tidak berlaku gerhana kerana kematian sesiapa." (Bukhari)\n\nKusuf = Gerhana matahari\nKhusuf = Gerhana bulan\n\nCara (unik, berbeza dari solat biasa):\n1. Rakaat pertama:\n   - Baca Al-Fatihah + surah panjang\n   - Rukuk panjang\n   - Bangun dari rukuk\n   - Baca Al-Fatihah + surah lagi (lebih pendek)\n   - Rukuk panjang kedua\n   - Bangun, kemudian sujud 2 kali\n2. Rakaat kedua: sama seperti rakaat pertama\n\nTempoh: Teruskan sehingga gerhana berakhir'},
    },
    'id': {
      1: {'title': 'Sholat Idul Fitri', 'content': 'Sholat Idul Fitri dilakukan pada 1 Syawal setelah Ramadhan.\n\nHukum: Sunnah Muakkadah\n\nCara sholat:\n1. Niat sholat Ied\n2. Takbiratul Ihram\n3. Rakaat pertama: 7 takbir tambahan\n4. Baca Al-Fatihah + Surah Al-Ala\n5. Rakaat kedua: 5 takbir tambahan\n6. Baca Al-Fatihah + Surah Al-Ghashiyah\n7. Imam menyampaikan 2 khutbah setelah sholat\n\nSunnah Eid:\n• Makan sebelum sholat Idul Fitri\n• Mandi dan pakai pakaian terbaik\n• Baca takbir dalam perjalanan\n• Ambil jalan berbeda pergi dan pulang'},
      2: {'title': 'Sholat Idul Adha', 'content': 'Sholat Idul Adha dilakukan pada 10 Dzulhijjah.\n\nCara sama seperti sholat Idul Fitri.\n\nPerbedaan:\n• JANGAN makan sebelum sholat\n• Qurban dilakukan setelah sholat\n• Hari qurban: 10, 11, 12, 13 Dzulhijjah\n\nHukum qurban:\n• Sunnah Muakkadah bagi yang mampu\n• Hewan: unta, sapi, kerbau, kambing, domba\n• Daging dibagi 3 bagian:\n  - Untuk diri sendiri dan keluarga\n  - Untuk kerabat dan teman\n  - Untuk fakir miskin'},
      3: {'title': 'Sholat Jenazah', 'content': 'Sholat jenazah adalah Fardhu Kifayah.\n\nSyarat:\n• Jenazah harus Muslim\n• Jenazah harus dimandikan dan dikafankan\n\nCara sholat:\n1. Berdiri menghadap kiblat\n2. Takbir pertama: baca Al-Fatihah\n3. Takbir kedua: baca shalawat atas Nabi\n4. Takbir ketiga: baca doa untuk jenazah\n   "Allahummaghfir lahu warhamhu wa afihi wa\'fu anhu"\n5. Takbir keempat: doa pendek atau diam\n6. Salam kanan dan kiri\n\nCatatan:\n• Tidak ada ruku atau sujud\n• Semua dilakukan dalam posisi berdiri'},
      4: {'title': 'Sholat Tarawih', 'content': 'Tarawih adalah sholat malam khusus di bulan Ramadhan.\n\nHukum: Sunnah Muakkadah\n\nJumlah rakaat:\n• Paling umum: 20 rakaat\n• Juga sah: 8 rakaat\n• Witir: 1 atau 3 rakaat di akhir\n\nCara:\n• Sholat 2 rakaat setiap set\n• Istirahat pendek (tarwihah) antar set\n• Khatam Al-Quran dalam Ramadhan\n\nKeutamaan:\n• "Barangsiapa mendirikan sholat Ramadhan dengan iman dan mengharap pahala, diampuni dosanya yang lalu" (Bukhari)'},
      5: {'title': 'Sholat Istisqa', 'content': 'Sholat Istisqa dilakukan untuk memohon hujan saat kemarau.\n\nCara:\n• 2 rakaat seperti sholat Eid\n• Imam menyampaikan 2 khutbah\n• Perbanyak doa dan istighfar\n• Hadap kiblat saat berdoa\n\nDoa Istisqa:\n"Allahummasqina ghaysan mughitsan marian marian nafian ghayra dharr"\n\nSyarat doa dikabulkan:\n• Taubat sebelum sholat\n• Bersedekah kepada fakir\n• Selesaikan perselisihan dan kezaliman'},
      6: {'title': 'Sholat Kusuf/Khusuf', 'content': '"Matahari dan bulan adalah dua tanda dari tanda-tanda Allah. Keduanya tidak mengalami gerhana karena kematian seseorang." (Bukhari)\n\nKusuf = Gerhana matahari\nKhusuf = Gerhana bulan\n\nCara (unik, berbeda dari sholat biasa):\n1. Rakaat pertama:\n   - Baca Al-Fatihah + surah panjang\n   - Ruku panjang\n   - Bangkit dari ruku\n   - Baca Al-Fatihah + surah lagi (lebih pendek)\n   - Ruku panjang kedua\n   - Bangkit, kemudian sujud 2 kali\n2. Rakaat kedua: sama seperti rakaat pertama\n\nDurasi: Teruskan sampai gerhana berakhir'},
    },
    'ar': {
      1: {'title': 'صلاة عيد الفطر', 'content': 'تُؤدَّى صلاة عيد الفطر في أول شوال بعد رمضان.\n\nالحكم: سنة مؤكدة\n\nطريقة الصلاة:\n1. النية لصلاة العيد\n2. تكبيرة الإحرام\n3. الركعة الأولى: 7 تكبيرات إضافية\n4. قراءة الفاتحة + سورة الأعلى\n5. الركعة الثانية: 5 تكبيرات إضافية\n6. قراءة الفاتحة + سورة الغاشية\n7. خطبتان بعد الصلاة\n\nسنن العيد:\n• الأكل قبل صلاة عيد الفطر\n• الاغتسال ولبس أحسن الثياب\n• قراءة التكبير في الطريق\n• المجيء والعودة من طريقين مختلفين'},
      2: {'title': 'صلاة عيد الأضحى', 'content': 'تُؤدَّى صلاة عيد الأضحى في العاشر من ذي الحجة.\n\nالطريقة كصلاة عيد الفطر.\n\nالفروق:\n• لا تأكل قبل الصلاة (السنة الأكل بعدها)\n• الأضحية بعد الصلاة\n• أيام النحر: 10، 11، 12، 13 ذو الحجة\n\nالأضحية:\n• سنة مؤكدة لمن يستطيع\n• الأنعام: إبل، بقر، غنم\n• تقسيم اللحم 3 أجزاء:\n  - لنفسه وعائلته\n  - للأقارب والأصدقاء\n  - للفقراء والمساكين'},
      3: {'title': 'صلاة الجنازة', 'content': 'صلاة الجنازة فرض كفاية.\n\nالشروط:\n• أن يكون الميت مسلماً\n• أن يُغسَّل ويُكفَّن\n\nطريقة الصلاة:\n1. الوقوف مستقبل القبلة\n2. التكبيرة الأولى: قراءة الفاتحة\n3. التكبيرة الثانية: الصلاة على النبي\n4. التكبيرة الثالثة: الدعاء للميت\n   "اللهم اغفر له وارحمه وعافه واعف عنه"\n5. التكبيرة الرابعة: دعاء قصير أو سكوت\n6. التسليم يميناً وشمالاً\n\nملاحظة:\n• لا ركوع ولا سجود\n• كل شيء في القيام'},
      4: {'title': 'صلاة التراويح', 'content': 'التراويح صلاة الليل الخاصة في رمضان.\n\nالحكم: سنة مؤكدة\n\nعدد الركعات:\n• الأشهر: 20 ركعة\n• يجوز أيضاً: 8 ركعات\n• الوتر: 1 أو 3 ركعات في النهاية\n\nالطريقة:\n• صلاة ركعتين في كل مجموعة\n• استراحة قصيرة بين المجموعات\n• ختم القرآن في رمضان\n\nالفضل:\n• "من قام رمضان إيماناً واحتساباً غُفر له ما تقدم من ذنبه" (البخاري)'},
      5: {'title': 'صلاة الاستسقاء', 'content': 'صلاة الاستسقاء تُؤدَّى لطلب المطر في أوقات الجفاف.\n\nالطريقة:\n• ركعتان كصلاة العيد\n• الإمام يخطب خطبتين\n• الإكثار من الدعاء والاستغفار\n• استقبال القبلة عند الدعاء\n\nدعاء الاستسقاء:\n"اللهم أسقنا غيثاً مغيثاً مريئاً مريئاً نافعاً غير ضار"\n\nشروط إجابة الدعاء:\n• التوبة قبل الصلاة\n• الصدقة على الفقراء\n• إزالة الظلم والمظالم'},
      6: {'title': 'صلاة الكسوف والخسوف', 'content': '"الشمس والقمر آيتان من آيات الله لا يخسفان لموت أحد" (البخاري)\n\nالكسوف = كسوف الشمس\nالخسوف = خسوف القمر\n\nالطريقة (مميزة):\n1. الركعة الأولى:\n   - قراءة الفاتحة + سورة طويلة\n   - ركوع طويل\n   - الرفع من الركوع\n   - قراءة الفاتحة + سورة مرة أخرى\n   - ركوع طويل ثانٍ\n   - الرفع ثم السجود\n2. الركعة الثانية: كالأولى\n\nالمدة: تستمر حتى ينتهي الخسوف'},
    },
    'ur': {
      1: {'title': 'عید الفطر کی نماز', 'content': 'عید الفطر کی نماز یکم شوال کو رمضان کے بعد پڑھی جاتی ہے۔\n\nحکم: سنت مؤکدہ\n\nنماز کا طریقہ:\n1. عید کی نماز کی نیت\n2. تکبیر تحریمہ\n3. پہلی رکعت: 7 اضافی تکبیریں\n4. الفاتحہ + سورۃ الاعلی\n5. دوسری رکعت: 5 اضافی تکبیریں\n6. الفاتحہ + سورۃ الغاشیہ\n7. نماز کے بعد 2 خطبے\n\nعید کی سنتیں:\n• عید الفطر کی نماز سے پہلے کچھ کھانا\n• غسل اور بہترین لباس\n• راستے میں تکبیر پڑھنا\n• آتے جاتے مختلف راستہ'},
      2: {'title': 'عید الاضحیٰ کی نماز', 'content': '10 ذوالحجہ کو عید الاضحیٰ کی نماز پڑھی جاتی ہے۔\n\nطریقہ عید الفطر جیسا۔\n\nفرق:\n• نماز سے پہلے نہ کھائیں\n• قربانی نماز کے بعد\n• قربانی کے دن: 10، 11، 12، 13 ذوالحجہ\n\nقربانی:\n• صاحب استطاعت پر سنت مؤکدہ\n• جانور: اونٹ، گائے، بھینس، بکرا، بھیڑ\n• گوشت 3 حصوں میں:\n  - اپنے اور گھر والوں کے لیے\n  - رشتہ داروں اور دوستوں کے لیے\n  - غریبوں کے لیے'},
      3: {'title': 'نماز جنازہ', 'content': 'نماز جنازہ فرض کفایہ ہے۔\n\nشرائط:\n• میت مسلمان ہو\n• غسل اور کفن دیا گیا ہو\n\nطریقہ:\n1. قبلہ رخ کھڑے ہوں\n2. پہلی تکبیر: الفاتحہ\n3. دوسری تکبیر: نبی پر درود\n4. تیسری تکبیر: میت کے لیے دعا\n   "اللہم اغفر لہ وارحمہ وعافہ واعف عنہ"\n5. چوتھی تکبیر: مختصر دعا یا خاموشی\n6. دائیں بائیں سلام\n\nنوٹ:\n• رکوع یا سجدہ نہیں\n• سب کھڑے ہو کر'},
      4: {'title': 'نماز تراویح', 'content': 'تراویح رمضان کی خصوصی رات کی نماز ہے۔\n\nحکم: سنت مؤکدہ\n\nرکعات:\n• سب سے عام: 20 رکعات\n• یہ بھی جائز: 8 رکعات\n• وتر: آخر میں 1 یا 3 رکعات\n\nطریقہ:\n• 2 رکعات کا ہر سیٹ\n• سیٹوں کے درمیان مختصر آرام\n• رمضان میں قرآن ختم\n\nفضیلت:\n• "جو رمضان میں ایمان اور ثواب کی نیت سے قیام کرے اس کے پچھلے گناہ معاف" (بخاری)'},
      5: {'title': 'نماز استسقاء', 'content': 'نماز استسقاء قحط کے وقت بارش مانگنے کے لیے پڑھی جاتی ہے۔\n\nطریقہ:\n• 2 رکعات عید جیسی\n• امام 2 خطبے دیتا ہے\n• کثرت سے دعا اور استغفار\n• دعا کے وقت قبلہ رخ\n\nدعا:\n"اللہم اسقنا غیثاً مغیثاً مریئاً نافعاً غیر ضار"\n\nقبولیت کی شرائط:\n• نماز سے پہلے توبہ\n• فقراء کو صدقہ\n• ظلم اور جھگڑوں کا ازالہ'},
      6: {'title': 'نماز کسوف/خسوف', 'content': '"سورج اور چاند اللہ کی نشانیوں میں سے دو نشانیاں ہیں، کسی کی موت سے گرہن نہیں لگتا" (بخاری)\n\nکسوف = سورج گرہن\nخسوف = چاند گرہن\n\nطریقہ (منفرد):\n1. پہلی رکعت:\n   - الفاتحہ + لمبی سورت\n   - لمبا رکوع\n   - رکوع سے اٹھنا\n   - الفاتحہ + سورت پھر\n   - دوسرا لمبا رکوع\n   - اٹھنا، پھر 2 سجدے\n2. دوسری رکعت: پہلی جیسی\n\nمدت: گرہن ختم ہونے تک'},
    },
    'bn': {
      1: {'title': 'ঈদুল ফিতরের নামাজ', 'content': 'ঈদুল ফিতরের নামাজ রমজানের পর ১ শাওয়ালে পড়া হয়।\n\nহুকুম: সুন্নতে মুআক্কাদাহ\n\nনামাজের পদ্ধতি:\n1. ঈদের নামাজের নিয়ত\n2. তাকবিরে তাহরিমা\n3. প্রথম রাকাত: ৭টি অতিরিক্ত তাকবির\n4. আল-ফাতিহা + সূরা আল-আলা\n5. দ্বিতীয় রাকাত: ৫টি অতিরিক্ত তাকবির\n6. আল-ফাতিহা + সূরা আল-গাশিয়াহ\n7. নামাজের পর ২টি খুতবা\n\nঈদের সুন্নত:\n• ঈদুল ফিতরের নামাজের আগে খাওয়া\n• গোসল ও সুন্দর পোশাক\n• পথে তাকবির পড়া\n• যাওয়া-আসার পথ আলাদা রাখা'},
      2: {'title': 'ঈদুল আযহার নামাজ', 'content': '১০ জিলহজে ঈদুল আযহার নামাজ পড়া হয়।\n\nপদ্ধতি ঈদুল ফিতরের মতো।\n\nপার্থক্য:\n• নামাজের আগে না খাওয়া\n• নামাজের পর কুরবানি\n• কুরবানির দিন: ১০, ১১, ১২, ১৩ জিলহজ\n\nকুরবানি:\n• সামর্থ্যবানের জন্য সুন্নতে মুআক্কাদাহ\n• পশু: উট, গরু, মহিষ, ছাগল, ভেড়া\n• গোশত ৩ ভাগে:\n  - নিজের ও পরিবারের জন্য\n  - আত্মীয় ও বন্ধুদের জন্য\n  - গরিবদের জন্য'},
      3: {'title': 'জানাজার নামাজ', 'content': 'জানাজার নামাজ ফরজে কিফায়া।\n\nশর্ত:\n• মৃত ব্যক্তি মুসলিম হতে হবে\n• গোসল ও কাফন দেওয়া হতে হবে\n\nপদ্ধতি:\n1. কিবলামুখী দাঁড়ান\n2. প্রথম তাকবির: আল-ফাতিহা\n3. দ্বিতীয় তাকবির: নবীর উপর দরুদ\n4. তৃতীয় তাকবির: মৃতের জন্য দোয়া\n   "আল্লাহুম্মাগফিরলাহু ওয়ারহামহু ওয়াআফিহি ওয়াআফু আনহু"\n5. চতুর্থ তাকবির: সংক্ষিপ্ত দোয়া বা নীরবতা\n6. ডানে বামে সালাম\n\nবিশেষ:\n• রুকু বা সিজদা নেই\n• সব দাঁড়িয়ে'},
      4: {'title': 'তারাবির নামাজ', 'content': 'তারাবি রমজানের বিশেষ রাতের নামাজ।\n\nহুকুম: সুন্নতে মুআক্কাদাহ\n\nরাকাত সংখ্যা:\n• সবচেয়ে প্রচলিত: ২০ রাকাত\n• এটিও সহিহ: ৮ রাকাত\n• বিতর: শেষে ১ বা ৩ রাকাত\n\nপদ্ধতি:\n• প্রতি সেটে ২ রাকাত\n• সেটের মাঝে সংক্ষিপ্ত বিশ্রাম\n• রমজানে কুরআন খতম\n\nফযীলত:\n• "যে ঈমান ও সওয়াবের আশায় রমজানে কিয়াম করে তার আগের গুনাহ মাফ" (বুখারি)'},
      5: {'title': 'ইস্তিসকার নামাজ', 'content': 'খরার সময় বৃষ্টির জন্য ইস্তিসকার নামাজ পড়া হয়।\n\nপদ্ধতি:\n• ঈদের মতো ২ রাকাত\n• ইমাম ২টি খুতবা দেন\n• বেশি বেশি দোয়া ও ইস্তিগফার\n• দোয়ার সময় কিবলামুখী\n\nদোয়া:\n"আল্লাহুম্মাসকিনা গাইসান মুগিসান মারিআন নাফিআন গাইরা দার্র"\n\nদোয়া কবুলের শর্ত:\n• নামাজের আগে তাওবা\n• গরিবদের সদকা\n• জুলুম ও ঝগড়া নিরসন'},
      6: {'title': 'কুসুফ/খুসুফের নামাজ', 'content': '"সূর্য ও চাঁদ আল্লাহর নিদর্শনের দুটি নিদর্শন। কারো মৃত্যুতে গ্রহণ হয় না।" (বুখারি)\n\nকুসুফ = সূর্যগ্রহণ\nখুসুফ = চন্দ্রগ্রহণ\n\nপদ্ধতি (অনন্য):\n1. প্রথম রাকাত:\n   - আল-ফাতিহা + লম্বা সূরা\n   - দীর্ঘ রুকু\n   - রুকু থেকে উঠা\n   - আল-ফাতিহা + সূরা আবার\n   - দ্বিতীয় দীর্ঘ রুকু\n   - উঠে ২টি সিজদাহ\n2. দ্বিতীয় রাকাত: প্রথমের মতো\n\nসময়কাল: গ্রহণ শেষ না হওয়া পর্যন্ত'},
    },
  },
};
const Map<String, Map<int, Map<String, String>>> kLessonTransliterations = {
  'pillars': {
    1: {'latin': 'La ilaha illallahu Muhammadur Rasulullah', 'th': 'ลา อิลาฮะ อิลลัลลอฮุ มุฮัมมะดัน เราะซูลุลลอฮ์'},
    2: {'latin': 'As-salatu imadud-din', 'th': 'อัศศอลาตุ อิมาดุดดีน'},
    3: {'latin': 'Wa aqimus-salata wa atuz-zakata', 'th': 'วะ อะกีมุศ ศอลาตะ วะ อาตุซ ซะกาต'},
    4: {'latin': 'Shahru Ramadanal-ladhi unzila fihil-Quran', 'th': 'ชะฮ์รุ รอมะฎอนัลลาซี อุนซิละ ฟีฮิล กุรอาน'},
    5: {'latin': 'Walillahi alan-nasi hijjul-bayt', 'th': 'วะลิลลาฮิ อะลันนาสิ ฮิจญุล บัยต์'},
  },
  'iman': {
    1: {'latin': 'Qul Huwallahu Ahad', 'th': 'กุล ฮุวัลลอฮุ อะฮัด'},
    2: {'latin': 'Wal-malaikati wal-kitabi wan-nabiyyin', 'th': 'วัลมะลาอิกะติ วัลกิตาบิ วันนะบิยยีน'},
    3: {'latin': 'Inna nahnu nazzalnadh-dhikra wa inna lahu lahafidhun', 'th': 'อินนา นะฮ์นุ นัซซัลนาซ ซิกรอ วะอินนา ละฮู ละฮาฟิซูน'},
    4: {'latin': 'Lakin Rasulallahi wa khataman-nabiyyin', 'th': 'ลากิน เราะซูลัลลอฮิ วะคอตะมันนะบิยยีน'},
    5: {'latin': 'Wa nadhaalul-mawaziinal-qista li-yawmil-qiyamah', 'th': 'วะนะดะอุล มะวาซีนัล กิสฏะ ลิยะวมิล กิยามะฮ์'},
    6: {'latin': 'Inna kulla shayin khalaqnahu biqadar', 'th': 'อินนา กุลละ ชัยอิน คอลักนาฮู บิกอดัร'},
  },
  'prayer': {
    1: {'latin': 'Innas-salata kanat alal-muminiina kitaban mawquta', 'th': 'อินนัศ ศอลาตะ กานัต อะลัล มุอ์มินีนะ กิตาบัน เมากูตา'},
    2: {'latin': 'Allahu Akbar', 'th': 'อัลลอฮุ อักบัร'},
    3: {'latin': 'Bismillahir-rahmanir-rahim', 'th': 'บิสมิลลาฮิร เราะฮ์มานิร เราะฮีม'},
    4: {'latin': 'Subhana Rabbiyal-Adhim', 'th': 'สุบฮานะ รอบบิยัล อะซีม'},
    5: {'latin': 'Subhana Rabbiyal-Ala', 'th': 'สุบฮานะ รอบบิยัล อะอ์ลา'},
    6: {'latin': 'At-tahiyyatu lillahi was-salawatu wat-tayyibat', 'th': 'อัตตะฮิยยาตุ ลิลลาฮิ วัศศอลาวาตุ วัฏฏ็อยยิบาตุ'},
    7: {'latin': 'Fa idha qadhaitumussalata fadhkurullaha', 'th': 'ฝะ อิซา กอดอยตุมุศ ศอลาตะ ฝัซกุรุลลอฮ์'},
  },
  'hadith': {
    1: {'latin': 'Innamal-amalu bin-niyyat', 'th': 'อินนะมัล อะอ์มาลุ บิน นิยยาต'},
    2: {'latin': 'Buniyal-Islamu ala khams', 'th': 'บุนิยัล อิสลามุ อะลา คัมส์'},
    3: {'latin': 'Al-halalu bayyinun wal-haramu bayyinun', 'th': 'อัลฮะลาลุ บัยยินุน วัลฮะรามุ บัยยินุน'},
    4: {'latin': 'La yuminu ahadukum hatta yuhibba li-akhihi ma yuhibbu li-nafsih', 'th': 'ลา ยุอ์มินุ อะฮะดุกุม ฮัตตา ยุฮิบบะ ลิอะคีฮิ มา ยุฮิบบุ ลินัฝซิฮ์'},
    5: {'latin': 'Ad-dinu an-nasihah', 'th': 'อัดดีนุ อัน นะศีฮะฮ์'},
    6: {'latin': 'Min husni Islamil-maryi tarkuhu ma la yanihi', 'th': 'มิน ฮุสนิ อิสลามิล มัรอิ ตัรกุฮู มา ลา ยะนีฮี'},
    7: {'latin': 'Tabasumuka fi wajhi akhika laka sadaqah', 'th': 'ตะบัสสุมุกะ ฝี วัจฮิ อะคีกะ ละกะ ศอดะกะฮ์'},
    8: {'latin': 'Irhamuu man fil-ardhi yarhamkum man fis-sama', 'th': 'อิรฮะมู มัน ฝิล อัรดิ ยัรฮะมกุม มัน ฝิสสะมา'},
    9: {'latin': 'Al-muminul-qawiyyu khayrun wa ahabbu ilallahi minal-muminidhdhаif', 'th': 'อัลมุอ์มินุล กอวิยยุ คอยรุน วะ อะฮับบุ อิลัลลอฮิ มินัล มุอ์มินิดดออีฝ์'},
    10: {'latin': 'La dharara wa la dhirar', 'th': 'ลา ดอรอรอ วะลา ดิรอร'},
  },
  'adab': {
    1: {'latin': 'Assalamu alaykum wa rahmatullahi wa barakatuh', 'th': 'อัสสะลามุอะลัยกุม วะเราะฮ์มะตุลลอฮิ วะบะเราะกาตุฮ์'},
    2: {'latin': 'Bismillah', 'th': 'บิสมิลลาฮ์'},
    3: {'latin': 'Wa qadha rabbuka alla tabudu illa iyyahu wa bil-walidayni ihsana', 'th': 'วะ กอดอ รอบบุกะ อัลลา ตะอ์บุดู อิลลา อิยยาฮุ วะบิล วาลิดัยนิ อิฮ์ซานา'},
    4: {'latin': 'Alaykum bis-sidqi fa innas-sidqa yahdi ilal-birr', 'th': 'อะลัยกุม บิศศิดกิ ฝะ อินนัศ ศิดกะ ยะฮ์ดี อิลัล บิรร์'},
    5: {'latin': 'At-tahuru shatrul-iman', 'th': 'อัฏฏุฮูรุ ชัฏรุล อีมาน'},
  },
  'history': {
    1: {'latin': 'Muhammadur Rasulullah', 'th': 'มุฮัมมะดุร เราะซูลุลลอฮ์'},
    2: {'latin': 'Iqra bismi rabbikalladhi khalaq', 'th': 'อิกรอ บิสมิ รอบบิกัลลาซี คอลอก'},
    3: {'latin': 'Innal-ladhina amanu wa hajaru wa jahadu fi sabilillah', 'th': 'อินนัลลาซีนะ อามะนู วะฮาญะรู วะญาฮะดู ฝี ซะบีลิลลาฮ์'},
    4: {'latin': 'Wa aiddu lahum mastatatam min quwwah', 'th': 'วะ อะอิดดู ละฮุม มัสตะฏ็อตุม มิน กุววะฮ์'},
    5: {'latin': 'Khulafaur-Rashidun', 'th': 'คุลาฝาอุรรอชิดูน'},
    6: {'latin': 'Huwal-ladhi arsala rasulahu bil-huda', 'th': 'ฮุวัลลาซี อัรสะละ เราะซูละฮู บิลฮุดา'},
  },
  'fasting': {
    1: {'latin': 'Kullu amali bni adama lahu illasswama fa innahu li wa ana ajzi bihi', 'th': 'กุลลุ อะมะลิ บนิ อาดะมะ ละฮู อิลลัศศิยามะ ฝะ อินนะฮู ลี วะ อะนา อัจ์ซี บิฮี'},
    2: {'latin': 'Ya ayyuhal-ladhina amanu kutiba alaykumus-siyam', 'th': 'ยา อัยยุฮัลลาซีนะ อามะนู กุติบะ อะลัยกุมุศ ศิยาม'},
    3: {'latin': 'Wa kulu washrabu hatta yatabayyana lakumul-khaytu al-abyadhu', 'th': 'วะ กุลู วัชรอบู ฮัตตา ยะตะบัยยะนะ ละกุมุล คอยฏุล อับยัดุ'},
    4: {'latin': 'Idha kana yawmu sawmi ahadikum fala yarfuth wa la yaskhab', 'th': 'อิซา กานะ ยะวมุ เซาวมิ อะฮะดิกุม ฝะลา ยัรฝุษ วะลา ยัศคอบ'},
    5: {'latin': 'Man sama yawman fi sabilillahi baada Allahu wajhahu anis-nari sabiina kharifa', 'th': 'มัน ศอมะ ยะวมัน ฝี ซะบีลิลลาฮิ บะอัดะ อัลลอฮุ วัจฮะฮู อะนิน นาริ ซับอีนะ คอรีฝา'},
    6: {'latin': 'Laylatul-Qadri khayrun min alfi shahr', 'th': 'ลัยละตุล กอดรี คอยรุน มิน อัลฝิ ชะฮ์ร'},
    7: {'latin': 'Faradha Rasulullahi zakatil-fitri tuhuratan lissaim', 'th': 'ฝะรอดอ เราะซูลุลลอฮิ ซะกาติล ฝิฏรี ฏุฮูรอตัน ลิศศออิม'},
  },
  'special_prayer': {
    1: {'latin': 'Wa qumu lillahi qaanitin', 'th': 'วะ กูมู ลิลลาฮิ กอนิตีน'},
    2: {'latin': 'Inna salati wa nusuki wa mahyaya wa mamati lillahi rabbil-alamin', 'th': 'อินนา ศอลาตี วะ นุสุกี วะ มะฮ์ยายะ วะ มะมาตี ลิลลาฮิ รอบบิล อาลามีน'},
    3: {'latin': 'Wa la taqulu liman yuqtalu fi sabilillahi amwat', 'th': 'วะลา ตะกูลู ลิมัน ยุกตะลู ฝี ซะบีลิลลาฮิ อัมวาต'},
    4: {'latin': 'Wa min al-layli fa-tahajjad bihi nafilatan laka', 'th': 'วะ มินัลลัยลิ ฝะตะฮัจญัด บิฮี นาฝิละตัน ลาก'},
    5: {'latin': 'Wastaqhimullaha rabbakum thumma tubu ilayh', 'th': 'วัสตัฆฟิรู อัลลอฮะ รอบบะกุม ษุมมะ ตูบู อิลัยฮ์'},
    6: {'latin': 'Inna shams wal-qamara ayatani min ayatillah', 'th': 'อินนัช ชัมสะ วัลกอมะรอ อายะตานิ มิน อายาติลลาฮ์'},
  },
};

String _getLessonTrans(Map<String, dynamic> lesson, String lang) {
  if (lang == 'ar') return '';
  final catId = lesson['catId'] as String? ?? '';
  final no = lesson['no'] as int? ?? 0;
  final transMap = kLessonTransliterations[catId]?[no];
  if (transMap == null) return '';
  if (lang == 'th') return transMap['th'] ?? transMap['latin'] ?? '';
  return transMap['latin'] ?? '';
}
class LessonData {
  static List<Map<String, dynamic>> getLesson(String id) {
    switch (id) {
      case 'pillars': return _pillars;
      case 'iman': return _iman;
      case 'wudhu': return _wudhu;
      case 'prayer': return _prayer;
      case 'hadith': return _hadith;
      case 'adab': return _adab;
      case 'history': return _history;
      case 'fasting': return _fasting;
      case 'special_prayer': return _specialPrayer;
      default: return [];
    }
  }

  static final List<Map<String, dynamic>> _pillars = [
    {
      'no': 1, 'titleEn': 'Shahada (Declaration of Faith)', 'titleTh': 'ชะฮาดะห์ (การปฏิญาณตน)',
      'arabic': 'لَا إِلَٰهَ إِلَّا ٱللَّٰهُ مُحَمَّدٌ رَسُولُ ٱللَّٰهِ',
      'contentEn': 'The Shahada is the declaration of faith:\n"There is no god but Allah, and Muhammad is the messenger of Allah"\n\nThis is the first and most important pillar of Islam.\n\n• It affirms the oneness of Allah (Tawhid)\n• It acknowledges Muhammad as the final prophet\n• It must be said with full understanding and conviction',
      'contentTh': 'ชะฮาดะห์คือการปฏิญาณตนว่า\n"ไม่มีพระเจ้าอื่นใดนอกจากอัลลอฮ์ และมุฮัมมัดคือศาสนทูตของอัลลอฮ์"\n\nนี่คือเสาหลักที่สำคัญที่สุดของอิสลาม\n\n• ยืนยันความเป็นหนึ่งเดียวของอัลลอฮ์ (เตาฮีด)\n• ยอมรับว่ามุฮัมมัดเป็นนบีองค์สุดท้าย\n• ต้องกล่าวด้วยความเข้าใจและศรัทธาอย่างแท้จริง',
    },
    {
      'no': 2, 'titleEn': 'Salah (Prayer)', 'titleTh': 'ศอลาห์ (การละหมาด)',
      'arabic': 'الصَّلَاةُ عِمَادُ الدِّينِ',
      'contentEn': 'Muslims are required to pray five times a day:\n\n1. Fajr - Dawn prayer (2 rakahs)\n2. Dhuhr - Noon prayer (4 rakahs)\n3. Asr - Afternoon prayer (4 rakahs)\n4. Maghrib - Sunset prayer (3 rakahs)\n5. Isha - Night prayer (4 rakahs)\n\nPrayer is a direct connection between the worshipper and Allah.',
      'contentTh': 'มุสลิมต้องละหมาด 5 เวลาต่อวัน:\n\n1. ฟัจร์ - ละหมาดรุ่งอรุณ (2 ร็อกอะห์)\n2. ซุฮร์ - ละหมาดเที่ยง (4 ร็อกอะห์)\n3. อัศร์ - ละหมาดบ่าย (4 ร็อกอะห์)\n4. มัฆริบ - ละหมาดตะวันตก (3 ร็อกอะห์)\n5. อิชาอ์ - ละหมาดกลางคืน (4 ร็อกอะห์)\n\nการละหมาดคือการเชื่อมต่อโดยตรงระหว่างผู้ศรัทธากับอัลลอฮ์',
    },
    {
      'no': 3, 'titleEn': 'Zakat (Charity)', 'titleTh': 'ซะกาต (การบริจาค)',
      'arabic': 'وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ',
      'contentEn': 'Zakat is the mandatory giving of a set proportion of wealth to charity.\n\n• Required from Muslims who have wealth above the nisab\n• The rate is 2.5% of savings held for a full lunar year\n• It purifies wealth and helps those in need\n• Recipients: the poor, debtors, travelers in need',
      'contentTh': 'ซะกาตคือการจ่ายทรัพย์สินส่วนหนึ่งเป็นการบังคับ\n\n• บังคับสำหรับมุสลิมที่มีทรัพย์สินเกิน นิศอบ\n• อัตรา 2.5% ของเงินออมที่ครบรอบปีจันทรคติ\n• ชำระล้างทรัพย์สินและช่วยเหลือผู้ยากไร้\n• ผู้รับ: คนยากจน ลูกหนี้ นักเดินทาง',
    },
    {
      'no': 4, 'titleEn': 'Sawm (Fasting)', 'titleTh': 'เซาม์ (การถือศีลอด)',
      'arabic': 'شَهْرُ رَمَضَانَ الَّذِي أُنزِلَ فِيهِ الْقُرْآنُ',
      'contentEn': 'Fasting during Ramadan is obligatory for all adult Muslims.\n\n• Abstain from food, drink, and sexual relations from dawn to sunset\n• Ramadan is the 9th month of the Islamic calendar\n• Laylatul Qadr falls in the last 10 nights\n• Eid ul-Fitr marks the end of Ramadan\n\nFasting teaches patience, gratitude, and empathy.',
      'contentTh': 'การถือศีลอดในรอมฎอนเป็นสิ่งบังคับ\n\n• งดอาหาร น้ำ และการมีเพศสัมพันธ์ตั้งแต่รุ่งอรุณถึงพระอาทิตย์ตก\n• รอมฎอนคือเดือนที่ 9 ของปฏิทินอิสลาม\n• คืนลัยลาตุลก็อดร์อยู่ใน 10 คืนสุดท้าย\n• อีดุลฟิฏร์คือวันสิ้นสุดรอมฎอน\n\nการถือศีลอดสอนความอดทน ความกตัญญู และเห็นอกเห็นใจ',
    },
    {
      'no': 5, 'titleEn': 'Hajj (Pilgrimage)', 'titleTh': 'ฮัจญ์ (การประกอบพิธีฮัจญ์)',
      'arabic': 'وَلِلَّهِ عَلَى النَّاسِ حِجُّ الْبَيْتِ',
      'contentEn': 'Hajj is the pilgrimage to Makkah, required once in a lifetime.\n\n• Performed during Dhul Hijjah\n• Key rituals: Tawaf, Sai, Standing at Arafat\n• Eid ul-Adha is celebrated during Hajj\n• Over 2 million Muslims perform Hajj annually\n\nHajj symbolizes the unity of Muslims worldwide.',
      'contentTh': 'ฮัจญ์คือการเดินทางไปประกอบพิธีที่มักกะห์ บังคับครั้งหนึ่งในชีวิต\n\n• ประกอบพิธีในเดือนซุลฮิจญะห์\n• พิธีสำคัญ: เฏาวาฟ ซะอ์ยี วุกูฟที่อะรอฟะห์\n• อีดุลอัฎฮาจัดขึ้นระหว่างฮัจญ์\n• มุสลิมกว่า 2 ล้านคนไปฮัจญ์ทุกปี\n\nฮัจญ์เป็นสัญลักษณ์ของความเป็นหนึ่งเดียวของมุสลิม',
    },
  ];

  static final List<Map<String, dynamic>> _iman = [
    {
      'no': 1, 'titleEn': 'Belief in Allah', 'titleTh': 'ศรัทธาในอัลลอฮ์',
      'arabic': 'قُلْ هُوَ اللَّهُ أَحَدٌ',
      'contentEn': 'Believing in the oneness of Allah (Tawhid).\n\nAllah is:\n• The one and only God, creator of all things\n• All-knowing (Al-Alim)\n• All-powerful (Al-Qadir)\n• Most Merciful (Ar-Rahman)\n• He has 99 beautiful names (Asma ul Husna)',
      'contentTh': 'เชื่อในความเป็นหนึ่งเดียวของอัลลอฮ์ (เตาฮีด)\n\nอัลลอฮ์คือ:\n• พระเจ้าองค์เดียว ผู้สร้างทุกสิ่ง\n• ทรงรอบรู้ทุกอย่าง (อัล-อะลีม)\n• ทรงมีอำนาจสูงสุด (อัล-กอดีร)\n• ทรงเมตตาสูงสุด (อัร-เราะห์มาน)\n• มีพระนาม 99 พระนาม (อัสมาอุลฮุสนา)',
    },
    {
      'no': 2, 'titleEn': 'Belief in Angels', 'titleTh': 'ศรัทธาในมะลาอิกะห์',
      'arabic': 'وَالْمَلَائِكَةِ وَالْكِتَابِ وَالنَّبِيِّينَ',
      'contentEn': 'Angels are created from light and serve Allah.\n\nKey angels:\n• Jibril - Delivers revelation\n• Mikail - Controls rain and sustenance\n• Israfil - Will blow the trumpet on Judgment Day\n• Azrael - Angel of death\n• Munkar and Nakir - Question in the grave\n• Raqib and Atid - Record deeds',
      'contentTh': 'มะลาอิกะห์ถูกสร้างจากแสงสว่างและรับใช้อัลลอฮ์\n\nมะลาอิกะห์สำคัญ:\n• ญิบรีล - นำวะห์ยู\n• มีกาอีล - ดูแลฝนและปัจจัยยังชีพ\n• อิสราฟีล - เป่าแตรในวันกิยามะห์\n• อิซราอีล - มะลาอิกะห์แห่งความตาย\n• มุงกัรและนะกีร - ถามในหลุมฝังศพ\n• รอกีบและอะตีด - บันทึกความดีความชั่ว',
    },
    {
      'no': 3, 'titleEn': 'Belief in Holy Books', 'titleTh': 'ศรัทธาในคัมภีร์',
      'arabic': 'إِنَّا نَحْنُ نَزَّلْنَا الذِّكْرَ وَإِنَّا لَهُ لَحَافِظُونَ',
      'contentEn': 'Muslims believe in all scriptures revealed by Allah:\n\n• Torah (Tawrat) - Revealed to Prophet Musa\n• Psalms (Zabur) - Revealed to Prophet Dawud\n• Gospel (Injil) - Revealed to Prophet Isa\n• Quran - Revealed to Prophet Muhammad (Final revelation)\n\nOnly the Quran remains unchanged and perfectly preserved.',
      'contentTh': 'มุสลิมเชื่อในคัมภีร์ทั้งหมดที่อัลลอฮ์ประทานลงมา:\n\n• เตารอต - ประทานแก่นบีมูซา\n• ซะบูร - ประทานแก่นบีดาวูด\n• อินญีล - ประทานแก่นบีอีซา\n• อัลกุรอาน - ประทานแก่นบีมุฮัมมัด (วะห์ยูสุดท้าย)\n\nมีเพียงอัลกุรอานเท่านั้นที่ยังคงไม่เปลี่ยนแปลง',
    },
    {
      'no': 4, 'titleEn': 'Belief in Prophets', 'titleTh': 'ศรัทธาในบรรดานบี',
      'arabic': 'وَلَٰكِن رَّسُولَ اللَّهِ وَخَاتَمَ النَّبِيِّينَ',
      'contentEn': 'Allah sent 124,000 prophets throughout history.\n\nKey prophets:\n• Adam - First human and prophet\n• Ibrahim - Father of prophets\n• Musa - Given the Torah\n• Isa - Given the Gospel\n• Muhammad - Final prophet and messenger\n\nAll prophets taught: worship Allah alone.',
      'contentTh': 'อัลลอฮ์ทรงส่งนบี 124,000 คนตลอดประวัติศาสตร์\n\nนบีสำคัญ:\n• อาดัม - มนุษย์และนบีคนแรก\n• อิบรอฮีม - บิดาของบรรดานบี\n• มูซา - ได้รับเตารอต\n• อีซา - ได้รับอินญีล\n• มุฮัมมัด - นบีและร่อซูลองค์สุดท้าย\n\nนบีทุกองค์สอนสารเดียวกัน: ให้เคารพภักดีอัลลอฮ์เพียงองค์เดียว',
    },
    {
      'no': 5, 'titleEn': 'Belief in Day of Judgment', 'titleTh': 'ศรัทธาในวันกิยามะห์',
      'arabic': 'وَنَضَعُ الْمَوَازِينَ الْقِسْطَ لِيَوْمِ الْقِيَامَةِ',
      'contentEn': 'Every soul will be resurrected and judged by Allah.\n\nEvents of the Last Day:\n• Israfil blows the trumpet\n• All souls are resurrected\n• Deeds are weighed on the scale (Mizan)\n• Everyone crosses the bridge (Sirat)\n• The righteous enter Jannah (Paradise)\n• The wicked enter Jahannam (Hell)',
      'contentTh': 'ทุกวิญญาณจะถูกฟื้นคืนชีพและถูกพิพากษาโดยอัลลอฮ์\n\nเหตุการณ์ในวันกิยามะห์:\n• อิสราฟีลเป่าแตร\n• ทุกวิญญาณถูกฟื้นคืนชีพ\n• ความดีความชั่วถูกชั่งน้ำหนัก (มีซาน)\n• ทุกคนข้ามสะพาน (ศิรอฏ)\n• ผู้ชอบธรรมเข้าสวรรค์ (ญันนะห์)\n• ผู้ชั่วร้ายเข้านรก (ญะฮันนัม)',
    },
    {
      'no': 6, 'titleEn': 'Belief in Divine Decree (Qadar)', 'titleTh': 'ศรัทธาในกอดอและกอดัร',
      'arabic': 'إِنَّا كُلَّ شَيْءٍ خَلَقْنَاهُ بِقَدَرٍ',
      'contentEn': 'Allah has knowledge of all things and everything happens according to His will.\n\n4 Levels of Qadar:\n1. Ilm - Allahs knowledge of everything\n2. Kitabah - Written in Al-Lawh Al-Mahfuz\n3. Mashiah - Allahs will\n4. Khalq - Allahs creation\n\nBelieving in Qadar gives Muslims patience in hardship.',
      'contentTh': 'อัลลอฮ์ทรงรู้ทุกสิ่งและทุกอย่างเกิดขึ้นตามพระประสงค์ของพระองค์\n\n4 ระดับของกอดัร:\n1. อิลม์ - ความรอบรู้ของอัลลอฮ์ในทุกสิ่ง\n2. กิตาบะห์ - ถูกบันทึกในอัล-เลาห์ อัล-มะฮ์ฟูซ\n3. มัชยะห์ - พระประสงค์ของอัลลอฮ์\n4. คอลก์ - การสร้างของอัลลอฮ์\n\nการเชื่อในกอดัรทำให้มุสลิมอดทนต่อความยากลำบาก',
    },
  ];

  static final List<Map<String, dynamic>> _wudhu = [
    {
      'no': 1, 'titleEn': 'How to Perform Wudu', 'titleTh': 'วิธีทำวุฎูอ์',
      'arabic': 'يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا قُمْتُمْ إِلَى الصَّلَاةِ فَاغْسِلُوا وُجُوهَكُمْ',
      'contentEn': 'Steps of Wudu (Ablution):\n\n1. Say Bismillah\n2. Wash both hands 3 times\n3. Rinse mouth 3 times\n4. Rinse nose 3 times\n5. Wash face 3 times\n6. Wash right arm to elbow 3 times, then left\n7. Wipe head once\n8. Wipe ears once\n9. Wash right foot to ankle 3 times, then left\n10. Say Shahada after wudu',
      'contentTh': 'ขั้นตอนการทำวุฎูอ์:\n\n1. กล่าวบิสมิลลาห์\n2. ล้างมือทั้งสองข้าง 3 ครั้ง\n3. บ้วนปาก 3 ครั้ง\n4. สูดน้ำเข้าจมูก 3 ครั้ง\n5. ล้างหน้า 3 ครั้ง\n6. ล้างแขนขวาถึงข้อศอก 3 ครั้ง แล้วซ้าย\n7. ลูบศีรษะ 1 ครั้ง\n8. ลูบหู 1 ครั้ง\n9. ล้างเท้าขวาถึงข้อเท้า 3 ครั้ง แล้วซ้าย\n10. กล่าวชะฮาดะห์หลังวุฎูอ์',
    },
  ];

  static final List<Map<String, dynamic>> _prayer = [
    {
      'no': 1, 'titleEn': 'Conditions of Prayer', 'titleTh': 'เงื่อนไขของการละหมาด',
      'arabic': 'إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا',
      'contentEn': 'Before praying, these conditions must be met:\n\n1. Being Muslim\n2. Being sane and of age\n3. Being in a state of purity (Wudu or Ghusl)\n4. Clothes and place must be clean\n5. Facing the Qibla (direction of Makkah)\n6. Time of prayer must have entered\n7. Intention (Niyyah) in the heart',
      'contentTh': 'ก่อนละหมาด ต้องมีเงื่อนไขเหล่านี้:\n\n1. เป็นมุสลิม\n2. มีสติสัมปชัญญะและบรรลุนิติภาวะ\n3. อยู่ในสภาพสะอาด (วุฎูอ์หรือฆุสล์)\n4. เสื้อผ้าและสถานที่ต้องสะอาด\n5. หันหน้าไปทางกิบลัต (มักกะห์)\n6. ถึงเวลาละหมาดแล้ว\n7. มีเจตนา (นิยะห์) ในใจ',
    },
    {
      'no': 2, 'titleEn': 'Intention and Takbir', 'titleTh': 'การตั้งเจตนาและตักบีร',
      'arabic': 'اللَّهُ أَكْبَرُ',
      'contentEn': 'Starting the prayer:\n\n1. Stand facing the Qibla\n2. Make intention (Niyyah) in your heart\n3. Raise both hands to ear level\n4. Say Takbiratul Ihram: "Allahu Akbar"\n5. Place right hand over left on chest',
      'contentTh': 'การเริ่มต้นละหมาด:\n\n1. ยืนหันหน้าไปทางกิบลัต\n2. ตั้งนิยะห์ในใจ\n3. ยกมือทั้งสองข้างขึ้นถึงใบหู\n4. กล่าวตักบีเราะตุลอิฮ์รอม: "อัลลอฮุอักบัร"\n5. วางมือขวาทับมือซ้ายไว้ที่หน้าอก',
    },
    {
      'no': 3, 'titleEn': 'Recitation in Standing', 'titleTh': 'การอ่านในท่ายืน',
      'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'contentEn': 'After Takbir, recite:\n\n1. Dua Iftitah (Opening supplication) - Optional\n2. Surah Al-Fatihah (Obligatory in every rakah)\n3. Any additional Surah or verses\n\nWithout Al-Fatihah, the prayer is invalid.',
      'contentTh': 'หลังตักบีร กล่าว:\n\n1. ดุอาอิฟติตาห์ - เป็นซุนนะห์\n2. ซูเราะห์อัล-ฟาติฮะห์ (บังคับในทุกร็อกอะห์)\n3. ซูเราะห์หรืออายะห์เพิ่มเติม\n\nถ้าไม่อ่านอัล-ฟาติฮะห์ ละหมาดใช้ไม่ได้',
    },
    {
      'no': 4, 'titleEn': 'Ruku (Bowing)', 'titleTh': 'รุกูอ์ (การก้มโค้ง)',
      'arabic': 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      'contentEn': 'Performing Ruku:\n\n1. Say "Allahu Akbar" while bowing\n2. Bow with back straight, hands on knees\n3. Recite: "Subhana Rabbiyal Adhim" (3 times)\n4. Rise saying: "Sami allahu liman hamidah"\n5. Say: "Rabbana lakal hamd"',
      'contentTh': 'การทำรุกูอ์:\n\n1. กล่าว "อัลลอฮุอักบัร" ขณะก้ม\n2. ก้มหลังให้ตรง มือวางบนเข่า\n3. อ่าน: "ซุบฮานะ ร็อบบิยัล อะซีม" (3 ครั้ง)\n4. ลุกขึ้นกล่าว: "ซะมิอัลลอฮุ ลิมัน ฮะมิดะห์"\n5. กล่าว: "ร็อบบานา ละกัล ฮัมด์"',
    },
    {
      'no': 5, 'titleEn': 'Sujud (Prostration)', 'titleTh': 'สุญูด (การกราบ)',
      'arabic': 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
      'contentEn': 'Performing Sujud:\n\n1. Say "Allahu Akbar" going down\n2. 7 body parts touch the ground:\n   - Forehead and nose\n   - Both palms\n   - Both knees\n   - Tips of both feet\n3. Recite: "Subhana Rabbiyal Ala" (3 times)\n4. Rise saying "Allahu Akbar"\n5. Sit briefly then perform second sajdah',
      'contentTh': 'การทำสุญูด:\n\n1. กล่าว "อัลลอฮุอักบัร" ขณะลงกราบ\n2. อวัยวะ 7 ส่วนต้องแตะพื้น:\n   - หน้าผากและจมูก\n   - ฝ่ามือทั้งสองข้าง\n   - เข่าทั้งสองข้าง\n   - ปลายเท้าทั้งสองข้าง\n3. อ่าน: "ซุบฮานะ ร็อบบิยัล อะอ์ลา" (3 ครั้ง)\n4. ลุกขึ้นกล่าว "อัลลอฮุอักบัร"\n5. นั่งพักสั้นๆ แล้วทำสุญูดครั้งที่สอง',
    },
    {
      'no': 6, 'titleEn': 'Tashahhud and Salutation', 'titleTh': 'ตะชะฮ์ฮุดและสลาม',
      'arabic': 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ',
      'contentEn': 'Final sitting:\n\n1. Sit in Tashahhud position\n2. Recite At-Tahiyyat\n3. Recite Salawat Ibrahimiyyah\n4. Make Dua before salam\n5. Give Salam:\n   - Turn right: "Assalamu Alaikum Wa Rahmatullah"\n   - Turn left: "Assalamu Alaikum Wa Rahmatullah"\n\nPrayer is complete!',
      'contentTh': 'การนั่งสุดท้าย:\n\n1. นั่งในท่าตะชะฮ์ฮุด\n2. อ่านอัต-ตะฮิยยาต\n3. อ่านศอลาวาตอิบรอฮีมียะห์\n4. ดุอาก่อนสลาม\n5. กล่าวสลาม:\n   - หันขวา: "อัสสะลามุอะลัยกุม วะเราะห์มะตุลลอฮ์"\n   - หันซ้าย: "อัสสะลามุอะลัยกุม วะเราะห์มะตุลลอฮ์"\n\nละหมาดเสร็จสมบูรณ์!',
    },
    {
      'no': 7, 'titleEn': 'Dhikr After Prayer', 'titleTh': 'ซิกร์หลังละหมาด',
      'arabic': 'فَإِذَا قَضَيْتُمُ الصَّلَاةَ فَاذْكُرُوا اللَّهَ',
      'contentEn': 'Recommended dhikr after prayer:\n\n1. Say "Astaghfirullah" 3 times\n2. Recite Ayatul Kursi\n3. "Subhanallah" 33 times\n4. "Alhamdulillah" 33 times\n5. "Allahu Akbar" 33 times\n6. "La ilaha illallah wahdahu..." once',
      'contentTh': 'ซิกร์ที่แนะนำหลังละหมาด:\n\n1. กล่าว "อัสตัฆฟิรุลลอฮ์" 3 ครั้ง\n2. อ่านอายะตุลกุรซี\n3. "ซุบฮานัลลอฮ์" 33 ครั้ง\n4. "อัลฮัมดุลิลลาห์" 33 ครั้ง\n5. "อัลลอฮุอักบัร" 33 ครั้ง\n6. "ลา อิลาฮะ อิลลัลลอฮ์ วะห์ดะฮู..." 1 ครั้ง',
    },
  ];

  static final List<Map<String, dynamic>> _hadith = [
    {
      'no': 1, 'titleEn': 'Actions by Intentions', 'titleTh': 'การกระทำขึ้นอยู่กับเจตนา',
      'arabic': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ',
      'contentEn': 'Narrated by Umar ibn al-Khattab:\n\n"Actions are but by intention, and every man shall have only that which he intended."\n\n[Bukhari and Muslim]\n\nThis is one of the most important hadith in Islam. It teaches that the value of any action depends on the intention behind it.',
      'contentTh': 'รายงานโดยอุมัร อิบน์ อัล-คัฏฏ็อบ:\n\n"การกระทำทั้งหลายขึ้นอยู่กับเจตนา และทุกคนจะได้รับสิ่งที่เขาตั้งใจ"\n\n[บุคอรีและมุสลิม]\n\nนี่คือหะดีษที่สำคัญที่สุดอย่างหนึ่งในอิสลาม สอนว่าคุณค่าของการกระทำขึ้นอยู่กับเจตนาเบื้องหลัง',
    },
    {
      'no': 2, 'titleEn': 'Islam is Built on Five', 'titleTh': 'อิสลามสร้างบนห้าสิ่ง',
      'arabic': 'بُنِيَ الْإِسْلَامُ عَلَى خَمْسٍ',
      'contentEn': 'Narrated by Ibn Umar:\n\n"Islam is built upon five:\n1. Testifying that there is no god but Allah\n2. Establishing prayer\n3. Paying Zakat\n4. Fasting Ramadan\n5. Performing Hajj"\n\n[Bukhari and Muslim]',
      'contentTh': 'รายงานโดยอิบน์อุมัร:\n\n"อิสลามสร้างบนห้าสิ่ง:\n1. การปฏิญาณว่าไม่มีพระเจ้าอื่นนอกจากอัลลอฮ์\n2. การดำรงละหมาด\n3. การจ่ายซะกาต\n4. การถือศีลอดรอมฎอน\n5. การประกอบพิธีฮัจญ์"\n\n[บุคอรีและมุสลิม]',
    },
    {
      'no': 3, 'titleEn': 'The Halal and Haram are Clear', 'titleTh': 'ฮาลาลและฮารามชัดเจน',
      'arabic': 'الْحَلَالُ بَيِّنٌ وَالْحَرَامُ بَيِّنٌ',
      'contentEn': 'Narrated by An-Numan ibn Bashir:\n\n"The halal is clear and the haram is clear, and between them are doubtful matters which many people do not know. He who guards against doubtful things keeps his religion blameless."\n\n[Bukhari and Muslim]',
      'contentTh': 'รายงานโดยอัน-นุอ์มาน อิบน์ บะชีร:\n\n"ฮาลาลนั้นชัดเจน และฮารามก็ชัดเจน และระหว่างทั้งสองมีเรื่องที่น่าสงสัยซึ่งคนมากมายไม่รู้ ผู้ที่ระวังตัวจากเรื่องน่าสงสัยก็รักษาศาสนาของตนไว้ได้"\n\n[บุคอรีและมุสลิม]',
    },
    {
      'no': 4, 'titleEn': 'None of You Truly Believes', 'titleTh': 'ไม่มีใครศรัทธาอย่างแท้จริง',
      'arabic': 'لَا يُؤْمِنُ أَحَدُكُمْ حَتَّى يُحِبَّ لِأَخِيهِ مَا يُحِبُّ لِنَفْسِهِ',
      'contentEn': 'Narrated by Anas ibn Malik:\n\n"None of you truly believes until he loves for his brother what he loves for himself."\n\n[Bukhari and Muslim]\n\nThis hadith emphasizes brotherhood, empathy, and treating others as we wish to be treated.',
      'contentTh': 'รายงานโดยอะนัส อิบน์ มาลิก:\n\n"ไม่มีใครในพวกท่านศรัทธาอย่างแท้จริง จนกว่าเขาจะรักให้พี่น้องได้รับสิ่งที่เขารักให้ตัวเองได้รับ"\n\n[บุคอรีและมุสลิม]\n\nหะดีษนี้เน้นย้ำถึงความเป็นพี่น้อง ความเห็นอกเห็นใจ และการปฏิบัติต่อผู้อื่นอย่างที่เราอยากให้ปฏิบัติต่อเรา',
    },
    {
      'no': 5, 'titleEn': 'The Religion is Sincerity', 'titleTh': 'ศาสนาคือความจริงใจ',
      'arabic': 'الدِّينُ النَّصِيحَةُ',
      'contentEn': 'Narrated by Tamim Ad-Dari:\n\n"The religion is sincerity (nasiha). We asked: To whom? He said: To Allah, to His Book, to His Messenger, to the leaders of the Muslims and to the common people."\n\n[Muslim]',
      'contentTh': 'รายงานโดยตะมีม อัด-ดารี:\n\n"ศาสนาคือความจริงใจ เราถามว่า: ต่อใคร? ท่านกล่าวว่า: ต่ออัลลอฮ์ ต่อคัมภีร์ ต่อร่อซูล ต่อผู้นำมุสลิม และต่อคนทั่วไป"\n\n[มุสลิม]',
    },
    {
      'no': 6, 'titleEn': 'Leave What Does Not Concern You', 'titleTh': 'ละทิ้งสิ่งที่ไม่เกี่ยวข้อง',
      'arabic': 'مِنْ حُسْنِ إِسْلَامِ الْمَرْءِ تَرْكُهُ مَا لَا يَعْنِيهِ',
      'contentEn': 'Narrated by Abu Hurayrah:\n\n"Part of the perfection of ones Islam is his leaving that which does not concern him."\n\n[Tirmidhi]\n\nThis teaches us to focus on what benefits us and avoid unnecessary involvement in others affairs.',
      'contentTh': 'รายงานโดยอบู ฮุร็อยเราะห์:\n\n"ส่วนหนึ่งของความสมบูรณ์ในอิสลามของบุคคลคือการละทิ้งสิ่งที่ไม่เกี่ยวข้องกับเขา"\n\n[ติรมิซี]\n\nสอนให้มุ่งเน้นสิ่งที่เป็นประโยชน์และหลีกเลี่ยงการยุ่งเกี่ยวกับกิจการของผู้อื่นโดยไม่จำเป็น',
    },
    {
      'no': 7, 'titleEn': 'Smiling is Charity', 'titleTh': 'การยิ้มคือทาน',
      'arabic': 'تَبَسُّمُكَ فِي وَجْهِ أَخِيكَ لَكَ صَدَقَةٌ',
      'contentEn': 'Narrated by Abu Dharr:\n\n"Your smiling in the face of your brother is charity, your enjoining good and forbidding evil is charity, your giving directions to a man lost is charity, removing a rock or thorn from the road is charity."\n\n[Tirmidhi]',
      'contentTh': 'รายงานโดยอบู ซัรร์:\n\n"การยิ้มให้หน้าพี่น้องของท่านเป็นทาน การสั่งความดีและห้ามความชั่วเป็นทาน การบอกทางคนหลงเป็นทาน การเอาหินหรือหนามออกจากถนนเป็นทาน"\n\n[ติรมิซี]',
    },
    {
      'no': 8, 'titleEn': 'Kindness to All Creatures', 'titleTh': 'ความเมตตาต่อทุกสิ่งมีชีวิต',
      'arabic': 'ارْحَمُوا مَنْ فِي الْأَرْضِ يَرْحَمْكُمْ مَنْ فِي السَّمَاءِ',
      'contentEn': 'Narrated by Abdullah ibn Amr:\n\n"Show mercy to those on earth, and the One in heaven will show mercy to you."\n\n[Tirmidhi]\n\nMercy (Rahmah) is a central value in Islam. Be merciful to people, animals, and care for the environment.',
      'contentTh': 'รายงานโดยอับดุลลอฮ์ อิบน์ อัมร์:\n\n"จงเมตตาต่อผู้ที่อยู่บนแผ่นดิน แล้วผู้ที่อยู่บนฟ้าจะเมตตาต่อพวกท่าน"\n\n[ติรมิซี]\n\nความเมตตาคือคุณค่าหลักในอิสลาม จงเมตตาต่อผู้คน สัตว์ และดูแลสิ่งแวดล้อม',
    },
    {
      'no': 9, 'titleEn': 'The Strong Believer', 'titleTh': 'ผู้ศรัทธาที่แข็งแกร่ง',
      'arabic': 'الْمُؤْمِنُ الْقَوِيُّ خَيْرٌ وَأَحَبُّ إِلَى اللَّهِ مِنَ الْمُؤْمِنِ الضَّعِيفِ',
      'contentEn': 'Narrated by Abu Hurayrah:\n\n"The strong believer is better and more beloved to Allah than the weak believer, though both are good. Strive for what benefits you, seek Allahs help and do not feel helpless."\n\n[Muslim]',
      'contentTh': 'รายงานโดยอบู ฮุร็อยเราะห์:\n\n"ผู้ศรัทธาที่แข็งแกร่งดีกว่าและเป็นที่รักยิ่งกว่าต่ออัลลอฮ์มากกว่าผู้ศรัทธาที่อ่อนแอ จงพยายามในสิ่งที่เป็นประโยชน์แก่คุณ ขอความช่วยเหลือจากอัลลอฮ์ และอย่ารู้สึกสิ้นหวัง"\n\n[มุสลิม]',
    },
    {
      'no': 10, 'titleEn': 'The Removal of Harm', 'titleTh': 'การกำจัดอันตราย',
      'arabic': 'لَا ضَرَرَ وَلَا ضِرَارَ',
      'contentEn': 'Narrated by Ibn Abbas:\n\n"There should be neither harming nor reciprocating harm."\n\n[Ibn Majah and Malik]\n\nThis is one of the most important principles in Islamic jurisprudence:\n• Do not harm others\n• Do not reciprocate harm with harm\n• Harm must be removed when possible',
      'contentTh': 'รายงานโดยอิบน์อับบาส:\n\n"ไม่มีการทำให้เกิดอันตราย และไม่มีการตอบโต้ด้วยอันตราย"\n\n[อิบน์มาญะห์และมาลิก]\n\nนี่คือหลักการสำคัญในนิติศาสตร์อิสลาม:\n• อย่าทำอันตรายผู้อื่น\n• อย่าตอบโต้อันตรายด้วยอันตราย\n• ต้องขจัดอันตรายเมื่อเป็นไปได้',
    },
  ];

  static final List<Map<String, dynamic>> _adab = [
    {
      'no': 1, 'titleEn': 'Islamic Greeting (Salam)', 'titleTh': 'การทักทายแบบอิสลาม',
      'arabic': 'السَّلَامُ عَلَيْكُمْ وَرَحْمَةُ اللَّهِ وَبَرَكَاتُهُ',
      'contentEn': 'Spreading salam is one of the best deeds in Islam.\n\nLevels of salam:\n1. "Assalamu Alaikum"\n2. "Assalamu Alaikum Wa Rahmatullah"\n3. "Assalamu Alaikum Wa Rahmatullahi Wa Barakatuh"\n\nEtiquette:\n• The younger greets the older\n• Those passing greet those sitting\n• It is obligatory to reply to salam',
      'contentTh': 'การเผยแพร่สลามเป็นหนึ่งในการกระทำที่ดีที่สุด\n\nระดับของสลาม:\n1. "อัสสะลามุอะลัยกุม"\n2. "อัสสะลามุอะลัยกุม วะเราะห์มะตุลลอฮ์"\n3. "อัสสะลามุอะลัยกุม วะเราะห์มะตุลลอฮิ วะบะเราะกาตุฮ์"\n\nมารยาท:\n• ผู้น้องทักทายผู้อาวุโส\n• ผู้เดินทักทายผู้นั่ง\n• การตอบสลามเป็นสิ่งบังคับ',
    },
    {
      'no': 2, 'titleEn': 'Eating and Drinking Manners', 'titleTh': 'มารยาทการกินและดื่ม',
      'arabic': 'بِسْمِ اللَّهِ',
      'contentEn': 'Islamic manners of eating:\n\n• Say Bismillah before eating\n• Eat with the right hand\n• Eat from what is nearest to you\n• Do not waste food\n• Eat in moderation\n• Say Alhamdulillah after eating\n• Wash hands before and after',
      'contentTh': 'มารยาทอิสลามในการกิน:\n\n• กล่าวบิสมิลลาห์ก่อนกิน\n• กินด้วยมือขวา\n• กินจากสิ่งที่อยู่ใกล้ตัว\n• อย่าสุรุ่ยสุร่าย\n• กินพอดี\n• กล่าวอัลฮัมดุลิลลาห์หลังกิน\n• ล้างมือก่อนและหลังกิน',
    },
    {
      'no': 3, 'titleEn': 'Respecting Parents', 'titleTh': 'การเคารพพ่อแม่',
      'arabic': 'وَبِالْوَالِدَيْنِ إِحْسَانًا',
      'contentEn': 'Respecting parents is second only to worshipping Allah.\n\nDuties towards parents:\n• Speak kindly and gently\n• Never say words of annoyance\n• Obey them in permissible matters\n• Make dua for them always\n• Visit them regularly\n• Care for them in old age\n\n"Paradise lies at the feet of mothers" - Hadith',
      'contentTh': 'การเคารพพ่อแม่เป็นรองจากการเคารพภักดีอัลลอฮ์\n\nหน้าที่ต่อพ่อแม่:\n• พูดด้วยความสุภาพและอ่อนโยน\n• อย่ากล่าวคำที่แสดงความรำคาญ\n• เชื่อฟังในสิ่งที่อนุมัติ\n• ดุอาให้พ่อแม่เสมอ\n• ไปเยี่ยมเยียนสม่ำเสมอ\n• ดูแลในยามชรา\n\n"สวรรค์อยู่ใต้ฝ่าเท้าของมารดา" - หะดีษ',
    },
    {
      'no': 4, 'titleEn': 'Honesty and Truthfulness', 'titleTh': 'ความซื่อสัตย์',
      'arabic': 'عَلَيْكُمْ بِالصِّدْقِ',
      'contentEn': '"Truthfulness leads to righteousness and righteousness leads to Paradise."\n\nPractice honesty in:\n• Everyday speech\n• Business dealings\n• Promises and commitments\n• Social media and sharing information\n\nAvoid lying even in jokes.',
      'contentTh': '"ความซื่อสัตย์นำไปสู่ความดีงาม และความดีงามนำไปสู่สวรรค์"\n\nฝึกฝนความซื่อสัตย์ใน:\n• การพูดในชีวิตประจำวัน\n• การค้าขาย\n• สัญญาและพันธกรณี\n• โซเชียลมีเดียและการแชร์ข้อมูล\n\nหลีกเลี่ยงการโกหกแม้แต่ในเรื่องตลก',
    },
    {
      'no': 5, 'titleEn': 'Cleanliness (Taharah)', 'titleTh': 'ความสะอาด (ฏอฮาเราะห์)',
      'arabic': 'الطَّهُورُ شَطْرُ الْإِيمَانِ',
      'contentEn': '"Cleanliness is half of faith" - Hadith (Muslim)\n\nTypes of purification:\n1. Wudu (minor purification)\n2. Ghusl (major purification)\n3. Tayammum (dry purification with soil)\n\nAlso includes spiritual cleanliness:\n• Purifying heart from envy\n• Purifying from arrogance\n• Purifying from showing off',
      'contentTh': '"ความสะอาดคือครึ่งหนึ่งของอีหม่าน" - หะดีษ\n\nประเภทของการชำระ:\n1. วุฎูอ์ (การชำระเล็กน้อย)\n2. ฆุสล์ (การชำระใหญ่)\n3. ตะยัมมุม (การชำระด้วยดิน)\n\nรวมถึงความสะอาดทางจิตใจ:\n• ชำระจากความอิจฉา\n• ชำระจากความหยิ่งยโส\n• ชำระจากการโอ้อวด',
    },
  ];

  static final List<Map<String, dynamic>> _history = [
    {
      'no': 1, 'titleEn': 'Prophet Muhammad - Early Life', 'titleTh': 'ท่านนบีมุฮัมมัด - ชีวิตช่วงต้น',
      'arabic': 'مُحَمَّدٌ رَّسُولُ اللَّهِ',
      'contentEn': 'The life of Prophet Muhammad:\n\n• Born: 570 CE in Makkah (Year of the Elephant)\n• Father: Abdullah ibn Abd al-Muttalib\n• Mother: Aminah bint Wahb\n• Known as "Al-Amin" (The Trustworthy)\n• Married Khadijah at age 25\n• First revelation at age 40 in Cave Hira\n• Prophetic mission lasted 23 years',
      'contentTh': 'ชีวิตของท่านนบีมุฮัมมัด:\n\n• เกิด: ปี 570 CE ที่มักกะห์\n• บิดา: อับดุลลอฮ์ อิบน์ อับดุล มุฏฏอลิบ\n• มารดา: อามีนะห์ บินต์ วะฮับ\n• เป็นที่รู้จักในนาม "อัล-อามีน" (ผู้ซื่อสัตย์)\n• แต่งงานกับคอดีญะห์เมื่ออายุ 25\n• ได้รับวะห์ยูครั้งแรกเมื่ออายุ 40 ที่ถ้ำฮิรา\n• ภารกิจนบีกินเวลา 23 ปี',
    },
    {
      'no': 2, 'titleEn': 'The First Revelation', 'titleTh': 'วะห์ยูแรก',
      'arabic': 'اقْرَأْ بِاسْمِ رَبِّكَ الَّذِي خَلَقَ',
      'contentEn': 'The First Revelation (610 CE):\n\nIn Cave Hira, Angel Jibril commanded: "Read!" (Iqra!)\n\nThe first 5 verses of Surah Al-Alaq were revealed.\n\nFirst Muslims:\n• Khadijah - First woman\n• Ali ibn Abi Talib - First child\n• Abu Bakr - First adult man\n\nEarly Muslims faced severe persecution in Makkah.',
      'contentTh': 'วะห์ยูแรก (610 CE):\n\nที่ถ้ำฮิรา มะลาอิกะห์ญิบรีลสั่งว่า "อ่าน!" (อิกเราอ์!)\n\n5 อายะห์แรกของซูเราะห์อัล-อะลักถูกประทานลงมา\n\nมุสลิมยุคแรก:\n• คอดีญะห์ - ผู้หญิงคนแรก\n• อาลี อิบน์ อบี ฏอลิบ - เด็กคนแรก\n• อบู บักร - ผู้ชายผู้ใหญ่คนแรก\n\nมุสลิมยุคแรกเผชิญการข่มเหงอย่างรุนแรง',
    },
    {
      'no': 3, 'titleEn': 'Hijrah - Migration to Madinah', 'titleTh': 'ฮิจเราะห์ - การอพยพไปมาดีนะห์',
      'arabic': 'إِنَّ الَّذِينَ آمَنُوا وَهَاجَرُوا',
      'contentEn': 'The Hijrah (622 CE):\n\n• Muslims faced intense persecution in Makkah\n• Allah commanded migration to Madinah\n• The Prophet and Abu Bakr made the journey secretly\n• They hid in Cave Thawr for 3 days\n• The Ansar of Madinah welcomed them warmly\n• This marks the beginning of the Islamic calendar (1 AH)',
      'contentTh': 'ฮิจเราะห์ (622 CE):\n\n• มุสลิมเผชิญการข่มเหงอย่างหนักในมักกะห์\n• อัลลอฮ์สั่งให้อพยพไปมาดีนะห์\n• ท่านนบีและอบู บักร เดินทางอย่างลับๆ\n• พักในถ้ำษาวร์ 3 วัน\n• ชาวอันศอรในมาดีนะห์ต้อนรับด้วยความอบอุ่น\n• เหตุการณ์นี้เป็นจุดเริ่มต้นของปฏิทินอิสลาม (1 AH)',
    },
    {
      'no': 4, 'titleEn': 'Key Battles in Early Islam', 'titleTh': 'การสู้รบสำคัญในอิสลามยุคต้น',
      'arabic': 'وَأَعِدُّوا لَهُم مَّا اسْتَطَعْتُم مِّن قُوَّةٍ',
      'contentEn': 'Major battles:\n\n1. Battle of Badr (624 CE)\n   313 Muslims vs 1000 Makkans - First major victory\n\n2. Battle of Uhud (625 CE)\n   Muslims suffered defeat due to disobedience\n\n3. Battle of the Trench (627 CE)\n   Muslims dug a trench - Confederates failed\n\n4. Conquest of Makkah (630 CE)\n   Prophet entered Makkah peacefully with general amnesty',
      'contentTh': 'การสู้รบสำคัญ:\n\n1. การสู้รบที่บัดร์ (624 CE)\n   มุสลิม 313 คน vs ชาวมักกะห์ 1000 คน - ชัยชนะครั้งแรก\n\n2. การสู้รบที่อุฮุด (625 CE)\n   มุสลิมพ่ายแพ้เพราะไม่เชื่อฟัง\n\n3. การสู้รบที่สนามเพลาะ (627 CE)\n   มุสลิมขุดสนามเพลาะ - พวกสหพันธ์ล้มเหลว\n\n4. การพิชิตมักกะห์ (630 CE)\n   ท่านนบีเข้ามักกะห์อย่างสันติ ประกาศอภัยโทษทั่วไป',
    },
    {
      'no': 5, 'titleEn': 'The Four Rightly Guided Caliphs', 'titleTh': 'เคาะลีฟะห์ผู้ทรงธรรม 4 องค์',
      'arabic': 'خُلَفَاءُ الرَّاشِدُونَ',
      'contentEn': 'After the Prophet passed away (632 CE):\n\n1. Abu Bakr As-Siddiq (632-634 CE)\n   Unified Arabia, compiled the Quran\n\n2. Umar ibn al-Khattab (634-644 CE)\n   Greatly expanded the Islamic state\n\n3. Uthman ibn Affan (644-656 CE)\n   Standardized the Quran\n\n4. Ali ibn Abi Talib (656-661 CE)\n   Known for knowledge and justice',
      'contentTh': 'หลังจากท่านนบีเสียชีวิต (632 CE):\n\n1. อบู บักร อัส-ศิดดีก (632-634 CE)\n   รวมคาบสมุทรอาหรับ รวบรวมอัลกุรอาน\n\n2. อุมัร อิบน์ อัล-คัฏฏ็อบ (634-644 CE)\n   ขยายรัฐอิสลามอย่างยิ่งใหญ่\n\n3. อุษมาน อิบน์ อัฟฟาน (644-656 CE)\n   จัดระเบียบอัลกุรอาน\n\n4. อาลี อิบน์ อบี ฏอลิบ (656-661 CE)\n   เป็นที่รู้จักด้านความรู้และความยุติธรรม',
    },
    {
      'no': 6, 'titleEn': 'Spread of Islam', 'titleTh': 'การแพร่กระจายของอิสลาม',
      'arabic': 'هُوَ الَّذِي أَرْسَلَ رَسُولَهُ بِالْهُدَىٰ',
      'contentEn': 'Islam spread rapidly across the world:\n\n• 7th century: Arabia, Persia, Byzantine Empire\n• 8th century: North Africa, Spain, Central Asia\n• 9th-10th century: Trade routes to Southeast Asia\n• Today: 1.8 billion Muslims worldwide (24% of world population)\n\nIslam spread through trade, scholarship, and the message of the Quran.',
      'contentTh': 'อิสลามแพร่กระจายอย่างรวดเร็วทั่วโลก:\n\n• ศตวรรษที่ 7: คาบสมุทรอาหรับ เปอร์เซีย ไบแซนไทน์\n• ศตวรรษที่ 8: แอฟริกาเหนือ สเปน เอเชียกลาง\n• ศตวรรษที่ 9-10: เส้นทางการค้าสู่เอเชียตะวันออกเฉียงใต้\n• ปัจจุบัน: มุสลิม 1.8 พันล้านคนทั่วโลก (24% ของประชากรโลก)\n\nอิสลามแพร่กระจายผ่านการค้า วิชาการ และสารของอัลกุรอาน',
    },
  ];

  static final List<Map<String, dynamic>> _fasting = [
    {
      'no': 1, 'titleEn': 'The Virtues of Fasting', 'titleTh': 'คุณค่าของการถือศีลอด',
      'arabic': 'كُلُّ عَمَلِ ابْنِ آدَمَ لَهُ إِلَّا الصَّوْمَ فَإِنَّهُ لِي وَأَنَا أَجْزِي بِهِ',
      'contentEn': 'Allah says in the Hadith Qudsi:\n"Every deed of the son of Adam is for him except fasting; it is for Me and I shall reward it."\n\nVirtues of fasting:\n• Purifies the soul and body\n• Teaches patience and self-control\n• Develops empathy for the poor\n• Multiplied rewards from Allah\n• The gate of Rayyan in Paradise is only for those who fast\n• Fasting is a shield against sins',
      'contentTh': 'อัลลอฮ์ตรัสในหะดีษกุดซี:\n"ทุกการกระทำของบุตรอาดัมเป็นของเขา ยกเว้นการถือศีลอด มันเป็นของข้า และข้าจะตอบแทน"\n\nคุณค่าของการถือศีลอด:\n• ชำระจิตใจและร่างกาย\n• สอนความอดทนและการควบคุมตนเอง\n• พัฒนาความเห็นอกเห็นใจผู้ยากจน\n• รางวัลทวีคูณจากอัลลอฮ์\n• ประตูร็อยยานในสวรรค์สำหรับผู้ถือศีลอดเท่านั้น\n• การถือศีลอดเป็นโล่ป้องกันบาป',
    },
    {
      'no': 2, 'titleEn': 'Conditions of Fasting', 'titleTh': 'เงื่อนไขของการถือศีลอด',
      'arabic': 'يَا أَيُّهَا الَّذِينَ آمَنُوا كُتِبَ عَلَيْكُمُ الصِّيَامُ',
      'contentEn': 'Who must fast:\n• Muslim, sane, and adult (puberty)\n• Physically able (not seriously ill)\n• Not traveling (though can make up later)\n\nWho is exempt:\n• The ill - make up later\n• Travelers - make up later\n• Pregnant/breastfeeding women - make up or pay fidyah\n• The elderly who cannot fast - pay fidyah\n• Children - not obligatory\n\nFidyah = feeding one poor person per day missed',
      'contentTh': 'ผู้ที่ต้องถือศีลอด:\n• มุสลิม มีสติสัมปชัญญะ และบรรลุนิติภาวะ\n• มีสุขภาพแข็งแรง (ไม่ป่วยหนัก)\n• ไม่ได้เดินทาง (แต่ชดเชยได้)\n\nผู้ที่ได้รับการยกเว้น:\n• ผู้ป่วย - ชดเชยภายหลัง\n• นักเดินทาง - ชดเชยภายหลัง\n• สตรีตั้งครรภ์/ให้นม - ชดเชยหรือจ่ายฟิดยะห์\n• ผู้สูงอายุที่ไม่สามารถถือได้ - จ่ายฟิดยะห์\n• เด็ก - ยังไม่บังคับ\n\nฟิดยะห์ = เลี้ยงอาหารคนยากจน 1 คนต่อวันที่ขาด',
    },
    {
      'no': 3, 'titleEn': 'Things That Break the Fast', 'titleTh': 'สิ่งที่ทำให้เสียการถือศีลอด',
      'arabic': 'وَكُلُوا وَاشْرَبُوا حَتَّىٰ يَتَبَيَّنَ لَكُمُ الْخَيْطُ الْأَبْيَضُ',
      'contentEn': 'Major invalidators (require making up the fast):\n• Eating or drinking intentionally\n• Sexual intercourse\n• Intentional vomiting\n• Menstruation or postnatal bleeding\n\nThings that do NOT break the fast:\n• Unintentional eating or drinking (forgetting)\n• Rinsing the mouth or nose\n• Injection (for medical purposes)\n• Using eye drops\n• Kissing spouse (without swallowing)\n• Bad thoughts (without acting on them)',
      'contentTh': 'สิ่งที่ทำให้ศีลอดเสีย (ต้องชดเชย):\n• กินหรือดื่มโดยตั้งใจ\n• การมีเพศสัมพันธ์\n• อาเจียนโดยตั้งใจ\n• ประจำเดือนหรือเลือดหลังคลอด\n\nสิ่งที่ไม่ทำให้ศีลอดเสีย:\n• กินหรือดื่มโดยลืม (ไม่ตั้งใจ)\n• บ้วนปากหรือสูดน้ำเข้าจมูก\n• ฉีดยา (เพื่อการรักษา)\n• ใช้ยาหยอดตา\n• จูบคู่สมรส (โดยไม่กลืน)\n• ความคิดชั่ว (โดยไม่กระทำ)',
    },
    {
      'no': 4, 'titleEn': 'Etiquette of Fasting', 'titleTh': 'มารยาทในการถือศีลอด',
      'arabic': 'إِذَا كَانَ يَوْمُ صَوْمِ أَحَدِكُمْ فَلَا يَرْفُثْ وَلَا يَصْخَبْ',
      'contentEn': 'Sunnah acts during fasting:\n• Eat Suhoor (pre-dawn meal) - great blessing\n• Delay Suhoor until just before Fajr\n• Break fast promptly at Maghrib\n• Break fast with dates and water\n• Increase Quran recitation\n• Give more charity (Sadaqah)\n• Perform extra prayers (Tarawih)\n• Avoid bad speech, arguments and lies\n• Make lots of dua, especially at iftar\n• Seek Lailatul Qadr in last 10 nights',
      'contentTh': 'ซุนนะห์ในการถือศีลอด:\n• กินสะฮูร (อาหารก่อนรุ่งอรุณ) - มีบะเราะกะห์มาก\n• ช้าสะฮูรจนใกล้ฟัจร์\n• ละศีลอดทันทีเมื่อถึงมัฆริบ\n• ละศีลอดด้วยอินทผลัมและน้ำ\n• เพิ่มการอ่านอัลกุรอาน\n• บริจาคทานมากขึ้น\n• ละหมาดตะรอวีห์\n• หลีกเลี่ยงคำพูดไม่ดี การทะเลาะ และการโกหก\n• ดุอามากๆ โดยเฉพาะตอนละศีลอด\n• แสวงหาคืนลัยลาตุลก็อดร์ใน 10 คืนสุดท้าย',
    },
    {
      'no': 5, 'titleEn': 'Voluntary (Sunnah) Fasting', 'titleTh': 'การถือศีลอดสุนัต',
      'arabic': 'مَنْ صَامَ يَوْمًا فِي سَبِيلِ اللَّهِ بَعَّدَ اللَّهُ وَجْهَهُ عَنِ النَّارِ سَبْعِينَ خَرِيفًا',
      'contentEn': 'Recommended voluntary fasts:\n\n• 6 days of Shawwal (after Ramadan)\n  → Like fasting the whole year\n• Monday and Thursday\n  → Prophet fasted these days\n• 3 White Days (13th, 14th, 15th of each month)\n• Day of Arafah (9th Dhul Hijjah)\n  → Expiates sins of 2 years\n• Day of Ashura (10th Muharram)\n  → Expiates sins of 1 year\n• Fasting of Dawud (alternating days)',
      'contentTh': 'การถือศีลอดสุนัตที่แนะนำ:\n\n• 6 วันในเดือนชะวาล (หลังรอมฎอน)\n  → เหมือนถือศีลอดตลอดทั้งปี\n• วันจันทร์และพฤหัสบดี\n  → ท่านนบีถือศีลอดวันเหล่านี้\n• 3 วันขาว (วันที่ 13, 14, 15 ของทุกเดือน)\n• วันอะรอฟะห์ (9 ซุลฮิจญะห์)\n  → ลบบาป 2 ปี\n• วันอาชูรอ (10 มุฮัรรอม)\n  → ลบบาป 1 ปี\n• การถือศีลอดของนบีดาวูด (สลับวัน)',
    },
    {
      'no': 6, 'titleEn': 'Lailatul Qadr (Night of Power)', 'titleTh': 'ลัยลาตุลก็อดร์ (คืนแห่งพลัง)',
      'arabic': 'لَيْلَةُ الْقَدْرِ خَيْرٌ مِّنْ أَلْفِ شَهْرٍ',
      'contentEn': '"The Night of Power is better than a thousand months" (Quran 97:3)\n\nKey facts:\n• Falls in the last 10 odd nights of Ramadan (21, 23, 25, 27, 29)\n• Most likely the 27th night\n• Angels descend and peace prevails\n• Worship on this night = 83 years of worship\n\nHow to seek it:\n• Pray Tarawih and Tahajjud\n• Recite Quran abundantly\n• Make lots of dua\n• Recite: "Allahumma innaka afuwwun tuhibbul afwa faafu anni"\n• Give charity\n• Do Iikaf (seclusion in mosque)',
      'contentTh': '"คืนแห่งพลังดีกว่าหนึ่งพันเดือน" (อัลกุรอาน 97:3)\n\nข้อเท็จจริงสำคัญ:\n• อยู่ใน 10 คืนสุดท้ายที่เป็นคี่ของรอมฎอน (21, 23, 25, 27, 29)\n• น่าจะเป็นคืนที่ 27 มากที่สุด\n• มะลาอิกะห์ลงมาและมีความสงบสุข\n• การอิบาดะห์คืนนี้ = การอิบาดะห์ 83 ปี\n\nวิธีแสวงหา:\n• ละหมาดตะรอวีห์และตะฮัจญุด\n• อ่านอัลกุรอานมากๆ\n• ดุอามากๆ\n• อ่าน: "อัลลอฮุมมะ อินนะกะ อะฝุววุน ตุฮิบบุล อัฝวะ ฝะอ์ฝุ อันนี"\n• บริจาคทาน\n• อิอ์ติกาฟ (เก็บตัวในมัสยิด)',
    },
    {
      'no': 7, 'titleEn': 'Zakat al-Fitr', 'titleTh': 'ซะกาตุลฟิฏร์',
      'arabic': 'فَرَضَ رَسُولُ اللَّهِ زَكَاةَ الْفِطْرِ طُهْرَةً لِلصَّائِمِ',
      'contentEn': 'Zakat al-Fitr is obligatory charity at end of Ramadan.\n\n"The Prophet prescribed Zakat al-Fitr as purification of the fasting person from idle talk and obscenities, and as food for the poor."\n\nRulings:\n• Obligatory on every Muslim who has food beyond needs\n• Amount: 1 Sa (approx. 2.5-3 kg) of staple food or its cash equivalent\n• Must be paid before Eid prayer\n• Given to the poor and needy\n• Can be paid in cash equivalent in most schools\n\nPurpose:\n• Purifies the fasting person\n• Brings joy to the poor on Eid',
      'contentTh': 'ซะกาตุลฟิฏร์คือการบริจาคบังคับเมื่อสิ้นรอมฎอน\n\n"ท่านนบีบัญญัติซะกาตุลฟิฏร์เพื่อชำระผู้ถือศีลอดจากคำพูดไร้สาระและลามก และเป็นอาหารสำหรับคนยากจน"\n\nหลักการ:\n• บังคับสำหรับทุกมุสลิมที่มีอาหารเกินความต้องการ\n• จำนวน: 1 ศออ์ (ประมาณ 2.5-3 กก.) ของอาหารหลักหรือมูลค่าเทียบเท่า\n• ต้องจ่ายก่อนละหมาดอีด\n• ให้แก่คนยากจนและผู้ขัดสน\n• จ่ายเป็นเงินสดได้ตามทัศนะส่วนใหญ่\n\nจุดประสงค์:\n• ชำระผู้ถือศีลอด\n• นำความสุขมาสู่คนยากจนในวันอีด',
    },
  ];

  static final List<Map<String, dynamic>> _specialPrayer = [
    {
      'no': 1, 'titleEn': 'Eid al-Fitr Prayer', 'titleTh': 'ละหมาดอีดุลฟิฏร์',
      'arabic': 'وَقُومُوا لِلَّهِ قَانِتِينَ',
      'contentEn': 'Eid al-Fitr prayer is performed on the 1st of Shawwal after Ramadan.\n\nRulings:\n• Sunnah Muakkadah (strongly recommended)\n• Performed in congregation\n• Time: After sunrise until before Dhuhr\n• Best performed in open field (musalla)\n• No Adhan or Iqamah\n\nHow to pray:\n1. Intention for Eid prayer\n2. Takbiratul Ihram: "Allahu Akbar"\n3. First rakah: 7 additional takbirs\n4. Recite Al-Fatihah + Surah Al-Ala\n5. Second rakah: 5 additional takbirs\n6. Recite Al-Fatihah + Surah Al-Ghashiyah\n7. Imam delivers 2 khutbahs after prayer\n\nSunnah of Eid:\n• Eat before going for Eid al-Fitr prayer\n• Ghusl, wear best clothes\n• Recite Takbir on the way to prayer\n• Use different routes going and returning',
      'contentTh': 'ละหมาดอีดุลฟิฏร์ทำในวันที่ 1 เชาวาล หลังรอมฎอน\n\nหลักการ:\n• ซุนนะห์มุอักกะดะห์ (แนะนำอย่างยิ่ง)\n• ทำเป็นญะมาอะห์\n• เวลา: หลังพระอาทิตย์ขึ้นถึงก่อนซุฮร์\n• ดีที่สุดคือทำในที่โล่งแจ้ง\n• ไม่มีอาซานและอิกอมะห์\n\nวิธีละหมาด:\n1. ตั้งนิยะห์ละหมาดอีด\n2. ตักบีเราะตุลอิฮ์รอม: "อัลลอฮุอักบัร"\n3. ร็อกอะห์แรก: ตักบีรเพิ่ม 7 ครั้ง\n4. อ่านอัลฟาติฮะห์ + ซูเราะห์อัลอะลา\n5. ร็อกอะห์ที่สอง: ตักบีรเพิ่ม 5 ครั้ง\n6. อ่านอัลฟาติฮะห์ + ซูเราะห์อัลฆอชิยะห์\n7. อิหม่ามกล่าวคุฏบะห์ 2 ครั้งหลังละหมาด\n\nซุนนะห์วันอีด:\n• กินก่อนไปละหมาดอีดุลฟิฏร์\n• อาบน้ำ แต่งกายสวยงาม\n• อ่านตักบีรระหว่างทาง\n• ใช้เส้นทางต่างกันขาไปและขากลับ',
    },
    {
      'no': 2, 'titleEn': 'Eid al-Adha Prayer', 'titleTh': 'ละหมาดอีดุลอัฎฮา',
      'arabic': 'إِنَّ صَلَاتِي وَنُسُكِي وَمَحْيَايَ وَمَمَاتِي لِلَّهِ رَبِّ الْعَالَمِينَ',
      'contentEn': 'Eid al-Adha prayer is performed on 10th Dhul Hijjah.\n\nSame method as Eid al-Fitr prayer:\n• 2 rakahs with additional takbirs\n• First rakah: 7 takbirs\n• Second rakah: 5 takbirs\n\nDifferences from Eid al-Fitr:\n• Do NOT eat before prayer (sunnah to eat after)\n• Qurbani (sacrifice) is done after prayer\n• Days of sacrifice: 10, 11, 12, 13 Dhul Hijjah\n\nQurbani rulings:\n• Sunnah Muakkadah for those who can afford it\n• Animals: camel, cow, buffalo, goat, sheep\n• Must be healthy and of proper age\n• Meat divided into 3 parts:\n  - For self and family\n  - For relatives and friends\n  - For the poor\n\nTakbir of Tashreeq:\n• Recited after every fard prayer\n• From Fajr of 9th Dhul Hijjah\n• Until Asr of 13th Dhul Hijjah',
      'contentTh': 'ละหมาดอีดุลอัฎฮาทำในวันที่ 10 ซุลฮิจญะห์\n\nวิธีเหมือนละหมาดอีดุลฟิฏร์:\n• 2 ร็อกอะห์ พร้อมตักบีรเพิ่ม\n• ร็อกอะห์แรก: ตักบีร 7 ครั้ง\n• ร็อกอะห์ที่สอง: ตักบีร 5 ครั้ง\n\nต่างจากอีดุลฟิฏร์:\n• ไม่ควรกินก่อนละหมาด (ซุนนะห์กินหลัง)\n• เชือดกุรบาน (อุฎฮียะห์) หลังละหมาด\n• วันเชือด: 10, 11, 12, 13 ซุลฮิจญะห์\n\nหลักการกุรบาน:\n• ซุนนะห์มุอักกะดะห์สำหรับผู้มีความสามารถ\n• สัตว์: อูฐ วัว กระบือ แพะ แกะ\n• ต้องสุขภาพดีและอายุครบ\n• เนื้อแบ่ง 3 ส่วน:\n  - สำหรับตนเองและครอบครัว\n  - สำหรับญาติและเพื่อน\n  - สำหรับคนยากจน\n\nตักบีรตัชรีก:\n• อ่านหลังละหมาดฟัรดูทุกเวลา\n• ตั้งแต่ฟัจร์วันที่ 9 ซุลฮิจญะห์\n• ถึงอัศร์วันที่ 13 ซุลฮิจญะห์',
    },
    {
      'no': 3, 'titleEn': 'Funeral Prayer (Janazah)', 'titleTh': 'ละหมาดญะนาซะห์ (มายัต)',
      'arabic': 'وَلَا تَقُولُوا لِمَن يُقْتَلُ فِي سَبِيلِ اللَّهِ أَمْوَاتٌ',
      'contentEn': 'Janazah prayer is Fard Kifayah (communal obligation).\n\nConditions:\n• The deceased must be Muslim\n• Body must be washed and shrouded\n• Prayer must be before burial\n\nMethod:\n1. Stand facing Qibla, body in front\n2. First Takbir: recite Al-Fatihah\n3. Second Takbir: recite Salawat on Prophet\n4. Third Takbir: recite dua for deceased\n   "Allahummaghfir lahu warhamhu wa afihi wa\'fu anhu"\n5. Fourth Takbir: short dua or silent\n6. Give Salam to right and left\n\nNote:\n• No Ruku or Sujud\n• All done standing\n• No Adhan or Iqamah\n• Women may join the prayer\n• Can pray over grave if missed',
      'contentTh': 'ละหมาดญะนาซะห์เป็นฟัรดูกิฟายะห์ (ภาระรวมของชุมชน)\n\nเงื่อนไข:\n• ผู้เสียชีวิตต้องเป็นมุสลิม\n• ต้องอาบน้ำและห่อผ้าแล้ว\n• ต้องละหมาดก่อนฝังศพ\n\nวิธีละหมาด:\n1. ยืนหันหน้าไปทางกิบลัต ศพอยู่ข้างหน้า\n2. ตักบีรที่ 1: อ่านอัลฟาติฮะห์\n3. ตักบีรที่ 2: อ่านศอลาวาตแด่นบี\n4. ตักบีรที่ 3: ดุอาให้ผู้เสียชีวิต\n   "อัลลอฮุมมัฆฝิร ละฮู วัรฮัมฮุ วะอาฝิฮิ วัอ์ฝุ อันฮุ"\n5. ตักบีรที่ 4: ดุอาสั้นหรือนิ่ง\n6. กล่าวสลามซ้ายขวา\n\nหมายเหตุ:\n• ไม่มีรุกูอ์หรือสุญูด\n• ทั้งหมดทำในท่ายืน\n• ไม่มีอาซานหรืออิกอมะห์\n• สตรีเข้าร่วมได้\n• ละหมาดบนหลุมฝังศพได้หากพลาด',
    },
    {
      'no': 4, 'titleEn': 'Tarawih Prayer', 'titleTh': 'ละหมาดตะรอวีห์',
      'arabic': 'وَمِنَ اللَّيْلِ فَتَهَجَّدْ بِهِ نَافِلَةً لَّكَ',
      'contentEn': 'Tarawih is the special night prayer performed in Ramadan.\n\nRulings:\n• Sunnah Muakkadah\n• Performed in congregation at mosque\n• After Isha prayer and before Witr\n• Time: After Isha until Fajr\n\nNumber of rakahs:\n• Most common: 20 rakahs (Hanafi, Maliki, Shafi)\n• Also valid: 8 rakahs (based on some hadith)\n• Witr: 1 or 3 rakahs at end\n\nMethod:\n• Prayed in sets of 2 rakahs\n• Short rest (tarwihah) between sets\n• Complete Quran recitation in Ramadan (Khatam)\n\nVirtues:\n• "Whoever prays Ramadan nights with faith and seeking reward, his past sins are forgiven" (Bukhari)',
      'contentTh': 'ตะรอวีห์คือการละหมาดกลางคืนพิเศษในรอมฎอน\n\nหลักการ:\n• ซุนนะห์มุอักกะดะห์\n• ทำเป็นญะมาอะห์ในมัสยิด\n• หลังละหมาดอิชาอ์ก่อนวิตร์\n• เวลา: หลังอิชาอ์ถึงฟัจร์\n\nจำนวนร็อกอะห์:\n• นิยมมากที่สุด: 20 ร็อกอะห์ (ฮะนะฟี มาลิกี ชาฝีอี)\n• ถูกต้องเช่นกัน: 8 ร็อกอะห์ (ตามบางหะดีษ)\n• วิตร์: 1 หรือ 3 ร็อกอะห์ท้าย\n\nวิธีละหมาด:\n• ละหมาดทีละ 2 ร็อกอะห์\n• พักสั้นๆ (ตัรวีฮะห์) ระหว่างชุด\n• อ่านอัลกุรอานครบในรอมฎอน (ค็อตม์)\n\nอานิสงส์:\n• "ผู้ใดละหมาดในคืนรอมฎอนด้วยศรัทธาและหวังผลตอบแทน บาปที่ผ่านมาของเขาจะได้รับการอภัย" (บุคอรี)',
    },
    {
      'no': 5, 'titleEn': 'Istisqa Prayer (Rain Prayer)', 'titleTh': 'ละหมาดอิสติสก้า (ขอฝน)',
      'arabic': 'وَأَنِ اسْتَغْفِرُوا رَبَّكُمْ ثُمَّ تُوبُوا إِلَيْهِ',
      'contentEn': 'Istisqa prayer is performed to seek rain during drought.\n\nMethod:\n• 2 rakahs like Eid prayer\n• Imam delivers 2 khutbahs\n• In second khutbah: imam turns cloak inside out as sign of change\n• Make abundant dua and istighfar\n• Face Qibla during dua\n\nDua of Istisqa:\n"Allahumma-asqina ghaysan mughithan mari\'an mari\'an nafi\'an ghayra dharr"\n\nConditions for answered prayer:\n• Tawbah (repentance) before the prayer\n• Give charity to the poor\n• Resolve disputes and oppressions\n• Sincerity and humility before Allah\n\nWhen rain comes:\n• Say: "Allahumma sayyiban nafi\'a"\n• Do not curse the rain\n• Seek shelter from harmful rain',
      'contentTh': 'ละหมาดอิสติสก้าทำเพื่อขอฝนในยามแล้ง\n\nวิธีละหมาด:\n• 2 ร็อกอะห์ เหมือนละหมาดอีด\n• อิหม่ามกล่าวคุฏบะห์ 2 ครั้ง\n• ในคุฏบะห์ที่ 2: อิหม่ามพลิกเสื้อคลุมเป็นสัญลักษณ์การเปลี่ยนแปลง\n• ดุอาและอิสติฆฝารมากๆ\n• หันหน้าไปทางกิบลัตขณะดุอา\n\nดุอาอิสติสก้า:\n"อัลลอฮุมมัสกินา ฆอยษัน มุฆีษัน มะรีอัน มะรีอัน นาฝิอัน ฆอยรอ ดอรร์"\n\nเงื่อนไขสำหรับดุอาที่ถูกรับ:\n• เตาบะห์ (สำนึกผิด) ก่อนละหมาด\n• บริจาคทานให้คนยากจน\n• แก้ไขความขัดแย้งและการอธรรม\n• ความจริงใจและความถ่อมตนต่ออัลลอฮ์\n\nเมื่อฝนตก:\n• กล่าว: "อัลลอฮุมมะ ซ็อยยิบัน นาฝิอา"\n• อย่าด่าฝน\n• หลบฝนที่เป็นอันตราย',
    },
    {
      'no': 6, 'titleEn': 'Eclipse Prayer (Kusuf/Khusuf)', 'titleTh': 'ละหมาดกุสูฟ/คุสูฟ (สุริยุปราคา/จันทรุปราคา)',
      'arabic': 'إِنَّ الشَّمْسَ وَالْقَمَرَ آيَتَانِ مِنْ آيَاتِ اللَّهِ',
      'contentEn': '"The sun and moon are two of Allah\'s signs. They do not eclipse for the death of anyone." (Bukhari)\n\nKusuf = Solar eclipse\nKhusuf = Lunar eclipse\n\nMethod (unique, unlike regular prayer):\n1. First rakah:\n   - Recite Al-Fatihah + long surah\n   - Long Ruku\n   - Rise from Ruku\n   - Recite Al-Fatihah + surah again (shorter)\n   - Second long Ruku\n   - Rise, then Sujud (2 times)\n2. Second rakah: same as first\n\nDuration: Continue until eclipse ends\n\nSunnah:\n• Perform in congregation\n• Imam delivers khutbah after prayer\n• Make lots of dua, istighfar, and sadaqah\n• Free slaves (historically)',
      'contentTh': '"พระอาทิตย์และพระจันทร์เป็นสองสัญลักษณ์จากสัญลักษณ์ของอัลลอฮ์ พวกมันไม่ได้เกิดอุปราคาเพราะการตายของผู้ใด" (บุคอรี)\n\nกุสูฟ = สุริยุปราคา\nคุสูฟ = จันทรุปราคา\n\nวิธีละหมาด (พิเศษ ต่างจากปกติ):\n1. ร็อกอะห์แรก:\n   - อ่านอัลฟาติฮะห์ + ซูเราะห์ยาว\n   - รุกูอ์นาน\n   - ลุกจากรุกูอ์\n   - อ่านอัลฟาติฮะห์ + ซูเราะห์อีกครั้ง (สั้นกว่า)\n   - รุกูอ์นานครั้งที่สอง\n   - ลุกขึ้น แล้วสุญูด 2 ครั้ง\n2. ร็อกอะห์ที่สอง: เหมือนร็อกอะห์แรก\n\nระยะเวลา: ละหมาดจนกว่าอุปราคาจะสิ้นสุด\n\nซุนนะห์:\n• ทำเป็นญะมาอะห์\n• อิหม่ามกล่าวคุฏบะห์หลังละหมาด\n• ดุอา อิสติฆฝาร และบริจาคทานมากๆ',
    },
  ];
}
class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();

  final List<Map<String, dynamic>> _categories = [
    {'id': 'pillars', 'icon': '🕌',
     'titleEn': '5 Pillars of Islam', 'titleTh': '5 เสาหลักของอิสลาม', 'titleMs': '5 Rukun Islam', 'titleId': '5 Rukun Islam', 'titleAr': 'أركان الإسلام الخمسة', 'titleUr': 'اسلام کے 5 ارکان', 'titleBn': 'ইসলামের ৫ স্তম্ভ',
     'subtitleEn': 'The foundation of Islamic faith', 'subtitleTh': 'รากฐานของศาสนาอิสลาม', 'subtitleMs': 'Asas agama Islam', 'subtitleId': 'Dasar agama Islam', 'subtitleAr': 'أساس الإسلام', 'subtitleUr': 'اسلام کی بنیاد', 'subtitleBn': 'ইসলামের ভিত্তি',
     'color': const Color(0xFF1B5E20), 'lessons': 5},
    {'id': 'iman', 'icon': '💫',
     'titleEn': '6 Pillars of Iman', 'titleTh': '6 หลักอีหม่าน', 'titleMs': '6 Rukun Iman', 'titleId': '6 Rukun Iman', 'titleAr': 'أركان الإيمان الستة', 'titleUr': 'ایمان کے 6 ارکان', 'titleBn': 'ঈমানের ৬ স্তম্ভ',
     'subtitleEn': 'Articles of Islamic faith', 'subtitleTh': 'หลักความเชื่อในอิสลาม', 'subtitleMs': 'Kepercayaan asas Islam', 'subtitleId': 'Kepercayaan dasar Islam', 'subtitleAr': 'عقائد الإيمان', 'subtitleUr': 'ایمان کے عقائد', 'subtitleBn': 'ইসলামী বিশ্বাসের মূলনীতি',
     'color': const Color(0xFF1565C0), 'lessons': 6},
    {'id': 'wudhu', 'icon': '💧',
     'titleEn': 'How to Perform Wudhu', 'titleTh': 'วิธีทำวุฎูอ์', 'titleMs': 'Cara Berwudhu', 'titleId': 'Cara Berwudhu', 'titleAr': 'كيفية الوضوء', 'titleUr': 'وضو کا طریقہ', 'titleBn': 'ওযু করার নিয়ম',
     'subtitleEn': 'Step by step wudhu guide', 'subtitleTh': 'คู่มือวุฎูอ์ทีละขั้นตอน', 'subtitleMs': 'Panduan wudhu langkah demi langkah', 'subtitleId': 'Panduan wudhu langkah demi langkah', 'subtitleAr': 'دليل الوضوء خطوة بخطوة', 'subtitleUr': 'وضو کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে ওযুর গাইড',
     'color': const Color(0xFF0277BD), 'lessons': 1},
    {'id': 'prayer', 'icon': '🙏',
     'titleEn': 'How to Pray', 'titleTh': 'วิธีละหมาด', 'titleMs': 'Cara Solat', 'titleId': 'Cara Sholat', 'titleAr': 'كيفية الصلاة', 'titleUr': 'نماز کا طریقہ', 'titleBn': 'নামাজের পদ্ধতি',
     'subtitleEn': 'Step by step prayer guide', 'subtitleTh': 'คู่มือละหมาดทีละขั้นตอน', 'subtitleMs': 'Panduan solat langkah demi langkah', 'subtitleId': 'Panduan sholat langkah demi langkah', 'subtitleAr': 'دليل الصلاة خطوة بخطوة', 'subtitleUr': 'نماز کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে নামাজের গাইড',
     'color': const Color(0xFF6A1B9A), 'lessons': 7},
    {'id': 'hadith', 'icon': '📜',
     'titleEn': '40 Hadith', 'titleTh': '40 หะดีษ', 'titleMs': '40 Hadith', 'titleId': '40 Hadis', 'titleAr': '٤٠ حديثاً', 'titleUr': '40 احادیث', 'titleBn': '৪০ হাদিস',
     'subtitleEn': 'Key teachings of Prophet Muhammad', 'subtitleTh': 'คำสอนสำคัญของท่านนบี', 'subtitleMs': 'Ajaran utama Nabi Muhammad', 'subtitleId': 'Ajaran utama Nabi Muhammad', 'subtitleAr': 'تعاليم النبي محمد الأساسية', 'subtitleUr': 'نبی محمد کی اہم تعلیمات', 'subtitleBn': 'নবী মুহাম্মদের মূল শিক্ষা',
     'color': const Color(0xFF4E342E), 'lessons': 10},
    {'id': 'adab', 'icon': '🤝',
     'titleEn': 'Islamic Manners', 'titleTh': 'มารยาทอิสลาม', 'titleMs': 'Adab Islam', 'titleId': 'Adab Islam', 'titleAr': 'الآداب الإسلامية', 'titleUr': 'اسلامی آداب', 'titleBn': 'ইসলামী আদব',
     'subtitleEn': 'Etiquette in daily life', 'subtitleTh': 'มารยาทในชีวิตประจำวัน', 'subtitleMs': 'Adab dalam kehidupan harian', 'subtitleId': 'Etika dalam kehidupan sehari-hari', 'subtitleAr': 'الآداب في الحياة اليومية', 'subtitleUr': 'روزمرہ زندگی میں آداب', 'subtitleBn': 'দৈনন্দিন জীবনে শিষ্টাচার',
     'color': const Color(0xFF00695C), 'lessons': 5},
    {'id': 'history', 'icon': '🏛️',
     'titleEn': 'Islamic History', 'titleTh': 'ประวัติศาสตร์อิสลาม', 'titleMs': 'Sejarah Islam', 'titleId': 'Sejarah Islam', 'titleAr': 'التاريخ الإسلامي', 'titleUr': 'اسلامی تاریخ', 'titleBn': 'ইসলামের ইতিহাস',
     'subtitleEn': 'Key events in Islamic history', 'subtitleTh': 'เหตุการณ์สำคัญในประวัติอิสลาม', 'subtitleMs': 'Peristiwa penting dalam sejarah Islam', 'subtitleId': 'Peristiwa penting dalam sejarah Islam', 'subtitleAr': 'أحداث رئيسية في التاريخ الإسلامي', 'subtitleUr': 'اسلامی تاریخ کے اہم واقعات', 'subtitleBn': 'ইসলামের ইতিহাসের গুরুত্বপূর্ণ ঘটনা',
     'color': const Color(0xFFE65100), 'lessons': 6},
    {'id': 'fasting', 'icon': '🌙',
     'titleEn': 'Fasting (Sawm)', 'titleTh': 'การถือศีลอด (เซาม์)', 'titleMs': 'Puasa (Sawm)', 'titleId': 'Puasa (Shaum)', 'titleAr': 'الصيام', 'titleUr': 'روزہ (صوم)', 'titleBn': 'রোজা (সাওম)',
     'subtitleEn': 'The complete guide to Islamic fasting', 'subtitleTh': 'คู่มือการถือศีลอดในอิสลาม', 'subtitleMs': 'Panduan lengkap puasa Islam', 'subtitleId': 'Panduan lengkap puasa Islam', 'subtitleAr': 'الدليل الشامل للصيام الإسلامي', 'subtitleUr': 'اسلامی روزے کی مکمل رہنمائی', 'subtitleBn': 'ইসলামিক রোজার সম্পূর্ণ গাইড',
     'color': const Color(0xFF00838F), 'lessons': 7},
    {'id': 'special_prayer', 'icon': '🕌',
     'titleEn': 'Special Prayers', 'titleTh': 'ละหมาดพิเศษ', 'titleMs': 'Solat Khas', 'titleId': 'Sholat Khusus', 'titleAr': 'الصلوات الخاصة', 'titleUr': 'خصوصی نمازیں', 'titleBn': 'বিশেষ নামাজ',
     'subtitleEn': 'Eid, Funeral, Tarawih and more', 'subtitleTh': 'ละหมาดอีด ญะนาซะห์ ตะรอวีห์ และอื่นๆ', 'subtitleMs': 'Solat Eid, Jenazah, Tarawih dan lain-lain', 'subtitleId': 'Sholat Eid, Jenazah, Tarawih dan lainnya', 'subtitleAr': 'صلاة العيد والجنازة والتراويح وغيرها', 'subtitleUr': 'عید، جنازہ، تراویح اور دیگر نمازیں', 'subtitleBn': 'ঈদ, জানাজা, তারাবি এবং অন্যান্য',
     'color': const Color(0xFF4527A0), 'lessons': 6},
  ];

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: _categories.length,
          itemBuilder: (_, i) => _buildCard(_categories[i]),
        )),
      ]),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: _theme.isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A5C32)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)]),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22))]),
            const SizedBox(height: 8),
            const Text('📚', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(_lang.lang == 'th' ? 'บทเรียน' : 'Lessons',
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_lang.lang == 'th' ? 'เรียนรู้อิสลามทีละขั้นตอน' : 'Learn Islam step by step',
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> cat) {
    final title = _getLangText(cat, 'title', _lang.lang);
    final subtitle = _getLangText(cat, 'subtitle', _lang.lang);
    final color = cat['color'] as Color;
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
          builder: (_) => LessonDetailPage(category: cat, lang: _lang, theme: _theme))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFF0F0F0)),
          boxShadow: _theme.isDark ? null : [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Row(children: [
          Container(width: 4, height: 90,
            decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)))),
          const SizedBox(width: 16),
          Expanded(child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _theme.textColor)),
              const SizedBox(height: 3),
              Text(subtitle, style: TextStyle(fontSize: 12, color: _theme.subTextColor, height: 1.4)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text('${cat['lessons']} ${_lang.lang == 'th' ? 'บทเรียน' : 'lessons'}',
                    style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))),
            ]))),
          Padding(padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, size: 18, color: _theme.subTextColor)),
        ]),
      ),
    );
  }
}

// ── LessonDetailPage ───────────────────────────────
class LessonDetailPage extends StatelessWidget {
  final Map<String, dynamic> category;
  final LanguageService lang;
  final ThemeService theme;
  const LessonDetailPage({super.key, required this.category, required this.lang, required this.theme});

  @override
  Widget build(BuildContext context) {
    final title = _getLangText(category, 'title', lang.lang);
    final color = category['color'] as Color;
    final lessons = LessonData.getLesson(category['id']);

    return Scaffold(
      backgroundColor: theme.bgColor,
      body: Column(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [color, color.withOpacity(0.7)],
                begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24))),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(children: [
                Row(children: [
                  GestureDetector(onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22))]),
                const SizedBox(height: 8),
                Text(category['icon'], style: const TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                const SizedBox(height: 16),
              ]),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: lessons.length,
            itemBuilder: (_, i) {
              final lesson = lessons[i];
              final lessonTitle = _getLessonTitle(lesson, category['id'] as String, lang.lang, i);
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) {
                      final lessonWithCat = Map<String, dynamic>.from(lesson);
                      lessonWithCat['catId'] = category['id'];
                      return LessonContentPage(
                        lesson: lessonWithCat,
                        color: color,
                        lang: lang,
                        theme: theme,
                        translatedTitle: _getLessonTitle(lesson, category['id'] as String, lang.lang, i),
                      );
                    })),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.cardColor, borderRadius: BorderRadius.circular(16),
                    border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
                    boxShadow: [BoxShadow(color: theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2))]),
                  child: Row(children: [
                    Container(width: 40, height: 40,
                      decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
                      child: Center(child: Text('${lesson['no']}',
                          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)))),
                    const SizedBox(width: 14),
                    Expanded(child: Text(lessonTitle,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: theme.textColor))),
                    Icon(Icons.chevron_right, color: theme.subTextColor),
                  ]),
                ),
              );
            },
          ),
        ),
      ]),
    );
  }
}

// ── LessonContentPage ──────────────────────────────
class LessonContentPage extends StatelessWidget {
  final Map<String, dynamic> lesson;
  final Color color;
  final LanguageService lang;
  final ThemeService theme;
  final String? translatedTitle;
  const LessonContentPage({super.key, required this.lesson, required this.color, required this.lang, required this.theme, this.translatedTitle});

  @override
  Widget build(BuildContext context) {
    final title = translatedTitle ?? (lang.lang == 'th' ? lesson['titleTh'] : lesson['titleEn']);
    final catId = lesson['catId'] as String? ?? '';
    final lessonNo = lesson['no'] as int? ?? 0;
    final content = _getLessonContent(lesson, catId, lang.lang, lessonNo);
    final arabic = lesson['arabic'] ?? '';

    // Wudhu image
    const wudhuImages = {
      1: ['image/prayer/prayer_2_takbir.png'],
    };
    const prayerImages = {
      2: ['image/prayer/prayer_2_takbir.png'],
      3: ['image/prayer/prayer_3_qiraah.png'],
      4: ['image/prayer/prayer_4_ruku.png'],
      5: ['image/prayer/prayer_6_sujud.png',
          'image/prayer/prayer_7_juloos.png'],
      6: ['image/prayer/prayer_9_tashahhud1.png',
          'image/prayer/prayer_11_salam1.png',
          'image/prayer/prayer_12_salam2.png'],
      7: ['image/prayer/prayer_12_salam2.png'],
    };
    final List<String>? prayerImageList = catId == 'prayer'
        ? prayerImages[lessonNo]
        : catId == 'wudhu'
            ? wudhuImages[lessonNo]
            : null;

    return Scaffold(
      backgroundColor: theme.bgColor,
      appBar: AppBar(
        backgroundColor: color,
        title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
            child: Text('${lang.lang == 'th' ? 'บทที่' : 'Lesson'} ${lesson['no']}',
                style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 13))),
          const SizedBox(height: 16),
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: theme.textColor)),
          const SizedBox(height: 20),

          // Prayer image(s)
          if (prayerImageList != null && prayerImageList.isNotEmpty) ...[
            if (prayerImageList.length == 1)
              Container(
                height: 200,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: theme.isDark ? const Color(0xFF0D2E1A) : const Color(0xFFF1F8E9),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.15))),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(prayerImageList[0], fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Center(
                          child: Icon(Icons.image_not_supported_outlined,
                              color: theme.subTextColor, size: 40)))))
            else ...[
              Row(children: [
                for (int i = 0; i < prayerImageList.length; i++) ...[
                  Expanded(
                    child: Container(
                      height: 180,
                      margin: EdgeInsets.only(
                        right: i < prayerImageList.length - 1 ? 8 : 0),
                      decoration: BoxDecoration(
                        color: theme.isDark ? const Color(0xFF0D2E1A) : const Color(0xFFF1F8E9),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: color.withOpacity(0.15))),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.asset(prayerImageList[i], fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Center(
                                child: Icon(Icons.image_not_supported_outlined,
                                    color: theme.subTextColor, size: 32))))),
                  ),
                ],
              ]),
              const SizedBox(height: 20),
            ],
          ],
          if (arabic.isNotEmpty) ...[
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3))),
              child: Column(children: [
                Text(arabic, textAlign: TextAlign.center, textDirection: TextDirection.rtl,
                    style: TextStyle(fontSize: 24, height: 2.0, color: theme.textColor)),
                if (_getLessonTrans(lesson, lang.lang).isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(_getLessonTrans(lesson, lang.lang),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: theme.subTextColor,
                          fontStyle: FontStyle.italic, height: 1.6)),
                ],
              ]),
            ),
            const SizedBox(height: 20),
          ],
          Container(
            width: double.infinity, padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor, borderRadius: BorderRadius.circular(16),
              border: theme.isDark ? Border.all(color: ThemeService.darkBorder) : null),
            child: Text(content, style: TextStyle(fontSize: 15, color: theme.textColor, height: 1.8))),
          const SizedBox(height: 32),
        ]),
      ),
    );
  }
}

// ── LessonsTab (ใช้ใน DuaLessonsPage) ────────────
class LessonsTab extends StatefulWidget {
  const LessonsTab({super.key});
  @override
  State<LessonsTab> createState() => _LessonsTabState();
}

class _LessonsTabState extends State<LessonsTab> {
  final _theme = ThemeService();
  final _lang = LanguageService();

  final List<Map<String, dynamic>> _categories = [
    {'id': 'pillars', 'icon': '🕌',
     'titleEn': '5 Pillars of Islam', 'titleTh': '5 เสาหลักของอิสลาม', 'titleMs': '5 Rukun Islam', 'titleId': '5 Rukun Islam', 'titleAr': 'أركان الإسلام الخمسة', 'titleUr': 'اسلام کے 5 ارکان', 'titleBn': 'ইসলামের ৫ স্তম্ভ',
     'subtitleEn': 'The foundation of Islamic faith', 'subtitleTh': 'รากฐานของศาสนาอิสลาม', 'subtitleMs': 'Asas agama Islam', 'subtitleId': 'Dasar agama Islam', 'subtitleAr': 'أساس الإسلام', 'subtitleUr': 'اسلام کی بنیاد', 'subtitleBn': 'ইসলামের ভিত্তি',
     'color': const Color(0xFF1B5E20), 'lessons': 5},
    {'id': 'iman', 'icon': '💫',
     'titleEn': '6 Pillars of Iman', 'titleTh': '6 หลักอีหม่าน', 'titleMs': '6 Rukun Iman', 'titleId': '6 Rukun Iman', 'titleAr': 'أركان الإيمان الستة', 'titleUr': 'ایمان کے 6 ارکان', 'titleBn': 'ঈমানের ৬ স্তম্ভ',
     'subtitleEn': 'Articles of Islamic faith', 'subtitleTh': 'หลักความเชื่อในอิสลาม', 'subtitleMs': 'Kepercayaan asas Islam', 'subtitleId': 'Kepercayaan dasar Islam', 'subtitleAr': 'عقائد الإيمان', 'subtitleUr': 'ایمان کے عقائد', 'subtitleBn': 'ইসলামী বিশ্বাসের মূলনীতি',
     'color': const Color(0xFF1565C0), 'lessons': 6},
    {'id': 'wudhu', 'icon': '💧',
     'titleEn': 'How to Perform Wudhu', 'titleTh': 'วิธีทำวุฎูอ์', 'titleMs': 'Cara Berwudhu', 'titleId': 'Cara Berwudhu', 'titleAr': 'كيفية الوضوء', 'titleUr': 'وضو کا طریقہ', 'titleBn': 'ওযু করার নিয়ম',
     'subtitleEn': 'Step by step wudhu guide', 'subtitleTh': 'คู่มือวุฎูอ์ทีละขั้นตอน', 'subtitleMs': 'Panduan wudhu langkah demi langkah', 'subtitleId': 'Panduan wudhu langkah demi langkah', 'subtitleAr': 'دليل الوضوء خطوة بخطوة', 'subtitleUr': 'وضو کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে ওযুর গাইড',
     'color': const Color(0xFF0277BD), 'lessons': 1},
    {'id': 'prayer', 'icon': '🙏',
     'titleEn': 'How to Pray', 'titleTh': 'วิธีละหมาด', 'titleMs': 'Cara Solat', 'titleId': 'Cara Sholat', 'titleAr': 'كيفية الصلاة', 'titleUr': 'نماز کا طریقہ', 'titleBn': 'নামাজের পদ্ধতি',
     'subtitleEn': 'Step by step prayer guide', 'subtitleTh': 'คู่มือละหมาดทีละขั้นตอน', 'subtitleMs': 'Panduan solat langkah demi langkah', 'subtitleId': 'Panduan sholat langkah demi langkah', 'subtitleAr': 'دليل الصلاة خطوة بخطوة', 'subtitleUr': 'نماز کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে নামাজের গাইড',
     'color': const Color(0xFF6A1B9A), 'lessons': 7},
    {'id': 'hadith', 'icon': '📜',
     'titleEn': '40 Hadith', 'titleTh': '40 หะดีษ', 'titleMs': '40 Hadith', 'titleId': '40 Hadis', 'titleAr': '٤٠ حديثاً', 'titleUr': '40 احادیث', 'titleBn': '৪০ হাদিস',
     'subtitleEn': 'Key teachings of Prophet Muhammad', 'subtitleTh': 'คำสอนสำคัญของท่านนบี', 'subtitleMs': 'Ajaran utama Nabi Muhammad', 'subtitleId': 'Ajaran utama Nabi Muhammad', 'subtitleAr': 'تعاليم النبي محمد الأساسية', 'subtitleUr': 'نبی محمد کی اہم تعلیمات', 'subtitleBn': 'নবী মুহাম্মদের মূল শিক্ষা',
     'color': const Color(0xFF4E342E), 'lessons': 10},
    {'id': 'adab', 'icon': '🤝',
     'titleEn': 'Islamic Manners', 'titleTh': 'มารยาทอิสลาม', 'titleMs': 'Adab Islam', 'titleId': 'Adab Islam', 'titleAr': 'الآداب الإسلامية', 'titleUr': 'اسلامی آداب', 'titleBn': 'ইসলামী আদব',
     'subtitleEn': 'Etiquette in daily life', 'subtitleTh': 'มารยาทในชีวิตประจำวัน', 'subtitleMs': 'Adab dalam kehidupan harian', 'subtitleId': 'Etika dalam kehidupan sehari-hari', 'subtitleAr': 'الآداب في الحياة اليومية', 'subtitleUr': 'روزمرہ زندگی میں آداب', 'subtitleBn': 'দৈনন্দিন জীবনে শিষ্টাচার',
     'color': const Color(0xFF00695C), 'lessons': 5},
    {'id': 'history', 'icon': '🏛️',
     'titleEn': 'Islamic History', 'titleTh': 'ประวัติศาสตร์อิสลาม', 'titleMs': 'Sejarah Islam', 'titleId': 'Sejarah Islam', 'titleAr': 'التاريخ الإسلامي', 'titleUr': 'اسلامی تاریخ', 'titleBn': 'ইসলামের ইতিহাস',
     'subtitleEn': 'Key events in Islamic history', 'subtitleTh': 'เหตุการณ์สำคัญในประวัติอิสลาม', 'subtitleMs': 'Peristiwa penting dalam sejarah Islam', 'subtitleId': 'Peristiwa penting dalam sejarah Islam', 'subtitleAr': 'أحداث رئيسية في التاريخ الإسلامي', 'subtitleUr': 'اسلامی تاریخ کے اہم واقعات', 'subtitleBn': 'ইসলামের ইতিহাসের গুরুত্বপূর্ণ ঘটনা',
     'color': const Color(0xFFE65100), 'lessons': 6},
    {'id': 'fasting', 'icon': '🌙',
     'titleEn': 'Fasting (Sawm)', 'titleTh': 'การถือศีลอด (เซาม์)', 'titleMs': 'Puasa (Sawm)', 'titleId': 'Puasa (Shaum)', 'titleAr': 'الصيام', 'titleUr': 'روزہ (صوم)', 'titleBn': 'রোজা (সাওম)',
     'subtitleEn': 'The complete guide to Islamic fasting', 'subtitleTh': 'คู่มือการถือศีลอดในอิสลาม', 'subtitleMs': 'Panduan lengkap puasa Islam', 'subtitleId': 'Panduan lengkap puasa Islam', 'subtitleAr': 'الدليل الشامل للصيام الإسلامي', 'subtitleUr': 'اسلامی روزے کی مکمل رہنمائی', 'subtitleBn': 'ইসলামিক রোজার সম্পূর্ণ গাইড',
     'color': const Color(0xFF00838F), 'lessons': 7},
    {'id': 'special_prayer', 'icon': '🕌',
     'titleEn': 'Special Prayers', 'titleTh': 'ละหมาดพิเศษ', 'titleMs': 'Solat Khas', 'titleId': 'Sholat Khusus', 'titleAr': 'الصلوات الخاصة', 'titleUr': 'خصوصی نمازیں', 'titleBn': 'বিশেষ নামাজ',
     'subtitleEn': 'Eid, Funeral, Tarawih and more', 'subtitleTh': 'ละหมาดอีด ญะนาซะห์ ตะรอวีห์ และอื่นๆ', 'subtitleMs': 'Solat Eid, Jenazah, Tarawih dan lain-lain', 'subtitleId': 'Sholat Eid, Jenazah, Tarawih dan lainnya', 'subtitleAr': 'صلاة العيد والجنازة والتراويح وغيرها', 'subtitleUr': 'عید، جنازہ، تراویح اور دیگر نمازیں', 'subtitleBn': 'ঈদ, জানাজা, তারাবি এবং অন্যান্য',
     'color': const Color(0xFF4527A0), 'lessons': 6},
  ];

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categories.length,
      itemBuilder: (_, i) {
        final cat = _categories[i];
        final title = _getLangText(cat, 'title', _lang.lang);
        final subtitle = _getLangText(cat, 'subtitle', _lang.lang);
        final color = cat['color'] as Color;
        return GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(
              builder: (_) => LessonDetailPage(category: cat, lang: _lang, theme: _theme))),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: _theme.cardColor,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFF0F0F0)),
              boxShadow: _theme.isDark ? null : [
                BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
            child: Row(children: [
              Container(width: 4, height: 90,
                decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14), bottomLeft: Radius.circular(14)))),
              const SizedBox(width: 16),
              Expanded(child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(title, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: _theme.textColor)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: TextStyle(fontSize: 12, color: _theme.subTextColor, height: 1.4)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                    child: Text('${cat['lessons']} ${_lang.lang == 'th' ? 'บทเรียน' : 'lessons'}',
                        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))),
                ]))),
              Padding(padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.chevron_right, size: 18, color: _theme.subTextColor)),
            ]),
          ),
        );
      },
    );
  }
}