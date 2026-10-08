import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import 'api_config.dart';

// ── Thai translations hardcoded ────────────────────
const Map<int, Map<String, String>> kDuaTranslations = {
  1:  {'titleTh': 'ดุอาตอนตื่นนอน', 'descTh': 'อ่านทุกเช้าหลังตื่นนอน', 'transTh': 'อัลฮัมดุลิลลาฮิลลาซี อะฮ์ยานา บะอ์ดะมา อะมาตานา วะอิลัยฮิน นุชูร'},
  2:  {'titleTh': 'ดุอาก่อนเข้าห้องน้ำ', 'descTh': 'อ่านก่อนเข้าห้องน้ำ', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มินัล คุบุษิ วัลคะบาอิษ'},
  3:  {'titleTh': 'ดุอาหลังออกจากห้องน้ำ', 'descTh': 'อ่านหลังออกจากห้องน้ำ', 'transTh': 'อัลฮัมดุลิลลาฮิลลาซี อัซฮะบะ อันนิยัล อะซา วะอาฟานี'},
  4:  {'titleTh': 'ดุอาตอนเปลี่ยนเสื้อผ้า', 'descTh': 'อ่านเมื่อสวมเสื้อผ้า', 'transTh': 'อัลฮัมดุลิลลาฮิลลาซี กะสานี ฮาซัษษะวบะ วะเราะซะกอนีฮิ มิน ฆอยริ เฮาลิน มินนี วะลา กุววะฮ์'},
  5:  {'titleTh': 'ดุอาตอนส่องกระจก', 'descTh': 'อ่านเมื่อมองกระจก', 'transTh': 'อัลลอฮุมมะ อันตะ ฮัสสันตะ คอลกี ฟะฮัสสิน คุลุกี'},
  6:  {'titleTh': 'ดุอาก่อนรับประทานอาหาร', 'descTh': 'อ่านก่อนเริ่มรับประทานอาหาร', 'transTh': 'บิสมิลลาฮ์'},
  7:  {'titleTh': 'ดุอาเมื่อลืมบิสมิลลาห์', 'descTh': 'อ่านเมื่อนึกขึ้นได้ระหว่างกิน', 'transTh': 'บิสมิลลาฮิ อาวิลาฮู วะอาคิรอฮู'},
  8:  {'titleTh': 'ดุอาหลังรับประทานอาหาร', 'descTh': 'อ่านหลังกินอาหารเสร็จ', 'transTh': 'อัลฮัมดุลิลลาฮิลลาซี อัฏอะมะนา วะซะกอนา วะญะอะละนา มินัล มุสลิมีน'},
  9:  {'titleTh': 'ดุอาตอนออกจากบ้าน', 'descTh': 'อ่านเมื่อออกจากบ้าน', 'transTh': 'บิสมิลลาฮิ ตะวักกัลตุ อะลัลลอฮ์ วะลา เฮาละ วะลา กุววะตะ อิลลา บิลลาฮ์'},
  10: {'titleTh': 'ดุอาตอนขึ้นยานพาหนะ', 'descTh': 'อ่านเมื่อขึ้นรถหรือยานพาหนะ', 'transTh': 'สุบฮานัลลาซี ซัคคอเราะ ลานา ฮาซา วะมา กุนนา ละฮู มุกรินีน วะอินนา อิลา รอบบินา ละมุนกอลิบูน'},
  11: {'titleTh': 'ดุอาการทักทาย (สลาม)', 'descTh': 'กล่าวเมื่อทักทายมุสลิม', 'transTh': 'อัสสะลามุอะลัยกุม วะเราะฮ์มะตุลลอฮิ วะบะเราะกาตุฮู'},
  12: {'titleTh': 'ดุอาตอบรับสลาม', 'descTh': 'กล่าวเมื่อตอบรับสลาม', 'transTh': 'วะอะลัยกุมุสสะลามุ วะเราะฮ์มะตุลลอฮิ วะบะเราะกาตุฮู'},
  13: {'titleTh': 'ดุอาตอนจาม', 'descTh': 'กล่าวหลังจาม', 'transTh': 'อัลฮัมดุลิลลาฮ์'},
  14: {'titleTh': 'ดุอาเมื่อได้ยินคนอื่นจาม', 'descTh': 'กล่าวเมื่อได้ยินคนจาม', 'transTh': 'ยัรฮะมุกัลลอฮ์'},
  15: {'titleTh': 'ดุอาตอบรับยัรฮามุกัลลอฮ์', 'descTh': 'กล่าวตอบเมื่อมีคนอวยพรหลังจาม', 'transTh': 'ยัฮดีกุมุลลอฮุ วะยุศลิฮุ บาละกุม'},
  16: {'titleTh': 'ดุอาเมื่อเห็นผู้อื่นตกทุกข์', 'descTh': 'อ่านเงียบๆ เมื่อเห็นคนเดือดร้อน', 'transTh': 'อัลฮัมดุลิลลาฮิ อัลลาซี อาฟานี มิมมับตะลากะ บิฮี'},
  17: {'titleTh': 'ดุอาตอนเข้าตลาด', 'descTh': 'อ่านเมื่อเข้าตลาดหรือร้านค้า', 'transTh': 'ลา อิลาฮะ อิลลัลลอฮุ วะฮ์ดะฮู ลา ชะรีกะ ละฮู ละฮุล มุลกุ วะละฮุล ฮัมดุ'},
  18: {'titleTh': 'ดุอาตอนเข้าบ้าน', 'descTh': 'อ่านเมื่อเข้าบ้าน', 'transTh': 'บิสมิลลาฮิ วะลัจนา วะบิสมิลลาฮิ คอรอจนา วะอะลา รอบบินา ตะวักกัลนา'},
  19: {'titleTh': 'ดุอาก่อนนอน', 'descTh': 'อ่านก่อนเข้านอน', 'transTh': 'บิสมิกัลลอฮุมมะ อะมูตุ วะอะฮ์ยา'},
  20: {'titleTh': 'ดุอาหลังวุฎูอ์', 'descTh': 'อ่านหลังทำวุฎูอ์เสร็จ', 'transTh': 'อัชฮะดุ อัน ลา อิลาฮะ อิลลัลลอฮุ วะฮ์ดะฮู ลา ชะรีกะ ละฮู วะอัชฮะดุ อันนะ มุฮัมมะดัน อับดุฮู วะเราะซูลุฮู'},
  21: {'titleTh': 'ดุอาตอนเข้ามัสยิด', 'descTh': 'อ่านเมื่อเข้ามัสยิด', 'transTh': 'อัลลอฮุมมัฟตัฮ์ ลี อับวาบะ เราะฮ์มะติก'},
  22: {'titleTh': 'ดุอาระหว่างอาซาน', 'descTh': 'กล่าวแทนการทวนวลีหัยยะ', 'transTh': 'ลา เฮาลา วะลา กุววะตะ อิลลา บิลลาฮ์'},
  23: {'titleTh': 'ดุอาหลังอาซานเสร็จ', 'descTh': 'อ่านหลังได้ยินอาซานจบ', 'transTh': 'อัลลอฮุมมะ รอบบะ ฮาซิฮิดดะอ์วะติต ตัมมะฮ์ วัศศอลาติล กออิมะฮ์ อาติ มุฮัมมะดานิล วะซีละตะ วัลฟะดีละฮ์'},
  24: {'titleTh': 'ดุอาเริ่มละหมาด (ษะนาอ์)', 'descTh': 'อ่านต้นละหมาดหลังตักบีร', 'transTh': 'สุบฮานะกัลลอฮุมมะ วะบิฮัมดิกะ วะตะบาเราะกัสมุกะ วะตะอาลา ญัดดุกะ วะลา อิลาฮะ ฆ็อยรุก'},
  25: {'titleTh': 'ดุอาตอนรุกูอ์', 'descTh': 'อ่านขณะก้มรุกูอ์ในละหมาด', 'transTh': 'สุบฮานะ รอบบิยัล อะซีม'},
  26: {'titleTh': 'ดุอาตอนสุญูด', 'descTh': 'อ่านขณะสุญูดในละหมาด', 'transTh': 'สุบฮานะ รอบบิยัล อะอ์ลา'},
  27: {'titleTh': 'อัตตะฮิยยาต', 'descTh': 'อ่านในท่านั่งระหว่างละหมาด', 'transTh': 'อัตตะฮิยยาตุ ลิลลาฮิ วัศศอลาวาตุ วัฏฏ็อยยิบาตุ อัสสะลามุ อะลัยกะ อัยยุฮันนะบิยยุ'},
  28: {'titleTh': 'ศอลาวาตอิบรอฮีมียะห์', 'descTh': 'อ่านหลังอัตตะฮิยยาต', 'transTh': 'อัลลอฮุมมะ ศ็อลลิ อะลา มุฮัมมะดิน วะอะลา อาลิ มุฮัมมะดิน'},
  29: {'titleTh': 'ดุอาก่อนสลามละหมาด', 'descTh': 'อ่านตอนท้ายละหมาดก่อนสลาม', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มิน อะซาบิล กอบรี วะมิน อะซาบิน นาร์'},
  30: {'titleTh': 'ดุอากุนูต', 'descTh': 'อ่านในละหมาดวิตร์', 'transTh': 'อัลลอฮุมมะ อิฮ์ดินา ฟีมัน ฮะดัยตะ วะอาฟินา ฟีมัน อาฟัยตะ'},
  31: {'titleTh': 'ดุอาขอการอภัยหลังละหมาด', 'descTh': 'อ่านทันทีหลังละหมาดเสร็จ', 'transTh': 'อัสตัฆฟิรุลลอฮ์'},
  32: {'titleTh': 'ดุอาขอความช่วยเหลือในการอิบาดะห์', 'descTh': 'อ่านหลังละหมาดเสร็จ', 'transTh': 'อัลลอฮุมมะ อะอินนี อะลา ซิกริกะ วะชุกริกะ วะฮุสนิ อิบาดะติก'},
  33: {'titleTh': 'ซิกร์หลังละหมาด', 'descTh': 'ซุบฮานัลลอฮ์ 33x อัลฮัมดุลิลลาห์ 33x อัลลอฮุอักบัร 33x', 'transTh': 'สุบฮานัลลอฮ์ x33 อัลฮัมดุลิลลาฮ์ x33 อัลลอฮุอักบัร x33'},
  34: {'titleTh': 'ดุอาตอนออกจากมัสยิด', 'descTh': 'อ่านเมื่อออกจากมัสยิด', 'transTh': 'อัลลอฮุมมะ อินนี อัสอะลุกะ มิน ฟัดลิก'},
  35: {'titleTh': 'ดุอาต้อนรับรอมฎอน', 'descTh': 'อ่านเมื่อเริ่มเดือนรอมฎอน', 'transTh': 'อัลลอฮุมมะ บาริกลานา ฟี รอญับ วะชะอ์บานะ วะบัลลิฆนา รอมะดอน'},
  36: {'titleTh': 'ดุอาละศีลอด (อิฟตาร์)', 'descTh': 'อ่านเมื่อละศีลอดตอนพระอาทิตย์ตก', 'transTh': 'อัลลอฮุมมะ ลากะ ศุมตุ วะอะลา ริซกิกะ อัฟตอรตุ'},
  37: {'titleTh': 'ดุอาคืนลัยลาตุลก็อดร์', 'descTh': 'อ่านบ่อยๆ ใน 10 คืนสุดท้ายของรอมฎอน', 'transTh': 'อัลลอฮุมมะ อินนะกะ อะฝุววุน ตุฮิบบุล อัฝวะ ฝะอ์ฝุ อันนี'},
  38: {'titleTh': 'ดุอาอิสติคอเราะห์', 'descTh': 'อ่านหลังละหมาด 2 ร็อกอะห์เมื่อตัดสินใจเรื่องสำคัญ', 'transTh': 'อัลลอฮุมมะ อินนี อัสตะคีรุกะ บิอิลมิกะ วะอัสตักดิรุกะ บิกุดรอติก'},
  39: {'titleTh': 'ดุอาขอความสะดวก', 'descTh': 'อ่านเมื่อเผชิญความยากลำบาก', 'transTh': 'อัลลอฮุมมะ ลา ซะฮ์ลา อิลลา มา ญะอัลตะฮู ซะฮ์ลา'},
  40: {'titleTh': 'ดุอาขอการรักษาจากความเจ็บป่วย', 'descTh': 'วางมือที่บริเวณที่เจ็บแล้วอ่าน', 'transTh': 'บิสมิลลาฮ์ อะอูซุ บิอิซซะติลลาฮิ วะกุดรอติฮิ มิน ชัรริ มา อะญิดุ'},
  41: {'titleTh': 'ดุอาขอปกป้องจากความชั่ว', 'descTh': 'อ่านเพื่อขอปกป้องจากชัยฏอน', 'transTh': 'อะอูซุ บิกะลิมาติลลาฮิตตัมมาติ มิน ชัรริ มา คอลอก'},
  42: {'titleTh': 'ดุอาขอปกป้องจากความยากจน', 'descTh': 'อ่านเมื่อประสบปัญหาการเงิน', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มินัล ฝักริ วัลกิลละติ วัซซิลละฮ์'},
  43: {'titleTh': 'ดุอาขอปกป้องจากความวิตกกังวล', 'descTh': 'อ่านเมื่อรู้สึกวิตกกังวลหรือเศร้า', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มินัล ฮัมมิ วัลฮะซัน'},
  44: {'titleTh': 'ดุอาเมื่อมีความสงสัยหรือโกรธ', 'descTh': 'อ่านเมื่อมีความสงสัยในศรัทธาหรือโกรธ', 'transTh': 'อะอูซุ บิลลาฮิมินัช ชัยฏอนิรเราะญีม'},
  45: {'titleTh': 'ดุอาก่อนเดินทาง', 'descTh': 'อ่านเมื่อออกเดินทาง', 'transTh': 'อัลลอฮุมมะ อินนา นัสอะลุกะ ฟี ซะฝะรินา ฮาซัล บิรรอ วัตตักวา'},
  46: {'titleTh': 'ดุอาตอนกลับจากเดินทาง', 'descTh': 'อ่านเมื่อกลับถึงบ้านจากการเดินทาง', 'transTh': 'อายิบูนะ ตาอิบูนะ อาบิดูนะ ลิรอบบินา ฮามิดูน'},
  47: {'titleTh': 'ดุอาเพื่อพ่อแม่', 'descTh': 'อ่านขอให้อัลลอฮ์เมตตาพ่อแม่', 'transTh': 'รอบบิรฮัมฮุมา กะมา รอบบะยานี ศ็อฆีรา'},
  48: {'titleTh': 'ดุอาอวยพรคู่บ่าวสาว', 'descTh': 'อ่านเป็นพรให้คู่บ่าวสาวใหม่', 'transTh': 'บาเราะกัลลอฮุ ละกะ วะบาเราะกะ อะลัยกะ วะญะมะอะ บัยนะกุมา ฝี คอยร์'},
  49: {'titleTh': 'ดุอาก่อนมีเพศสัมพันธ์', 'descTh': 'อ่านเพื่อขอปกป้องลูกหลานจากชัยฏอน', 'transTh': 'บิสมิลลาฮ์ อัลลอฮุมมะ ญันนิบนัช ชัยฏอนะ วะญันนิบิช ชัยฏอนะ มา เราะซักตะนา'},
  50: {'titleTh': 'ดุอาปกป้องเด็ก', 'descTh': 'อ่านเพื่อปกป้องเด็กจากสิ่งชั่วร้าย', 'transTh': 'อุอีซุกุมา บิกะลิมาติลลาฮิตตัมมะติ มิน กุลลิ ชัยฏอนิน วะฮัมมะฮ์'},
  51: {'titleTh': 'ดุอาขอบคุณผู้อื่น', 'descTh': 'กล่าวเมื่อมีคนทำดีกับเรา', 'transTh': 'ญะซากัลลอฮุ คอยรัน'},
  52: {'titleTh': 'ดุอาอวยพรเจ้าภาพหลังกินอาหาร', 'descTh': 'อ่านเป็นพรให้เจ้าภาพที่เชิญมากิน', 'transTh': 'อัลลอฮุมมะ อัฏอิมฮุม วัสกิฮิม วะบาริกลาฮุม'},
  53: {'titleTh': 'ดุอาเยี่ยมผู้ป่วย', 'descTh': 'อ่าน 7 ครั้งเมื่อเยี่ยมผู้ป่วย', 'transTh': 'อัสอะลุลลอฮัล อะซีมะ รอบบัล อัรชิล อะซีมิ อัน ยัชฝิยะก x7'},
  54: {'titleTh': 'ดุอาละหมาดญะนาซะห์ (ผู้ใหญ่)', 'descTh': 'อ่านหลังตักบีร์ที่ 3 ในละหมาดญะนาซะห์', 'transTh': 'อัลลอฮุมมัฆฝิร ละฮู วัรฮัมฮุ วะอาฝิฮิ วัอ์ฝุ อันฮุ'},
  55: {'titleTh': 'ดุอาละหมาดญะนาซะห์ (เด็ก)', 'descTh': 'อ่านในละหมาดญะนาซะห์สำหรับเด็ก', 'transTh': 'อัลลอฮุมมัฆฝิร ลิวาลิดัยนา วะลิญะมีอิล มุสลิมีน'},
  56: {'titleTh': 'ดุอาตอนเข้าสุสาน', 'descTh': 'อ่านเมื่อเข้าสุสาน', 'transTh': 'อัสสะลามุ อะลัยกุม ยา อะฮ์ลัล กุบูร'},
  57: {'titleTh': 'ซัยยิดุลอิสติฆฟาร์', 'descTh': 'ดุอาขอการอภัยที่ยิ่งใหญ่ที่สุด', 'transTh': 'อัลลอฮุมมะ อันตะ รอบบี ลา อิลาฮะ อิลลา อันตะ คอลักตะนี วะอะนา อับดุกะ วะอะนา อะลา อะฮ์ดิกะ วะวะอ์ดิกะ มัสตะฏ็อตุ'},
  58: {'titleTh': 'ดุอาเมื่อสิ่งต่างๆ ยากลำบาก', 'descTh': 'ดุอาเมื่อสิ่งต่างๆ ยากลำบาก', 'transTh': 'ลา อิลาฮะ อิลลัลลอฮุล ฮะลีมุล กะรีม'},
  59: {'titleTh': 'ดุอาก่อนสอบหรืออ่านหนังสือ', 'descTh': 'อ่านเพื่อเพิ่มสมาธิและความจำ', 'transTh': 'รอบบิ ซิดนี อิลมา'},
  60: {'titleTh': 'ดุอาขอแต่งงาน', 'descTh': 'ดุอาเพื่อการแต่งงาน', 'transTh': 'รอบบีย์ อินนี ลิมา อันซัลตะ อิลัยยะ มิน คอยริน ฝะกีร'},
  61: {'titleTh': 'ดุอาตอนฝนตก', 'descTh': 'อ่านขณะฝนตก', 'transTh': 'อัลลอฮุมมะ อัมฏิรนา ฆัยษัน มุฆีษัน'},
  62: {'titleTh': 'ดุอาขอปกป้องจากความวิตกและกลัว', 'descTh': 'อ่านเมื่อรู้สึกวิตก กลัว หรือเครียด', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มินัล ฮัมมิ วัลฮะซัน'},
  63: {'titleTh': 'ดุอาขอความสะดวกก่อนสอบ', 'descTh': 'อ่านก่อนสอบหรืองานที่ยาก', 'transTh': 'รอบบิ ยัสสิร วะลา ตุอัสสิร'},
  64: {'titleTh': 'ดุอาขอการรักษา', 'descTh': 'อ่านเพื่อขอให้อัลลอฮ์รักษา', 'transTh': 'อัลลอฮุมมะ รอบบันนาส อัซฮิบิล บัส วัชฝิ อันตัช ชาฝี'},
  65: {'titleTh': 'ดุอาขอปกป้องจากภัยพิบัติ', 'descTh': 'อ่านเพื่อขอปกป้องจากความทุกข์ยาก', 'transTh': 'ยา ฮัยยุ ยา กอยยูมุ บิเราะฮ์มะติกะ อัสตะฆีษ'},
  66: {'titleTh': 'ดุอาขอความมั่งคั่งและบะเราะกะห์', 'descTh': 'อ่านในยามประสบปัญหาการเงิน', 'transTh': 'อัลลอฮุมมะ อักฝินี บิฮะลาลิกะ อัน ฮะรอมิก'},
  67: {'titleTh': 'ดุอาเพื่อการศึกษา', 'descTh': 'ดุอาจากอัลกุรอานเพื่อขยายหน้าอกและเพิ่มความรู้', 'transTh': 'รอบบิ ซิดนี อิลมา'},
  68: {'titleTh': 'ดุอาเมื่อหัวใจไม่สงบ', 'descTh': 'อ่าน 3 ครั้งและเป่าที่หน้าอก', 'transTh': 'บิสมิลลาฮ์ อะอูซุ บิอิซซะติลลาฮิ วะกุดรอติฮิ มิน ชัรริ มา อะญิดุ'},
  69: {'titleTh': 'ดุอาขอปกป้องจากดวงตาชั่ว', 'descTh': 'อ่านเพื่อปกป้องจากการใส่ร้าย', 'transTh': 'อุอีซุกะ บิกะลิมาติลลาฮิตตัมมะติ'},
  70: {'titleTh': 'ขอให้หัวใจเต็มด้วยความรัก', 'descTh': 'ขอให้อัลลอฮ์เติมหัวใจด้วยความรัก', 'transTh': 'อัลลอฮุมมัจอัล ฝี กัลบี นูรา'},
  71: {'titleTh': 'ดุอาขอคู่ครองที่ดี (ชาย)', 'descTh': 'ขอให้อัลลอฮ์ให้เป็นจากผู้บริสุทธิ์', 'transTh': 'รอบบี อินนี ลิมา อันซัลตะ อิลัยยะ มิน คอยริน ฝะกีร'},
  72: {'titleTh': 'ดุอาผู้ถูกกดขี่', 'descTh': 'ร้องทุกข์ต่ออัลลอฮ์ถึงความอ่อนแอ', 'transTh': 'อัลลอฮุมมะ อินนี อัชกู อิลัยกะ ดุอ์ฝะ กุววะตี'},
  73: {'titleTh': 'ดุอาขอมองเห็นความสามารถตนเอง', 'descTh': 'ขอให้อัลลอฮ์ให้มองเห็นพรสวรรค์', 'transTh': 'อัลลอฮุมมะ อะรินี ฮิบาตักะ'},
  74: {'titleTh': 'ดุอาขอพรที่สมบูรณ์', 'descTh': 'เมื่อพระองค์ให้ความมั่งคั่ง อย่าเอาความสุขไป', 'transTh': 'อัลลอฮุมมะ อิซา อัฏ็อยตะ อะฮะดัน คอยรอน ฝะลา ตัจอัลฮู ฝิตนะตัน'},
  75: {'titleTh': 'ดุอาขอที่พักพิงจากความกังวล', 'descTh': 'ขอพึ่งพิงจากความกังวลที่ทำให้เศร้า', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มินัล ฮัมมิ วัลฮะซัน'},
  76: {'titleTh': 'ดุอาขอให้หัวใจปลอดจากความเกลียดชัง', 'descTh': 'อย่าให้ความเกลียดชังอยู่ในหัวใจ', 'transTh': 'อัลลอฮุมมะ อักริจ มิน กัลบี ฆิลลัน ลิลมุอ์มินีน'},
  77: {'titleTh': 'ดุอาขอปกป้องจากนิอ์มะห์ที่ลดลง', 'descTh': 'ขอพึ่งพิงจากการหมดไปของนิอ์มะห์', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มิน ซะวาลิ นิอ์มะติก'},
  78: {'titleTh': 'ดุอาขอเรียนรู้ความรักและการให้อภัย', 'descTh': 'สอนให้รักผู้อื่นเหมือนรักตนเอง', 'transTh': 'อัลลอฮุมมะ อัลฮิมนี ฮุบบัล อาคิรีน'},
  79: {'titleTh': 'ดุอาขอปกป้องจากความชั่วของตนเอง', 'descTh': 'ขอพึ่งพิงจากความชั่วของการได้ยิน', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มิน ชัรริ ซัมอี'},
  80: {'titleTh': 'ดุอาขอไม่ให้หัวใจผูกพันกับสิ่งที่ไม่ใช่ของตน', 'descTh': 'อย่าให้หัวใจผูกพันกับสิ่งที่ไม่ใช่ของข้า', 'transTh': 'อัลลอฮุมมะ ลา ตุอัลลิก กัลบี บิมา ลัยซะ ลี'},
  81: {'titleTh': 'ดุอาขอล้างความคิดลบ', 'descTh': 'ขอให้อัลลอฮ์ล้างความคิดลบออก', 'transTh': 'อัลลอฮุมมะ อันกิ อันนี อัลวาซาวิซ'},
  82: {'titleTh': 'ดุอาขอบรรเทาความวิตกและความเศร้า', 'descTh': 'ขอให้บรรเทาความกังวลของข้า', 'transTh': 'อัลลอฮุมมะ ยา กาชิฝัล ฮัมมิ วัลฆ็อมมิ'},
  83: {'titleTh': 'ดุอาขอให้หัวใจสงบ', 'descTh': 'ขอให้ประทานความสงบจากพระองค์', 'transTh': 'อัลลอฮุมมะ อาตินา มิน ลาดุนกะ ซะกีนะฮ์'},
  84: {'titleTh': 'ดุอาขอให้สิ่งดีเกิดขึ้น', 'descTh': 'หากสิ่งนี้ดีสำหรับข้า โปรดกำหนดและทำให้ง่าย', 'transTh': 'อัลลอฮุมมะ อิน กานะ ฮาซัล อัมรุ คอยรอน ลี ฝี ดีนี'},
  85: {'titleTh': 'ดุอาขอคู่ครองที่ดี (หญิง)', 'descTh': 'ขอให้เป็นจากผู้หญิงบริสุทธิ์', 'transTh': 'รอบบี อินนี ลิมา อันซัลตะ อิลัยยะ มิน คอยริน ฝะกีร'},
  86: {'titleTh': 'ดุอาขอให้หัวใจหายโกรธ', 'descTh': 'ขอให้ขจัดความโกรธออกจากหัวใจ', 'transTh': 'อัลลอฮุมมะ อัซฮิบ อัน กัลบี ฆะดอบ'},
  87: {'titleTh': 'ดุอาขอการอภัยในความผิด', 'descTh': 'ข้าได้อธรรมต่อตัวเองอย่างมาก', 'transTh': 'รอบบิ อินนี ซอลัมตุ นัฝซี ซุลมัน กะษีรา'},
  88: {'titleTh': 'ดุอาขอแสงสว่าง', 'descTh': 'ขอให้ประทานแสงในหัวใจ ลิ้น การได้ยิน และการมองเห็น', 'transTh': 'อัลลอฮุมมัจอัล ฝี กัลบี นูรา วะฝี ลิซานี นูรา'},
  89: {'titleTh': 'ดุอาขอความอดทนในการถูกทดสอบ', 'descTh': 'ขอให้อดทนต่อสิ่งที่พระองค์ทดสอบ', 'transTh': 'อัลลอฮุมมะ อันตัศ ศอบูรุ ฝะอะอินนี อะลา มา อับตะลัยตะนี'},
  90: {'titleTh': 'ดุอาขอให้หน้าอกกว้างและกิจการง่าย', 'descTh': 'ขอให้ขยายหน้าอกและทำให้กิจการง่าย', 'transTh': 'รอบบิชเราะฮ์ ลี ศ็อดรี วะยัสสิร ลี อัมรี'},
  91: {'titleTh': 'ดุอาขอปกป้องสายตาและหัวใจ', 'descTh': 'ขอให้ลดสายตาและปกป้องข้า', 'transTh': 'อัลลอฮุมมะ อักดุดดุ บะศ็อรี'},
  92: {'titleTh': 'ดุอาขอดับความปรารถนาในใจ', 'descTh': 'ขอให้ดับไฟแห่งความปรารถนาในหัวใจ', 'transTh': 'อัลลอฮุมมะ อัฏฝิ นารัล ชะฮ์วะติ'},
  93: {'titleTh': 'ดุอาขอผู้ซ่อมแซม', 'descTh': 'โอ้ผู้ซ่อมแซม โปรดซ่อมแซมข้า', 'transTh': 'ยา มุศ็อลลิฮุ อัศลิฮ์นี'},
  94: {'titleTh': 'ดุอาขอปกป้องจากสิ่งล่อใจ', 'descTh': 'ขอให้ป้องกันจากความปรารถนาที่เป็นอันตราย', 'transTh': 'อัลลอฮุมมะ กินนี ฝิตนะตัช ชะฮ์วะฮ์'},
  95: {'titleTh': 'ดุอาขอความขอบคุณ', 'descTh': 'การขอบคุณพระองค์คือนิอ์มะห์', 'transTh': 'อัลลอฮุมมะ อะอินนี อะลา ชุกริก'},
  96: {'titleTh': 'ดุอาขอพึ่งพิงจากความวิตกและความขี้เกียจ', 'descTh': 'ขอพึ่งพิงจากความกังวลและความเศร้า', 'transTh': 'อัลลอฮุมมะ อินนี อะอูซุบิกะ มินัล ฮัมมิ วัลฮะซัน'},
  97: {'titleTh': 'ดุอาขออย่าให้ถูกทอดทิ้ง', 'descTh': 'ความเมตตาของพระองค์คือสิ่งที่ข้าหวัง', 'transTh': 'อัลลอฮุมมะ เราะฮ์มะตะกะ อัรญู'},
  98: {'titleTh': 'ดุอาขอออกจากความมืดสู่แสงสว่าง', 'descTh': 'ขอให้นำข้าออกจากความมืดสู่แสงสว่าง', 'transTh': 'อัลลอฮุมมะ อัคริจนา มินัล ซุลุมาติ อิลันนูร์'},
  99: {'titleTh': 'ดุอาขอให้หน้าอกสะอาด', 'descTh': 'ขอให้ชำระหน้าอกด้วยความเมตตา', 'transTh': 'รอบบี อักริจ กัลบี มิน กุลลิ กะดัร์'},
  100: {'titleTh': 'ดุอาขอความแข็งแกร่งและกล้าหาญ', 'descTh': 'ขอให้ประทานความแข็งแกร่งต่อสู้กับตัวเอง', 'transTh': 'อัลลอฮุมมะ อะอินนี อะลา ญิฮาดิน นัฝส์'},
  101: {'titleTh': 'ดุอาขอชำระหัวใจจากความชั่ว', 'descTh': 'ขอให้ชำระหัวใจจากทุกความชั่ว', 'transTh': 'อัลลอฮุมมะ ฏ็อฮฮิร กัลบี มิน กุลลิ ชัรร์'},
  102: {'titleTh': 'ดุอาขอความสำเร็จในการงาน', 'descTh': 'ขอความรู้ที่มีประโยชน์ ริซกี้ที่ดี และการงานที่ถูกรับ', 'transTh': 'อัลลอฮุมมะ อินนี อัสอะลุกะ อิลมัน นาฝิอา วะริซกัน ฏ็อยยิบา'},
};

const Map<String, Map<int, Map<String, String>>> kDuaAllTranslations = {
  'ms': {
    1: {'title': 'Doa Bangun Tidur', 'desc': 'Baca setiap pagi selepas bangun tidur'},
    2: {'title': 'Doa Masuk Tandas', 'desc': 'Baca sebelum masuk tandas'},
    3: {'title': 'Doa Keluar Tandas', 'desc': 'Baca selepas keluar tandas'},
    4: {'title': 'Doa Memakai Pakaian', 'desc': 'Baca ketika memakai pakaian'},
    5: {'title': 'Doa Bercermin', 'desc': 'Baca ketika melihat cermin'},
    6: {'title': 'Doa Sebelum Makan', 'desc': 'Baca sebelum mula makan'},
    7: {'title': 'Doa Lupa Bismillah', 'desc': 'Baca apabila teringat semasa makan'},
    8: {'title': 'Doa Selepas Makan', 'desc': 'Baca selepas selesai makan'},
    9: {'title': 'Doa Keluar Rumah', 'desc': 'Baca ketika keluar dari rumah'},
    10: {'title': 'Doa Naik Kenderaan', 'desc': 'Baca ketika naik kenderaan'},
    11: {'title': 'Doa Memberi Salam', 'desc': 'Ucapkan ketika memberi salam'},
    12: {'title': 'Doa Membalas Salam', 'desc': 'Ucapkan ketika membalas salam'},
    13: {'title': 'Doa Bersin', 'desc': 'Ucapkan selepas bersin'},
    14: {'title': 'Doa Mendengar Orang Bersin', 'desc': 'Ucapkan apabila mendengar orang bersin'},
    15: {'title': 'Doa Membalas Yarhamukallah', 'desc': 'Ucapkan sebagai balasan doa bersin'},
    16: {'title': 'Doa Melihat Orang Susah', 'desc': 'Baca perlahan apabila melihat orang dalam kesusahan'},
    17: {'title': 'Doa Masuk Pasar', 'desc': 'Baca ketika masuk pasar atau kedai'},
    18: {'title': 'Doa Masuk Rumah', 'desc': 'Baca ketika masuk rumah'},
    19: {'title': 'Doa Sebelum Tidur', 'desc': 'Baca sebelum tidur'},
    20: {'title': 'Doa Selepas Wudhu', 'desc': 'Baca selepas berwudhu'},
    21: {'title': 'Doa Masuk Masjid', 'desc': 'Baca ketika masuk masjid'},
    22: {'title': 'Doa Semasa Azan', 'desc': 'Ucapkan sebagai ganti "Hayya alas solah"'},
    23: {'title': 'Doa Selepas Azan', 'desc': 'Baca selepas mendengar azan'},
    24: {'title': 'Doa Iftitah', 'desc': 'Baca awal solat selepas takbir'},
    25: {'title': 'Doa Ruku', 'desc': 'Baca semasa ruku dalam solat'},
    26: {'title': 'Doa Sujud', 'desc': 'Baca semasa sujud dalam solat'},
    27: {'title': 'At-Tahiyyat', 'desc': 'Baca dalam duduk antara solat'},
    28: {'title': 'Selawat Ibrahimiyyah', 'desc': 'Baca selepas at-tahiyyat'},
    29: {'title': 'Doa Sebelum Salam', 'desc': 'Baca di akhir solat sebelum salam'},
    30: {'title': 'Doa Qunut', 'desc': 'Baca dalam solat witir'},
    31: {'title': 'Doa Istighfar Selepas Solat', 'desc': 'Baca terus selepas solat'},
    32: {'title': 'Doa Minta Pertolongan Ibadah', 'desc': 'Baca selepas solat'},
    33: {'title': 'Zikir Selepas Solat', 'desc': 'Subhanallah 33x Alhamdulillah 33x Allahuakbar 33x'},
    34: {'title': 'Doa Keluar Masjid', 'desc': 'Baca ketika keluar masjid'},
    35: {'title': 'Doa Menyambut Ramadan', 'desc': 'Baca ketika masuk bulan Ramadan'},
    36: {'title': 'Doa Berbuka Puasa', 'desc': 'Baca ketika berbuka puasa'},
    37: {'title': 'Doa Malam Lailatul Qadr', 'desc': 'Baca kerap pada 10 malam terakhir Ramadan'},
    38: {'title': 'Doa Istikharah', 'desc': 'Baca selepas solat 2 rakaat untuk membuat keputusan'},
    39: {'title': 'Doa Minta Kemudahan', 'desc': 'Baca ketika menghadapi kesukaran'},
    40: {'title': 'Doa Minta Kesembuhan', 'desc': 'Letakkan tangan di tempat sakit dan baca'},
    41: {'title': 'Doa Minta Perlindungan dari Kejahatan', 'desc': 'Baca untuk perlindungan dari syaitan'},
    42: {'title': 'Doa Perlindungan dari Kemiskinan', 'desc': 'Baca ketika menghadapi masalah kewangan'},
    43: {'title': 'Doa Perlindungan dari Keresahan', 'desc': 'Baca ketika rasa resah atau sedih'},
    44: {'title': 'Doa Ketika Ragu atau Marah', 'desc': 'Baca ketika ragu dalam iman atau marah'},
    45: {'title': 'Doa Sebelum Bermusafir', 'desc': 'Baca ketika keluar untuk bermusafir'},
    46: {'title': 'Doa Pulang dari Musafir', 'desc': 'Baca ketika pulang ke rumah dari musafir'},
    47: {'title': 'Doa untuk Ibu Bapa', 'desc': 'Baca untuk memohon rahmat Allah bagi ibu bapa'},
    48: {'title': 'Doa untuk Pengantin', 'desc': 'Baca sebagai doa untuk pengantin baru'},
    49: {'title': 'Doa Sebelum Berjimak', 'desc': 'Baca untuk memohon perlindungan anak dari syaitan'},
    50: {'title': 'Doa Perlindungan Kanak-kanak', 'desc': 'Baca untuk melindungi kanak-kanak dari kejahatan'},
    51: {'title': 'Doa Terima Kasih', 'desc': 'Ucapkan apabila seseorang berbuat baik kepada kita'},
    52: {'title': 'Doa untuk Tuan Rumah', 'desc': 'Baca sebagai doa untuk tuan rumah yang menjamu'},
    53: {'title': 'Doa Melawat Orang Sakit', 'desc': 'Baca 7 kali ketika melawat orang sakit'},
    54: {'title': 'Doa Solat Jenazah Dewasa', 'desc': 'Baca selepas takbir ke-3 dalam solat jenazah'},
    55: {'title': 'Doa Solat Jenazah Kanak-kanak', 'desc': 'Baca dalam solat jenazah untuk kanak-kanak'},
    56: {'title': 'Doa Masuk Kubur', 'desc': 'Baca ketika masuk kawasan perkuburan'},
    57: {'title': 'Sayyidul Istighfar', 'desc': 'Istighfar yang paling agung'},
    58: {'title': 'Doa Ketika Susah', 'desc': 'Doa ketika segala sesuatu terasa sukar'},
    59: {'title': 'Doa Sebelum Peperiksaan', 'desc': 'Baca untuk meningkatkan tumpuan dan ingatan'},
    60: {'title': 'Doa Minta Jodoh', 'desc': 'Doa untuk perkahwinan'},
    61: {'title': 'Doa Ketika Hujan', 'desc': 'Baca semasa hujan turun'},
    62: {'title': 'Doa Perlindungan dari Kebimbangan', 'desc': 'Baca ketika rasa bimbang atau takut'},
    63: {'title': 'Doa Kemudahan Peperiksaan', 'desc': 'Baca sebelum peperiksaan atau kerja sukar'},
    64: {'title': 'Doa Minta Kesembuhan', 'desc': 'Baca untuk memohon Allah menyembuhkan'},
    65: {'title': 'Doa Perlindungan dari Bencana', 'desc': 'Baca untuk perlindungan dari kesusahan'},
    66: {'title': 'Doa Keberkatan Rezeki', 'desc': 'Baca ketika menghadapi masalah kewangan'},
    67: {'title': 'Doa untuk Ilmu', 'desc': 'Doa dari Al-Quran untuk meluaskan dada dan ilmu'},
    68: {'title': 'Doa Hati Tidak Tenang', 'desc': 'Baca 3 kali dan tiup ke dada apabila tidak tenang'},
    69: {'title': 'Doa Perlindungan dari Mata Jahat', 'desc': 'Baca untuk perlindungan dari hasad dengki'},
    70: {'title': 'Doa Kasih Sayang', 'desc': 'Minta Allah penuhi hati dengan kasih sayang'},
    71: {'title': 'Doa Jodoh (Lelaki)', 'desc': 'Minta Allah jadikan dari golongan yang bersih'},
    72: {'title': 'Doa Orang yang Teraniaya', 'desc': 'Mengadu kepada Allah tentang kelemahan diri'},
    73: {'title': 'Doa Minta Lihat Bakat Diri', 'desc': 'Minta Allah tunjukkan bakat yang dikurniakan'},
    74: {'title': 'Doa Minta Nikmat Sempurna', 'desc': 'Apabila Allah beri kekayaan jangan ambil kebahagiaan'},
    75: {'title': 'Doa Perlindungan dari Keresahan', 'desc': 'Minta perlindungan dari kebimbangan yang menyedihkan'},
    76: {'title': 'Doa Hati Bebas dari Kebencian', 'desc': 'Jangan biarkan kebencian dalam hati'},
    77: {'title': 'Doa Perlindungan Nikmat', 'desc': 'Minta perlindungan dari hilangnya nikmat'},
    78: {'title': 'Doa Belajar Kasih dan Maaf', 'desc': 'Ajar untuk mencintai orang lain seperti diri sendiri'},
    79: {'title': 'Doa Perlindungan dari Kejahatan Diri', 'desc': 'Minta perlindungan dari kejahatan pendengaran'},
    80: {'title': 'Doa Hati Tidak Terikat', 'desc': 'Jangan biarkan hati terikat pada yang bukan milik'},
    81: {'title': 'Doa Buang Fikiran Negatif', 'desc': 'Minta Allah buang fikiran negatif'},
    82: {'title': 'Doa Hilangkan Kesedihan', 'desc': 'Minta hilangkan kebimbangan dan kesedihan'},
    83: {'title': 'Doa Hati Tenang', 'desc': 'Minta Allah kurniakan ketenangan'},
    84: {'title': 'Doa Minta Kebaikan Berlaku', 'desc': 'Jika ini baik untukku, tetapkan dan permudahkan'},
    85: {'title': 'Doa Jodoh (Perempuan)', 'desc': 'Minta Allah jadikan dari wanita yang solehah'},
    86: {'title': 'Doa Hilangkan Marah', 'desc': 'Minta Allah hilangkan kemarahan dari hati'},
    87: {'title': 'Doa Minta Keampunan', 'desc': 'Aku telah menzalimi diri sendiri'},
    88: {'title': 'Doa Minta Cahaya', 'desc': 'Minta cahaya dalam hati, lidah, pendengaran dan penglihatan'},
    89: {'title': 'Doa Minta Kesabaran', 'desc': 'Minta kesabaran menghadapi ujian Allah'},
    90: {'title': 'Doa Lapangkan Dada', 'desc': 'Minta Allah lapangkan dada dan mudahkan urusan'},
    91: {'title': 'Doa Jaga Mata dan Hati', 'desc': 'Minta Allah jaga pandangan dan lindungi'},
    92: {'title': 'Doa Padamkan Nafsu', 'desc': 'Minta Allah padamkan api nafsu dalam hati'},
    93: {'title': 'Doa Minta Pemulih', 'desc': 'Ya Pemulih, pulihkanlah aku'},
    94: {'title': 'Doa Perlindungan dari Godaan', 'desc': 'Minta perlindungan dari keinginan yang bahaya'},
    95: {'title': 'Doa Rasa Syukur', 'desc': 'Bersyukur kepada Allah adalah nikmat'},
    96: {'title': 'Doa Perlindungan dari Kerisauan', 'desc': 'Minta perlindungan dari kerisauan dan kesedihan'},
    97: {'title': 'Doa Jangan Ditinggalkan', 'desc': 'Rahmat Allah adalah harapanku'},
    98: {'title': 'Doa Keluar dari Kegelapan', 'desc': 'Minta Allah bawa dari kegelapan ke cahaya'},
    99: {'title': 'Doa Bersihkan Hati', 'desc': 'Minta Allah bersihkan hati dengan rahmat-Nya'},
    100: {'title': 'Doa Kekuatan dan Keberanian', 'desc': 'Minta kekuatan untuk melawan hawa nafsu'},
    101: {'title': 'Doa Suci Hati dari Kejahatan', 'desc': 'Minta Allah sucikan hati dari segala kejahatan'},
    102: {'title': 'Doa Kejayaan dalam Amal', 'desc': 'Minta ilmu bermanfaat, rezeki baik dan amal diterima'},
  },
  'id': {
    1: {'title': 'Doa Bangun Tidur', 'desc': 'Baca setiap pagi setelah bangun tidur'},
    2: {'title': 'Doa Masuk Kamar Mandi', 'desc': 'Baca sebelum masuk kamar mandi'},
    3: {'title': 'Doa Keluar Kamar Mandi', 'desc': 'Baca setelah keluar kamar mandi'},
    4: {'title': 'Doa Memakai Pakaian', 'desc': 'Baca saat memakai pakaian'},
    5: {'title': 'Doa Bercermin', 'desc': 'Baca saat melihat cermin'},
    6: {'title': 'Doa Sebelum Makan', 'desc': 'Baca sebelum mulai makan'},
    7: {'title': 'Doa Lupa Bismillah', 'desc': 'Baca saat teringat di tengah makan'},
    8: {'title': 'Doa Setelah Makan', 'desc': 'Baca setelah selesai makan'},
    9: {'title': 'Doa Keluar Rumah', 'desc': 'Baca saat keluar dari rumah'},
    10: {'title': 'Doa Naik Kendaraan', 'desc': 'Baca saat naik kendaraan'},
    11: {'title': 'Doa Memberi Salam', 'desc': 'Ucapkan saat menyapa muslim'},
    12: {'title': 'Doa Membalas Salam', 'desc': 'Ucapkan saat membalas salam'},
    13: {'title': 'Doa Bersin', 'desc': 'Ucapkan setelah bersin'},
    14: {'title': 'Doa Mendengar Orang Bersin', 'desc': 'Ucapkan saat mendengar orang bersin'},
    15: {'title': 'Doa Membalas Yarhamukallah', 'desc': 'Ucapkan sebagai balasan doa bersin'},
    16: {'title': 'Doa Melihat Orang Susah', 'desc': 'Baca pelan saat melihat orang dalam kesulitan'},
    17: {'title': 'Doa Masuk Pasar', 'desc': 'Baca saat masuk pasar atau toko'},
    18: {'title': 'Doa Masuk Rumah', 'desc': 'Baca saat masuk rumah'},
    19: {'title': 'Doa Sebelum Tidur', 'desc': 'Baca sebelum tidur'},
    20: {'title': 'Doa Setelah Wudhu', 'desc': 'Baca setelah berwudhu'},
    21: {'title': 'Doa Masuk Masjid', 'desc': 'Baca saat masuk masjid'},
    22: {'title': 'Doa Saat Adzan', 'desc': 'Ucapkan sebagai ganti "Hayya alash shalah"'},
    23: {'title': 'Doa Setelah Adzan', 'desc': 'Baca setelah mendengar adzan'},
    24: {'title': 'Doa Iftitah', 'desc': 'Baca awal sholat setelah takbir'},
    25: {'title': 'Doa Ruku', 'desc': 'Baca saat ruku dalam sholat'},
    26: {'title': 'Doa Sujud', 'desc': 'Baca saat sujud dalam sholat'},
    27: {'title': 'At-Tahiyyat', 'desc': 'Baca dalam duduk sholat'},
    28: {'title': 'Shalawat Ibrahimiyyah', 'desc': 'Baca setelah at-tahiyyat'},
    29: {'title': 'Doa Sebelum Salam', 'desc': 'Baca di akhir sholat sebelum salam'},
    30: {'title': 'Doa Qunut', 'desc': 'Baca dalam sholat witir'},
    31: {'title': 'Doa Istighfar Setelah Sholat', 'desc': 'Baca segera setelah sholat'},
    32: {'title': 'Doa Minta Pertolongan Ibadah', 'desc': 'Baca setelah sholat'},
    33: {'title': 'Dzikir Setelah Sholat', 'desc': 'Subhanallah 33x Alhamdulillah 33x Allahu Akbar 33x'},
    34: {'title': 'Doa Keluar Masjid', 'desc': 'Baca saat keluar masjid'},
    35: {'title': 'Doa Menyambut Ramadhan', 'desc': 'Baca saat masuk bulan Ramadhan'},
    36: {'title': 'Doa Buka Puasa', 'desc': 'Baca saat berbuka puasa'},
    37: {'title': 'Doa Malam Lailatul Qadr', 'desc': 'Baca sering pada 10 malam terakhir Ramadhan'},
    38: {'title': 'Doa Istikharah', 'desc': 'Baca setelah sholat 2 rakaat untuk mengambil keputusan'},
    39: {'title': 'Doa Minta Kemudahan', 'desc': 'Baca saat menghadapi kesulitan'},
    40: {'title': 'Doa Minta Kesembuhan', 'desc': 'Letakkan tangan di tempat sakit lalu baca'},
    41: {'title': 'Doa Perlindungan dari Kejahatan', 'desc': 'Baca untuk perlindungan dari syaitan'},
    42: {'title': 'Doa Perlindungan dari Kemiskinan', 'desc': 'Baca saat menghadapi masalah keuangan'},
    43: {'title': 'Doa Perlindungan dari Kegelisahan', 'desc': 'Baca saat merasa cemas atau sedih'},
    44: {'title': 'Doa Saat Ragu atau Marah', 'desc': 'Baca saat ragu dalam iman atau marah'},
    45: {'title': 'Doa Sebelum Bepergian', 'desc': 'Baca saat hendak bepergian'},
    46: {'title': 'Doa Pulang dari Perjalanan', 'desc': 'Baca saat pulang ke rumah dari perjalanan'},
    47: {'title': 'Doa untuk Orang Tua', 'desc': 'Baca untuk memohon rahmat Allah bagi orang tua'},
    48: {'title': 'Doa untuk Pengantin', 'desc': 'Baca sebagai doa untuk pengantin baru'},
    49: {'title': 'Doa Sebelum Berhubungan', 'desc': 'Baca untuk perlindungan anak dari syaitan'},
    50: {'title': 'Doa Perlindungan Anak', 'desc': 'Baca untuk melindungi anak dari kejahatan'},
    51: {'title': 'Doa Terima Kasih', 'desc': 'Ucapkan saat seseorang berbuat baik kepada kita'},
    52: {'title': 'Doa untuk Tuan Rumah', 'desc': 'Baca sebagai doa untuk tuan rumah yang menjamu'},
    53: {'title': 'Doa Menjenguk Orang Sakit', 'desc': 'Baca 7 kali saat menjenguk orang sakit'},
    54: {'title': 'Doa Sholat Jenazah Dewasa', 'desc': 'Baca setelah takbir ke-3 dalam sholat jenazah'},
    55: {'title': 'Doa Sholat Jenazah Anak', 'desc': 'Baca dalam sholat jenazah untuk anak'},
    56: {'title': 'Doa Masuk Kuburan', 'desc': 'Baca saat masuk area pemakaman'},
    57: {'title': 'Sayyidul Istighfar', 'desc': 'Istighfar yang paling agung'},
    58: {'title': 'Doa Saat Segala Terasa Sulit', 'desc': 'Doa saat segala sesuatu terasa sulit'},
    59: {'title': 'Doa Sebelum Ujian', 'desc': 'Baca untuk meningkatkan konsentrasi dan ingatan'},
    60: {'title': 'Doa Minta Jodoh', 'desc': 'Doa untuk pernikahan'},
    61: {'title': 'Doa Saat Hujan', 'desc': 'Baca saat hujan turun'},
    62: {'title': 'Doa Perlindungan dari Kecemasan', 'desc': 'Baca saat merasa cemas atau takut'},
    63: {'title': 'Doa Kemudahan Ujian', 'desc': 'Baca sebelum ujian atau pekerjaan sulit'},
    64: {'title': 'Doa Minta Kesembuhan', 'desc': 'Baca untuk memohon Allah menyembuhkan'},
    65: {'title': 'Doa Perlindungan dari Bencana', 'desc': 'Baca untuk perlindungan dari kesulitan'},
    66: {'title': 'Doa Keberkahan Rezeki', 'desc': 'Baca saat menghadapi masalah keuangan'},
    67: {'title': 'Doa untuk Ilmu', 'desc': 'Doa dari Al-Quran untuk melapangkan dada dan ilmu'},
    68: {'title': 'Doa Hati Tidak Tenang', 'desc': 'Baca 3 kali dan tiup ke dada saat tidak tenang'},
    69: {'title': 'Doa Perlindungan dari Mata Jahat', 'desc': 'Baca untuk perlindungan dari hasad'},
    70: {'title': 'Doa Kasih Sayang', 'desc': 'Minta Allah penuhi hati dengan kasih sayang'},
    71: {'title': 'Doa Jodoh (Laki-laki)', 'desc': 'Minta Allah jadikan dari golongan yang bersih'},
    72: {'title': 'Doa Orang yang Teraniaya', 'desc': 'Mengadu kepada Allah tentang kelemahan diri'},
    73: {'title': 'Doa Minta Lihat Bakat', 'desc': 'Minta Allah tunjukkan bakat yang diberikan'},
    74: {'title': 'Doa Nikmat Sempurna', 'desc': 'Jika Allah beri kekayaan jangan ambil kebahagiaan'},
    75: {'title': 'Doa Perlindungan dari Kegelisahan', 'desc': 'Minta perlindungan dari kecemasan yang menyedihkan'},
    76: {'title': 'Doa Hati Bebas Kebencian', 'desc': 'Jangan biarkan kebencian dalam hati'},
    77: {'title': 'Doa Jaga Nikmat', 'desc': 'Minta perlindungan dari hilangnya nikmat'},
    78: {'title': 'Doa Belajar Kasih dan Maaf', 'desc': 'Ajar untuk mencintai orang lain seperti diri sendiri'},
    79: {'title': 'Doa Perlindungan dari Kejahatan Diri', 'desc': 'Minta perlindungan dari kejahatan pendengaran'},
    80: {'title': 'Doa Hati Tidak Terikat', 'desc': 'Jangan biarkan hati terikat pada yang bukan milik'},
    81: {'title': 'Doa Buang Pikiran Negatif', 'desc': 'Minta Allah buang pikiran negatif'},
    82: {'title': 'Doa Hilangkan Kesedihan', 'desc': 'Minta hilangkan kegelisahan dan kesedihan'},
    83: {'title': 'Doa Hati Tenang', 'desc': 'Minta Allah karuniakan ketenangan'},
    84: {'title': 'Doa Minta Kebaikan Terjadi', 'desc': 'Jika ini baik untukku, tetapkan dan permudahkan'},
    85: {'title': 'Doa Jodoh (Perempuan)', 'desc': 'Minta Allah jadikan dari wanita yang shalihah'},
    86: {'title': 'Doa Hilangkan Marah', 'desc': 'Minta Allah hilangkan kemarahan dari hati'},
    87: {'title': 'Doa Minta Ampunan', 'desc': 'Aku telah menzhalimi diri sendiri'},
    88: {'title': 'Doa Minta Cahaya', 'desc': 'Minta cahaya dalam hati, lidah, pendengaran dan penglihatan'},
    89: {'title': 'Doa Minta Kesabaran', 'desc': 'Minta kesabaran menghadapi ujian Allah'},
    90: {'title': 'Doa Lapangkan Dada', 'desc': 'Minta Allah lapangkan dada dan mudahkan urusan'},
    91: {'title': 'Doa Jaga Pandangan', 'desc': 'Minta Allah jaga pandangan dan lindungi'},
    92: {'title': 'Doa Padamkan Nafsu', 'desc': 'Minta Allah padamkan api nafsu dalam hati'},
    93: {'title': 'Doa Minta Penyembuh', 'desc': 'Ya Penyembuh, sembuhkanlah aku'},
    94: {'title': 'Doa Perlindungan dari Godaan', 'desc': 'Minta perlindungan dari keinginan berbahaya'},
    95: {'title': 'Doa Rasa Syukur', 'desc': 'Bersyukur kepada Allah adalah nikmat'},
    96: {'title': 'Doa Perlindungan dari Kegelisahan', 'desc': 'Minta perlindungan dari kegelisahan dan kesedihan'},
    97: {'title': 'Doa Jangan Ditinggalkan', 'desc': 'Rahmat Allah adalah harapanku'},
    98: {'title': 'Doa Keluar dari Kegelapan', 'desc': 'Minta Allah bawa dari kegelapan ke cahaya'},
    99: {'title': 'Doa Bersihkan Hati', 'desc': 'Minta Allah bersihkan hati dengan rahmat-Nya'},
    100: {'title': 'Doa Kekuatan dan Keberanian', 'desc': 'Minta kekuatan untuk melawan hawa nafsu'},
    101: {'title': 'Doa Sucikan Hati dari Kejahatan', 'desc': 'Minta Allah sucikan hati dari segala kejahatan'},
    102: {'title': 'Doa Kesuksesan Amal', 'desc': 'Minta ilmu bermanfaat, rezeki baik dan amal diterima'},
  },
  'ar': {
    1: {'title': 'دعاء الاستيقاظ من النوم', 'desc': 'يُقرأ كل صباح بعد الاستيقاظ'},
    2: {'title': 'دعاء دخول الخلاء', 'desc': 'يُقرأ قبل دخول الحمام'},
    3: {'title': 'دعاء الخروج من الخلاء', 'desc': 'يُقرأ بعد الخروج من الحمام'},
    4: {'title': 'دعاء لبس الثوب', 'desc': 'يُقرأ عند ارتداء الملابس'},
    5: {'title': 'دعاء النظر في المرآة', 'desc': 'يُقرأ عند النظر في المرآة'},
    6: {'title': 'دعاء قبل الطعام', 'desc': 'يُقرأ قبل البدء بالأكل'},
    7: {'title': 'دعاء نسيان البسملة', 'desc': 'يُقرأ عند التذكر أثناء الأكل'},
    8: {'title': 'دعاء بعد الطعام', 'desc': 'يُقرأ بعد الانتهاء من الأكل'},
    9: {'title': 'دعاء الخروج من البيت', 'desc': 'يُقرأ عند الخروج من المنزل'},
    10: {'title': 'دعاء ركوب المركبة', 'desc': 'يُقرأ عند ركوب السيارة أو أي مركبة'},
    11: {'title': 'دعاء السلام', 'desc': 'يُقال عند تحية المسلم'},
    12: {'title': 'دعاء رد السلام', 'desc': 'يُقال عند رد التحية'},
    13: {'title': 'دعاء العطاس', 'desc': 'يُقال بعد العطاس'},
    14: {'title': 'دعاء سماع العطاس', 'desc': 'يُقال عند سماع العطاس'},
    15: {'title': 'دعاء الرد على يرحمك الله', 'desc': 'يُقال ردًا على دعاء العطاس'},
    16: {'title': 'دعاء رؤية المبتلى', 'desc': 'يُقرأ سرًا عند رؤية شخص في ضائقة'},
    17: {'title': 'دعاء دخول السوق', 'desc': 'يُقرأ عند دخول السوق أو المحل'},
    18: {'title': 'دعاء دخول المنزل', 'desc': 'يُقرأ عند دخول المنزل'},
    19: {'title': 'دعاء النوم', 'desc': 'يُقرأ قبل النوم'},
    20: {'title': 'دعاء بعد الوضوء', 'desc': 'يُقرأ بعد الانتهاء من الوضوء'},
    21: {'title': 'دعاء دخول المسجد', 'desc': 'يُقرأ عند دخول المسجد'},
    22: {'title': 'دعاء الأذان', 'desc': 'يُقال بدلًا من حي على الصلاة'},
    23: {'title': 'دعاء بعد الأذان', 'desc': 'يُقرأ بعد سماع الأذان'},
    24: {'title': 'دعاء الاستفتاح', 'desc': 'يُقرأ في بداية الصلاة بعد التكبير'},
    25: {'title': 'دعاء الركوع', 'desc': 'يُقرأ أثناء الركوع في الصلاة'},
    26: {'title': 'دعاء السجود', 'desc': 'يُقرأ أثناء السجود في الصلاة'},
    27: {'title': 'التحيات', 'desc': 'يُقرأ في الجلوس بين الصلاة'},
    28: {'title': 'الصلاة الإبراهيمية', 'desc': 'تُقرأ بعد التحيات'},
    29: {'title': 'دعاء قبل السلام', 'desc': 'يُقرأ في آخر الصلاة قبل السلام'},
    30: {'title': 'دعاء القنوت', 'desc': 'يُقرأ في صلاة الوتر'},
    31: {'title': 'الاستغفار بعد الصلاة', 'desc': 'يُقرأ فور الانتهاء من الصلاة'},
    32: {'title': 'دعاء طلب المعونة على العبادة', 'desc': 'يُقرأ بعد الصلاة'},
    33: {'title': 'أذكار بعد الصلاة', 'desc': 'سبحان الله 33 الحمد لله 33 الله أكبر 33'},
    34: {'title': 'دعاء الخروج من المسجد', 'desc': 'يُقرأ عند الخروج من المسجد'},
    35: {'title': 'دعاء استقبال رمضان', 'desc': 'يُقرأ عند حلول شهر رمضان'},
    36: {'title': 'دعاء الإفطار', 'desc': 'يُقرأ عند الإفطار وقت غروب الشمس'},
    37: {'title': 'دعاء ليلة القدر', 'desc': 'يُكثر منه في العشر الأواخر من رمضان'},
    38: {'title': 'دعاء الاستخارة', 'desc': 'يُقرأ بعد صلاة ركعتين لاتخاذ قرار مهم'},
    39: {'title': 'دعاء طلب التيسير', 'desc': 'يُقرأ عند مواجهة الصعوبات'},
    40: {'title': 'دعاء الشفاء من المرض', 'desc': 'ضع يدك على موضع الألم واقرأ'},
    41: {'title': 'دعاء الحماية من الشر', 'desc': 'يُقرأ للحماية من الشيطان'},
    42: {'title': 'دعاء الحماية من الفقر', 'desc': 'يُقرأ عند مواجهة مشاكل مالية'},
    43: {'title': 'دعاء الحماية من القلق', 'desc': 'يُقرأ عند الشعور بالقلق أو الحزن'},
    44: {'title': 'دعاء عند الشك أو الغضب', 'desc': 'يُقرأ عند الشك في الإيمان أو الغضب'},
    45: {'title': 'دعاء السفر', 'desc': 'يُقرأ عند الخروج للسفر'},
    46: {'title': 'دعاء العودة من السفر', 'desc': 'يُقرأ عند العودة إلى المنزل من السفر'},
    47: {'title': 'دعاء للوالدين', 'desc': 'يُقرأ طلبًا لرحمة الله على الوالدين'},
    48: {'title': 'دعاء للعروسين', 'desc': 'يُقرأ دعاءً للعروسين الجديدين'},
    49: {'title': 'دعاء قبل الجماع', 'desc': 'يُقرأ للحماية من الشيطان'},
    50: {'title': 'دعاء حماية الأطفال', 'desc': 'يُقرأ لحماية الأطفال من الشر'},
    51: {'title': 'دعاء الشكر', 'desc': 'يُقال عند فعل شخص ما معنا معروفًا'},
    52: {'title': 'دعاء للمضيف', 'desc': 'يُقرأ دعاءً لمن أضافنا'},
    53: {'title': 'دعاء عيادة المريض', 'desc': 'يُقرأ 7 مرات عند زيارة المريض'},
    54: {'title': 'دعاء صلاة الجنازة للكبير', 'desc': 'يُقرأ بعد التكبيرة الثالثة'},
    55: {'title': 'دعاء صلاة الجنازة للصغير', 'desc': 'يُقرأ في صلاة الجنازة للأطفال'},
    56: {'title': 'دعاء دخول المقبرة', 'desc': 'يُقرأ عند دخول المقبرة'},
    57: {'title': 'سيد الاستغفار', 'desc': 'أعظم صيغ الاستغفار'},
    58: {'title': 'دعاء عند الضيق', 'desc': 'دعاء عند مواجهة الصعوبات'},
    59: {'title': 'دعاء قبل الامتحان', 'desc': 'يُقرأ لتحسين التركيز والذاكرة'},
    60: {'title': 'دعاء الزواج', 'desc': 'دعاء للزواج'},
    61: {'title': 'دعاء نزول المطر', 'desc': 'يُقرأ أثناء سقوط المطر'},
    62: {'title': 'دعاء الحماية من الخوف', 'desc': 'يُقرأ عند الشعور بالقلق أو الخوف'},
    63: {'title': 'دعاء تيسير الامتحان', 'desc': 'يُقرأ قبل الامتحان أو العمل الصعب'},
    64: {'title': 'دعاء طلب الشفاء', 'desc': 'يُقرأ لطلب الشفاء من الله'},
    65: {'title': 'دعاء الحماية من البلاء', 'desc': 'يُقرأ للحماية من المصائب'},
    66: {'title': 'دعاء البركة في الرزق', 'desc': 'يُقرأ عند مواجهة مشاكل مالية'},
    67: {'title': 'دعاء طلب العلم', 'desc': 'دعاء من القرآن لشرح الصدر وزيادة العلم'},
    68: {'title': 'دعاء اضطراب القلب', 'desc': 'يُقرأ 3 مرات وينفث في الصدر'},
    69: {'title': 'دعاء الحماية من العين', 'desc': 'يُقرأ للحماية من الحسد'},
    70: {'title': 'دعاء المحبة', 'desc': 'اطلب من الله ملء القلب بالمحبة'},
    71: {'title': 'دعاء الزواج للرجل', 'desc': 'اطلب من الله أن يجعلك من الطاهرين'},
    72: {'title': 'دعاء المظلوم', 'desc': 'الشكوى إلى الله من الضعف'},
    73: {'title': 'دعاء رؤية المواهب', 'desc': 'اطلب من الله أن يريك مواهبك'},
    74: {'title': 'دعاء النعمة الكاملة', 'desc': 'إذا أعطاك الله الغنى فلا تأخذ السعادة'},
    75: {'title': 'دعاء الحماية من الهموم', 'desc': 'اطلب الحماية من القلق المحزن'},
    76: {'title': 'دعاء تطهير القلب من الحقد', 'desc': 'لا تدع الحقد في القلب'},
    77: {'title': 'دعاء الحفاظ على النعم', 'desc': 'اطلب الحماية من زوال النعم'},
    78: {'title': 'دعاء تعلم المحبة والعفو', 'desc': 'علمني أن أحب الآخرين كما أحب نفسي'},
    79: {'title': 'دعاء الحماية من شر النفس', 'desc': 'اطلب الحماية من شر السمع'},
    80: {'title': 'دعاء عدم تعلق القلب', 'desc': 'لا تدع القلب يتعلق بما ليس لك'},
    81: {'title': 'دعاء إزالة الأفكار السلبية', 'desc': 'اطلب من الله إزالة الأفكار السلبية'},
    82: {'title': 'دعاء تخفيف الغم', 'desc': 'اطلب إزالة القلق والحزن'},
    83: {'title': 'دعاء اطمئنان القلب', 'desc': 'اطلب من الله السكينة'},
    84: {'title': 'دعاء حدوث الخير', 'desc': 'إن كان هذا خيرًا لي فيسره'},
    85: {'title': 'دعاء الزواج للمرأة', 'desc': 'اطلب من الله أن تكوني من الطاهرات'},
    86: {'title': 'دعاء إزالة الغضب', 'desc': 'اطلب من الله إزالة الغضب من القلب'},
    87: {'title': 'دعاء طلب المغفرة', 'desc': 'إني ظلمت نفسي ظلمًا كثيرًا'},
    88: {'title': 'دعاء طلب النور', 'desc': 'اطلب النور في القلب واللسان والسمع والبصر'},
    89: {'title': 'دعاء الصبر على البلاء', 'desc': 'اطلب الصبر على ما يبتلي الله به'},
    90: {'title': 'دعاء شرح الصدر', 'desc': 'اطلب من الله شرح الصدر وتيسير الأمور'},
    91: {'title': 'دعاء حفظ البصر والقلب', 'desc': 'اطلب من الله حفظ البصر والقلب'},
    92: {'title': 'دعاء إطفاء الشهوة', 'desc': 'اطلب من الله إطفاء نار الشهوة'},
    93: {'title': 'دعاء طلب المصلح', 'desc': 'يا مصلح أصلحني'},
    94: {'title': 'دعاء الحماية من الفتنة', 'desc': 'اطلب الحماية من الرغبات الضارة'},
    95: {'title': 'دعاء الشكر', 'desc': 'الشكر لله نعمة'},
    96: {'title': 'دعاء الحماية من الهم', 'desc': 'اطلب الحماية من الهم والحزن'},
    97: {'title': 'دعاء عدم الخذلان', 'desc': 'رحمة الله هي أملي'},
    98: {'title': 'دعاء الخروج من الظلمات', 'desc': 'اطلب من الله أن يخرجك من الظلمات إلى النور'},
    99: {'title': 'دعاء تطهير الصدر', 'desc': 'اطلب من الله تطهير الصدر برحمته'},
    100: {'title': 'دعاء القوة والشجاعة', 'desc': 'اطلب القوة لمجاهدة النفس'},
    101: {'title': 'دعاء تطهير القلب من الشر', 'desc': 'اطلب من الله تطهير القلب من كل شر'},
    102: {'title': 'دعاء النجاح في العمل', 'desc': 'اطلب العلم النافع والرزق الطيب والعمل المقبول'},
  },
  'ur': {
    1: {'title': 'صبح اٹھنے کی دعا', 'desc': 'ہر صبح اٹھنے کے بعد پڑھیں'},
    2: {'title': 'بیت الخلاء جانے کی دعا', 'desc': 'بیت الخلاء جانے سے پہلے پڑھیں'},
    3: {'title': 'بیت الخلاء سے نکلنے کی دعا', 'desc': 'بیت الخلاء سے نکلنے کے بعد پڑھیں'},
    4: {'title': 'کپڑے پہننے کی دعا', 'desc': 'کپڑے پہنتے وقت پڑھیں'},
    5: {'title': 'آئینہ دیکھنے کی دعا', 'desc': 'آئینہ دیکھتے وقت پڑھیں'},
    6: {'title': 'کھانے سے پہلے کی دعا', 'desc': 'کھانا شروع کرنے سے پہلے پڑھیں'},
    7: {'title': 'بسم اللہ بھولنے کی دعا', 'desc': 'کھانے کے دوران یاد آنے پر پڑھیں'},
    8: {'title': 'کھانے کے بعد کی دعا', 'desc': 'کھانا ختم ہونے کے بعد پڑھیں'},
    9: {'title': 'گھر سے نکلنے کی دعا', 'desc': 'گھر سے نکلتے وقت پڑھیں'},
    10: {'title': 'سواری پر سوار ہونے کی دعا', 'desc': 'گاڑی یا سواری پر سوار ہوتے وقت پڑھیں'},
    11: {'title': 'سلام کی دعا', 'desc': 'مسلمان سے ملتے وقت کہیں'},
    12: {'title': 'سلام کا جواب', 'desc': 'سلام کا جواب دیتے وقت کہیں'},
    13: {'title': 'چھینک کی دعا', 'desc': 'چھینک آنے کے بعد کہیں'},
    14: {'title': 'دوسرے کی چھینک پر دعا', 'desc': 'کسی کی چھینک سننے پر کہیں'},
    15: {'title': 'یرحمک اللہ کا جواب', 'desc': 'چھینک کی دعا کے جواب میں کہیں'},
    16: {'title': 'مصیبت زدہ کو دیکھنے کی دعا', 'desc': 'کسی مصیبت میں مبتلا کو دیکھ کر آہستہ پڑھیں'},
    17: {'title': 'بازار جانے کی دعا', 'desc': 'بازار یا دکان میں داخل ہوتے وقت پڑھیں'},
    18: {'title': 'گھر میں داخل ہونے کی دعا', 'desc': 'گھر میں داخل ہوتے وقت پڑھیں'},
    19: {'title': 'سونے سے پہلے کی دعا', 'desc': 'سونے سے پہلے پڑھیں'},
    20: {'title': 'وضو کے بعد کی دعا', 'desc': 'وضو مکمل ہونے کے بعد پڑھیں'},
    21: {'title': 'مسجد میں داخل ہونے کی دعا', 'desc': 'مسجد میں داخل ہوتے وقت پڑھیں'},
    22: {'title': 'اذان کے دوران کی دعا', 'desc': 'حی علی الصلوٰۃ کے بجائے کہیں'},
    23: {'title': 'اذان کے بعد کی دعا', 'desc': 'اذان سننے کے بعد پڑھیں'},
    24: {'title': 'دعائے ثناء', 'desc': 'نماز شروع میں تکبیر کے بعد پڑھیں'},
    25: {'title': 'رکوع کی دعا', 'desc': 'نماز میں رکوع کے دوران پڑھیں'},
    26: {'title': 'سجدے کی دعا', 'desc': 'نماز میں سجدے کے دوران پڑھیں'},
    27: {'title': 'التحیات', 'desc': 'نماز کی بیٹھک میں پڑھیں'},
    28: {'title': 'درود ابراہیمی', 'desc': 'التحیات کے بعد پڑھیں'},
    29: {'title': 'سلام سے پہلے کی دعا', 'desc': 'نماز کے آخر میں سلام سے پہلے پڑھیں'},
    30: {'title': 'دعائے قنوت', 'desc': 'وتر کی نماز میں پڑھیں'},
    31: {'title': 'نماز کے بعد استغفار', 'desc': 'نماز کے فوراً بعد پڑھیں'},
    32: {'title': 'عبادت میں مدد کی دعا', 'desc': 'نماز کے بعد پڑھیں'},
    33: {'title': 'نماز کے بعد اذکار', 'desc': 'سبحان اللہ 33x الحمد للہ 33x اللہ اکبر 33x'},
    34: {'title': 'مسجد سے نکلنے کی دعا', 'desc': 'مسجد سے نکلتے وقت پڑھیں'},
    35: {'title': 'رمضان کے استقبال کی دعا', 'desc': 'رمضان کا مہینہ شروع ہونے پر پڑھیں'},
    36: {'title': 'افطار کی دعا', 'desc': 'غروب آفتاب کے وقت روزہ کھولتے وقت پڑھیں'},
    37: {'title': 'لیلۃ القدر کی دعا', 'desc': 'رمضان کے آخری 10 راتوں میں کثرت سے پڑھیں'},
    38: {'title': 'دعائے استخارہ', 'desc': 'کوئی اہم فیصلہ کرتے وقت 2 رکعت نماز کے بعد پڑھیں'},
    39: {'title': 'آسانی کی دعا', 'desc': 'مشکل وقت میں پڑھیں'},
    40: {'title': 'بیماری سے شفا کی دعا', 'desc': 'تکلیف کی جگہ پر ہاتھ رکھ کر پڑھیں'},
    41: {'title': 'برائی سے حفاظت کی دعا', 'desc': 'شیطان سے حفاظت کے لیے پڑھیں'},
    42: {'title': 'غربت سے حفاظت کی دعا', 'desc': 'مالی مشکلات میں پڑھیں'},
    43: {'title': 'فکر سے حفاظت کی دعا', 'desc': 'پریشانی یا غم میں پڑھیں'},
    44: {'title': 'شک یا غصے کی دعا', 'desc': 'ایمان میں شک یا غصے کے وقت پڑھیں'},
    45: {'title': 'سفر سے پہلے کی دعا', 'desc': 'سفر پر نکلتے وقت پڑھیں'},
    46: {'title': 'سفر سے واپسی کی دعا', 'desc': 'سفر سے گھر واپس آنے پر پڑھیں'},
    47: {'title': 'والدین کے لیے دعا', 'desc': 'اللہ سے والدین پر رحمت مانگنے کے لیے پڑھیں'},
    48: {'title': 'دولہا دلہن کے لیے دعا', 'desc': 'نئے جوڑے کے لیے دعا کے طور پر پڑھیں'},
    49: {'title': 'ہمبستری سے پہلے کی دعا', 'desc': 'اولاد کو شیطان سے بچانے کے لیے پڑھیں'},
    50: {'title': 'بچوں کی حفاظت کی دعا', 'desc': 'بچوں کو برائی سے بچانے کے لیے پڑھیں'},
    51: {'title': 'شکریہ کی دعا', 'desc': 'جب کوئی ہم سے اچھا کرے تو کہیں'},
    52: {'title': 'میزبان کے لیے دعا', 'desc': 'دعوت دینے والے کے لیے دعا کے طور پر پڑھیں'},
    53: {'title': 'بیمار کی عیادت کی دعا', 'desc': 'مریض کی عیادت کے وقت 7 بار پڑھیں'},
    54: {'title': 'بالغ کی نماز جنازہ کی دعا', 'desc': 'تیسری تکبیر کے بعد پڑھیں'},
    55: {'title': 'بچے کی نماز جنازہ کی دعا', 'desc': 'بچے کی نماز جنازہ میں پڑھیں'},
    56: {'title': 'قبرستان میں داخل ہونے کی دعا', 'desc': 'قبرستان میں داخل ہوتے وقت پڑھیں'},
    57: {'title': 'سیدالاستغفار', 'desc': 'سب سے بڑی استغفار'},
    58: {'title': 'مشکل وقت کی دعا', 'desc': 'جب سب کچھ مشکل لگے تو پڑھیں'},
    59: {'title': 'امتحان سے پہلے کی دعا', 'desc': 'توجہ اور یادداشت بڑھانے کے لیے پڑھیں'},
    60: {'title': 'نکاح کی دعا', 'desc': 'شادی کے لیے دعا'},
    61: {'title': 'بارش کے وقت کی دعا', 'desc': 'بارش کے وقت پڑھیں'},
    62: {'title': 'فکر اور خوف سے حفاظت کی دعا', 'desc': 'پریشانی یا خوف محسوس ہونے پر پڑھیں'},
    63: {'title': 'امتحان میں آسانی کی دعا', 'desc': 'امتحان یا مشکل کام سے پہلے پڑھیں'},
    64: {'title': 'شفا کی دعا', 'desc': 'اللہ سے شفا مانگنے کے لیے پڑھیں'},
    65: {'title': 'آفت سے حفاظت کی دعا', 'desc': 'مشکلات سے حفاظت کے لیے پڑھیں'},
    66: {'title': 'رزق میں برکت کی دعا', 'desc': 'مالی مشکلات میں پڑھیں'},
    67: {'title': 'علم کی دعا', 'desc': 'قرآن کی دعا سینہ کشادہ اور علم بڑھانے کے لیے'},
    68: {'title': 'دل کی بے چینی کی دعا', 'desc': '3 بار پڑھیں اور سینے پر پھونکیں'},
    69: {'title': 'نظر بد سے حفاظت کی دعا', 'desc': 'حسد سے حفاظت کے لیے پڑھیں'},
    70: {'title': 'محبت کی دعا', 'desc': 'اللہ سے دل میں محبت بھرنے کی دعا'},
    71: {'title': 'شادی کی دعا (مرد)', 'desc': 'اللہ سے پاکیزہ لوگوں میں شامل ہونے کی دعا'},
    72: {'title': 'مظلوم کی دعا', 'desc': 'اللہ سے کمزوری کی فریاد'},
    73: {'title': 'صلاحیتیں دیکھنے کی دعا', 'desc': 'اللہ سے عطا کردہ صلاحیتیں دکھانے کی دعا'},
    74: {'title': 'مکمل نعمت کی دعا', 'desc': 'جب اللہ دولت دے تو خوشی نہ لے'},
    75: {'title': 'فکر سے پناہ کی دعا', 'desc': 'غم زدہ فکر سے حفاظت مانگیں'},
    76: {'title': 'دل نفرت سے پاک رکھنے کی دعا', 'desc': 'دل میں نفرت نہ آنے دیں'},
    77: {'title': 'نعمتوں کی حفاظت کی دعا', 'desc': 'نعمتوں کے زوال سے حفاظت مانگیں'},
    78: {'title': 'محبت اور معافی سیکھنے کی دعا', 'desc': 'دوسروں سے ایسا پیار سکھاو جیسا اپنے آپ سے'},
    79: {'title': 'اپنی برائی سے حفاظت کی دعا', 'desc': 'سماعت کی برائی سے حفاظت مانگیں'},
    80: {'title': 'دل نہ اٹکانے کی دعا', 'desc': 'دل کو غیر کی چیز سے نہ اٹکنے دیں'},
    81: {'title': 'منفی خیالات دور کرنے کی دعا', 'desc': 'اللہ سے منفی خیالات دور کرنے کی دعا'},
    82: {'title': 'غم دور کرنے کی دعا', 'desc': 'فکر اور غم دور کرنے کی دعا'},
    83: {'title': 'دل کا سکون', 'desc': 'اللہ سے سکون عطا فرمانے کی دعا'},
    84: {'title': 'خیر ہونے کی دعا', 'desc': 'اگر یہ میرے لیے بہتر ہو تو آسان فرما'},
    85: {'title': 'شادی کی دعا (عورت)', 'desc': 'اللہ سے نیک عورتوں میں شامل ہونے کی دعا'},
    86: {'title': 'غصہ دور کرنے کی دعا', 'desc': 'اللہ سے دل سے غصہ دور کرنے کی دعا'},
    87: {'title': 'مغفرت کی دعا', 'desc': 'میں نے خود پر بہت ظلم کیا'},
    88: {'title': 'نور کی دعا', 'desc': 'دل زبان سماعت اور بصارت میں نور مانگیں'},
    89: {'title': 'آزمائش پر صبر کی دعا', 'desc': 'اللہ کی آزمائش پر صبر مانگیں'},
    90: {'title': 'سینہ کشادہ کرنے کی دعا', 'desc': 'اللہ سے سینہ کشادہ اور کام آسان کرنے کی دعا'},
    91: {'title': 'نظر اور دل کی حفاظت', 'desc': 'اللہ سے نظر کی حفاظت مانگیں'},
    92: {'title': 'خواہش بجھانے کی دعا', 'desc': 'اللہ سے دل کی آگ بجھانے کی دعا'},
    93: {'title': 'اصلاح کرنے والے کی دعا', 'desc': 'اے اصلاح کرنے والے میری اصلاح فرما'},
    94: {'title': 'فتنے سے حفاظت کی دعا', 'desc': 'نقصاندہ خواہشات سے حفاظت مانگیں'},
    95: {'title': 'شکر کی دعا', 'desc': 'اللہ کا شکر نعمت ہے'},
    96: {'title': 'غم سے پناہ کی دعا', 'desc': 'فکر اور غم سے حفاظت مانگیں'},
    97: {'title': 'نہ چھوڑنے کی دعا', 'desc': 'اللہ کی رحمت میری امید ہے'},
    98: {'title': 'اندھیرے سے روشنی کی دعا', 'desc': 'اللہ سے اندھیرے سے روشنی میں لانے کی دعا'},
    99: {'title': 'دل پاک کرنے کی دعا', 'desc': 'اللہ سے رحمت سے دل پاک کرنے کی دعا'},
    100: {'title': 'طاقت اور ہمت کی دعا', 'desc': 'نفس سے لڑنے کی طاقت مانگیں'},
    101: {'title': 'دل برائی سے پاک کرنے کی دعا', 'desc': 'اللہ سے دل کو ہر برائی سے پاک کرنے کی دعا'},
    102: {'title': 'عمل میں کامیابی کی دعا', 'desc': 'نفع مند علم نیک رزق اور مقبول عمل مانگیں'},
  },
  'bn': {
    1: {'title': 'ঘুম থেকে ওঠার দোয়া', 'desc': 'প্রতিদিন সকালে ঘুম থেকে উঠে পড়ুন'},
    2: {'title': 'টয়লেটে প্রবেশের দোয়া', 'desc': 'টয়লেটে যাওয়ার আগে পড়ুন'},
    3: {'title': 'টয়লেট থেকে বের হওয়ার দোয়া', 'desc': 'টয়লেট থেকে বের হওয়ার পর পড়ুন'},
    4: {'title': 'কাপড় পরার দোয়া', 'desc': 'কাপড় পরার সময় পড়ুন'},
    5: {'title': 'আয়না দেখার দোয়া', 'desc': 'আয়নায় দেখার সময় পড়ুন'},
    6: {'title': 'খাবার আগের দোয়া', 'desc': 'খাবার শুরু করার আগে পড়ুন'},
    7: {'title': 'বিসমিল্লাহ ভুলে যাওয়ার দোয়া', 'desc': 'খাওয়ার মাঝে মনে পড়লে পড়ুন'},
    8: {'title': 'খাবার পরের দোয়া', 'desc': 'খাবার শেষে পড়ুন'},
    9: {'title': 'ঘর থেকে বের হওয়ার দোয়া', 'desc': 'ঘর থেকে বের হওয়ার সময় পড়ুন'},
    10: {'title': 'যানবাহনে ওঠার দোয়া', 'desc': 'গাড়ি বা যানবাহনে ওঠার সময় পড়ুন'},
    11: {'title': 'সালামের দোয়া', 'desc': 'মুসলিমকে সালাম দেওয়ার সময় বলুন'},
    12: {'title': 'সালামের জবাব', 'desc': 'সালামের জবাব দেওয়ার সময় বলুন'},
    13: {'title': 'হাঁচির দোয়া', 'desc': 'হাঁচি দেওয়ার পর বলুন'},
    14: {'title': 'অন্যের হাঁচির দোয়া', 'desc': 'অন্যের হাঁচি শুনলে বলুন'},
    15: {'title': 'ইয়ারহামুকাল্লাহর জবাব', 'desc': 'হাঁচির দোয়ার জবাবে বলুন'},
    16: {'title': 'বিপদগ্রস্ত দেখলে দোয়া', 'desc': 'কাউকে বিপদে দেখলে আস্তে পড়ুন'},
    17: {'title': 'বাজারে প্রবেশের দোয়া', 'desc': 'বাজার বা দোকানে ঢোকার সময় পড়ুন'},
    18: {'title': 'ঘরে প্রবেশের দোয়া', 'desc': 'ঘরে ঢোকার সময় পড়ুন'},
    19: {'title': 'ঘুমানোর আগের দোয়া', 'desc': 'ঘুমানোর আগে পড়ুন'},
    20: {'title': 'ওযুর পরের দোয়া', 'desc': 'ওযু শেষে পড়ুন'},
    21: {'title': 'মসজিদে প্রবেশের দোয়া', 'desc': 'মসজিদে ঢোকার সময় পড়ুন'},
    22: {'title': 'আযানের সময়ের দোয়া', 'desc': 'হাইয়া আলাস সালাহর বদলে বলুন'},
    23: {'title': 'আযানের পরের দোয়া', 'desc': 'আযান শুনলে পড়ুন'},
    24: {'title': 'ইফতিতাহের দোয়া', 'desc': 'নামাজ শুরুতে তাকবিরের পর পড়ুন'},
    25: {'title': 'রুকুর দোয়া', 'desc': 'নামাজে রুকুর সময় পড়ুন'},
    26: {'title': 'সিজদার দোয়া', 'desc': 'নামাজে সিজদার সময় পড়ুন'},
    27: {'title': 'আত্তাহিয়্যাত', 'desc': 'নামাজের বৈঠকে পড়ুন'},
    28: {'title': 'দরুদে ইব্রাহিম', 'desc': 'আত্তাহিয়্যাতের পর পড়ুন'},
    29: {'title': 'সালামের আগের দোয়া', 'desc': 'নামাজের শেষে সালামের আগে পড়ুন'},
    30: {'title': 'দোয়ায়ে কুনুত', 'desc': 'বিতরের নামাজে পড়ুন'},
    31: {'title': 'নামাজের পরের ইস্তেগফার', 'desc': 'নামাজ শেষে তৎক্ষণাৎ পড়ুন'},
    32: {'title': 'ইবাদতে সাহায্যের দোয়া', 'desc': 'নামাজের পর পড়ুন'},
    33: {'title': 'নামাজের পরের যিকির', 'desc': 'সুবহানাল্লাহ ৩৩x আলহামদুলিল্লাহ ৩৩x আল্লাহু আকবার ৩৩x'},
    34: {'title': 'মসজিদ থেকে বের হওয়ার দোয়া', 'desc': 'মসজিদ থেকে বের হওয়ার সময় পড়ুন'},
    35: {'title': 'রমজান স্বাগত দোয়া', 'desc': 'রমজান মাস শুরু হলে পড়ুন'},
    36: {'title': 'ইফতারের দোয়া', 'desc': 'সূর্যাস্তের সময় রোজা ভাঙার সময় পড়ুন'},
    37: {'title': 'লাইলাতুল কদরের দোয়া', 'desc': 'রমজানের শেষ ১০ রাতে বেশি বেশি পড়ুন'},
    38: {'title': 'ইস্তেখারার দোয়া', 'desc': 'গুরুত্বপূর্ণ সিদ্ধান্তের আগে ২ রাকাত নামাজের পর পড়ুন'},
    39: {'title': 'সহজতার দোয়া', 'desc': 'কষ্টের সময় পড়ুন'},
    40: {'title': 'রোগ থেকে সুস্থতার দোয়া', 'desc': 'ব্যথার জায়গায় হাত রেখে পড়ুন'},
    41: {'title': 'মন্দ থেকে সুরক্ষার দোয়া', 'desc': 'শয়তান থেকে সুরক্ষার জন্য পড়ুন'},
    42: {'title': 'দারিদ্র্য থেকে সুরক্ষার দোয়া', 'desc': 'আর্থিক সমস্যায় পড়ুন'},
    43: {'title': 'দুশ্চিন্তা থেকে সুরক্ষার দোয়া', 'desc': 'উদ্বেগ বা দুঃখ অনুভব করলে পড়ুন'},
    44: {'title': 'সন্দেহ বা রাগের দোয়া', 'desc': 'ঈমানে সন্দেহ বা রাগের সময় পড়ুন'},
    45: {'title': 'সফরের আগের দোয়া', 'desc': 'যাত্রা শুরু করার সময় পড়ুন'},
    46: {'title': 'সফর থেকে ফেরার দোয়া', 'desc': 'সফর থেকে ঘরে ফেরার সময় পড়ুন'},
    47: {'title': 'বাবা-মার জন্য দোয়া', 'desc': 'আল্লাহর কাছে বাবা-মার জন্য রহমত চাইতে পড়ুন'},
    48: {'title': 'বর-কনের জন্য দোয়া', 'desc': 'নতুন দম্পতির জন্য দোয়া হিসেবে পড়ুন'},
    49: {'title': 'সহবাসের আগের দোয়া', 'desc': 'সন্তানকে শয়তান থেকে সুরক্ষার জন্য পড়ুন'},
    50: {'title': 'শিশু সুরক্ষার দোয়া', 'desc': 'শিশুকে মন্দ থেকে রক্ষার জন্য পড়ুন'},
    51: {'title': 'ধন্যবাদের দোয়া', 'desc': 'কেউ ভালো করলে বলুন'},
    52: {'title': 'মেহমানদারির দোয়া', 'desc': 'আপ্যায়নকারীর জন্য দোয়া হিসেবে পড়ুন'},
    53: {'title': 'রোগীর সেবার দোয়া', 'desc': 'রোগী দেখতে গেলে ৭ বার পড়ুন'},
    54: {'title': 'প্রাপ্তবয়স্কের জানাজার দোয়া', 'desc': 'তৃতীয় তাকবিরের পর পড়ুন'},
    55: {'title': 'শিশুর জানাজার দোয়া', 'desc': 'শিশুর জানাজায় পড়ুন'},
    56: {'title': 'কবরস্থানে প্রবেশের দোয়া', 'desc': 'কবরস্থানে ঢোকার সময় পড়ুন'},
    57: {'title': 'সাইয়্যিদুল ইস্তেগফার', 'desc': 'সবচেয়ে বড় ক্ষমার দোয়া'},
    58: {'title': 'কষ্টের সময়ের দোয়া', 'desc': 'সব কিছু কঠিন লাগলে পড়ুন'},
    59: {'title': 'পরীক্ষার আগের দোয়া', 'desc': 'মনোযোগ ও স্মৃতিশক্তি বাড়াতে পড়ুন'},
    60: {'title': 'বিয়ের দোয়া', 'desc': 'বিয়ের জন্য দোয়া'},
    61: {'title': 'বৃষ্টির সময়ের দোয়া', 'desc': 'বৃষ্টির সময় পড়ুন'},
    62: {'title': 'উদ্বেগ ও ভয় থেকে সুরক্ষার দোয়া', 'desc': 'উদ্বেগ বা ভয় অনুভব করলে পড়ুন'},
    63: {'title': 'পরীক্ষায় সহজতার দোয়া', 'desc': 'পরীক্ষা বা কঠিন কাজের আগে পড়ুন'},
    64: {'title': 'সুস্থতার দোয়া', 'desc': 'আল্লাহর কাছে সুস্থতা চাইতে পড়ুন'},
    65: {'title': 'বিপদ থেকে সুরক্ষার দোয়া', 'desc': 'কষ্ট থেকে সুরক্ষার জন্য পড়ুন'},
    66: {'title': 'রিজিকে বরকতের দোয়া', 'desc': 'আর্থিক সমস্যায় পড়ুন'},
    67: {'title': 'জ্ঞানের দোয়া', 'desc': 'বুক খুলে দিতে ও জ্ঞান বাড়াতে কুরআনের দোয়া'},
    68: {'title': 'অস্থির হৃদয়ের দোয়া', 'desc': '৩ বার পড়ুন এবং বুকে ফুঁ দিন'},
    69: {'title': 'কুদৃষ্টি থেকে সুরক্ষার দোয়া', 'desc': 'হিংসা থেকে সুরক্ষার জন্য পড়ুন'},
    70: {'title': 'ভালোবাসার দোয়া', 'desc': 'আল্লাহর কাছে হৃদয় ভালোবাসায় ভরার দোয়া'},
    71: {'title': 'বিয়ের দোয়া (পুরুষ)', 'desc': 'আল্লাহর কাছে পবিত্রদের মধ্যে থাকার দোয়া'},
    72: {'title': 'মজলুমের দোয়া', 'desc': 'আল্লাহর কাছে দুর্বলতার অভিযোগ'},
    73: {'title': 'প্রতিভা দেখার দোয়া', 'desc': 'আল্লাহর দেওয়া প্রতিভা দেখাতে দোয়া'},
    74: {'title': 'পরিপূর্ণ নেয়ামতের দোয়া', 'desc': 'সম্পদ দিলে সুখ নিও না'},
    75: {'title': 'উদ্বেগ থেকে আশ্রয়ের দোয়া', 'desc': 'দুঃখজনক উদ্বেগ থেকে সুরক্ষা চান'},
    76: {'title': 'ঘৃণামুক্ত হৃদয়ের দোয়া', 'desc': 'হৃদয়ে ঘৃণা না আসতে দিন'},
    77: {'title': 'নেয়ামত রক্ষার দোয়া', 'desc': 'নেয়ামত চলে যাওয়া থেকে সুরক্ষা চান'},
    78: {'title': 'ভালোবাসা ও ক্ষমা শেখার দোয়া', 'desc': 'নিজেকে ভালোবাসার মতো অন্যকে ভালোবাসতে শেখান'},
    79: {'title': 'নিজের মন্দ থেকে সুরক্ষার দোয়া', 'desc': 'শ্রবণের মন্দ থেকে সুরক্ষা চান'},
    80: {'title': 'হৃদয় না বাঁধার দোয়া', 'desc': 'হৃদয়কে পরের জিনিসে না বাঁধতে দিন'},
    81: {'title': 'নেতিবাচক চিন্তা দূরের দোয়া', 'desc': 'আল্লাহর কাছে নেতিবাচক চিন্তা দূর করার দোয়া'},
    82: {'title': 'দুঃখ-কষ্ট দূরের দোয়া', 'desc': 'উদ্বেগ ও দুঃখ দূর করার দোয়া'},
    83: {'title': 'হৃদয়ের শান্তির দোয়া', 'desc': 'আল্লাহর কাছে শান্তি চান'},
    84: {'title': 'কল্যাণ হওয়ার দোয়া', 'desc': 'যদি এটি আমার জন্য ভালো হয় তাহলে সহজ করুন'},
    85: {'title': 'বিয়ের দোয়া (নারী)', 'desc': 'আল্লাহর কাছে পবিত্র নারীদের মধ্যে থাকার দোয়া'},
    86: {'title': 'রাগ দূরের দোয়া', 'desc': 'আল্লাহর কাছে হৃদয় থেকে রাগ দূর করার দোয়া'},
    87: {'title': 'ক্ষমার দোয়া', 'desc': 'আমি নিজের প্রতি অনেক অন্যায় করেছি'},
    88: {'title': 'আলোর দোয়া', 'desc': 'হৃদয় জিহ্বা শ্রবণ ও দৃষ্টিতে আলো চান'},
    89: {'title': 'পরীক্ষায় ধৈর্যের দোয়া', 'desc': 'আল্লাহর পরীক্ষায় ধৈর্য চান'},
    90: {'title': 'বুক প্রশস্ত করার দোয়া', 'desc': 'আল্লাহর কাছে বুক প্রশস্ত ও কাজ সহজ করার দোয়া'},
    91: {'title': 'দৃষ্টি ও হৃদয় রক্ষার দোয়া', 'desc': 'আল্লাহর কাছে দৃষ্টি রক্ষার দোয়া'},
    92: {'title': 'কামনা নেভানোর দোয়া', 'desc': 'আল্লাহর কাছে হৃদয়ের আগুন নেভানোর দোয়া'},
    93: {'title': 'সংশোধনকারীর দোয়া', 'desc': 'হে সংশোধনকারী আমাকে সংশোধন করুন'},
    94: {'title': 'প্রলোভন থেকে সুরক্ষার দোয়া', 'desc': 'ক্ষতিকর কামনা থেকে সুরক্ষা চান'},
    95: {'title': 'কৃতজ্ঞতার দোয়া', 'desc': 'আল্লাহর শুকরিয়া নেয়ামত'},
    96: {'title': 'উদ্বেগ থেকে আশ্রয়ের দোয়া', 'desc': 'উদ্বেগ ও দুঃখ থেকে সুরক্ষা চান'},
    97: {'title': 'পরিত্যক্ত না হওয়ার দোয়া', 'desc': 'আল্লাহর রহমত আমার আশা'},
    98: {'title': 'অন্ধকার থেকে আলোয় আসার দোয়া', 'desc': 'আল্লাহর কাছে অন্ধকার থেকে আলোয় আসার দোয়া'},
    99: {'title': 'হৃদয় পরিষ্কারের দোয়া', 'desc': 'আল্লাহর রহমতে হৃদয় পরিষ্কার করার দোয়া'},
    100: {'title': 'শক্তি ও সাহসের দোয়া', 'desc': 'নফসের বিরুদ্ধে শক্তি চান'},
    101: {'title': 'হৃদয় মন্দমুক্ত করার দোয়া', 'desc': 'আল্লাহর কাছে হৃদয় সব মন্দ থেকে মুক্ত করার দোয়া'},
    102: {'title': 'আমলে সফলতার দোয়া', 'desc': 'উপকারী জ্ঞান ভালো রিজিক ও কবুল আমল চান'},
  },
};


final _categories = [
  {'id': 'all',        'th': 'ทั้งหมด',     'en': 'All',        'ms': 'Semua',       'id2': 'Semua',       'ar': 'الكل',       'ur': 'سب',      'bn': 'সব'},
  {'id': 'daily',      'th': 'ประจำวัน',    'en': 'Daily',      'ms': 'Harian',      'id2': 'Harian',      'ar': 'يومي',       'ur': 'روزانہ',  'bn': 'দৈনিক'},
  {'id': 'prayer',     'th': 'ละหมาด',      'en': 'Prayer',     'ms': 'Solat',       'id2': 'Sholat',      'ar': 'الصلاة',     'ur': 'نماز',    'bn': 'নামাজ'},
  {'id': 'hardship',   'th': 'ยากลำบาก',   'en': 'Hardship',   'ms': 'Kesusahan',   'id2': 'Kesulitan',   'ar': 'الشدة',      'ur': 'مشکل',    'bn': 'কষ্ট'},
  {'id': 'protection', 'th': 'ปกป้อง',      'en': 'Protection', 'ms': 'Perlindungan','id2': 'Perlindungan','ar': 'الحماية',    'ur': 'تحفظ',    'bn': 'সুরক্ষা'},
  {'id': 'travel',     'th': 'เดินทาง',     'en': 'Travel',     'ms': 'Perjalanan',  'id2': 'Perjalanan',  'ar': 'السفر',      'ur': 'سفر',     'bn': 'ভ্রমণ'},
  {'id': 'family',     'th': 'ครอบครัว',    'en': 'Family',     'ms': 'Keluarga',    'id2': 'Keluarga',    'ar': 'الأسرة',     'ur': 'خاندان',  'bn': 'পরিবার'},
  {'id': 'ramadan',    'th': 'รอมฎอน',      'en': 'Ramadan',    'ms': 'Ramadan',     'id2': 'Ramadan',     'ar': 'رمضان',      'ur': 'رمضان',   'bn': 'রমজান'},
  {'id': 'social',     'th': 'สังคม',       'en': 'Social',     'ms': 'Sosial',      'id2': 'Sosial',      'ar': 'الاجتماعي',  'ur': 'سماجی',   'bn': 'সামাজিক'},
  {'id': 'death',      'th': 'ผู้เสียชีวิต','en': 'Death',      'ms': 'Kematian',    'id2': 'Kematian',    'ar': 'الوفاة',     'ur': 'موت',     'bn': 'মৃত্যু'},
];

// ── คำว่า "บท/ดุอาอ์" ต่อท้ายตัวเลขนับ ให้ครบทุกภาษาที่แอปรองรับ ──
// (เดิมมีแค่ th/en เท่านั้น ภาษาอื่นจะว่างเปล่า เช่น "3/14" ไม่มีคำต่อท้าย)
String _duaUnitWord(String lang) {
  switch (lang) {
    case 'th':
      return 'บท';
    case 'ms':
      return 'doa';
    case 'id':
      return 'doa';
    case 'ar':
      return 'دعاء';
    case 'ur':
      return 'دعائیں';
    case 'bn':
      return 'দোয়া';
    case 'en':
    default:
      return 'duas';
  }
}

// ── ไอคอนและสีไล่เฉดของแต่ละหมวดหมู่ดุอาอ์ (ใช้ในหน้าการ์ดหมวดหมู่) ──
const Map<String, IconData> kDuaCategoryIcons = {
  'daily': Icons.wb_sunny_rounded,
  'prayer': Icons.mosque_rounded,
  'hardship': Icons.volunteer_activism_rounded,
  'protection': Icons.shield_rounded,
  'travel': Icons.flight_rounded,
  'family': Icons.family_restroom_rounded,
  'ramadan': Icons.nights_stay_rounded,
  'social': Icons.groups_rounded,
  'death': Icons.spa_rounded,
};

const Map<String, List<Color>> kDuaCategoryColors = {
  'daily':      [Color(0xFFEF6C00), Color(0xFFFFA726)],
  'prayer':     [Color(0xFF6A1B9A), Color(0xFF9C27B0)],
  'hardship':   [Color(0xFF37474F), Color(0xFF607D8B)],
  'protection': [Color(0xFF00695C), Color(0xFF00897B)],
  'travel':     [Color(0xFF0D47A1), Color(0xFF1E88E5)],
  'family':     [Color(0xFFAD1457), Color(0xFFD81B60)],
  'ramadan':    [Color(0xFF283593), Color(0xFF3F51B5)],
  'social':     [Color(0xFF2E7D32), Color(0xFF43A047)],
  'death':      [Color(0xFF4E342E), Color(0xFF6D4C41)],
};

/// ── แคชรายการดุอาอ์ทั้งหมดลง SharedPreferences เพื่อให้เปิดหน้านี้แบบ ──
/// offline ได้หลังจากเคยโหลดสำเร็จอย่างน้อย 1 ครั้ง (ใช้ร่วมกันทั้ง DuaPage
/// และ DuaTab) — เก็บเป็น JSON string ของ List<Map> ดิบจาก API ตรงๆ
/// (ยังไม่ผสมคำแปลภาษาอื่น เพราะคำแปลคำนวณจาก kDuaTranslations/
/// kDuaAllTranslations ที่ฝังอยู่ในแอปอยู่แล้ว ไม่ต้องแคชซ้ำ)
class DuaCacheService {
  static const _key = 'dua_cached_list';

  static Future<void> save(List<Map<String, dynamic>> duas) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, json.encode(duas));
  }

  static Future<List<Map<String, dynamic>>?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_key);
    if (cached == null) return null;
    try {
      final data = json.decode(cached) as List;
      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      return null;
    }
  }
}

/// ── บันทึก "อ่านแล้ว" ของแต่ละดุอาอ์ลง SharedPreferences ──
/// เก็บเป็น Set ของ id (แปลงเป็น String) ใช้ร่วมกันทั้งหน้า DuaPage และ DuaTab
class DuaProgressService {
  static const _key = 'dua_read_ids';

  static Future<Set<String>> getReadIds() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_key) ?? []).toSet();
  }

  static Future<void> markRead(dynamic duaId) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = (prefs.getStringList(_key) ?? []).toSet();
    if (ids.add(duaId.toString())) {
      await prefs.setStringList(_key, ids.toList());
    }
  }
}

