import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audioplayers.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

// ── รายการซิกิร์ (dhikr) ให้เลือกนับ ── แต่ละบทมี id ไว้อ้างอิงคีย์บันทึก
// ค่าความคืบหน้าใน SharedPreferences แยกกันเป็นรายบท (สลับบทแล้วยอดนับเก่า
// ของบทนั้นๆ ไม่หาย) ──────────────────────────────────────────────
const List<Map<String, String>> kDhikrList = [
  {
    'id': 'subhanallah',
    'arabic': 'سُبْحَانَ اللَّٰهِ',
    'translit': 'Subhanallah',
    'th': 'มหาบริสุทธิ์แด่อัลลอฮ์',
    'en': 'Glory be to Allah',
  },
  {
    'id': 'alhamdulillah',
    'arabic': 'الْحَمْدُ لِلَّٰهِ',
    'translit': 'Alhamdulillah',
    'th': 'บรรดาการสรรเสริญทั้งมวลเป็นของอัลลอฮ์',
    'en': 'All praise is due to Allah',
  },
  {
    'id': 'allahuakbar',
    'arabic': 'اللَّٰهُ أَكْبَرُ',
    'translit': 'Allahu Akbar',
    'th': 'อัลลอฮ์ทรงยิ่งใหญ่ที่สุด',
    'en': 'Allah is the Greatest',
  },
  {
    'id': 'lailahaillallah',
    'arabic': 'لَا إِلَٰهَ إِلَّا اللَّٰهُ',
    'translit': 'La ilaha illallah',
    'th': 'ไม่มีพระเจ้าอื่นใดนอกจากอัลลอฮ์',
    'en': 'There is no god but Allah',
  },
  {
    'id': 'astaghfirullah',
    'arabic': 'أَسْتَغْفِرُ اللَّٰهَ',
    'translit': 'Astaghfirullah',
    'th': 'ข้าพเจ้าขออภัยโทษต่ออัลลอฮ์',
    'en': 'I seek forgiveness from Allah',
  },
  {
    'id': 'lahawla',
    'arabic': 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّٰهِ',
    'translit': 'La hawla wala quwwata illa billah',
    'th': 'ไม่มีอำนาจและพลังใดนอกจากด้วยอัลลอฮ์',
    'en': 'There is no power nor strength except with Allah',
  },
  {
    'id': 'subhanallahwabihamdihi',
    'arabic': 'سُبْحَانَ اللَّٰهِ وَبِحَمْدِهِ',
    'translit': 'Subhanallahi wa bihamdihi',
    'th': 'มหาบริสุทธิ์แด่อัลลอฮ์พร้อมด้วยการสรรเสริญพระองค์',
    'en': 'Glory be to Allah and praise Him',
  },
  {
    'id': 'subhanallahilazim',
    'arabic': 'سُبْحَانَ اللَّٰهِ الْعَظِيمِ',
    'translit': "SubhanAllahil 'Azim",
    'th': 'มหาบริสุทธิ์แด่อัลลอฮ์ผู้ทรงยิ่งใหญ่',
    'en': 'Glory be to Allah, the Magnificent',
  },
  {
    'id': 'salawat',
    'arabic': 'اللَّٰهُمَّ صَلِّ عَلَىٰ مُحَمَّدٍ',
    'translit': "Allahumma salli 'ala Muhammad",
    'th': 'โอ้อัลลอฮ์ ขอทรงประทานความโปรดปรานแด่มุฮัมมัด',
    'en': 'O Allah, send blessings upon Muhammad',
  },
];

const List<int> kTasbihTargets = [33, 99, 100, 0]; // 0 = ไม่จำกัด (นับไม่วนรอบ)

