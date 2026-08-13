import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

const Map<String, Map<String, List<String>>> kLessonTitleTranslations = {
  'ms': {
    'pillars': ['Syahadah (Pengakuan Iman)', 'Solat (Sembahyang)', 'Zakat (Derma)', 'Sawm (Puasa)', 'Haji (Ziarah)'],
    'iman': ['Percaya kepada Allah', 'Percaya kepada Malaikat', 'Percaya kepada Kitab Suci', 'Percaya kepada Nabi', 'Percaya kepada Hari Kiamat', 'Percaya kepada Qada dan Qadar'],
    'prayer': ['Syarat Solat', 'Cara Berwudhu', 'Niat dan Takbir', 'Bacaan dalam Berdiri', 'Rukuk', 'Sujud', 'Tahiyat dan Salam', 'Zikir Selepas Solat'],
    'hadith': ['Amal Bergantung pada Niat', 'Islam Dibina atas Lima', 'Halal dan Haram Jelas', 'Tidak Beriman Sempurna', 'Agama adalah Keikhlasan', 'Tinggalkan yang Tidak Perlu', 'Senyum adalah Sedekah', 'Kasih Sayang kepada Semua', 'Mukmin yang Kuat', 'Menghilangkan Mudarat'],
    'adab': ['Salam Islam', 'Adab Makan dan Minum', 'Menghormati Ibu Bapa', 'Kejujuran', 'Kebersihan (Taharah)'],
    'history': ['Nabi Muhammad - Awal Kehidupan', 'Wahyu Pertama', 'Hijrah ke Madinah', 'Peperangan Penting', 'Empat Khalifah', 'Penyebaran Islam'],
  },
  'id': {
    'pillars': ['Syahadat (Ikrar Iman)', 'Sholat (Sembahyang)', 'Zakat (Amal)', 'Shaum (Puasa)', 'Haji (Ziarah)'],
    'iman': ['Iman kepada Allah', 'Iman kepada Malaikat', 'Iman kepada Kitab Suci', 'Iman kepada Nabi', 'Iman kepada Hari Kiamat', 'Iman kepada Qada dan Qadar'],
    'prayer': ['Syarat Sholat', 'Cara Berwudhu', 'Niat dan Takbir', 'Bacaan dalam Berdiri', 'Ruku', 'Sujud', 'Tasyahud dan Salam', 'Dzikir Setelah Sholat'],
    'hadith': ['Amal Tergantung Niat', 'Islam Dibangun atas Lima', 'Halal dan Haram Jelas', 'Tidak Beriman Sempurna', 'Agama adalah Ketulusan', 'Tinggalkan yang Tidak Perlu', 'Senyum adalah Sedekah', 'Kasih Sayang kepada Semua', 'Mukmin yang Kuat', 'Menghilangkan Kemudharatan'],
    'adab': ['Salam Islam', 'Adab Makan dan Minum', 'Menghormati Orang Tua', 'Kejujuran', 'Kebersihan (Thaharah)'],
    'history': ['Nabi Muhammad - Kehidupan Awal', 'Wahyu Pertama', 'Hijrah ke Madinah', 'Perang Penting', 'Empat Khalifah', 'Penyebaran Islam'],
  },
  'ar': {
    'pillars': ['الشهادة (الإقرار بالإيمان)', 'الصلاة', 'الزكاة', 'الصوم', 'الحج'],
    'iman': ['الإيمان بالله', 'الإيمان بالملائكة', 'الإيمان بالكتب', 'الإيمان بالأنبياء', 'الإيمان باليوم الآخر', 'الإيمان بالقضاء والقدر'],
    'prayer': ['شروط الصلاة', 'كيفية الوضوء', 'النية والتكبير', 'القراءة في القيام', 'الركوع', 'السجود', 'التشهد والسلام', 'الأذكار بعد الصلاة'],
    'hadith': ['الأعمال بالنيات', 'بني الإسلام على خمس', 'الحلال بين والحرام بين', 'لا يؤمن أحدكم', 'الدين النصيحة', 'ترك ما لا يعنيك', 'التبسم صدقة', 'الرحمة بالخلق', 'المؤمن القوي', 'لا ضرر ولا ضرار'],
    'adab': ['السلام الإسلامي', 'آداب الأكل والشرب', 'احترام الوالدين', 'الصدق والأمانة', 'الطهارة'],
    'history': ['النبي محمد - حياته الأولى', 'الوحي الأول', 'الهجرة إلى المدينة', 'المعارك الكبرى', 'الخلفاء الراشدون الأربعة', 'انتشار الإسلام'],
  },
  'ur': {
    'pillars': ['شہادت (ایمان کا اقرار)', 'نماز', 'زکوٰۃ', 'روزہ', 'حج'],
    'iman': ['اللہ پر ایمان', 'فرشتوں پر ایمان', 'کتابوں پر ایمان', 'نبیوں پر ایمان', 'قیامت کے دن پر ایمان', 'تقدیر پر ایمان'],
    'prayer': ['نماز کی شرائط', 'وضو کا طریقہ', 'نیت اور تکبیر', 'قیام میں تلاوت', 'رکوع', 'سجدہ', 'تشہد اور سلام', 'نماز کے بعد اذکار'],
    'hadith': ['اعمال کا دارومدار نیتوں پر', 'اسلام پانچ چیزوں پر بنا ہے', 'حلال اور حرام واضح ہیں', 'کامل ایمان', 'دین خیرخواہی ہے', 'غیر ضروری چھوڑنا', 'مسکراہٹ صدقہ ہے', 'تمام مخلوق پر رحم', 'مضبوط مومن', 'نقصان نہ پہنچانا'],
    'adab': ['اسلامی سلام', 'کھانے پینے کے آداب', 'والدین کا احترام', 'سچائی اور دیانتداری', 'پاکیزگی (طہارت)'],
    'history': ['نبی محمد - ابتدائی زندگی', 'پہلی وحی', 'مدینہ کی طرف ہجرت', 'اہم غزوات', 'چار خلفائے راشدین', 'اسلام کا پھیلاؤ'],
  },
  'bn': {
    'pillars': ['শাহাদাহ (ঈমানের স্বীকৃতি)', 'সালাত (নামাজ)', 'যাকাত', 'সাওম (রোজা)', 'হজ'],
    'iman': ['আল্লাহর প্রতি ঈমান', 'ফেরেশতাদের প্রতি ঈমান', 'কিতাবসমূহের প্রতি ঈমান', 'নবীদের প্রতি ঈমান', 'কিয়ামত দিবসের প্রতি ঈমান', 'তাকদীরের প্রতি ঈমান'],
    'prayer': ['নামাজের শর্তসমূহ', 'ওযু করার নিয়ম', 'নিয়ত ও তাকবির', 'দাঁড়ানো অবস্থায় তিলাওয়াত', 'রুকু', 'সিজদাহ', 'তাশাহহুদ ও সালাম', 'নামাজের পরের যিকির'],
    'hadith': ['আমল নিয়তের উপর নির্ভরশীল', 'ইসলাম পাঁচটি স্তম্ভের উপর প্রতিষ্ঠিত', 'হালাল ও হারাম স্পষ্ট', 'পরিপূর্ণ ঈমান', 'দ্বীন হলো কল্যাণকামিতা', 'অপ্রয়োজনীয় ছেড়ে দেওয়া', 'হাসি সদকাহ', 'সকল সৃষ্টির প্রতি দয়া', 'শক্তিশালী মুমিন', 'ক্ষতি না করা'],
    'adab': ['ইসলামী সালাম', 'খাওয়া-দাওয়ার আদব', 'পিতামাতার প্রতি সম্মান', 'সততা ও সত্যবাদিতা', 'পবিত্রতা (তাহারাহ)'],
    'history': ['নবী মুহাম্মদ - প্রারম্ভিক জীবন', 'প্রথম ওহী', 'মদিনায় হিজরত', 'গুরুত্বপূর্ণ যুদ্ধসমূহ', 'চার খলিফা', 'ইসলামের বিস্তার'],
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
      2: {'title': 'Cara Berwudhu', 'content': 'Langkah-langkah Wudhu:\n\n1. Baca Bismillah\n2. Basuh kedua tangan 3 kali\n3. Kumur-kumur 3 kali\n4. Hirup air ke hidung 3 kali\n5. Basuh muka 3 kali\n6. Basuh tangan kanan hingga siku 3 kali, kemudian kiri\n7. Sapu kepala sekali\n8. Sapu telinga sekali\n9. Basuh kaki kanan hingga buku lali 3 kali, kemudian kiri\n10. Baca Syahadah'},
      3: {'title': 'Niat dan Takbir', 'content': 'Memulakan solat:\n\n1. Berdiri menghadap kiblat\n2. Buat niat dalam hati\n3. Angkat kedua tangan ke paras telinga\n4. Ucap Takbiratul Ihram: "Allahu Akbar"\n5. Letakkan tangan kanan atas tangan kiri di dada'},
      4: {'title': 'Bacaan dalam Berdiri', 'content': 'Selepas Takbir, baca:\n\n1. Doa Iftitah (sunat)\n2. Surah Al-Fatihah (wajib setiap rakaat)\n3. Surah atau ayat tambahan\n\nTanpa Al-Fatihah solat tidak sah.'},
      5: {'title': 'Rukuk', 'content': 'Melakukan Rukuk:\n\n1. Ucap "Allahu Akbar" sambil membongkok\n2. Bongkok dengan belakang lurus, tangan di lutut\n3. Baca: "Subhana Rabbiyal Adhim" (3 kali)\n4. Bangun sambil ucap: "Sami\'allahu liman hamidah"\n5. Ucap: "Rabbana lakal hamd"'},
      6: {'title': 'Sujud', 'content': 'Melakukan Sujud:\n\n1. Ucap "Allahu Akbar" ketika turun\n2. 7 anggota badan menyentuh lantai:\n   - Dahi dan hidung\n   - Kedua tapak tangan\n   - Kedua lutut\n   - Hujung kedua kaki\n3. Baca: "Subhana Rabbiyal A\'la" (3 kali)\n4. Bangun ucap "Allahu Akbar"\n5. Duduk sebentar, kemudian sujud kedua'},
      7: {'title': 'Tahiyat dan Salam', 'content': 'Duduk terakhir:\n\n1. Baca At-Tahiyyat\n2. Baca Selawat Ibrahimiyyah\n3. Baca doa sebelum salam\n4. Beri salam:\n   - Pusing kanan: "Assalamu Alaikum Warahmatullah"\n   - Pusing kiri: "Assalamu Alaikum Warahmatullah"\n\nSolat selesai!'},
      8: {'title': 'Zikir Selepas Solat', 'content': 'Zikir yang disyorkan:\n\n1. "Astaghfirullah" 3 kali\n2. Ayatul Kursi\n3. "Subhanallah" 33 kali\n4. "Alhamdulillah" 33 kali\n5. "Allahu Akbar" 33 kali'},
    },
    'id': {
      1: {'title': 'Syarat Sholat', 'content': 'Sebelum sholat, syarat berikut harus dipenuhi:\n\n1. Beragama Islam\n2. Berakal dan baligh\n3. Dalam keadaan suci (Wudhu)\n4. Pakaian dan tempat bersih\n5. Menghadap kiblat\n6. Waktu sholat sudah masuk\n7. Niat dalam hati'},
      2: {'title': 'Cara Berwudhu', 'content': 'Langkah-langkah Wudhu:\n\n1. Baca Bismillah\n2. Cuci kedua tangan 3 kali\n3. Berkumur 3 kali\n4. Hirup air ke hidung 3 kali\n5. Cuci muka 3 kali\n6. Cuci tangan kanan sampai siku 3 kali, lalu kiri\n7. Usap kepala sekali\n8. Usap telinga sekali\n9. Cuci kaki kanan sampai mata kaki 3 kali, lalu kiri\n10. Baca Syahadat'},
      3: {'title': 'Niat dan Takbir', 'content': 'Memulai sholat:\n\n1. Berdiri menghadap kiblat\n2. Buat niat dalam hati\n3. Angkat kedua tangan setinggi telinga\n4. Ucap Takbiratul Ihram: "Allahu Akbar"\n5. Letakkan tangan kanan di atas tangan kiri di dada'},
      4: {'title': 'Bacaan dalam Berdiri', 'content': 'Setelah Takbir, baca:\n\n1. Doa Iftitah (sunnah)\n2. Surah Al-Fatihah (wajib setiap rakaat)\n3. Surah atau ayat tambahan\n\nTanpa Al-Fatihah sholat tidak sah.'},
      5: {'title': 'Ruku', 'content': 'Melakukan Ruku:\n\n1. Ucap "Allahu Akbar" sambil membungkuk\n2. Bungkuk dengan punggung lurus, tangan di lutut\n3. Baca: "Subhana Rabbiyal Adhim" (3 kali)\n4. Bangkit sambil ucap: "Sami\'allahu liman hamidah"\n5. Ucap: "Rabbana lakal hamd"'},
      6: {'title': 'Sujud', 'content': 'Melakukan Sujud:\n\n1. Ucap "Allahu Akbar" saat turun\n2. 7 anggota badan menyentuh lantai:\n   - Dahi dan hidung\n   - Kedua telapak tangan\n   - Kedua lutut\n   - Ujung kedua kaki\n3. Baca: "Subhana Rabbiyal A\'la" (3 kali)\n4. Bangkit ucap "Allahu Akbar"\n5. Duduk sebentar, lalu sujud kedua'},
      7: {'title': 'Tasyahud dan Salam', 'content': 'Duduk terakhir:\n\n1. Baca At-Tahiyyat\n2. Baca Shalawat Ibrahimiyyah\n3. Baca doa sebelum salam\n4. Beri salam:\n   - Putar kanan: "Assalamu Alaikum Warahmatullah"\n   - Putar kiri: "Assalamu Alaikum Warahmatullah"\n\nSholat selesai!'},
      8: {'title': 'Dzikir Setelah Sholat', 'content': 'Dzikir yang dianjurkan:\n\n1. "Astaghfirullah" 3 kali\n2. Ayatul Kursi\n3. "Subhanallah" 33 kali\n4. "Alhamdulillah" 33 kali\n5. "Allahu Akbar" 33 kali'},
    },
    'ar': {
      1: {'title': 'شروط الصلاة', 'content': 'قبل الصلاة يجب توفر:\n\n1. الإسلام\n2. العقل والبلوغ\n3. الطهارة (الوضوء)\n4. طهارة الثوب والمكان\n5. استقبال القبلة\n6. دخول وقت الصلاة\n7. النية في القلب'},
      2: {'title': 'كيفية الوضوء', 'content': 'خطوات الوضوء:\n\n1. قل بسم الله\n2. اغسل الكفين 3 مرات\n3. المضمضة 3 مرات\n4. الاستنشاق 3 مرات\n5. اغسل الوجه 3 مرات\n6. اغسل اليدين إلى المرفق 3 مرات\n7. امسح الرأس مرة\n8. امسح الأذنين مرة\n9. اغسل القدمين 3 مرات\n10. اقرأ الشهادة'},
      3: {'title': 'النية والتكبير', 'content': 'بدء الصلاة:\n\n1. قف مستقبلاً القبلة\n2. انوِ في قلبك\n3. ارفع يديك إلى أذنيك\n4. قل تكبيرة الإحرام: "الله أكبر"\n5. ضع اليمنى على اليسرى على الصدر'},
      4: {'title': 'القراءة في القيام', 'content': 'بعد التكبير اقرأ:\n\n1. دعاء الاستفتاح (مستحب)\n2. سورة الفاتحة (ركن في كل ركعة)\n3. سورة أو آيات إضافية\n\nبدون الفاتحة لا تصح الصلاة.'},
      5: {'title': 'الركوع', 'content': 'أداء الركوع:\n\n1. قل "الله أكبر" وأنت راكع\n2. استوِ في الركوع، يداك على ركبتيك\n3. قل: "سبحان ربي العظيم" (3 مرات)\n4. ارفع قائلاً: "سمع الله لمن حمده"\n5. قل: "ربنا لك الحمد"'},
      6: {'title': 'السجود', 'content': 'أداء السجود:\n\n1. قل "الله أكبر" وأنت نازل\n2. 7 أعضاء تلمس الأرض:\n   - الجبهة والأنف\n   - الكفان\n   - الركبتان\n   - أطراف القدمين\n3. قل: "سبحان ربي الأعلى" (3 مرات)\n4. ارفع قائلاً "الله أكبر"\n5. اجلس ثم اسجد ثانياً'},
      7: {'title': 'التشهد والسلام', 'content': 'الجلسة الأخيرة:\n\n1. اقرأ التحيات\n2. اقرأ الصلاة الإبراهيمية\n3. ادعُ قبل السلام\n4. أدِّ السلام:\n   - يميناً: "السلام عليكم ورحمة الله"\n   - يساراً: "السلام عليكم ورحمة الله"\n\nانتهت الصلاة!'},
      8: {'title': 'الأذكار بعد الصلاة', 'content': 'الأذكار المستحبة:\n\n1. "أستغفر الله" 3 مرات\n2. آية الكرسي\n3. "سبحان الله" 33 مرة\n4. "الحمد لله" 33 مرة\n5. "الله أكبر" 33 مرة'},
    },
    'ur': {
      1: {'title': 'نماز کی شرائط', 'content': 'نماز سے پہلے یہ شرائط ضروری ہیں:\n\n1. مسلمان ہونا\n2. عاقل اور بالغ ہونا\n3. پاکیزہ ہونا (وضو)\n4. کپڑے اور جگہ پاک ہو\n5. قبلہ رخ ہونا\n6. نماز کا وقت داخل ہو\n7. دل میں نیت'},
      2: {'title': 'وضو کا طریقہ', 'content': 'وضو کے مراحل:\n\n1. بسم اللہ کہیں\n2. دونوں ہاتھ 3 بار دھوئیں\n3. 3 بار کلی کریں\n4. 3 بار ناک میں پانی لیں\n5. چہرہ 3 بار دھوئیں\n6. کہنی تک ہاتھ 3 بار\n7. سر کا مسح\n8. کانوں کا مسح\n9. ٹخنے تک پاؤں 3 بار\n10. شہادت پڑھیں'},
      3: {'title': 'نیت اور تکبیر', 'content': 'نماز شروع کرنا:\n\n1. قبلہ رخ کھڑے ہوں\n2. دل میں نیت کریں\n3. کانوں تک ہاتھ اٹھائیں\n4. تکبیر تحریمہ: "اللہ اکبر"\n5. سینے پر دائیں ہاتھ بائیں پر رکھیں'},
      4: {'title': 'قیام میں قرآت', 'content': 'تکبیر کے بعد پڑھیں:\n\n1. ثناء (سنت)\n2. سورہ فاتحہ (ہر رکعت میں فرض)\n3. اضافی سورہ یا آیات\n\nبغیر فاتحہ نماز نہیں ہوتی۔'},
      5: {'title': 'رکوع', 'content': 'رکوع کرنا:\n\n1. "اللہ اکبر" کہتے ہوئے جھکیں\n2. کمر سیدھی، ہاتھ گھٹنوں پر\n3. "سبحان ربی العظیم" (3 بار)\n4. "سمع اللہ لمن حمدہ" کہتے ہوئے اٹھیں\n5. "ربنا لک الحمد" کہیں'},
      6: {'title': 'سجدہ', 'content': 'سجدہ کرنا:\n\n1. "اللہ اکبر" کہتے ہوئے جھکیں\n2. 7 اعضاء زمین سے لگیں:\n   - پیشانی اور ناک\n   - دونوں ہتھیلیاں\n   - دونوں گھٹنے\n   - پاؤں کے انگلیاں\n3. "سبحان ربی الاعلی" (3 بار)\n4. "اللہ اکبر" کہتے اٹھیں'},
      7: {'title': 'تشہد اور سلام', 'content': 'آخری بیٹھک:\n\n1. التحیات پڑھیں\n2. درود ابراہیمی پڑھیں\n3. سلام سے پہلے دعا\n4. سلام پھیریں:\n   - دائیں: "السلام علیکم ورحمۃ اللہ"\n   - بائیں: "السلام علیکم ورحمۃ اللہ"\n\nنماز مکمل!'},
      8: {'title': 'نماز کے بعد اذکار', 'content': 'مستحب اذکار:\n\n1. "استغفر اللہ" 3 بار\n2. آیۃ الکرسی\n3. "سبحان اللہ" 33 بار\n4. "الحمد للہ" 33 بار\n5. "اللہ اکبر" 33 بار'},
    },
    'bn': {
      1: {'title': 'নামাজের শর্তসমূহ', 'content': 'নামাজের আগে শর্তসমূহ পূরণ করতে হবে:\n\n1. মুসলিম হওয়া\n2. সুস্থ মস্তিষ্ক ও প্রাপ্তবয়স্ক\n3. পবিত্র অবস্থায় থাকা (ওযু)\n4. কাপড় ও স্থান পবিত্র\n5. কিবলামুখী হওয়া\n6. নামাজের সময় হওয়া\n7. মনে নিয়ত করা'},
      2: {'title': 'ওযু করার নিয়ম', 'content': 'ওযুর ধাপসমূহ:\n\n1. বিসমিল্লাহ বলুন\n2. উভয় হাত ৩ বার ধুন\n3. ৩ বার কুলি করুন\n4. ৩ বার নাকে পানি দিন\n5. মুখ ৩ বার ধুন\n6. কনুই পর্যন্ত হাত ৩ বার\n7. মাথা একবার মাসেহ করুন\n8. কান একবার মাসেহ করুন\n9. গোড়ালি পর্যন্ত পা ৩ বার\n10. শাহাদাহ পড়ুন'},
      3: {'title': 'নিয়ত ও তাকবির', 'content': 'নামাজ শুরু করা:\n\n1. কিবলামুখী হয়ে দাঁড়ান\n2. মনে নিয়ত করুন\n3. কানের লতি পর্যন্ত হাত তুলুন\n4. তাকবিরে তাহরিমা: "আল্লাহু আকবার"\n5. ডান হাত বাম হাতের উপর বুকে রাখুন'},
      4: {'title': 'দাঁড়ানো অবস্থায় তিলাওয়াত', 'content': 'তাকবিরের পরে পড়ুন:\n\n1. দোয়া ইফতিতাহ (সুন্নত)\n2. সূরা আল-ফাতিহা (প্রতি রাকাতে ওয়াজিব)\n3. অতিরিক্ত সূরা বা আয়াত\n\nআল-ফাতিহা ছাড়া নামাজ হয় না।'},
      5: {'title': 'রুকু', 'content': 'রুকু করা:\n\n1. "আল্লাহু আকবার" বলে ঝুঁকুন\n2. পিঠ সোজা, হাত হাঁটুতে\n3. "সুবহানা রব্বিয়াল আযীম" (৩ বার)\n4. "সামিআল্লাহু লিমান হামিদাহ" বলে উঠুন\n5. "রব্বানা লাকাল হামদ" বলুন'},
      6: {'title': 'সিজদাহ', 'content': 'সিজদাহ করা:\n\n1. "আল্লাহু আকবার" বলে নামুন\n2. ৭টি অঙ্গ মাটি স্পর্শ করবে:\n   - কপাল ও নাক\n   - উভয় হাতের তালু\n   - উভয় হাঁটু\n   - উভয় পায়ের আঙুল\n3. "সুবহানা রব্বিয়াল আলা" (৩ বার)\n4. "আল্লাহু আকবার" বলে উঠুন'},
      7: {'title': 'তাশাহহুদ ও সালাম', 'content': 'শেষ বৈঠক:\n\n1. আত-তাহিয়্যাত পড়ুন\n2. দরুদে ইবরাহিম পড়ুন\n3. সালামের আগে দোয়া\n4. সালাম ফেরান:\n   - ডানে: "আস-সালামু আলাইকুম ওয়া রাহমাতুল্লাহ"\n   - বামে: "আস-সালামু আলাইকুম ওয়া রাহমাতুল্লাহ"\n\nনামাজ সম্পন্ন!'},
      8: {'title': 'নামাজের পরের যিকির', 'content': 'সুপারিশকৃত যিকির:\n\n1. "আস্তাগফিরুল্লাহ" ৩ বার\n2. আয়াতুল কুরসী\n3. "সুবহানাল্লাহ" ৩৩ বার\n4. "আলহামদুলিল্লাহ" ৩৩ বার\n5. "আল্লাহু আকবার" ৩৩ বার'},
    },
  },
};