/// ── การ์ดหมวดหมู่ดุอาอ์ (ไล่เฉดสี + ไอคอน + แถบความคืบหน้า) ──
/// ใช้ร่วมกันทั้ง DuaPage (มี Scaffold ของตัวเอง) และ DuaTab (แท็บใน DuaLessonsPage)
Widget buildDuaCategoryCard({
  required Map<String, String> cat,
  required int total,
  required int read,
  required LanguageService lang,
  required ThemeService theme,
  required VoidCallback onTap,
}) {
  final catId = cat['id'] as String;
  final colors = kDuaCategoryColors[catId] ?? const [Color(0xFF1B5E20), Color(0xFF2E7D32)];
  final icon = kDuaCategoryIcons[catId] ?? Icons.menu_book_rounded;
  final label = _getCatLabel(cat, lang.lang);
  final progress = total > 0 ? read / total : 0.0;
  final isDone = total > 0 && read >= total;

  return TweenAnimationBuilder<double>(
    tween: Tween(begin: 0.94, end: 1.0),
    duration: const Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
    builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        splashColor: colors[0].withOpacity(0.12),
        highlightColor: colors[0].withOpacity(0.06),
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(theme.isDark ? 0.20 : 0.04), blurRadius: 10, offset: const Offset(0, 3))]),
          child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Container(width: 52, height: 52,
                decoration: BoxDecoration(
                    gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color: colors[0].withOpacity(0.35), blurRadius: 8, offset: const Offset(0, 3))]),
                child: Icon(icon, color: Colors.white, size: 26)),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label,
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.textColor, fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(cat['en'] ?? '',
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: theme.subTextColor, fontSize: 11.5, letterSpacing: 0.2)),
                const SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.menu_book_rounded, size: 13, color: colors[0]),
                  const SizedBox(width: 4),
                  Text('$read/$total ${_duaUnitWord(lang.lang)}'.trim(),
                      style: TextStyle(color: colors[0], fontSize: 12, fontWeight: FontWeight.w700)),
                ]),
              ]),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 46, height: 46,
              child: Stack(alignment: Alignment.center, children: [
                SizedBox(
                  width: 46, height: 46,
                  child: CircularProgressIndicator(
                    value: progress.clamp(0.0, 1.0),
                    strokeWidth: 4,
                    backgroundColor: theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation(colors[0]),
                  ),
                ),
                isDone
                    ? Icon(Icons.check_rounded, color: colors[0], size: 20)
                    : Text('${(progress * 100).round()}%',
                        style: TextStyle(color: theme.textColor, fontSize: 11, fontWeight: FontWeight.w700)),
              ]),
            ),
          ]),
        ),
      ),
    ),
  );
}

