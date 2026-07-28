import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../services/theme_service.dart';
import '../services/language_service.dart';

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
  String _selectedCategory = 'all';
  final _searchController = TextEditingController();

  // ── Title แปลไทย (hardcoded) ──────────────────────
  static const Map<int, Map<String, String>> _translations = {
    1:  {'titleTh': 'ดุอาตอนตื่นนอน', 'descTh': 'อ่านทุกเช้าหลังตื่นนอน'},
    2:  {'titleTh': 'ดุอาก่อนเข้าห้องน้ำ', 'descTh': 'อ่านก่อนเข้าห้องน้ำ'},
    3:  {'titleTh': 'ดุอาหลังออกจากห้องน้ำ', 'descTh': 'อ่านหลังออกจากห้องน้ำ'},
    4:  {'titleTh': 'ดุอาตอนเปลี่ยนเสื้อผ้า', 'descTh': 'อ่านเมื่อสวมเสื้อผ้า'},
    5:  {'titleTh': 'ดุอาตอนส่องกระจก', 'descTh': 'อ่านเมื่อมองกระจก'},
    6:  {'titleTh': 'ดุอาก่อนรับประทานอาหาร', 'descTh': 'อ่านก่อนเริ่มรับประทานอาหาร'},
    7:  {'titleTh': 'ดุอาเมื่อลืมบิสมิลลาห์ตอนเริ่มกิน', 'descTh': 'อ่านเมื่อนึกขึ้นได้ระหว่างกิน'},
    8:  {'titleTh': 'ดุอาหลังรับประทานอาหาร', 'descTh': 'อ่านหลังกินอาหารเสร็จ'},
    9:  {'titleTh': 'ดุอาตอนออกจากบ้าน', 'descTh': 'อ่านเมื่อออกจากบ้าน'},
    10: {'titleTh': 'ดุอาตอนขึ้นยานพาหนะ', 'descTh': 'อ่านเมื่อขึ้นรถหรือยานพาหนะ'},
    11: {'titleTh': 'ดุอาการทักทาย (สลาม)', 'descTh': 'กล่าวเมื่อทักทายมุสลิม'},
    12: {'titleTh': 'ดุอาตอบรับสลาม', 'descTh': 'กล่าวเมื่อตอบรับสลาม'},
    13: {'titleTh': 'ดุอาตอนจาม', 'descTh': 'กล่าวหลังจาม'},
    14: {'titleTh': 'ดุอาเมื่อได้ยินคนอื่นจาม', 'descTh': 'กล่าวเมื่อได้ยินคนจามและเขากล่าวอัลฮัมดุลิลลาห์'},
    15: {'titleTh': 'ดุอาตอบรับ "ยัรฮามุกัลลอฮ์"', 'descTh': 'กล่าวตอบเมื่อมีคนอวยพรหลังจาม'},
    16: {'titleTh': 'ดุอาเมื่อเห็นผู้อื่นตกทุกข์', 'descTh': 'อ่านเงียบๆ เมื่อเห็นคนเดือดร้อน'},
    17: {'titleTh': 'ดุอาตอนเข้าตลาดหรือร้านค้า', 'descTh': 'อ่านเมื่อเข้าตลาดหรือร้านค้า'},
    18: {'titleTh': 'ดุอาตอนเข้าบ้าน', 'descTh': 'อ่านเมื่อเข้าบ้าน'},
    19: {'titleTh': 'ดุอาก่อนนอน', 'descTh': 'อ่านก่อนเข้านอน'},
    20: {'titleTh': 'ดุอาหลังวุฎูอ์', 'descTh': 'อ่านหลังทำวุฎูอ์เสร็จ'},
    21: {'titleTh': 'ดุอาตอนเข้ามัสยิด', 'descTh': 'อ่านเมื่อเข้ามัสยิด'},
    22: {'titleTh': 'ดุอาระหว่างอาซาน', 'descTh': 'กล่าวแทนการทวนวลี "หัยยะ อะลัส เศาะลาห์"'},
    23: {'titleTh': 'ดุอาหลังอาซานเสร็จ', 'descTh': 'อ่านหลังได้ยินอาซานจบ'},
    24: {'titleTh': 'ดุอาเริ่มละหมาด (ษะนาอ์)', 'descTh': 'อ่านต้นละหมาดหลังตักบีร'},
    25: {'titleTh': 'ดุอาตอนรุกูอ์', 'descTh': 'อ่านขณะก้มรุกูอ์ในละหมาด'},
    26: {'titleTh': 'ดุอาตอนสุญูด', 'descTh': 'อ่านขณะสุญูดในละหมาด'},
    27: {'titleTh': 'อัตตะฮิยยาต', 'descTh': 'อ่านในท่านั่งระหว่างละหมาด'},
    28: {'titleTh': 'ศอลาวาตอิบรอฮีมียะห์', 'descTh': 'อ่านหลังอัตตะฮิยยาต'},
    29: {'titleTh': 'ดุอาก่อนสลามละหมาด', 'descTh': 'อ่านตอนท้ายละหมาดก่อนสลาม'},
    30: {'titleTh': 'ดุอากุนูต (ละหมาดวิตร์)', 'descTh': 'อ่านในละหมาดวิตร์'},
    31: {'titleTh': 'ดุอาขอการอภัยหลังละหมาด', 'descTh': 'อ่านทันทีหลังละหมาดเสร็จ'},
    32: {'titleTh': 'ดุอาขอความช่วยเหลือในการอิบาดะห์', 'descTh': 'อ่านหลังละหมาดเสร็จ'},
    33: {'titleTh': 'ซิกร์หลังละหมาด', 'descTh': 'ซุบฮานัลลอฮ์ 33x อัลฮัมดุลิลลาห์ 33x อัลลอฮุอักบัร 33x'},
    34: {'titleTh': 'ดุอาตอนออกจากมัสยิด', 'descTh': 'อ่านเมื่อออกจากมัสยิด'},
    35: {'titleTh': 'ดุอาต้อนรับรอมฎอน', 'descTh': 'อ่านเมื่อเริ่มเดือนรอมฎอน'},
    36: {'titleTh': 'ดุอาละศีลอด (อิฟตาร์)', 'descTh': 'อ่านเมื่อละศีลอดตอนพระอาทิตย์ตก'},
    37: {'titleTh': 'ดุอาคืนลัยลาตุลก็อดร์', 'descTh': 'อ่านบ่อยๆ ใน 10 คืนสุดท้ายของรอมฎอน'},
    38: {'titleTh': 'ดุอาอิสติคอเราะห์', 'descTh': 'อ่านหลังละหมาด 2 ร็อกอะห์เมื่อตัดสินใจเรื่องสำคัญ'},
    39: {'titleTh': 'ดุอาขอความสะดวก', 'descTh': 'อ่านเมื่อเผชิญความยากลำบาก'},
    40: {'titleTh': 'ดุอาขอการรักษาจากความเจ็บป่วย', 'descTh': 'วางมือที่บริเวณที่เจ็บแล้วอ่าน'},
    41: {'titleTh': 'ดุอาขอปกป้องจากความชั่ว', 'descTh': 'อ่านเพื่อขอปกป้องจากชัยฏอน'},
    42: {'titleTh': 'ดุอาขอปกป้องจากความยากจน', 'descTh': 'อ่านเมื่อประสบปัญหาการเงิน'},
    43: {'titleTh': 'ดุอาขอปกป้องจากความวิตกกังวล', 'descTh': 'อ่านเมื่อรู้สึกวิตกกังวลหรือเศร้า'},
    44: {'titleTh': 'ดุอาเมื่อมีความสงสัย โกรธ หรือฝันร้าย', 'descTh': 'อ่านเมื่อมีความสงสัยในศรัทธาหรือโกรธ'},
    45: {'titleTh': 'ดุอาก่อนเดินทาง', 'descTh': 'อ่านเมื่อออกเดินทาง'},
    46: {'titleTh': 'ดุอาตอนกลับจากเดินทาง', 'descTh': 'อ่านเมื่อกลับถึงบ้านจากการเดินทาง'},
    47: {'titleTh': 'ดุอาเพื่อพ่อแม่', 'descTh': 'อ่านขอให้อัลลอฮ์เมตตาพ่อแม่'},
    48: {'titleTh': 'ดุอาอวยพรคู่บ่าวสาว', 'descTh': 'อ่านเป็นพรให้คู่บ่าวสาวใหม่'},
    49: {'titleTh': 'ดุอาก่อนมีเพศสัมพันธ์', 'descTh': 'อ่านเพื่อขอปกป้องลูกหลานจากชัยฏอน'},
    50: {'titleTh': 'ดุอาปกป้องเด็ก', 'descTh': 'อ่านเพื่อปกป้องเด็กจากสิ่งชั่วร้าย'},
    51: {'titleTh': 'ดุอาขอบคุณผู้อื่น', 'descTh': 'กล่าวเมื่อมีคนทำดีกับเรา'},
    52: {'titleTh': 'ดุอาอวยพรเจ้าภาพหลังกินอาหาร', 'descTh': 'อ่านเป็นพรให้เจ้าภาพที่เชิญมากิน'},
    53: {'titleTh': 'ดุอาเยี่ยมผู้ป่วย', 'descTh': 'อ่าน 7 ครั้งเมื่อเยี่ยมผู้ป่วย'},
    54: {'titleTh': 'ดุอาละหมาดญะนาซะห์ (ผู้ใหญ่)', 'descTh': 'อ่านหลังตักบีร์ที่ 3 ในละหมาดญะนาซะห์'},
    55: {'titleTh': 'ดุอาละหมาดญะนาซะห์ (เด็ก)', 'descTh': 'อ่านในละหมาดญะนาซะห์สำหรับเด็ก'},
    56: {'titleTh': 'ดุอาตอนเข้าสุสาน', 'descTh': 'อ่านเมื่อเข้าสุสาน'},
    57: {'titleTh': 'ซัยยิดุลอิสติฆฟาร์', 'descTh': 'ดุอาขอการอภัยที่ยิ่งใหญ่ที่สุด'},
    58: {'titleTh': 'ดุอาขอแต่งงานกับคนที่รัก', 'descTh': 'ดุอาเมื่อสิ่งต่างๆ ยากลำบาก'},
    59: {'titleTh': 'ดุอาก่อนสอบหรืออ่านหนังสือ', 'descTh': 'อ่านเพื่อเพิ่มสมาธิและความจำ'},
    60: {'titleTh': 'ดุอาขอแต่งงาน', 'descTh': 'ดุอาเพื่อการแต่งงาน'},
    61: {'titleTh': 'ดุอาตอนฝนตก', 'descTh': 'อ่านขณะฝนตก'},
    62: {'titleTh': 'ดุอาขอปกป้องจากความวิตกและกลัว', 'descTh': 'อ่านเมื่อรู้สึกวิตก กลัว หรือเครียด'},
    63: {'titleTh': 'ดุอาขอความสะดวกก่อนสอบ', 'descTh': 'อ่านก่อนสอบหรืองานที่ยาก'},
    64: {'titleTh': 'ดุอาขอการรักษาจากความเจ็บป่วย', 'descTh': 'อ่านเพื่อขอให้อัลลอฮ์รักษา'},
    65: {'titleTh': 'ดุอาขอปกป้องจากภัยพิบัติ', 'descTh': 'อ่านเพื่อขอปกป้องจากความทุกข์ยาก'},
    66: {'titleTh': 'ดุอาขอความมั่งคั่งและบะเราะกะห์', 'descTh': 'อ่านในยามประสบปัญหาการเงิน'},
    67: {'titleTh': 'ดุอาเพื่อการศึกษา (จากอัลกุรอาน)', 'descTh': 'ดุอาจากอัลกุรอานเพื่อขยายหน้าอกและเพิ่มความรู้'},
    68: {'titleTh': 'ดุอาเมื่อหัวใจไม่สงบ', 'descTh': 'อ่าน 3 ครั้งและเป่าที่หน้าอกเมื่อรู้สึกไม่สบายใจ'},
    69: {'titleTh': 'ดุอาขอปกป้องจากดวงตาชั่ว', 'descTh': 'อ่านเพื่อปกป้องจากการใส่ร้าย'},
    70: {'titleTh': 'ขอให้หัวใจเต็มด้วยความรัก', 'descTh': 'โอ้อัลลอฮ์ โปรดเติมหัวใจของข้าด้วยความรักของพระองค์'},
    71: {'titleTh': 'ดุอาขอคู่ครองที่ดี (สำหรับผู้ชาย)', 'descTh': 'โอ้อัลลอฮ์ โปรดให้ข้าเป็นจากผู้บริสุทธิ์'},
    72: {'titleTh': 'ดุอาผู้ถูกกดขี่', 'descTh': 'โอ้อัลลอฮ์ ข้าร้องทุกข์ต่อพระองค์ถึงความอ่อนแอของข้า'},
    73: {'titleTh': 'ดุอาขอมองเห็นความสามารถตนเอง', 'descTh': 'โอ้อัลลอฮ์ โปรดให้ข้ามองเห็นพรสวรรค์ที่พระองค์ประทานให้'},
    74: {'titleTh': 'ดุอาขอพรที่สมบูรณ์', 'descTh': 'โอ้พระเจ้า เมื่อพระองค์ให้ความมั่งคั่งแก่ข้า อย่าเอาความสุขไป'},
    75: {'titleTh': 'ดุอาขอที่พักพิงจากความกังวล', 'descTh': 'โอ้อัลลอฮ์ ข้าขอพึ่งพิงพระองค์จากความกังวลที่ทำให้เศร้า'},
    76: {'titleTh': 'ดุอาขอให้หัวใจปลอดจากความเกลียดชัง', 'descTh': 'โอ้อัลลอฮ์ อย่าให้ความเกลียดชังอยู่ในหัวใจของข้า'},
    77: {'titleTh': 'ดุอาขอปกป้องจากนิอ์มะห์ที่ลดลง', 'descTh': 'โอ้อัลลอฮ์ ข้าขอพึ่งพิงพระองค์จากการหมดไปของนิอ์มะห์'},
    78: {'titleTh': 'ดุอาขอเรียนรู้ความรักและการให้อภัย', 'descTh': 'โอ้พระเจ้า สอนข้าให้รักผู้อื่นเหมือนรักตนเอง'},
    79: {'titleTh': 'ดุอาขอปกป้องจากความชั่วของตนเอง', 'descTh': 'โอ้อัลลอฮ์ ข้าขอพึ่งพิงพระองค์จากความชั่วของการได้ยิน'},
    80: {'titleTh': 'ดุอาขอให้หัวใจไม่ผูกพันกับสิ่งที่ไม่ใช่ของตน', 'descTh': 'โอ้อัลลอฮ์ อย่าให้หัวใจที่อ่อนแอของข้าผูกพันกับสิ่งที่ไม่ใช่ของข้า'},
    81: {'titleTh': 'ดุอาขอล้างความคิดลบ', 'descTh': 'โอ้อัลลอฮ์ โปรดล้างความคิดลบออกจากข้า'},
    82: {'titleTh': 'ดุอาขอบรรเทาความวิตกและความเศร้า', 'descTh': 'โอ้อัลลอฮ์ ผู้บรรเทาความกังวล โปรดขจัดความกังวลของข้า'},
    83: {'titleTh': 'ดุอาขอให้หัวใจสงบ', 'descTh': 'โอ้อัลลอฮ์ โปรดประทานความสงบจากพระองค์ให้แก่ข้า'},
    84: {'titleTh': 'ดุอาขอให้สิ่งดีเกิดขึ้น', 'descTh': 'โอ้อัลลอฮ์ หากสิ่งนี้ดีสำหรับข้า โปรดกำหนดและทำให้ง่าย'},
    85: {'titleTh': 'ดุอาขอคู่ครองที่ดี (สำหรับผู้หญิง)', 'descTh': 'โอ้อัลลอฮ์ โปรดให้ข้าเป็นจากผู้หญิงบริสุทธิ์'},
    86: {'titleTh': 'ดุอาขอให้หัวใจหายโกรธ', 'descTh': 'โอ้อัลลอฮ์ โปรดขจัดความโกรธออกจากหัวใจของข้า'},
    87: {'titleTh': 'ดุอาขอการอภัยในความผิด', 'descTh': 'โอ้อัลลอฮ์ ข้าได้อธรรมต่อตัวเองอย่างมาก'},
    88: {'titleTh': 'ดุอาขอแสงสว่าง', 'descTh': 'โอ้อัลลอฮ์ โปรดประทานแสงในหัวใจ ลิ้น การได้ยิน และการมองเห็น'},
    89: {'titleTh': 'ดุอาขอความอดทนในการถูกทดสอบ', 'descTh': 'โอ้ผู้ทรงอดทน โปรดให้ข้าอดทนต่อสิ่งที่พระองค์ทดสอบ'},
    90: {'titleTh': 'ดุอาขอให้หน้าอกกว้างและกิจการง่าย', 'descTh': 'โอ้พระเจ้า โปรดขยายหน้าอกของข้าและทำให้กิจการง่าย'},
    91: {'titleTh': 'ดุอาขอปกป้องสายตาและหัวใจ', 'descTh': 'โอ้อัลลอฮ์ โปรดลดสายตาและปกป้องข้า'},
    92: {'titleTh': 'ดุอาขอดับความปรารถนาในใจ', 'descTh': 'โอ้อัลลอฮ์ โปรดดับไฟแห่งความปรารถนาในหัวใจของข้า'},
    93: {'titleTh': 'ดุอาขอผู้ซ่อมแซม', 'descTh': 'โอ้ผู้ซ่อมแซม โปรดซ่อมแซมข้า'},
    94: {'titleTh': 'ดุอาขอปกป้องจากสิ่งล่อใจ', 'descTh': 'โอ้อัลลอฮ์ โปรดป้องกันข้าจากความปรารถนาที่เป็นอันตราย'},
    95: {'titleTh': 'ดุอาขอความขอบคุณ', 'descTh': 'โอ้อัลลอฮ์ การขอบคุณพระองค์คือนิอ์มะห์'},
    96: {'titleTh': 'ดุอาขอพึ่งพิงจากความวิตกและความขี้เกียจ', 'descTh': 'โอ้อัลลอฮ์ ข้าขอพึ่งพิงพระองค์จากความกังวลและความเศร้า'},
    97: {'titleTh': 'ดุอาขออย่าให้ถูกทอดทิ้ง', 'descTh': 'โอ้อัลลอฮ์ ความเมตตาของพระองค์คือสิ่งที่ข้าหวัง'},
    98: {'titleTh': 'ดุอาขอออกจากความมืดสู่แสงสว่าง', 'descTh': 'โอ้อัลลอฮ์ โปรดนำข้าออกจากความมืดสู่แสงสว่าง'},
    99: {'titleTh': 'ดุอาขอให้หน้าอกสะอาด', 'descTh': 'โอ้พระเจ้า โปรดชำระหน้าอกของข้าด้วยความเมตตา'},
    100: {'titleTh': 'ดุอาขอความแข็งแกร่งและกล้าหาญ', 'descTh': 'โอ้อัลลอฮ์ โปรดประทานความแข็งแกร่งให้ข้าต่อสู้กับตัวเอง'},
    101: {'titleTh': 'ดุอาขอชำระหัวใจจากความชั่ว', 'descTh': 'โอ้อัลลอฮ์ โปรดชำระหัวใจของข้าจากทุกความชั่ว'},
    102: {'titleTh': 'ดุอาขอความสำเร็จในการงาน', 'descTh': 'ขอความรู้ที่มีประโยชน์ ริซกี้ที่ดี และการงานที่ถูกรับ'},
  };

  final List<Map<String, String>> _categories = [
    {'id': 'all',        'label': 'ทั้งหมด',          'labelEn': 'All',        'icon': '🤲'},
    {'id': 'daily',      'label': 'ประจำวัน',          'labelEn': 'Daily',      'icon': '☀️'},
    {'id': 'prayer',     'label': 'ละหมาด',            'labelEn': 'Prayer',     'icon': '🕌'},
    {'id': 'hardship',   'label': 'ความยากลำบาก',      'labelEn': 'Hardship',   'icon': '💙'},
    {'id': 'protection', 'label': 'ปกป้อง',            'labelEn': 'Protection', 'icon': '🛡️'},
    {'id': 'travel',     'label': 'เดินทาง',            'labelEn': 'Travel',     'icon': '✈️'},
    {'id': 'family',     'label': 'ครอบครัว',          'labelEn': 'Family',     'icon': '👨‍👩‍👧'},
    {'id': 'ramadan',    'label': 'รอมฎอน',            'labelEn': 'Ramadan',    'icon': '🌙'},
    {'id': 'social',     'label': 'สังคม',             'labelEn': 'Social',     'icon': '🤝'},
    {'id': 'death',      'label': 'ผู้เสียชีวิต',      'labelEn': 'Death',      'icon': '🕊️'},
  ];

  @override
  void initState() {
    super.initState();
    _theme.addListener(() => setState(() {}));
    _lang.addListener(() { setState(() {}); _filterDuas(); });
    _searchController.addListener(_filterDuas);
    _fetchDuas();
  }

  @override
  void dispose() {
    _theme.removeListener(() => setState(() {}));
    _lang.removeListener(() => setState(() {}));
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchDuas() async {
    setState(() { _isLoading = true; _errorMessage = ''; });
    try {
      final response = await http
          .get(Uri.parse('https://dua-data-api.vercel.app/api/usefulDuas'))
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        final duas = data.map((e) {
          final dua = Map<String, dynamic>.from(e);
          final id = dua['id'] as int;
          if (_translations.containsKey(id)) {
            dua['titleTh'] = _translations[id]!['titleTh'];
            dua['descTh'] = _translations[id]!['descTh'];
          }
          return dua;
        }).toList();
        setState(() { _duas = duas; _filtered = duas; _isLoading = false; });
      } else {
        setState(() { _errorMessage = 'Failed to load duas'; _isLoading = false; });
      }
    } catch (e) {
      setState(() { _errorMessage = 'No internet connection'; _isLoading = false; });
    }
  }

  void _filterDuas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filtered = _duas.where((dua) {
        final matchCat = _selectedCategory == 'all' || dua['category'] == _selectedCategory;
        final matchSearch = query.isEmpty ||
            (dua['title'] ?? '').toLowerCase().contains(query) ||
            (dua['titleTh'] ?? '').contains(query) ||
            (dua['dua'] ?? '').contains(query) ||
            (dua['transliteration'] ?? '').toLowerCase().contains(query);
        return matchCat && matchSearch;
      }).toList();
    });
  }

  void _onCategorySelected(String id) {
    setState(() => _selectedCategory = id);
    _filterDuas();
  }

  void _copyDua(Map<String, dynamic> dua) {
    final text = '${dua['dua']}\n\n${dua['transliteration']}';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_lang.isThai ? 'คัดลอกแล้ว!' : 'Copied!'),
      backgroundColor: const Color(0xFF1B5E20),
      duration: const Duration(seconds: 1),
    ));
  }

  void _showDuaDetail(Map<String, dynamic> dua) {
    final cat = _categories.firstWhere(
        (c) => c['id'] == dua['category'],
        orElse: () => {'icon': '🤲', 'label': '', 'labelEn': '', 'id': ''});
    final id = dua['id'] as int;
    final title = _lang.isThai ? (dua['titleTh'] ?? dua['title'] ?? '') : (dua['title'] ?? '');
    final desc = _lang.isThai ? (dua['descTh'] ?? dua['description'] ?? '') : (dua['description'] ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.75, maxChildSize: 0.95, minChildSize: 0.5,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24))),
          child: ListView(controller: controller, padding: const EdgeInsets.all(24), children: [
            Center(child: Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2)))),
            const SizedBox(height: 16),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _theme.iconColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Text(cat['icon']!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(_lang.isThai ? cat['label']! : cat['labelEn']!,
                      style: TextStyle(fontSize: 12, color: _theme.iconColor, fontWeight: FontWeight.w600)),
                ]),
              ),
              const Spacer(),
              IconButton(icon: Icon(Icons.copy, color: _theme.subTextColor, size: 20), onPressed: () => _copyDua(dua)),
            ]),
            const SizedBox(height: 12),
            Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: _theme.textColor)),
            const SizedBox(height: 6),
            Text(desc, style: TextStyle(fontSize: 13, color: _theme.subTextColor, height: 1.5)),
            const SizedBox(height: 20),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _theme.isDark ? const Color(0xFF0D3B1E) : const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _theme.iconColor.withOpacity(0.2))),
              child: Text(dua['dua'] ?? '',
                  textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                  style: TextStyle(fontSize: 26, height: 2.0, color: _theme.textColor, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity, padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _theme.cardColor, borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(_lang.isThai ? 'คำอ่าน' : 'Transliteration',
                    style: TextStyle(fontSize: 12, color: _theme.iconColor, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 6),
                Text(dua['transliteration'] ?? '',
                    style: TextStyle(fontSize: 14, color: _theme.textColor, height: 1.6, fontStyle: FontStyle.italic)),
              ]),
            ),
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
        Expanded(child: _isLoading
            ? Center(child: CircularProgressIndicator(color: _theme.iconColor))
            : _errorMessage.isNotEmpty ? _buildError() : _buildBody()),
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
            const Text('🤲', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 8),
            Text(_lang.isThai ? 'ดุอา & บทเรียน' : 'Dua & Lessons',
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_lang.isThai ? 'พบ ${_filtered.length} ดุอา' : '${_filtered.length} duas found',
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 12),
            Container(
              height: 40,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: _lang.isThai ? 'ค้นหาดุอา...' : 'Search duas...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Colors.white70, size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10)),
              ),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(children: [
      SizedBox(
        height: 52,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          itemCount: _categories.length,
          itemBuilder: (_, i) {
            final cat = _categories[i];
            final isSelected = _selectedCategory == cat['id'];
            return GestureDetector(
              onTap: () => _onCategorySelected(cat['id']!),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isSelected ? _theme.iconColor : _theme.cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? _theme.iconColor
                      : (_theme.isDark ? ThemeService.darkBorder : Colors.grey.shade300))),
                child: Row(children: [
                  Text(cat['icon']!, style: const TextStyle(fontSize: 14)),
                  const SizedBox(width: 4),
                  Text(_lang.isThai ? cat['label']! : cat['labelEn']!,
                      style: TextStyle(fontSize: 13,
                          color: isSelected ? Colors.white : _theme.textColor,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal)),
                ]),
              ),
            );
          },
        ),
      ),
      Expanded(
        child: _filtered.isEmpty
            ? Center(child: Text(_lang.isThai ? 'ไม่พบดุอา' : 'No duas found',
                style: TextStyle(color: _theme.subTextColor)))
            : ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => _buildDuaCard(_filtered[i])),
      ),
    ]);
  }

  Widget _buildDuaCard(Map<String, dynamic> dua) {
    final cat = _categories.firstWhere(
        (c) => c['id'] == dua['category'],
        orElse: () => {'icon': '🤲', 'label': '', 'labelEn': '', 'id': ''});
    final title = _lang.isThai ? (dua['titleTh'] ?? dua['title'] ?? '') : (dua['title'] ?? '');
    final desc = _lang.isThai ? (dua['descTh'] ?? dua['description'] ?? '') : (dua['description'] ?? '');

    return GestureDetector(
      onTap: () => _showDuaDetail(dua),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _theme.cardColor, borderRadius: BorderRadius.circular(16),
          border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
          boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 6, offset: const Offset(0, 2))]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(width: 40, height: 40,
              decoration: BoxDecoration(color: _theme.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
              child: Center(child: Text(cat['icon']!, style: const TextStyle(fontSize: 20)))),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: _theme.textColor)),
              Text(desc, style: TextStyle(fontSize: 12, color: _theme.subTextColor),
                  maxLines: 1, overflow: TextOverflow.ellipsis),
            ])),
            IconButton(
              icon: Icon(Icons.copy_outlined, color: _theme.subTextColor, size: 18),
              onPressed: () => _copyDua(dua),
              padding: EdgeInsets.zero, constraints: const BoxConstraints()),
          ]),
          const SizedBox(height: 12),
          Text(dua['dua'] ?? '',
              textAlign: TextAlign.right, textDirection: TextDirection.rtl,
              maxLines: 2, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 20, height: 1.8, color: _theme.textColor)),
          const SizedBox(height: 6),
          Text(dua['transliteration'] ?? '',
              maxLines: 1, overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 12, color: _theme.subTextColor, fontStyle: FontStyle.italic)),
        ]),
      ),
    );
  }

  Widget _buildError() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
      const SizedBox(height: 16),
      Text(_errorMessage, style: TextStyle(color: _theme.subTextColor)),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: _fetchDuas,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
        child: Text(_lang.isThai ? 'ลองอีกครั้ง' : 'Try Again',
            style: const TextStyle(color: Colors.white))),
    ]));
  }
}