// ── Lesson Data ────────────────────────────────────
class LessonData {
  static List<Map<String, dynamic>> getLesson(String id) {
    switch (id) {
      case 'pillars': return _pillars;
      case 'iman': return _iman;
      case 'prayer': return _prayer;
      case 'hadith': return _hadith;
      case 'adab': return _adab;
      case 'history': return _history;
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

  static final List<Map<String, dynamic>> _prayer = [
    {
      'no': 1, 'titleEn': 'Conditions of Prayer', 'titleTh': 'เงื่อนไขของการละหมาด',
      'arabic': 'إِنَّ الصَّلَاةَ كَانَتْ عَلَى الْمُؤْمِنِينَ كِتَابًا مَّوْقُوتًا',
      'contentEn': 'Before praying, these conditions must be met:\n\n1. Being Muslim\n2. Being sane and of age\n3. Being in a state of purity (Wudu or Ghusl)\n4. Clothes and place must be clean\n5. Facing the Qibla (direction of Makkah)\n6. Time of prayer must have entered\n7. Intention (Niyyah) in the heart',
      'contentTh': 'ก่อนละหมาด ต้องมีเงื่อนไขเหล่านี้:\n\n1. เป็นมุสลิม\n2. มีสติสัมปชัญญะและบรรลุนิติภาวะ\n3. อยู่ในสภาพสะอาด (วุฎูอ์หรือฆุสล์)\n4. เสื้อผ้าและสถานที่ต้องสะอาด\n5. หันหน้าไปทางกิบลัต (มักกะห์)\n6. ถึงเวลาละหมาดแล้ว\n7. มีเจตนา (นิยะห์) ในใจ',
    },
    {
      'no': 2, 'titleEn': 'How to Perform Wudu', 'titleTh': 'วิธีทำวุฎูอ์',
      'arabic': 'يَا أَيُّهَا الَّذِينَ آمَنُوا إِذَا قُمْتُمْ إِلَى الصَّلَاةِ فَاغْسِلُوا وُجُوهَكُمْ',
      'contentEn': 'Steps of Wudu (Ablution):\n\n1. Say Bismillah\n2. Wash both hands 3 times\n3. Rinse mouth 3 times\n4. Rinse nose 3 times\n5. Wash face 3 times\n6. Wash right arm to elbow 3 times, then left\n7. Wipe head once\n8. Wipe ears once\n9. Wash right foot to ankle 3 times, then left\n10. Say Shahada after wudu',
      'contentTh': 'ขั้นตอนการทำวุฎูอ์:\n\n1. กล่าวบิสมิลลาห์\n2. ล้างมือทั้งสองข้าง 3 ครั้ง\n3. บ้วนปาก 3 ครั้ง\n4. สูดน้ำเข้าจมูก 3 ครั้ง\n5. ล้างหน้า 3 ครั้ง\n6. ล้างแขนขวาถึงข้อศอก 3 ครั้ง แล้วซ้าย\n7. ลูบศีรษะ 1 ครั้ง\n8. ลูบหู 1 ครั้ง\n9. ล้างเท้าขวาถึงข้อเท้า 3 ครั้ง แล้วซ้าย\n10. กล่าวชะฮาดะห์หลังวุฎูอ์',
    },
    {
      'no': 3, 'titleEn': 'Intention and Takbir', 'titleTh': 'การตั้งเจตนาและตักบีร',
      'arabic': 'اللَّهُ أَكْبَرُ',
      'contentEn': 'Starting the prayer:\n\n1. Stand facing the Qibla\n2. Make intention (Niyyah) in your heart\n   Example: "I intend to pray Fajr 2 rakahs for Allah"\n3. Raise both hands to ear level\n4. Say Takbiratul Ihram: "Allahu Akbar"\n5. Place right hand over left on chest',
      'contentTh': 'การเริ่มต้นละหมาด:\n\n1. ยืนหันหน้าไปทางกิบลัต\n2. ตั้งนิยะห์ในใจ\n   ตัวอย่าง: "ฉันตั้งใจละหมาดฟัจร์ 2 ร็อกอะห์เพื่ออัลลอฮ์"\n3. ยกมือทั้งสองข้างขึ้นถึงใบหู\n4. กล่าวตักบีเราะตุลอิฮ์รอม: "อัลลอฮุอักบัร"\n5. วางมือขวาทับมือซ้ายไว้ที่หน้าอก',
    },
    {
      'no': 4, 'titleEn': 'Recitation in Standing', 'titleTh': 'การอ่านในท่ายืน',
      'arabic': 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ',
      'contentEn': 'After Takbir, recite:\n\n1. Dua Iftitah (Opening supplication) - Optional\n2. Surah Al-Fatihah (Obligatory in every rakah)\n3. Any additional Surah or verses from Quran\n\nAl-Fatihah is the most important recitation. Without it, the prayer is invalid.',
      'contentTh': 'หลังตักบีร กล่าว:\n\n1. ดุอาอิฟติตาห์ (ดุอาเริ่มต้น) - เป็นซุนนะห์\n2. ซูเราะห์อัล-ฟาติฮะห์ (บังคับในทุกร็อกอะห์)\n3. ซูเราะห์หรืออายะห์เพิ่มเติมจากอัลกุรอาน\n\nอัล-ฟาติฮะห์คือการอ่านที่สำคัญที่สุด ถ้าไม่อ่าน ละหมาดใช้ไม่ได้',
    },
    {
      'no': 5, 'titleEn': 'Ruku (Bowing)', 'titleTh': 'รุกูอ์ (การก้มโค้ง)',
      'arabic': 'سُبْحَانَ رَبِّيَ الْعَظِيمِ',
      'contentEn': 'Performing Ruku:\n\n1. Say "Allahu Akbar" while bowing\n2. Bow with back straight, hands on knees\n3. Head level with back\n4. Recite: "Subhana Rabbiyal Adhim" (3 times minimum)\n5. Rise saying: "Sami allahu liman hamidah"\n6. Say: "Rabbana lakal hamd"',
      'contentTh': 'การทำรุกูอ์:\n\n1. กล่าว "อัลลอฮุอักบัร" ขณะก้ม\n2. ก้มหลังให้ตรง มือวางบนเข่า\n3. ศีรษะอยู่ในระดับเดียวกับหลัง\n4. อ่าน: "ซุบฮานะ ร็อบบิยัล อะซีม" (อย่างน้อย 3 ครั้ง)\n5. ลุกขึ้นกล่าว: "ซะมิอัลลอฮุ ลิมัน ฮะมิดะห์"\n6. กล่าว: "ร็อบบานา ละกัล ฮัมด์"',
    },
    {
      'no': 6, 'titleEn': 'Sujud (Prostration)', 'titleTh': 'สุญูด (การกราบ)',
      'arabic': 'سُبْحَانَ رَبِّيَ الْأَعْلَى',
      'contentEn': 'Performing Sujud:\n\n1. Say "Allahu Akbar" going down\n2. 7 body parts touch the ground:\n   - Forehead and nose\n   - Both palms\n   - Both knees\n   - Tips of both feet\n3. Recite: "Subhana Rabbiyal Ala" (3 times minimum)\n4. Rise saying "Allahu Akbar"\n5. Sit briefly between two sajdahs\n6. Perform second sajdah',
      'contentTh': 'การทำสุญูด:\n\n1. กล่าว "อัลลอฮุอักบัร" ขณะลงกราบ\n2. อวัยวะ 7 ส่วนต้องแตะพื้น:\n   - หน้าผากและจมูก\n   - ฝ่ามือทั้งสองข้าง\n   - เข่าทั้งสองข้าง\n   - ปลายเท้าทั้งสองข้าง\n3. อ่าน: "ซุบฮานะ ร็อบบิยัล อะอ์ลา" (อย่างน้อย 3 ครั้ง)\n4. ลุกขึ้นกล่าว "อัลลอฮุอักบัร"\n5. นั่งพักสั้นๆ แล้วทำสุญูดครั้งที่สอง',
    },
    {
      'no': 7, 'titleEn': 'Tashahhud and Salutation', 'titleTh': 'ตะชะฮ์ฮุดและสลาม',
      'arabic': 'التَّحِيَّاتُ لِلَّهِ وَالصَّلَوَاتُ وَالطَّيِّبَاتُ',
      'contentEn': 'Final sitting:\n\n1. After the last rakah, sit in Tashahhud position\n2. Recite At-Tahiyyat\n3. Recite Salawat Ibrahimiyyah\n4. Make Dua before salam\n5. Give Salam:\n   - Turn right: "Assalamu Alaikum Wa Rahmatullah"\n   - Turn left: "Assalamu Alaikum Wa Rahmatullah"\n\nThe prayer is now complete!',
      'contentTh': 'การนั่งสุดท้าย:\n\n1. หลังร็อกอะห์สุดท้าย นั่งในท่าตะชะฮ์ฮุด\n2. อ่านอัต-ตะฮิยยาต\n3. อ่านศอลาวาตอิบรอฮีมียะห์\n4. ดุอาก่อนสลาม\n5. กล่าวสลาม:\n   - หันขวา: "อัสสะลามุอะลัยกุม วะเราะห์มะตุลลอฮ์"\n   - หันซ้าย: "อัสสะลามุอะลัยกุม วะเราะห์มะตุลลอฮ์"\n\nละหมาดเสร็จสมบูรณ์แล้ว!',
    },
    {
      'no': 8, 'titleEn': 'Dhikr After Prayer', 'titleTh': 'ซิกร์หลังละหมาด',
      'arabic': 'فَإِذَا قَضَيْتُمُ الصَّلَاةَ فَاذْكُرُوا اللَّهَ',
      'contentEn': 'Recommended dhikr after prayer:\n\n1. Say "Astaghfirullah" 3 times\n2. Say "Allahumma antas-salam..."\n3. Recite Ayatul Kursi\n4. "Subhanallah" 33 times\n5. "Alhamdulillah" 33 times\n6. "Allahu Akbar" 33 times\n7. "La ilaha illallah wahdahu..." once\n\nThese dhikr bring great reward and protection.',
      'contentTh': 'ซิกร์ที่แนะนำหลังละหมาด:\n\n1. กล่าว "อัสตัฆฟิรุลลอฮ์" 3 ครั้ง\n2. กล่าว "อัลลอฮุมมะ อันตัสสะลาม..."\n3. อ่านอายะตุลกุรซี\n4. "ซุบฮานัลลอฮ์" 33 ครั้ง\n5. "อัลฮัมดุลิลลาห์" 33 ครั้ง\n6. "อัลลอฮุอักบัร" 33 ครั้ง\n7. "ลา อิลาฮะ อิลลัลลอฮ์ วะห์ดะฮู..." 1 ครั้ง',
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
}

// ── LessonsPage ────────────────────────────────────
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
    {'id': 'prayer', 'icon': '🙏',
     'titleEn': 'How to Pray', 'titleTh': 'วิธีละหมาด', 'titleMs': 'Cara Solat', 'titleId': 'Cara Sholat', 'titleAr': 'كيفية الصلاة', 'titleUr': 'نماز کا طریقہ', 'titleBn': 'নামাজের পদ্ধতি',
     'subtitleEn': 'Step by step prayer guide', 'subtitleTh': 'คู่มือละหมาดทีละขั้นตอน', 'subtitleMs': 'Panduan solat langkah demi langkah', 'subtitleId': 'Panduan sholat langkah demi langkah', 'subtitleAr': 'دليل الصلاة خطوة بخطوة', 'subtitleUr': 'نماز کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে নামাজের গাইড',
     'color': const Color(0xFF6A1B9A), 'lessons': 8},
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
          color: _theme.cardColor, borderRadius: BorderRadius.circular(18),
          border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
          boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))]),
        child: Row(children: [
          Container(width: 8, height: 100,
            decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)))),
          const SizedBox(width: 16),
          Container(width: 56, height: 56,
            decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(cat['icon'], style: const TextStyle(fontSize: 28)))),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(fontSize: 12, color: _theme.subTextColor, height: 1.4)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Text('${cat['lessons']} ${_lang.lang == 'th' ? 'บทเรียน' : 'lessons'}',
                  style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))),
          ])),
          Padding(padding: const EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right, color: _theme.subTextColor)),
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
          if (arabic.isNotEmpty) ...[
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withOpacity(0.3))),
              child: Text(arabic, textAlign: TextAlign.center, textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 24, height: 2.0, color: theme.textColor)),
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
    {'id': 'prayer', 'icon': '🙏',
     'titleEn': 'How to Pray', 'titleTh': 'วิธีละหมาด', 'titleMs': 'Cara Solat', 'titleId': 'Cara Sholat', 'titleAr': 'كيفية الصلاة', 'titleUr': 'نماز کا طریقہ', 'titleBn': 'নামাজের পদ্ধতি',
     'subtitleEn': 'Step by step prayer guide', 'subtitleTh': 'คู่มือละหมาดทีละขั้นตอน', 'subtitleMs': 'Panduan solat langkah demi langkah', 'subtitleId': 'Panduan sholat langkah demi langkah', 'subtitleAr': 'دليل الصلاة خطوة بخطوة', 'subtitleUr': 'نماز کی مرحلہ وار رہنمائی', 'subtitleBn': 'ধাপে ধাপে নামাজের গাইড',
     'color': const Color(0xFF6A1B9A), 'lessons': 8},
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
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: _theme.cardColor, borderRadius: BorderRadius.circular(18),
              border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
              boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))]),
            child: Row(children: [
              Container(width: 8, height: 100,
                decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)))),
              const SizedBox(width: 16),
              Container(width: 56, height: 56,
                decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(14)),
                child: Center(child: Text(cat['icon'], style: const TextStyle(fontSize: 28)))),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(fontSize: 12, color: _theme.subTextColor, height: 1.4)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
                  child: Text('${cat['lessons']} ${_lang.lang == 'th' ? 'บทเรียน' : 'lessons'}',
                      style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))),
              ])),
              Padding(padding: const EdgeInsets.only(right: 12),
                  child: Icon(Icons.chevron_right, color: _theme.subTextColor)),
            ]),
          ),
        );
      },
    );
  }
}