/// ── หน้าใหม่แยกต่างหากสำหรับแสดงดุอาอ์ในหมวดที่เลือก ──
/// เปิดด้วย Navigator.push (มี transition แบบเปลี่ยนหน้าจริงของระบบ)
/// แทนการสลับ state อยู่ในหน้าเดิม ใช้ร่วมกันทั้ง DuaPage และ DuaTab
class DuaCategoryDetailPage extends StatefulWidget {
  final String categoryId;
  final List<Map<String, dynamic>> duas;
  const DuaCategoryDetailPage({super.key, required this.categoryId, required this.duas});

  @override
  State<DuaCategoryDetailPage> createState() => _DuaCategoryDetailPageState();
}

class _DuaCategoryDetailPageState extends State<DuaCategoryDetailPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();
  final _searchCtrl = TextEditingController();
  Set<String> _readDuaIds = {};
  late List<Map<String, dynamic>> _filtered;

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
    _filtered = widget.duas.where((d) => d['category'] == widget.categoryId).toList();
    _searchCtrl.addListener(_filterDuas);
    _loadReadIds();
  }

  Future<void> _loadReadIds() async {
    final ids = await DuaProgressService.getReadIds();
    if (mounted) setState(() => _readDuaIds = ids);
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    _searchCtrl.dispose();
    super.dispose();
  }

  void _filterDuas() {
    final query = _searchCtrl.text.toLowerCase();
    final lang = _lang.lang;
    setState(() {
      _filtered = widget.duas.where((dua) {
        final matchCat = dua['category'] == widget.categoryId;
        final matchSearch = query.isEmpty ||
            (_getDuaTitle(dua, lang)).toLowerCase().contains(query) ||
            (dua['dua'] ?? '').contains(query);
        return matchCat && matchSearch;
      }).toList();
    });
  }

  void _copyDua(Map<String, dynamic> dua) {
    Clipboard.setData(ClipboardData(text: '${dua['dua']}\n\n${dua['transliteration']}'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_lang.copied),
      backgroundColor: const Color(0xFF1B5E20),
      duration: const Duration(seconds: 1)));
  }

  void _showDetail(Map<String, dynamic> dua) {
    DuaProgressService.markRead(dua['id']).then((_) {
      if (mounted) setState(() => _readDuaIds.add(dua['id'].toString()));
    });
    final lang = _lang.lang;
    final cat = _categories.firstWhere(
        (c) => c['id'] == dua['category'],
        orElse: () => {'en': '', 'th': '', 'id2': '', 'ms': '', 'ar': '', 'ur': '', 'bn': ''});
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75, maxChildSize: 0.95, minChildSize: 0.5,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _theme.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Text(_getCatLabel(cat, lang),
                      style: TextStyle(fontSize: 12, color: _theme.iconColor, fontWeight: FontWeight.w600)),
                ])),
              const Spacer(),
              IconButton(icon: Icon(Icons.copy, color: _theme.subTextColor, size: 20), onPressed: () => _copyDua(dua)),
            ]),
            const SizedBox(height: 12),
            Text(_getDuaTitle(dua, lang), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _theme.textColor)),
            const SizedBox(height: 6),
            Text(_getDuaDesc(dua, lang), style: TextStyle(fontSize: 13, color: _theme.subTextColor, height: 1.5)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _theme.iconColor.withOpacity(0.2))),
              child: Text(dua['dua'] ?? '',
                  textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 26, height: 2.0, color: _theme.textColor, fontWeight: FontWeight.w500))),
            const SizedBox(height: 16),
            if (_getDuaTrans(dua, lang).isNotEmpty)
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _theme.cardColor, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_lang.transliteration, style: TextStyle(fontSize: 12, color: _theme.iconColor, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(_getDuaTrans(dua, lang),
                    style: TextStyle(fontSize: 14, color: _theme.textColor, height: 1.6, fontStyle: FontStyle.italic)),
              ])),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  Widget _buildCard(Map<String, dynamic> dua) {
    final lang = _lang.lang;
    return GestureDetector(
      onTap: () => _showDetail(dua),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFE8F5E9)),
          boxShadow: _theme.isDark ? null : [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_getDuaTitle(dua, lang),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _theme.textColor)),
                const SizedBox(height: 2),
                Text(_getDuaDesc(dua, lang),
                    style: TextStyle(fontSize: 11, color: _theme.subTextColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              GestureDetector(
                onTap: () => _copyDua(dua),
                child: Padding(padding: const EdgeInsets.all(4),
                    child: Icon(Icons.copy_outlined, color: _theme.subTextColor, size: 15))),
            ])),
          Container(height: 0.5, margin: const EdgeInsets.symmetric(horizontal: 14),
              color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(dua['dua'] ?? '',
                  textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 19, height: 1.9, color: _theme.textColor)),
              if (_getDuaTrans(dua, lang).isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(_getDuaTrans(dua, lang),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: _theme.subTextColor, fontStyle: FontStyle.italic)),
              ],
            ])),
        ]),
      ));
  }

  @override
  Widget build(BuildContext context) {
    final lang = _lang.lang;
    final cat = _categories.firstWhere((c) => c['id'] == widget.categoryId,
        orElse: () => const {'th': '', 'en': ''});
    final colors = kDuaCategoryColors[widget.categoryId] ?? const [Color(0xFF1B5E20), Color(0xFF2E7D32)];
    final icon = kDuaCategoryIcons[widget.categoryId] ?? Icons.menu_book_rounded;
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
            boxShadow: [BoxShadow(color: colors[0].withOpacity(0.28), blurRadius: 14, offset: const Offset(0, 6))]),
          child: SafeArea(bottom: false, child: Padding(
            padding: const EdgeInsets.fromLTRB(4, 4, 16, 16),
            child: Column(children: [
              Row(children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                  onPressed: () => Navigator.pop(context)),
                Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: Icon(icon, color: Colors.white, size: 22)),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_getCatLabel(cat, lang),
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('${_filtered.length} ${lang == "th" ? "บท" : (cat['en'] ?? '')}'.trim(),
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12)),
                ])),
              ]),
              const SizedBox(height: 14),
              Container(
                height: 42,
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                child: TextField(
                  controller: _searchCtrl,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    hintText: _lang.searchDua,
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 10)))),
            ]),
          )),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SafeArea(
            top: false,
            child: _filtered.isEmpty
                ? Center(child: Text(_lang.noDuaFound, style: TextStyle(color: _theme.subTextColor)))
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _buildCard(_filtered[i])),
          ),
        ),
      ]),
    );
  }
}

