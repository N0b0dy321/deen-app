import 'package:flutter/material.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

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
    {'id': 'pillars', 'icon': '🕌', 'titleEn': '5 Pillars of Islam', 'titleTh': '5 เสาหลักของอิสลาม',
     'subtitleEn': 'The foundation of Islamic faith', 'subtitleTh': 'รากฐานของศาสนาอิสลาม',
     'color': const Color(0xFF1B5E20), 'lessons': 5},
    {'id': 'iman', 'icon': '💫', 'titleEn': '6 Pillars of Iman', 'titleTh': '6 หลักอีหม่าน',
     'subtitleEn': 'Articles of Islamic faith', 'subtitleTh': 'หลักความเชื่อในอิสลาม',
     'color': const Color(0xFF1565C0), 'lessons': 6},
    {'id': 'prayer', 'icon': '🙏', 'titleEn': 'How to Pray', 'titleTh': 'วิธีละหมาด',
     'subtitleEn': 'Step by step prayer guide', 'subtitleTh': 'คู่มือละหมาดทีละขั้นตอน',
     'color': const Color(0xFF6A1B9A), 'lessons': 8},
    {'id': 'hadith', 'icon': '📜', 'titleEn': '40 Hadith', 'titleTh': '40 หะดีษ',
     'subtitleEn': 'Key teachings of Prophet Muhammad', 'subtitleTh': 'คำสอนสำคัญของท่านนบี',
     'color': const Color(0xFF4E342E), 'lessons': 10},
    {'id': 'adab', 'icon': '🤝', 'titleEn': 'Islamic Manners', 'titleTh': 'มารยาทอิสลาม',
     'subtitleEn': 'Etiquette in daily life', 'subtitleTh': 'มารยาทในชีวิตประจำวัน',
     'color': const Color(0xFF00695C), 'lessons': 5},
    {'id': 'history', 'icon': '🏛️', 'titleEn': 'Islamic History', 'titleTh': 'ประวัติศาสตร์อิสลาม',
     'subtitleEn': 'Key events in Islamic history', 'subtitleTh': 'เหตุการณ์สำคัญในประวัติอิสลาม',
     'color': const Color(0xFFE65100), 'lessons': 6},
  ];

  @override
  void initState() {
    super.initState();
    _theme.addListener(() => setState(() {}));
    _lang.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _theme.removeListener(() => setState(() {}));
    _lang.removeListener(() => setState(() {}));
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
            Text(_lang.isThai ? 'บทเรียน' : 'Lessons',
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_lang.isThai ? 'เรียนรู้อิสลามทีละขั้นตอน' : 'Learn Islam step by step',
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> cat) {
    final title = _lang.isThai ? cat['titleTh'] : cat['titleEn'];
    final subtitle = _lang.isThai ? cat['subtitleTh'] : cat['subtitleEn'];
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
              child: Text('${cat['lessons']} ${_lang.isThai ? 'บทเรียน' : 'lessons'}',
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
    final title = lang.isThai ? category['titleTh'] : category['titleEn'];
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
              final lessonTitle = lang.isThai ? lesson['titleTh'] : lesson['titleEn'];
              return GestureDetector(
                onTap: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => LessonContentPage(lesson: lesson, color: color, lang: lang, theme: theme))),
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
  const LessonContentPage({super.key, required this.lesson, required this.color, required this.lang, required this.theme});

  @override
  Widget build(BuildContext context) {
    final title = lang.isThai ? lesson['titleTh'] : lesson['titleEn'];
    final content = lang.isThai ? lesson['contentTh'] : lesson['contentEn'];
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
            child: Text('${lang.isThai ? 'บทที่' : 'Lesson'} ${lesson['no']}',
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
    {'id': 'pillars', 'icon': '🕌', 'titleEn': '5 Pillars of Islam', 'titleTh': '5 เสาหลักของอิสลาม',
     'subtitleEn': 'The foundation of Islamic faith', 'subtitleTh': 'รากฐานของศาสนาอิสลาม',
     'color': const Color(0xFF1B5E20), 'lessons': 5},
    {'id': 'iman', 'icon': '💫', 'titleEn': '6 Pillars of Iman', 'titleTh': '6 หลักอีหม่าน',
     'subtitleEn': 'Articles of Islamic faith', 'subtitleTh': 'หลักความเชื่อในอิสลาม',
     'color': const Color(0xFF1565C0), 'lessons': 6},
    {'id': 'prayer', 'icon': '🙏', 'titleEn': 'How to Pray', 'titleTh': 'วิธีละหมาด',
     'subtitleEn': 'Step by step prayer guide', 'subtitleTh': 'คู่มือละหมาดทีละขั้นตอน',
     'color': const Color(0xFF6A1B9A), 'lessons': 8},
    {'id': 'hadith', 'icon': '📜', 'titleEn': '40 Hadith', 'titleTh': '40 หะดีษ',
     'subtitleEn': 'Key teachings of Prophet Muhammad', 'subtitleTh': 'คำสอนสำคัญของท่านนบี',
     'color': const Color(0xFF4E342E), 'lessons': 10},
    {'id': 'adab', 'icon': '🤝', 'titleEn': 'Islamic Manners', 'titleTh': 'มารยาทอิสลาม',
     'subtitleEn': 'Etiquette in daily life', 'subtitleTh': 'มารยาทในชีวิตประจำวัน',
     'color': const Color(0xFF00695C), 'lessons': 5},
    {'id': 'history', 'icon': '🏛️', 'titleEn': 'Islamic History', 'titleTh': 'ประวัติศาสตร์อิสลาม',
     'subtitleEn': 'Key events in Islamic history', 'subtitleTh': 'เหตุการณ์สำคัญในประวัติอิสลาม',
     'color': const Color(0xFFE65100), 'lessons': 6},
  ];

  @override
  void initState() {
    super.initState();
    _theme.addListener(() => setState(() {}));
    _lang.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _theme.removeListener(() => setState(() {}));
    _lang.removeListener(() => setState(() {}));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _categories.length,
      itemBuilder: (_, i) {
        final cat = _categories[i];
        final title = _lang.isThai ? cat['titleTh'] : cat['titleEn'];
        final subtitle = _lang.isThai ? cat['subtitleTh'] : cat['subtitleEn'];
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
                  child: Text('${cat['lessons']} ${_lang.isThai ? 'บทเรียน' : 'lessons'}',
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