// ── เสียงตอนแตะนับ ── ไฟล์ mp3 ของผู้ใช้เอง วางไว้ที่ assets/audio/tasbih/
// ในโปรเจกต์ (ต้องประกาศโฟลเดอร์นี้ใน pubspec.yaml ใต้ flutter/assets ด้วย)
// 'none' คือ "ไม่มีเสียง" ให้เลือกได้จากลิสต์เดียวกัน ไม่ต้องมีสวิตช์แยก ──
const List<Map<String, String>> kTasbihSounds = [
  {'id': 'none', 'th': 'ไม่มีเสียง', 'en': 'No sound', 'asset': ''},
  {'id': 'tasbah1', 'th': 'เสียงที่ 1', 'en': 'Sound 1', 'asset': 'audio/tasbih/tasbah1.mp3'},
  {'id': 'tasbah2', 'th': 'เสียงที่ 2', 'en': 'Sound 2', 'asset': 'audio/tasbih/tasbah2.mp3'},
  {'id': 'tasbah3', 'th': 'เสียงที่ 3', 'en': 'Sound 3', 'asset': 'audio/tasbih/tasbah3.mp3'},
  {'id': 'tasbah4', 'th': 'เสียงที่ 4', 'en': 'Sound 4', 'asset': 'audio/tasbih/tasbah4.mp3'},
];

// ── ธีมสีวงนับ ── ให้เลือกสกินสีของวงกลมนับได้ 12 แบบ (แรงบันดาลใจจาก
// ระบบเลือกธีมของแอปตัสบีฮ์ทั่วไป) แยกจากธีมสว่าง/มืดหลักของแอป — ธีมนี้
// มีผลแค่สีวงกลมตรงกลาง+วงแหวนความคืบหน้าเท่านั้น ไม่กระทบสีพื้นหลัง/
// ข้อความส่วนอื่นของหน้า ──────────────────────────────────────────
const List<Map<String, dynamic>> kTasbihDialThemes = [
  {'id': 'emerald', 'th': 'มรกต', 'en': 'Emerald', 'colors': [Color(0xFF1B5E20), Color(0xFF2E7D32)]},
  {'id': 'goldenSands', 'th': 'ทรายทอง', 'en': 'Golden Sands', 'colors': [Color(0xFF8D6E00), Color(0xFFDAA520)]},
  {'id': 'roseGarden', 'th': 'สวนกุหลาบ', 'en': 'Rose Garden', 'colors': [Color(0xFF880E4F), Color(0xFFC2185B)]},
  {'id': 'blueOcean', 'th': 'มหาสมุทรคราม', 'en': 'Blue Ocean', 'colors': [Color(0xFF01579B), Color(0xFF0288D1)]},
  {'id': 'sunsetSerenade', 'th': 'อัสดงยามเย็น', 'en': 'Sunset Serenade', 'colors': [Color(0xFFBF360C), Color(0xFFFF7043)]},
  {'id': 'earthyTones', 'th': 'โทนดิน', 'en': 'Earthy Tones', 'colors': [Color(0xFF4E342E), Color(0xFF795548)]},
  {'id': 'midnightDreams', 'th': 'ราตรีมืดมิด', 'en': 'Midnight Dreams', 'colors': [Color(0xFF1A237E), Color(0xFF3949AB)]},
  {'id': 'monochrome', 'th': 'ขาวดำเรียบหรู', 'en': 'Monochrome', 'colors': [Color(0xFF212121), Color(0xFF616161)]},
  {'id': 'autumnHarvest', 'th': 'เก็บเกี่ยวใบไม้ร่วง', 'en': 'Autumn Harvest', 'colors': [Color(0xFFE65100), Color(0xFFFFA000)]},
  {'id': 'pureSouls', 'th': 'จิตใจบริสุทธิ์', 'en': 'Pure Souls', 'colors': [Color(0xFF00695C), Color(0xFF26A69A)]},
  {'id': 'lavenderMist', 'th': 'ม่วงลาเวนเดอร์', 'en': 'Lavender Mist', 'colors': [Color(0xFF6A1B9A), Color(0xFFAB47BC)]},
  {'id': 'turquoiseOasis', 'th': 'โอเอซิสฟ้าคราม', 'en': 'Turquoise Oasis', 'colors': [Color(0xFF006064), Color(0xFF00ACC1)]},
];