String _getCatLabel(Map<String, String> cat, String lang) {
  if (lang == 'id') return cat['id2'] ?? cat['en'] ?? '';
  return cat[lang] ?? cat['en'] ?? '';
}

String _getDuaTitle(Map<String, dynamic> dua, String lang) {
  if (lang == 'th') return dua['titleTh'] ?? dua['title'] ?? '';
  return dua['titleLang'] ?? dua['title'] ?? '';
}

String _getDuaDesc(Map<String, dynamic> dua, String lang) {
  if (lang == 'th') return dua['descTh'] ?? dua['description'] ?? '';
  return dua['descLang'] ?? dua['description'] ?? '';
}

String _getDuaTrans(Map<String, dynamic> dua, String lang) {
  // Arabic - no transliteration needed
  if (lang == 'ar') return '';
  // Thai - use Thai transliteration
  if (lang == 'th') {
    final id = dua['id'] as int?;
    if (id != null && kDuaTranslations.containsKey(id)) {
      return kDuaTranslations[id]!['transTh'] ?? dua['transliteration'] ?? '';
    }
  }
  // UR/BN - use script transliteration if available
  if (lang == 'ur' || lang == 'bn') {
    return dua['transLang'] ?? dua['transliteration'] ?? '';
  }
  // MS/ID/EN - use Latin transliteration from API
  return dua['transliteration'] ?? '';
}