class TasbihPage extends StatefulWidget {
  const TasbihPage({super.key});
  @override
  State<TasbihPage> createState() => _TasbihPageState();
}

class _TasbihPageState extends State<TasbihPage> with SingleTickerProviderStateMixin {
  final _theme = ThemeService();
  final _lang = LanguageService();

  String _selectedId = kDhikrList.first['id']!;
  int _count = 0;
  int _cycles = 0;
  int _target = 33;
  int _totalAllTime = 0; // นับสะสมตลอดกาลของบทนี้ (ไม่ถูกล้างตอนกด Reset)
  String _dialThemeId = kTasbihDialThemes.first['id'] as String;
  String _soundId = kTasbihSounds[1]['id']!; // ค่าเริ่มต้น = เสียงที่ 1

  final AudioPlayer _audioPlayer = AudioPlayer();

  late final AnimationController _bumpController;
  late final Animation<double> _bumpScale;

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
    _bumpController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120), lowerBound: 0, upperBound: 0.06);
    _bumpScale = Tween<double>(begin: 1.0, end: 0.94)
        .chain(CurveTween(curve: Curves.easeOut))
        .animate(_bumpController);
    _audioPlayer.setReleaseMode(ReleaseMode.stop);
    _load();
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    _bumpController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Map<String, String> get _dhikr =>
      kDhikrList.firstWhere((d) => d['id'] == _selectedId, orElse: () => kDhikrList.first);

  Map<String, dynamic> get _dialTheme => kTasbihDialThemes
      .firstWhere((t) => t['id'] == _dialThemeId, orElse: () => kTasbihDialThemes.first);

  List<Color> get _dialColors => (_dialTheme['colors'] as List<Color>);

  Map<String, String> get _sound =>
      kTasbihSounds.firstWhere((s) => s['id'] == _soundId, orElse: () => kTasbihSounds[1]);

  // ── เล่นเสียงแตะนับ ── หยุดตัวเล่นเดิมก่อนเสมอกันเสียงซ้อนกันตอนแตะถี่ๆ
  // ถ้าเลือก "ไม่มีเสียง" (asset ว่าง) ก็ไม่ต้องทำอะไร ──────────────────
  Future<void> _playTapSound() async {
    final asset = _sound['asset']!;
    if (asset.isEmpty) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource(asset));
    } catch (_) {
      // ไม่มีไฟล์เสียง/เล่นไม่ได้ ก็ปล่อยผ่านเงียบๆ ไม่ให้แอปพัง
    }
  }

  // ── โหลด/บันทึกความคืบหน้า ── ยอดนับ+จำนวนรอบเก็บแยกกันตามบทซิกิร์
  // เป้าหมายและบทที่เลือกล่าสุดเก็บรวมไว้ใช้ตอนเปิดแอปครั้งถัดไป ──────
  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('tasbih_selected_id');
    final id = kDhikrList.any((d) => d['id'] == savedId) ? savedId! : kDhikrList.first['id']!;
    final target = prefs.getInt('tasbih_target') ?? 33;
    final count = prefs.getInt('tasbih_count_$id') ?? 0;
    final cycles = prefs.getInt('tasbih_cycles_$id') ?? 0;
    final totalAllTime = prefs.getInt('tasbih_total_$id') ?? 0;
    final savedDialTheme = prefs.getString('tasbih_dial_theme');
    final dialThemeId = kTasbihDialThemes.any((t) => t['id'] == savedDialTheme)
        ? savedDialTheme!
        : kTasbihDialThemes.first['id'] as String;
    final savedSound = prefs.getString('tasbih_sound_id');
    final soundId = kTasbihSounds.any((s) => s['id'] == savedSound)
        ? savedSound!
        : kTasbihSounds[1]['id']!;
    if (mounted) {
      setState(() {
        _selectedId = id;
        _target = kTasbihTargets.contains(target) ? target : 33;
        _count = count;
        _cycles = cycles;
        _totalAllTime = totalAllTime;
        _dialThemeId = dialThemeId;
        _soundId = soundId;
      });
    }
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('tasbih_selected_id', _selectedId);
    await prefs.setInt('tasbih_target', _target);
    await prefs.setInt('tasbih_count_$_selectedId', _count);
    await prefs.setInt('tasbih_cycles_$_selectedId', _cycles);
    await prefs.setInt('tasbih_total_$_selectedId', _totalAllTime);
    await prefs.setString('tasbih_dial_theme', _dialThemeId);
    await prefs.setString('tasbih_sound_id', _soundId);
  }

  Future<void> _selectDialTheme(String id) async {
    if (id == _dialThemeId) return;
    HapticFeedback.selectionClick();
    setState(() => _dialThemeId = id);
    await _persist();
  }

  // ── เลือกเสียงแตะนับ ── เล่นตัวอย่างทันทีตอนเลือกให้ได้ยินว่าเป็นเสียงไหน ──
  Future<void> _selectSound(String id) async {
    setState(() => _soundId = id);
    await _persist();
    await _playTapSound();
  }

  void _increment() {
    HapticFeedback.lightImpact();
    _playTapSound();
    _bumpController.forward(from: 0).then((_) => _bumpController.reverse());
    setState(() {
      _count++;
      _totalAllTime++;
      if (_target > 0 && _count >= _target) {
        _cycles++;
        _count = 0;
        HapticFeedback.mediumImpact();
        _showCycleCompleteSnack();
      }
    });
    _persist();
  }

  void _undo() {
    if (_count == 0 && _cycles == 0) return;
    HapticFeedback.selectionClick();
    setState(() {
      if (_count > 0) {
        _count--;
      } else if (_cycles > 0) {
        _cycles--;
        _count = _target > 0 ? _target - 1 : 0;
      }
      if (_totalAllTime > 0) _totalAllTime--;
    });
    _persist();
  }

  void _confirmReset() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _theme.cardColor,
        title: Text(_lang.isThai ? 'รีเซ็ตตัวนับ?' : 'Reset counter?',
            style: TextStyle(color: _theme.textColor)),
        content: Text(
            _lang.isThai
                ? 'ยอดนับและจำนวนรอบของบทนี้จะถูกล้างกลับเป็นศูนย์'
                : 'The count and cycles for this dhikr will be cleared to zero.',
            style: TextStyle(color: _theme.subTextColor)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context),
              child: Text(_lang.isThai ? 'ยกเลิก' : 'Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() { _count = 0; _cycles = 0; });
              _persist();
            },
            child: Text(_lang.isThai ? 'รีเซ็ต' : 'Reset', style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCycleCompleteSnack() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(milliseconds: 1400),
      backgroundColor: const Color(0xFF1B5E20),
      content: Row(children: [
        const Icon(Icons.check_circle, color: Color(0xFFFFD700), size: 18),
        const SizedBox(width: 8),
        Text(_lang.isThai ? 'ครบ $_target ครั้งแล้ว! (รอบที่ $_cycles)' : 'Completed $_target! (Round $_cycles)',
            style: const TextStyle(color: Colors.white)),
      ]),
    ));
  }

  void _changeTarget(int t) {
    if (t == _target) return;
    setState(() { _target = t; _count = 0; });
    _persist();
  }

  Future<void> _selectDhikr(String id) async {
    if (id == _selectedId) return;
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt('tasbih_count_$id') ?? 0;
    final cycles = prefs.getInt('tasbih_cycles_$id') ?? 0;
    final totalAllTime = prefs.getInt('tasbih_total_$id') ?? 0;
    setState(() { _selectedId = id; _count = count; _cycles = cycles; _totalAllTime = totalAllTime; });
    await _persist();
  }

  void _showDhikrPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7, maxChildSize: 0.92, minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22))),
          child: Column(children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(children: [
                Text(_lang.isThai ? 'เลือกบทซิกิร์' : 'Choose a Dhikr',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                itemCount: kDhikrList.length,
                itemBuilder: (_, i) {
                  final d = kDhikrList[i];
                  final isSelected = d['id'] == _selectedId;
                  return ListTile(
                    onTap: () { _selectDhikr(d['id']!); Navigator.pop(context); },
                    selected: isSelected,
                    selectedTileColor: _theme.iconColor.withOpacity(0.08),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    title: Text(d['arabic']!,
                        textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                        style: TextStyle(fontSize: 22, color: _theme.textColor, height: 1.6)),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text('${d['translit']} · ${_lang.isThai ? d['th'] : d['en']}',
                          style: TextStyle(fontSize: 12, color: _theme.subTextColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ),
                    trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ]),
        ),
      ),
    );
  }

  // ── เลือกธีมสีวงนับ 12 แบบ ── แสดงเป็นตารางวงกลมตัวอย่างสี + ชื่อธีม
  // แตะเพื่อเปลี่ยนสีวงกลมนับตรงกลางหน้าทันที (ไม่กระทบธีมสว่าง/มืดหลัก) ──
  void _showDialThemePicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65, maxChildSize: 0.9, minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22))),
          child: Column(children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(children: [
                Text(_lang.isThai ? 'เลือกธีมสีวงนับ' : 'Choose a Dial Theme',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
              ]),
            ),
            Expanded(
              child: GridView.builder(
                controller: ctrl,
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, crossAxisSpacing: 14, mainAxisSpacing: 18, childAspectRatio: 0.78),
                itemCount: kTasbihDialThemes.length,
                itemBuilder: (_, i) {
                  final t = kTasbihDialThemes[i];
                  final colors = t['colors'] as List<Color>;
                  final isSelected = t['id'] == _dialThemeId;
                  return GestureDetector(
                    onTap: () { _selectDialTheme(t['id'] as String); Navigator.pop(context); },
                    child: Column(children: [
                      Container(
                        width: 56, height: 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                              begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
                          border: isSelected ? Border.all(color: _theme.textColor, width: 3) : null,
                          boxShadow: [BoxShadow(color: colors[0].withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 3))],
                        ),
                        child: isSelected
                            ? const Icon(Icons.check, color: Colors.white, size: 22)
                            : null,
                      ),
                      const SizedBox(height: 6),
                      Text(_lang.isThai ? t['th'] as String : t['en'] as String,
                          textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: _theme.subTextColor,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                    ]),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── เลือกเสียงตอนแตะนับ ── รายการเสียง + "ไม่มีเสียง" แตะแถวไหนคือเลือก
  // เสียงนั้นทันทีและเล่นตัวอย่างให้ฟัง ไม่ต้องมีสวิตช์เปิด/ปิดแยกต่างหาก ──
  void _showSoundPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.55, maxChildSize: 0.85, minChildSize: 0.35,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22))),
          // ── ชีตนี้เป็น route แยกจากหน้าหลัก การ setState ของ
          // _TasbihPageState (ใน _selectSound) ไม่ทำให้ ListView ในนี้
          // rebuild เอง เลยต้องมี StatefulBuilder ครอบไว้ แล้วสั่ง
          // setModalState ทุกครั้งหลังเลือก ติ๊กถึงจะขึ้นทันทีโดยไม่ต้อง
          // ปิด-เปิดชีตใหม่ ──────────────────────────────────────────
          child: StatefulBuilder(
            builder: (context, setModalState) => Column(children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
                child: Row(children: [
                  Text(_lang.isThai ? 'เลือกเสียงตอนนับ' : 'Choose a tap sound',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
                ]),
              ),
              Expanded(
                child: ListView.builder(
                  controller: ctrl,
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  itemCount: kTasbihSounds.length,
                  itemBuilder: (_, i) {
                    final s = kTasbihSounds[i];
                    final isSelected = s['id'] == _soundId;
                    final isNone = s['id'] == 'none';
                    return ListTile(
                      onTap: () async {
                        await _selectSound(s['id']!);
                        setModalState(() {});
                      },
                      selected: isSelected,
                      selectedTileColor: _dialColors[0].withOpacity(0.08),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      leading: Icon(isNone ? Icons.volume_off : Icons.graphic_eq,
                          color: isSelected ? _dialColors[0] : _theme.subTextColor),
                      title: Text(_lang.isThai ? s['th']! : s['en']!,
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: _theme.textColor)),
                      trailing: isSelected ? Icon(Icons.check_circle, color: _dialColors[0]) : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
            ]),
          ),
        ),
      ),
    );
  }

  // ── ประวัติสะสม ── โชว์ยอดนับสะสมตลอดกาล + จำนวนรอบที่ครบ ของทุกบทซิกิร์
  // (ไม่ใช่ log รายวัน เพราะแอปยังไม่เก็บ timestamp รายครั้ง แต่เป็นสรุปสะสม
  // ต่อบทซิกิร์ทั้งหมดที่เคยนับมา) ─────────────────────────────────
  Future<void> _showHistorySheet() async {
    final prefs = await SharedPreferences.getInstance();
    final rows = kDhikrList.map((d) {
      final id = d['id']!;
      return {
        'dhikr': d,
        'total': prefs.getInt('tasbih_total_$id') ?? 0,
        'cycles': prefs.getInt('tasbih_cycles_$id') ?? 0,
      };
    }).toList()
      ..sort((a, b) => (b['total'] as int).compareTo(a['total'] as int));

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65, maxChildSize: 0.9, minChildSize: 0.4,
        builder: (_, ctrl) => Container(
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(22))),
          child: Column(children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
              child: Row(children: [
                Text(_lang.isThai ? 'ยอดสะสมทุกบท' : 'All-time totals',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
              ]),
            ),
            Expanded(
              child: ListView.builder(
                controller: ctrl,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                itemCount: rows.length,
                itemBuilder: (_, i) {
                  final row = rows[i];
                  final d = row['dhikr'] as Map<String, String>;
                  final total = row['total'] as int;
                  final cycles = row['cycles'] as int;
                  final isCurrent = d['id'] == _selectedId;
                  return ListTile(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    tileColor: isCurrent ? _theme.iconColor.withOpacity(0.06) : null,
                    title: Text(d['translit']!,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _theme.textColor)),
                    subtitle: Text(_lang.isThai ? d['th']! : d['en']!,
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11, color: _theme.subTextColor)),
                    trailing: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.end, children: [
                      Text('$total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: _theme.iconColor)),
                      Text(_lang.isThai ? '$cycles รอบ' : '$cycles rounds',
                          style: TextStyle(fontSize: 10, color: _theme.subTextColor)),
                    ]),
                  );
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _dialColors;
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: SafeArea(
        child: Column(children: [
          _buildHeader(colors),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(children: [
                _buildDhikrCard(colors),
                const SizedBox(height: 16),
                _buildCounterCard(colors),
              ]),
            ),
          ),
        ]),
      ),
    );
  }

  // ── หัวหน้าจอไล่เฉดสีตามธีมวงนับที่เลือก มีปุ่มย้อนกลับ ชื่อหน้า
  // และปุ่มจานสีไว้เปลี่ยนธีมสีวงนับ (แบบเดิมก่อนปรับเป็นเส้นลูกประคำ) ──
  Widget _buildHeader(List<Color> colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(4, 4, 12, 18),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
        boxShadow: [BoxShadow(color: colors[0].withOpacity(0.28), blurRadius: 14, offset: const Offset(0, 6))],
      ),
      child: Row(children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
          onPressed: () => Navigator.pop(context)),
        Expanded(
          child: Text(_lang.isThai ? 'ตัสบีฮ์' : 'Tasbih',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        IconButton(
          icon: const Icon(Icons.graphic_eq, color: Colors.white, size: 22),
          onPressed: _showSoundPicker,
          tooltip: _lang.isThai ? 'เสียงตอนนับ' : 'Tap sound',
        ),
        IconButton(
          icon: const Icon(Icons.palette_outlined, color: Colors.white, size: 22),
          onPressed: _showDialThemePicker,
          tooltip: _lang.isThai ? 'ธีมสีวงนับ' : 'Dial theme',
        ),
      ]),
    );
  }

  // ── การ์ดชื่อบทซิกิร์ที่กำลังนับ + ปุ่มเปลี่ยนบท ──
  Widget _buildDhikrCard(List<Color> colors) {
    final d = _dhikr;
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: _theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200),
        boxShadow: _theme.isDark ? null : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 3))],
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(d['arabic']!,
                textAlign: TextAlign.right, textDirection: TextDirection.rtl,
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, color: colors[0], height: 1.4)),
            const SizedBox(height: 4),
            Text('${d['translit']} · ${_lang.isThai ? d['th'] : d['en']}',
                maxLines: 1, overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: _theme.subTextColor)),
          ]),
        ),
        IconButton(
          icon: Icon(Icons.edit_outlined, color: colors[0], size: 20),
          onPressed: _showDhikrPicker,
          tooltip: _lang.isThai ? 'เปลี่ยนบทซิกิร์' : 'Change dhikr',
        ),
      ]),
    );
  }

  // ── การ์ดรวม: วงกลมนับ + ป้ายรอบ/ยอดสะสม + ปุ่มเป้าหมาย + ปุ่มคำสั่ง
  // ไว้ในกรอบเดียวกัน (แทนที่จะปล่อยลอยแยกชิ้นบนพื้นหลังเทาแบบเดิม) ให้
  // สัดส่วนแน่นขึ้น ดูเป็นชิ้นเดียวที่ประณีตกว่า ─────────────────────
  Widget _buildCounterCard(List<Color> colors) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(20, 26, 20, 22),
      decoration: BoxDecoration(
        color: _theme.cardColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200),
        boxShadow: _theme.isDark ? null : [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(children: [
        _buildCycleBadge(colors),
        const SizedBox(height: 24),
        _buildCounterDial(colors),
        const SizedBox(height: 22),
        _buildTargetRow(),
        const SizedBox(height: 22),
        Container(height: 1, color: (_theme.isDark ? Colors.white : Colors.black).withOpacity(0.06)),
        const SizedBox(height: 18),
        _buildActionRow(colors),
      ]),
    );
  }

  // ── วงกลมนับหลัก ── แตะเพื่อนับ +1 กดค้างเพื่อรีเซ็ต มีวงแหวนความคืบหน้า
  // บางเรียวล้อมรอบตามสัดส่วน _count/_target วงกลมตรงกลางไล่เฉด 3 สี
  // ให้มีมิติมากกว่าเดิม ตัวเลขนับตัวใหญ่อยู่กึ่งกลาง ──────────────────
  Widget _buildCounterDial(List<Color> colors) {
    final progress = _target > 0 ? (_count / _target).clamp(0.0, 1.0) : null;
    return GestureDetector(
      onTap: _increment,
      onLongPress: _confirmReset,
      child: AnimatedBuilder(
        animation: _bumpScale,
        builder: (context, child) => Transform.scale(scale: _bumpScale.value, child: child),
        child: SizedBox(
          width: 220, height: 220,
          child: Stack(alignment: Alignment.center, children: [
            SizedBox(
              width: 220, height: 220,
              child: CircularProgressIndicator(
                value: progress ?? 1,
                strokeWidth: 7,
                strokeCap: StrokeCap.round,
                backgroundColor: (_theme.isDark ? Colors.white : Colors.black).withOpacity(0.07),
                valueColor: AlwaysStoppedAnimation(colors[0]),
              ),
            ),
            Container(
              width: 178, height: 178,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  center: const Alignment(-0.3, -0.4),
                  colors: [Color.lerp(colors[1], Colors.white, 0.18)!, colors[0], Color.lerp(colors[0], Colors.black, 0.25)!],
                  stops: const [0.0, 0.55, 1.0],
                ),
                boxShadow: [BoxShadow(color: colors[0].withOpacity(0.4), blurRadius: 22, offset: const Offset(0, 10))],
              ),
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text('$_count',
                      style: const TextStyle(color: Colors.white, fontSize: 52, fontWeight: FontWeight.bold, height: 1)),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.18), borderRadius: BorderRadius.circular(10)),
                    child: Text(_target > 0 ? '/ $_target' : (_lang.isThai ? 'ไม่จำกัด' : 'Unlimited'),
                        style: TextStyle(color: Colors.white.withOpacity(0.92), fontSize: 13, fontWeight: FontWeight.w600)),
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  // ── ป้ายแสดงจำนวนรอบที่ครบ + ยอดสะสมตลอดกาลของบทนี้ ── คั่นด้วยจุดกลม
  // เล็กแทนตัวอักษร "·" ให้ดูเรียบร้อยกว่า ─────────────────────────
  Widget _buildCycleBadge(List<Color> colors) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
      decoration: BoxDecoration(color: colors[0].withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(Icons.emoji_events_outlined, size: 15, color: colors[0]),
        const SizedBox(width: 6),
        Text(_lang.isThai ? 'รอบที่ $_cycles' : 'Round $_cycles',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors[0])),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(width: 3, height: 3, decoration: BoxDecoration(color: colors[0].withOpacity(0.5), shape: BoxShape.circle)),
        ),
        Text(_lang.isThai ? 'รวม $_totalAllTime' : 'Total $_totalAllTime',
            style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: colors[0])),
      ]),
    );
  }

  // ── ปุ่มเลือกเป้าหมาย ── จัดกึ่งกลางแบบเว้นระยะเท่ากัน (มีแค่ 4 ปุ่ม
  // พอดีความกว้างการ์ด ไม่ต้องเลื่อนแนวนอนแบบเดิม) ปุ่มโตขึ้นเล็กน้อย ──
  Widget _buildTargetRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: kTasbihTargets.map((t) {
        final isSelected = t == _target;
        final label = t == 0 ? '∞' : '$t';
        return GestureDetector(
          onTap: () => _changeTarget(t),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            width: 56, height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected ? _dialColors[0] : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: isSelected ? _dialColors[0]
                      : (_theme.isDark ? ThemeService.darkBorder : Colors.grey.shade300),
                  width: 1.3),
            ),
            child: Text(label,
                style: TextStyle(
                    color: isSelected ? Colors.white : _theme.textColor,
                    fontWeight: FontWeight.bold, fontSize: 14)),
          ),
        );
      }).toList(),
    );
  }

  // ── แถวปุ่มคำสั่ง: ย้อนกลับ 1 ครั้ง / ประวัติสะสม / รีเซ็ต ── เว้นระยะ
  // เท่ากันแบบ spaceEvenly ให้สมดุลกับความกว้างการ์ด ────────────────
  Widget _buildActionRow(List<Color> colors) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      _actionButton(Icons.undo_rounded, _lang.isThai ? 'ย้อนกลับ' : 'Undo', _undo, colors[0]),
      _actionButton(Icons.history, _lang.isThai ? 'ประวัติ' : 'History', _showHistorySheet, colors[0]),
      _actionButton(Icons.refresh, _lang.isThai ? 'รีเซ็ต' : 'Reset', _confirmReset, Colors.red),
    ]);
  }

  Widget _actionButton(IconData icon, String label, VoidCallback onTap, Color color) {
    return GestureDetector(
      onTap: onTap,
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          width: 50, height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.1),
            border: Border.all(color: color.withOpacity(0.18)),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(height: 7),
        Text(label, style: TextStyle(fontSize: 11.5, color: _theme.subTextColor, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}