// ── DuaPage ────────────────────────────────────────
class DuaPage extends StatefulWidget {
  const DuaPage({super.key});
  @override
  State<DuaPage> createState() => _DuaPageState();
}

class _DuaPageState extends State<DuaPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();
  List<Map<String, dynamic>> _duas = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Set<String> _readDuaIds = {};
  final _searchCtrl = TextEditingController();

  void _rebuild() { if (mounted) setState(() {}); }
  void _onLangChange() {
    if (!mounted) return;
    setState(() {});
    _filterDuas();
    final lang = _lang.lang;
    if (lang != 'en' && lang != 'th' && _duas.isNotEmpty) {
      _applyTranslations(lang);
    }
  }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_onLangChange);
    _searchCtrl.addListener(_filterDuas);
    _fetchDuas();
    _loadReadIds();
  }

  Future<void> _loadReadIds() async {
    final ids = await DuaProgressService.getReadIds();
    if (mounted) setState(() => _readDuaIds = ids);
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_onLangChange);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDuas() async {
    setState(() { _isLoading = true; _errorMessage = ''; });

    // ── โหลดจากแคช (ถ้ามี) ขึ้นมาแสดงก่อนทันที ไม่ต้องรอเน็ต ──
    // ทำให้เปิดหน้านี้แบบ offline ได้ถ้าเคยโหลดสำเร็จมาก่อนอย่างน้อย 1 ครั้ง
    final cached = await DuaCacheService.load();
    if (cached != null && cached.isNotEmpty && mounted) {
      final duas = _withThaiTranslations(cached);
      setState(() { _duas = duas; _filtered = duas; _isLoading = false; });
      final lang = _lang.lang;
      if (lang != 'en' && lang != 'th') await _applyTranslations(lang);
    }

    // ── ลองโหลดของจริงจากเน็ตอยู่เสมอ เพื่ออัปเดตแคชให้ใหม่ล่าสุด ──
    // ถ้าไม่มีเน็ตและเคยมีแคชอยู่แล้ว จะไม่ขึ้น error ซ้อน (ใช้ของแคชต่อไปเงียบๆ)
    try {
      final res = await http.get(
        Uri.parse('https://dua-data-api.vercel.app/api/usefulDuas'),
      ).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        final rawDuas = data.map((e) => Map<String, dynamic>.from(e)).toList();
        await DuaCacheService.save(rawDuas);
        final duas = _withThaiTranslations(rawDuas);
        if (mounted) setState(() { _duas = duas; _filtered = duas; _isLoading = false; });
        final lang = _lang.lang;
        if (lang != 'en' && lang != 'th') await _applyTranslations(lang);
      } else if (cached == null && mounted) {
        setState(() { _errorMessage = 'Failed'; _isLoading = false; });
      }
    } catch (e) {
      // หมดเน็ต — ถ้ามีแคชอยู่แล้วก็ปล่อยให้ใช้ของแคชต่อไปโดยไม่โชว์ error
      if (cached == null && mounted) {
        setState(() { _errorMessage = 'No internet'; _isLoading = false; });
      }
    }
  }

  /// ── ผสมคำแปลไทย (kDuaTranslations) เข้ากับรายการดุอาอ์ดิบ ──
  /// ใช้ร่วมกันทั้งตอนโหลดจากแคชและตอนโหลดจากเน็ตจริง กันโค้ดซ้ำ
  List<Map<String, dynamic>> _withThaiTranslations(List<Map<String, dynamic>> raw) {
    return raw.map((e) {
      final dua = Map<String, dynamic>.from(e);
      final id = dua['id'] as int;
      if (kDuaTranslations.containsKey(id)) {
        dua['titleTh'] = kDuaTranslations[id]!['titleTh'];
        dua['descTh'] = kDuaTranslations[id]!['descTh'];
      }
      return dua;
    }).toList();
  }

  Future<void> _applyTranslations(String lang) async {
    if (!mounted) return;
    // Use hardcoded translations - instant, no API needed
    final langMap = kDuaAllTranslations[lang];
    if (langMap != null) {
      for (var dua in _duas) {
        final id = dua['id'] as int;
        if (langMap.containsKey(id)) {
          dua['titleLang'] = langMap[id]!['title'];
          dua['descLang'] = langMap[id]!['desc'];
        }
      }
    }
    if (mounted) setState(() { _filtered = List.from(_duas); });
    _filterDuas();

    // For UR/BN - also translate transliteration via Gemini + cache
    if (lang == 'ur' || lang == 'bn') {
      await _applyTransLiteration(lang);
    }
  }

  Future<void> _applyTransLiteration(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'dua_translit_$lang';
    final cached = prefs.getString(cacheKey);
    Map<String, dynamic> transMap = {};

    if (cached != null) {
      transMap = json.decode(cached);
    } else {
      // Translate via Gemini in batches
      transMap = await _translateTransliteration(lang);
      if (transMap.isNotEmpty) {
        await prefs.setString(cacheKey, json.encode(transMap));
      }
    }

    if (!mounted) return;
    for (var dua in _duas) {
      final id = dua['id'].toString();
      if (transMap.containsKey(id)) {
        dua['transLang'] = transMap[id];
      }
    }
    if (mounted) setState(() { _filtered = List.from(_duas); });
    _filterDuas();
  }

  Future<Map<String, dynamic>> _translateTransliteration(String lang) async {
    // ดึงจาก api_config.dart ไฟล์เดียว (แก้ key ที่นั่นที่เดียวพอ)
    const geminiKey = ApiConfig.defaultGeminiApiKey;
    const geminiUrl = ApiConfig.geminiApiUrl;
    final langName = lang == 'ur' ? 'Urdu script (اردو)' : 'Bengali script (বাংলা)';
    final Map<String, dynamic> result = {};
    const batchSize = 25;

    try {
      for (int i = 0; i < _duas.length; i += batchSize) {
        final batch = _duas.sublist(i, (i + batchSize).clamp(0, _duas.length));
        final items = batch.map((d) => '${d['id']}|${d['transliteration'] ?? ''}').join('\n');
        final prompt = 'Convert these Islamic dua Latin transliterations to $langName phonetic script. '
            'Reply ONLY with JSON array, no markdown.\n'
            'Format: [{"id":1,"trans":"..."}]\n\n'
            'Items (id|latin_transliteration):\n$items';

        final res = await http.post(
          Uri.parse('$geminiUrl?key=$geminiKey'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'contents': [{'parts': [{'text': prompt}]}],
            'generationConfig': {'temperature': 0.1},
          }),
        ).timeout(const Duration(seconds: 30));

        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
          final jsonStr = text.replaceAll('```json', '').replaceAll('```', '').trim();
          final translated = json.decode(jsonStr) as List;
          for (final item in translated) {
            result[item['id'].toString()] = item['trans'];
          }
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (e) {
      print('Transliteration error: $e');
    }
    return result;
  }

  void _filterDuas() {
    final query = _searchCtrl.text.toLowerCase();
    final lang = _lang.lang;
    setState(() {
      _filtered = _duas.where((dua) {
        final matchSearch = query.isEmpty ||
            (_getDuaTitle(dua, lang)).toLowerCase().contains(query) ||
            (dua['dua'] ?? '').contains(query);
        return matchSearch;
      }).toList();
    });
  }

  void _copyDua(Map<String, dynamic> dua) {
    Clipboard.setData(ClipboardData(text: '${dua['dua']}\n\n${dua['transliteration']}'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_lang.copied),
      backgroundColor: const Color(0xFF1B5E20),
      duration: const Duration(seconds: 1)));
  }

  void _showDetail(Map<String, dynamic> dua) {
    DuaProgressService.markRead(dua['id']).then((_) {
      if (mounted) setState(() => _readDuaIds.add(dua['id'].toString()));
    });
    final lang = _lang.lang;
    final cat = _categories.firstWhere(
        (c) => c['id'] == dua['category'],
        orElse: () => {'en': '', 'th': '', 'id': '', 'id2': '', 'ms': '', 'ar': '', 'ur': '', 'bn': ''});
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75, maxChildSize: 0.95, minChildSize: 0.5,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _theme.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Text(_getCatLabel(cat, lang),
                      style: TextStyle(fontSize: 12, color: _theme.iconColor, fontWeight: FontWeight.w600)),
                ])),
              const Spacer(),
              IconButton(icon: Icon(Icons.copy, color: _theme.subTextColor, size: 20), onPressed: () => _copyDua(dua)),
            ]),
            const SizedBox(height: 12),
            Text(_getDuaTitle(dua, lang), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _theme.textColor)),
            const SizedBox(height: 6),
            Text(_getDuaDesc(dua, lang), style: TextStyle(fontSize: 13, color: _theme.subTextColor, height: 1.5)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _theme.iconColor.withOpacity(0.2))),
              child: Text(dua['dua'] ?? '',
                  textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 26, height: 2.0, color: _theme.textColor, fontWeight: FontWeight.w500))),
            const SizedBox(height: 16),
            if (_getDuaTrans(dua, lang).isNotEmpty)
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _theme.cardColor, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_lang.transliteration, style: TextStyle(fontSize: 12, color: _theme.iconColor, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(_getDuaTrans(dua, lang),
                    style: TextStyle(fontSize: 14, color: _theme.textColor, height: 1.6, fontStyle: FontStyle.italic)),
              ])),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),

        Expanded(child: SafeArea(
          top: false,
          child: _isLoading
              ? Center(child: CircularProgressIndicator(color: _theme.iconColor))
              : _errorMessage.isNotEmpty ? _buildError()
              : _buildBody(),
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
      child: SafeArea(bottom: false, child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(children: [
          Row(children: [
            GestureDetector(onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22))]),
          const SizedBox(height: 8),
          const Icon(Icons.volunteer_activism, color: Color(0xFFFFD700), size: 40),
          const SizedBox(height: 8),
          Text(_lang.duaLessons,
              style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_lang.duaFound(_filtered.length),
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
          const SizedBox(height: 12),
          Container(
            height: 40,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
            child: TextField(
              controller: _searchCtrl,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: InputDecoration(
                hintText: _lang.searchDua,
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10)))),
          const SizedBox(height: 16),
        ]),
      )),
    );
  }

  Widget _buildCategoryGrid() {
    final realCats = _categories.where((c) => c['id'] != 'all').toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: realCats.length,
      itemBuilder: (context, i) {
        final cat = realCats[i];
        final catId = cat['id'] as String;
        final total = _duas.where((d) => d['category'] == catId).length;
        final read = _duas.where((d) =>
            d['category'] == catId && _readDuaIds.contains(d['id'].toString())).length;
        return buildDuaCategoryCard(
          cat: cat, total: total, read: read, lang: _lang, theme: _theme,
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(
                builder: (_) => DuaCategoryDetailPage(categoryId: catId, duas: _duas)));
            if (mounted) await _loadReadIds();
          },
        );
      },
    );
  }

  Widget _buildBody() {
    if (_searchCtrl.text.trim().isEmpty) {
      return _buildCategoryGrid();
    }
    return _filtered.isEmpty
        ? Center(child: Text(_lang.noDuaFound, style: TextStyle(color: _theme.subTextColor)))
        : ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
            itemCount: _filtered.length,
            itemBuilder: (_, i) => _buildCard(_filtered[i]));
  }

  Widget _buildCard(Map<String, dynamic> dua) {
    final lang = _lang.lang;
    return GestureDetector(
      onTap: () => _showDetail(dua),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFE8F5E9)),
          boxShadow: _theme.isDark ? null : [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_getDuaTitle(dua, lang),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _theme.textColor)),
                const SizedBox(height: 2),
                Text(_getDuaDesc(dua, lang),
                    style: TextStyle(fontSize: 11, color: _theme.subTextColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              GestureDetector(
                onTap: () => _copyDua(dua),
                child: Padding(padding: const EdgeInsets.all(4),
                    child: Icon(Icons.copy_outlined, color: _theme.subTextColor, size: 15))),
            ])),
          Container(height: 0.5, margin: const EdgeInsets.symmetric(horizontal: 14),
              color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(dua['dua'] ?? '',
                  textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 19, height: 1.9, color: _theme.textColor)),
              if (_getDuaTrans(dua, lang).isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(_getDuaTrans(dua, lang),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: _theme.subTextColor, fontStyle: FontStyle.italic)),
              ],
            ])),
        ]),
      ));
  }

  Widget _buildError() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
      const SizedBox(height: 16),
      Text(_errorMessage, style: TextStyle(color: _theme.subTextColor)),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: _fetchDuas,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
        child: Text(_lang.tryAgain, style: const TextStyle(color: Colors.white))),
    ]));
  }
}

// ── DuaTab (used in DuaLessonsPage) ───────────────
class DuaTab extends StatefulWidget {
  const DuaTab({super.key});
  @override
  State<DuaTab> createState() => _DuaTabState();
}

class _DuaTabState extends State<DuaTab> {
  final _theme = ThemeService();
  final _lang = LanguageService();
  List<Map<String, dynamic>> _duas = [];
  List<Map<String, dynamic>> _filtered = [];
  bool _isLoading = true;
  String _errorMessage = '';
  Set<String> _readDuaIds = {};
  final _searchCtrl = TextEditingController();

  void _rebuild() { if (mounted) setState(() {}); }
  void _onLangChange() {
    if (!mounted) return;
    setState(() {});
    _filterDuas();
    final lang = _lang.lang;
    if (lang != 'en' && lang != 'th' && _duas.isNotEmpty) {
      _applyTranslations(lang);
    }
  }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_onLangChange);
    _searchCtrl.addListener(_filterDuas);
    _fetchDuas();
    _loadReadIds();
  }

  Future<void> _loadReadIds() async {
    final ids = await DuaProgressService.getReadIds();
    if (mounted) setState(() => _readDuaIds = ids);
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_onLangChange);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchDuas() async {
    setState(() { _isLoading = true; _errorMessage = ''; });

    // ── โหลดจากแคช (ถ้ามี) ขึ้นมาแสดงก่อนทันที ไม่ต้องรอเน็ต ──
    // ทำให้เปิดหน้านี้แบบ offline ได้ถ้าเคยโหลดสำเร็จมาก่อนอย่างน้อย 1 ครั้ง
    final cached = await DuaCacheService.load();
    if (cached != null && cached.isNotEmpty && mounted) {
      final duas = _withThaiTranslations(cached);
      setState(() { _duas = duas; _filtered = duas; _isLoading = false; });
      final lang = _lang.lang;
      if (lang != 'en' && lang != 'th') await _applyTranslations(lang);
    }

    // ── ลองโหลดของจริงจากเน็ตอยู่เสมอ เพื่ออัปเดตแคชให้ใหม่ล่าสุด ──
    // ถ้าไม่มีเน็ตและเคยมีแคชอยู่แล้ว จะไม่ขึ้น error ซ้อน (ใช้ของแคชต่อไปเงียบๆ)
    try {
      final res = await http.get(
        Uri.parse('https://dua-data-api.vercel.app/api/usefulDuas'),
      ).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        final rawDuas = data.map((e) => Map<String, dynamic>.from(e)).toList();
        await DuaCacheService.save(rawDuas);
        final duas = _withThaiTranslations(rawDuas);
        if (mounted) setState(() { _duas = duas; _filtered = duas; _isLoading = false; });
        final lang = _lang.lang;
        if (lang != 'en' && lang != 'th') await _applyTranslations(lang);
      } else if (cached == null && mounted) {
        setState(() { _errorMessage = 'Failed'; _isLoading = false; });
      }
    } catch (e) {
      // หมดเน็ต — ถ้ามีแคชอยู่แล้วก็ปล่อยให้ใช้ของแคชต่อไปโดยไม่โชว์ error
      if (cached == null && mounted) {
        setState(() { _errorMessage = 'No internet'; _isLoading = false; });
      }
    }
  }

  /// ── ผสมคำแปลไทย (kDuaTranslations) เข้ากับรายการดุอาอ์ดิบ ──
  /// ใช้ร่วมกันทั้งตอนโหลดจากแคชและตอนโหลดจากเน็ตจริง กันโค้ดซ้ำ
  List<Map<String, dynamic>> _withThaiTranslations(List<Map<String, dynamic>> raw) {
    return raw.map((e) {
      final dua = Map<String, dynamic>.from(e);
      final id = dua['id'] as int;
      if (kDuaTranslations.containsKey(id)) {
        dua['titleTh'] = kDuaTranslations[id]!['titleTh'];
        dua['descTh'] = kDuaTranslations[id]!['descTh'];
      }
      return dua;
    }).toList();
  }

  Future<void> _applyTranslations(String lang) async {
    if (!mounted) return;
    // Use hardcoded translations - instant, no API needed
    final langMap = kDuaAllTranslations[lang];
    if (langMap != null) {
      for (var dua in _duas) {
        final id = dua['id'] as int;
        if (langMap.containsKey(id)) {
          dua['titleLang'] = langMap[id]!['title'];
          dua['descLang'] = langMap[id]!['desc'];
        }
      }
    }
    if (mounted) setState(() { _filtered = List.from(_duas); });
    _filterDuas();

    // For UR/BN - also translate transliteration via Gemini + cache
    if (lang == 'ur' || lang == 'bn') {
      await _applyTransLiteration(lang);
    }
  }

  Future<void> _applyTransLiteration(String lang) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = 'dua_translit_$lang';
    final cached = prefs.getString(cacheKey);
    Map<String, dynamic> transMap = {};

    if (cached != null) {
      transMap = json.decode(cached);
    } else {
      // Translate via Gemini in batches
      transMap = await _translateTransliteration(lang);
      if (transMap.isNotEmpty) {
        await prefs.setString(cacheKey, json.encode(transMap));
      }
    }

    if (!mounted) return;
    for (var dua in _duas) {
      final id = dua['id'].toString();
      if (transMap.containsKey(id)) {
        dua['transLang'] = transMap[id];
      }
    }
    if (mounted) setState(() { _filtered = List.from(_duas); });
    _filterDuas();
  }

  Future<Map<String, dynamic>> _translateTransliteration(String lang) async {
    // ดึงจาก api_config.dart ไฟล์เดียว (แก้ key ที่นั่นที่เดียวพอ)
    const geminiKey = ApiConfig.defaultGeminiApiKey;
    const geminiUrl = ApiConfig.geminiApiUrl;
    final langName = lang == 'ur' ? 'Urdu script (اردو)' : 'Bengali script (বাংলা)';
    final Map<String, dynamic> result = {};
    const batchSize = 25;

    try {
      for (int i = 0; i < _duas.length; i += batchSize) {
        final batch = _duas.sublist(i, (i + batchSize).clamp(0, _duas.length));
        final items = batch.map((d) => '${d['id']}|${d['transliteration'] ?? ''}').join('\n');
        final prompt = 'Convert these Islamic dua Latin transliterations to $langName phonetic script. '
            'Reply ONLY with JSON array, no markdown.\n'
            'Format: [{"id":1,"trans":"..."}]\n\n'
            'Items (id|latin_transliteration):\n$items';

        final res = await http.post(
          Uri.parse('$geminiUrl?key=$geminiKey'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'contents': [{'parts': [{'text': prompt}]}],
            'generationConfig': {'temperature': 0.1},
          }),
        ).timeout(const Duration(seconds: 30));

        if (res.statusCode == 200) {
          final data = json.decode(res.body);
          final text = data['candidates'][0]['content']['parts'][0]['text'] as String;
          final jsonStr = text.replaceAll('```json', '').replaceAll('```', '').trim();
          final translated = json.decode(jsonStr) as List;
          for (final item in translated) {
            result[item['id'].toString()] = item['trans'];
          }
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }
    } catch (e) {
      print('Transliteration error: $e');
    }
    return result;
  }

  void _filterDuas() {
    final query = _searchCtrl.text.toLowerCase();
    final lang = _lang.lang;
    setState(() {
      _filtered = _duas.where((dua) {
        final matchSearch = query.isEmpty ||
            (_getDuaTitle(dua, lang)).toLowerCase().contains(query) ||
            (dua['dua'] ?? '').contains(query);
        return matchSearch;
      }).toList();
    });
  }

  void _copyDua(Map<String, dynamic> dua) {
    Clipboard.setData(ClipboardData(text: '${dua['dua']}\n\n${dua['transliteration']}'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_lang.copied),
      backgroundColor: const Color(0xFF1B5E20),
      duration: const Duration(seconds: 1)));
  }

  void _showDetail(Map<String, dynamic> dua) {
    DuaProgressService.markRead(dua['id']).then((_) {
      if (mounted) setState(() => _readDuaIds.add(dua['id'].toString()));
    });
    final lang = _lang.lang;
    final cat = _categories.firstWhere(
        (c) => c['id'] == dua['category'],
        orElse: () => {'en': '', 'th': '', 'id2': '', 'ms': '', 'ar': '', 'ur': '', 'bn': ''});
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75, maxChildSize: 0.95, minChildSize: 0.5,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          child: ListView(controller: ctrl, padding: const EdgeInsets.all(24), children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: _theme.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Text(_getCatLabel(cat, lang),
                      style: TextStyle(fontSize: 12, color: _theme.iconColor, fontWeight: FontWeight.w600)),
                ])),
              const Spacer(),
              IconButton(icon: Icon(Icons.copy, color: _theme.subTextColor, size: 20), onPressed: () => _copyDua(dua)),
            ]),
            const SizedBox(height: 12),
            Text(_getDuaTitle(dua, lang), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _theme.textColor)),
            const SizedBox(height: 6),
            Text(_getDuaDesc(dua, lang), style: TextStyle(fontSize: 13, color: _theme.subTextColor, height: 1.5)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _theme.iconColor.withOpacity(0.2))),
              child: Text(dua['dua'] ?? '',
                  textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 26, height: 2.0, color: _theme.textColor, fontWeight: FontWeight.w500))),
            const SizedBox(height: 16),
            if (_getDuaTrans(dua, lang).isNotEmpty)
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _theme.cardColor, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_lang.transliteration, style: TextStyle(fontSize: 12, color: _theme.iconColor, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                Text(_getDuaTrans(dua, lang),
                    style: TextStyle(fontSize: 14, color: _theme.textColor, height: 1.6, fontStyle: FontStyle.italic)),
              ])),
            const SizedBox(height: 32),
          ]),
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final realCats = _categories.where((c) => c['id'] != 'all').toList();
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: realCats.length,
      itemBuilder: (context, i) {
        final cat = realCats[i];
        final catId = cat['id'] as String;
        final total = _duas.where((d) => d['category'] == catId).length;
        final read = _duas.where((d) =>
            d['category'] == catId && _readDuaIds.contains(d['id'].toString())).length;
        return buildDuaCategoryCard(
          cat: cat, total: total, read: read, lang: _lang, theme: _theme,
          onTap: () async {
            await Navigator.push(context, MaterialPageRoute(
                builder: (_) => DuaCategoryDetailPage(categoryId: catId, duas: _duas)));
            if (mounted) await _loadReadIds();
          },
        );
      },
    );
  }

  Widget _buildCard(Map<String, dynamic> dua) {
    final lang = _lang.lang;
    return GestureDetector(
      onTap: () => _showDetail(dua),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFE8F5E9)),
          boxShadow: _theme.isDark ? null : [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 6, offset: const Offset(0, 2))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 10, 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_getDuaTitle(dua, lang),
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _theme.textColor)),
                const SizedBox(height: 2),
                Text(_getDuaDesc(dua, lang),
                    style: TextStyle(fontSize: 11, color: _theme.subTextColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              GestureDetector(
                onTap: () => _copyDua(dua),
                child: Padding(padding: const EdgeInsets.all(4),
                    child: Icon(Icons.copy_outlined, color: _theme.subTextColor, size: 15))),
            ])),
          Container(height: 0.5, margin: const EdgeInsets.symmetric(horizontal: 14),
              color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFEEEEEE)),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Text(dua['dua'] ?? '',
                  textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                  maxLines: 2, overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 19, height: 1.9, color: _theme.textColor)),
              if (_getDuaTrans(dua, lang).isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(_getDuaTrans(dua, lang),
                    maxLines: 1, overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: _theme.subTextColor, fontStyle: FontStyle.italic)),
              ],
            ])),
        ]),
      ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Builder(builder: (context) {
        if (_isLoading) {
          return Center(child: CircularProgressIndicator(color: _theme.iconColor));
        }
        if (_errorMessage.isNotEmpty) {
          return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            Text(_errorMessage, style: TextStyle(color: _theme.subTextColor)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _fetchDuas,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
              child: Text(_lang.tryAgain, style: const TextStyle(color: Colors.white))),
          ]));
        }
        return _buildCategoryGrid();
      }),
    );
  }
}