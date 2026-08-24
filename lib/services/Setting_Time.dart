import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../services/prayer_service.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';
import '../services/notification_service.dart';
import '../services/azan_service.dart';
import '../services/location_service.dart';

// ── ตัวช่วยฟอร์แมตเวลาเป็น mm:ss สำหรับ progress bar ──────────
String _fmtDuration(Duration d) {
  final minutes = d.inMinutes.remainder(60).toString().padLeft(1, '0');
  final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
  return '$minutes:$seconds';
}

// ── วงกลมปุ่มเล่นที่เต้นเบาๆ (pulse) ตอนกำลังเล่นเสียงอยู่ ──────
class _PulsingCircle extends StatefulWidget {
  final bool playing;
  final Widget child;
  const _PulsingCircle({required this.playing, required this.child});

  @override
  State<_PulsingCircle> createState() => _PulsingCircleState();
}

class _PulsingCircleState extends State<_PulsingCircle>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.playing) return widget.child;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        final scale = 1.0 + _controller.value * 0.12;
        return Transform.scale(scale: scale, child: widget.child);
      },
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── Shared UI helpers (ใช้ร่วมกันทุกหน้าใน Settings) ──────────
// ══════════════════════════════════════════════════════════════

Widget _sectionHeader(String title, Color subColor) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
    child: Text(title.toUpperCase(),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
            color: subColor, letterSpacing: 0.8)),
  );
}

Widget _buildGroup(Color bg, Color divColor, bool isDark, List<Widget> children) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: bg,
      borderRadius: BorderRadius.circular(12),
      boxShadow: isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
    ),
    child: Column(children: [
      for (int i = 0; i < children.length; i++) ...[
        children[i],
        if (i < children.length - 1) Divider(height: 1, indent: 66, color: divColor),
      ]
    ]),
  );
}

Widget _iconBox(IconData icon, Color color) {
  return Container(
    width: 42, height: 42,
    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12)),
    child: Icon(icon, color: Colors.white, size: 22),
  );
}

Widget _buildSwitchRow({
  required IconData icon, required Color iconColor, required String label,
  required bool value, required Color textColor, required Color activeTrackColor,
  required ValueChanged<bool> onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      _iconBox(icon, iconColor),
      const SizedBox(width: 12),
      Expanded(child: Text(label, style: TextStyle(fontSize: 15, color: textColor))),
      Switch(value: value, onChanged: onChanged,
          activeColor: Colors.white, activeTrackColor: activeTrackColor),
    ]),
  );
}

Widget _buildNavRow({
  required IconData icon, required Color iconColor, required String label,
  required String value, required Color textColor, required Color subColor,
  required VoidCallback onTap,
  String? subtitle, // บรรทัดรองบอกค่าปัจจุบันแบบย่อ (ใช้ในเมนูหลักเพื่อไม่ให้ดูโล่ง)
}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(children: [
        _iconBox(icon, iconColor),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor)),
              if (subtitle != null && subtitle.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: subColor),
                    maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ],
          ),
        ),
        if (value.isNotEmpty)
          Flexible(child: Text(value, style: TextStyle(fontSize: 14, color: subColor),
              overflow: TextOverflow.ellipsis, textAlign: TextAlign.end)),
        const SizedBox(width: 4),
        Icon(Icons.chevron_right, color: subColor, size: 18),
      ]),
    ),
  );
}

// ══════════════════════════════════════════════════════════════
// ── หน้าเมนูหลัก Settings ──────────────────────────────────────
// ══════════════════════════════════════════════════════════════

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();

  // ── ค่าสรุปสั้นๆ ใต้แต่ละหมวด (โชว์ให้กวาดตาดูได้เร็วโดยไม่ต้องกดเข้าไป) ──
  double _quranFontSize = 24.0;
  String _azanName = '';
  String? _locationName;

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
    _loadSummary();
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    super.dispose();
  }

  Future<void> _loadSummary() async {
    final prefs = await SharedPreferences.getInstance();
    final azanId = await AzanService.getSelectedAzanId();
    final savedLocation = await LocationService.getSavedLocation();
    if (!mounted) return;
    setState(() {
      _quranFontSize = prefs.getDouble('quran_font_size') ?? 24.0;
      _azanName = AzanService.getAzanById(azanId)[_lang.isThai ? 'nameTh' : 'name'] ?? '';
      _locationName = savedLocation?['name'] as String?;
    });
  }

  // เปิดหน้าย่อยแล้วรีเฟรชค่าสรุปทันทีที่กลับมา (การเปลี่ยนค่าใน sub-page apply ทันทีอยู่แล้ว)
  Future<void> _openSubPage(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    _loadSummary();
  }

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 22),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: _theme.isDark
              ? [const Color(0xFF0D3B1E), const Color(0xFF1A5C32)]
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16)),
          child: const Icon(Icons.mosque, color: Color(0xFFFFD700), size: 30),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DEEN',
                  style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 3),
              Text(
                _lang.isThai
                    ? 'ปรับแต่งแอปให้เข้ากับตัวคุณ'
                    : 'Personalize your Deen experience',
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12.5),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _theme.isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F7);
    final cardBg = _theme.isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = _theme.textColor;
    final subColor = _theme.subTextColor;
    final green = _theme.iconColor;
    final divColor = _theme.isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    final langInfo = LanguageService.availableLanguages
        .firstWhere((l) => l['code'] == _lang.lang, orElse: () => {'native': ''});
    final appearanceSubtitle = _lang.isThai
        ? '${langInfo['native']} • ${_theme.isDark ? 'โหมดมืด' : 'โหมดสว่าง'}'
        : '${langInfo['native']} • ${_theme.isDark ? 'Dark' : 'Light'} mode';
    final quranSubtitle = _lang.isThai
        ? 'ขนาดตัวอักษร ${_quranFontSize.toInt()}'
        : 'Font size ${_quranFontSize.toInt()}';
    final prayerSubtitle = [
      _locationName ?? (_lang.isThai ? 'อัตโนมัติ (GPS)' : 'Automatic (GPS)'),
      if (_azanName.isNotEmpty) _azanName,
    ].join(' • ');

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: green, size: 20)),
        title: Text(_lang.isThai ? 'ตั้งค่า' : 'Settings',
            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(children: [
        _buildHeaderCard(),
        _buildGroup(cardBg, divColor, _theme.isDark, [
          _buildNavRow(
            icon: Icons.palette_outlined,
            iconColor: Colors.indigo,
            label: _lang.isThai ? 'หน้าตา' : 'Appearance',
            subtitle: appearanceSubtitle,
            value: '',
            textColor: textColor,
            subColor: subColor,
            onTap: () => _openSubPage(const _AppearanceSettingsPage()),
          ),
          _buildNavRow(
            icon: Icons.menu_book_outlined,
            iconColor: Colors.orange,
            label: _lang.isThai ? 'อัลกุรอาน' : 'Al-Quran',
            subtitle: quranSubtitle,
            value: '',
            textColor: textColor,
            subColor: subColor,
            onTap: () => _openSubPage(const _QuranSettingsPage()),
          ),
          _buildNavRow(
            icon: Icons.mosque_outlined,
            iconColor: const Color(0xFF1B5E20),
            label: _lang.isThai ? 'เวลาละหมาดและการแจ้งเตือน' : 'Prayer Times & Notifications',
            subtitle: prayerSubtitle,
            value: '',
            textColor: textColor,
            subColor: subColor,
            onTap: () => _openSubPage(const _PrayerNotificationSettingsPage()),
          ),
          _buildNavRow(
            icon: Icons.info_outline,
            iconColor: Colors.blue,
            label: _lang.isThai ? 'เกี่ยวกับ' : 'About',
            subtitle: 'DEEN v1.0.0',
            value: '',
            textColor: textColor,
            subColor: subColor,
            onTap: () => _openSubPage(const _AboutSettingsPage()),
          ),
        ]),
        const SizedBox(height: 32),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── หน้าตา (Appearance) ─────────────────────────────────────────
// ══════════════════════════════════════════════════════════════

class _AppearanceSettingsPage extends StatefulWidget {
  const _AppearanceSettingsPage();

  @override
  State<_AppearanceSettingsPage> createState() => _AppearanceSettingsPageState();
}

class _AppearanceSettingsPageState extends State<_AppearanceSettingsPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();

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

  void _showLanguageSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _theme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text('Language / ภาษา',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  ...LanguageService.availableLanguages.map((lang) {
                    final isSelected = _lang.lang == lang['code'];
                    return ListTile(
                      leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                      title: Text(lang['native']!, style: TextStyle(color: _theme.textColor, fontWeight: FontWeight.w500)),
                      subtitle: Text(lang['name']!, style: TextStyle(color: _theme.subTextColor, fontSize: 12)),
                      trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
                      onTap: () async {
                        // apply ทันที ไม่ต้องรอกด Save
                        await _lang.setLang(lang['code']!);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  }),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _theme.isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F7);
    final cardBg = _theme.isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = _theme.textColor;
    final subColor = _theme.subTextColor;
    final green = _theme.iconColor;
    final divColor = _theme.isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: green, size: 20)),
        title: Text(_lang.isThai ? 'หน้าตา' : 'Appearance',
            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(children: [
        const SizedBox(height: 8),
        _buildGroup(cardBg, divColor, _theme.isDark, [
          _buildSwitchRow(
            icon: Icons.dark_mode_outlined,
            iconColor: Colors.indigo,
            label: _lang.isThai ? 'โหมดกลางคืน' : 'Dark Mode',
            value: _theme.isDark,
            textColor: textColor,
            activeTrackColor: green,
            onChanged: (_) => _theme.toggle(), // apply ทันทีอยู่แล้ว
          ),
          _buildNavRow(
            icon: Icons.language,
            iconColor: Colors.blue,
            label: _lang.isThai ? 'ภาษา' : 'Language',
            value: '${LanguageService.availableLanguages.firstWhere((l) => l['code'] == _lang.lang)['flag']} '
                '${LanguageService.availableLanguages.firstWhere((l) => l['code'] == _lang.lang)['native']}',
            textColor: textColor,
            subColor: subColor,
            onTap: _showLanguageSheet,
          ),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── อัลกุรอาน (Al-Quran) ─────────────────────────────────────────
// ══════════════════════════════════════════════════════════════

class _QuranSettingsPage extends StatefulWidget {
  const _QuranSettingsPage();

  @override
  State<_QuranSettingsPage> createState() => _QuranSettingsPageState();
}

class _QuranSettingsPageState extends State<_QuranSettingsPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();
  double _quranFontSize = 24.0;

  // null = ยังไม่ได้ตั้งค่าเอง ใช้ภาษาแอปเป็นค่าเริ่มต้น (พฤติกรรมเดิม)
  String? _translationLang;

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
    _loadFontSize();
    _loadTranslationLang();
  }

  Future<void> _loadFontSize() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _quranFontSize = prefs.getDouble('quran_font_size') ?? 24.0);
    }
  }

  Future<void> _saveFontSize(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('quran_font_size', value);
  }

  Future<void> _loadTranslationLang() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() => _translationLang = prefs.getString('quran_translation_lang'));
    }
  }

  // key เดียวกับที่ SurahDetailPage อ่าน/เขียนตอนเปลี่ยนภาษาคำแปลระหว่างอ่าน
  void _showTranslationLangSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _theme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        maxChildSize: 0.9,
        minChildSize: 0.4,
        expand: false,
        builder: (_, controller) => Column(
          children: [
            const SizedBox(height: 12),
            Container(width: 40, height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(_lang.isThai ? 'ภาษาคำแปล' : 'Translation Language',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                controller: controller,
                children: [
                  // ตัวเลือกแรก: ตามภาษาแอป (ล้างค่าที่ตั้งไว้เอง)
                  ListTile(
                    leading: Icon(Icons.smartphone, color: _theme.iconColor),
                    title: Text(_lang.isThai ? 'ตามภาษาแอป' : 'Follow app language',
                        style: TextStyle(color: _theme.textColor, fontWeight: FontWeight.w500)),
                    trailing: _translationLang == null
                        ? Icon(Icons.check_circle, color: _theme.iconColor)
                        : null,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('quran_translation_lang');
                      if (mounted) setState(() => _translationLang = null);
                      if (context.mounted) Navigator.pop(context);
                    },
                  ),
                  Divider(height: 1, color: _theme.isDark ? ThemeService.darkBorder : const Color(0xFFE5E5EA)),
                  ...LanguageService.availableLanguages.map((lang) {
                    final isSelected = _translationLang == lang['code'];
                    return ListTile(
                      leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                      title: Text(lang['native']!, style: TextStyle(color: _theme.textColor, fontWeight: FontWeight.w500)),
                      subtitle: Text(lang['name']!, style: TextStyle(color: _theme.subTextColor, fontSize: 12)),
                      trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
                      onTap: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('quran_translation_lang', lang['code']!);
                        if (mounted) setState(() => _translationLang = lang['code']);
                        if (context.mounted) Navigator.pop(context);
                      },
                    );
                  }),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bg = _theme.isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F7);
    final cardBg = _theme.isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = _theme.textColor;
    final subColor = _theme.subTextColor;
    final green = _theme.iconColor;
    final divColor = _theme.isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: green, size: 20)),
        title: Text(_lang.isThai ? 'อัลกุรอาน' : 'Al-Quran',
            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(children: [
        const SizedBox(height: 8),
        _buildGroup(cardBg, divColor, _theme.isDark, [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                _iconBox(Icons.format_size, Colors.orange),
                const SizedBox(width: 12),
                Expanded(child: Text(_lang.isThai ? 'ขนาดตัวอักษรอาหรับ' : 'Arabic Font Size',
                    style: TextStyle(fontSize: 15, color: textColor))),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(color: green.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                  child: Text('${_quranFontSize.toInt()}',
                      style: TextStyle(color: green, fontWeight: FontWeight.w600, fontSize: 13)),
                ),
              ]),
              const SizedBox(height: 8),
              Center(child: Text('بِسْمِ ٱللَّهِ',
                  style: TextStyle(fontSize: _quranFontSize, color: textColor, height: 1.8),
                  textDirection: TextDirection.rtl)),
              SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: green,
                  inactiveTrackColor: green.withOpacity(0.2),
                  thumbColor: green,
                  overlayColor: green.withOpacity(0.1),
                ),
                child: Slider(
                  value: _quranFontSize, min: 16, max: 36, divisions: 10,
                  onChanged: (v) => setState(() => _quranFontSize = v),
                  // apply ทันทีตอนปล่อยนิ้ว ไม่ต้อง Save
                  onChangeEnd: (v) => _saveFontSize(v),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('A', style: TextStyle(fontSize: 12, color: subColor)),
                Text('A', style: TextStyle(fontSize: 20, color: subColor, fontWeight: FontWeight.bold)),
              ]),
            ]),
          ),
        ]),

        _sectionHeader(_lang.isThai ? 'คำแปล' : 'Translation', subColor),
        _buildGroup(cardBg, divColor, _theme.isDark, [
          _buildNavRow(
            icon: Icons.translate,
            iconColor: Colors.teal,
            label: _lang.isThai ? 'ภาษาคำแปล' : 'Translation Language',
            value: _translationLang == null
                ? (_lang.isThai ? 'ตามภาษาแอป' : 'App language')
                : (LanguageService.availableLanguages
                        .firstWhere((l) => l['code'] == _translationLang)['native'] ??
                    ''),
            textColor: textColor,
            subColor: subColor,
            onTap: _showTranslationLangSheet,
          ),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── เวลาละหมาดและการแจ้งเตือน ────────────────────────────────────
// ══════════════════════════════════════════════════════════════

class _PrayerNotificationSettingsPage extends StatefulWidget {
  const _PrayerNotificationSettingsPage();

  @override
  State<_PrayerNotificationSettingsPage> createState() => _PrayerNotificationSettingsPageState();
}

class _PrayerNotificationSettingsPageState extends State<_PrayerNotificationSettingsPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();

  String _selectedTimezone = 'Asia/Bangkok';
  String _selectedMethod = '16';
  bool _notificationEnabled = true;
  String _selectedAzanId = 'azan_makkah';
  String? _selectedLocationName;

  final Map<String, double> _downloadProgress = {};
  final Set<String> _downloadedIds = {};

  final List<Map<String, String>> _timezones = [
    {'label': 'Thailand (Bangkok)', 'value': 'Asia/Bangkok'},
    {'label': 'Malaysia (Kuala Lumpur)', 'value': 'Asia/Kuala_Lumpur'},
    {'label': 'Indonesia (Jakarta)', 'value': 'Asia/Jakarta'},
    {'label': 'Indonesia (Makassar)', 'value': 'Asia/Makassar'},
    {'label': 'Indonesia (Jayapura)', 'value': 'Asia/Jayapura'},
    {'label': 'Saudi Arabia (Riyadh)', 'value': 'Asia/Riyadh'},
    {'label': 'UAE (Dubai)', 'value': 'Asia/Dubai'},
    {'label': 'Turkey (Istanbul)', 'value': 'Europe/Istanbul'},
    {'label': 'Pakistan (Karachi)', 'value': 'Asia/Karachi'},
    {'label': 'India (Kolkata)', 'value': 'Asia/Kolkata'},
    {'label': 'Egypt (Cairo)', 'value': 'Africa/Cairo'},
    {'label': 'UK (London)', 'value': 'Europe/London'},
    {'label': 'USA (New York)', 'value': 'America/New_York'},
    {'label': 'USA (Los Angeles)', 'value': 'America/Los_Angeles'},
  ];

  final List<Map<String, String>> _methods = [
    {'label': 'ISNA (North America)', 'value': '2'},
    {'label': 'Muslim World League', 'value': '3'},
    {'label': 'Umm Al-Qura (Makkah)', 'value': '4'},
    {'label': 'Egyptian Authority', 'value': '5'},
    {'label': 'Institute of Geophysics (Tehran)', 'value': '7'},
    {'label': 'Gulf Region', 'value': '8'},
    {'label': 'Kuwait', 'value': '9'},
    {'label': 'Qatar', 'value': '10'},
    {'label': 'Majlis Ugama Islam Singapura', 'value': '11'},
    {'label': 'Union Organization Islamic de France', 'value': '12'},
    {'label': 'Diyanet İşleri Başkanlığı (Turkey)', 'value': '13'},
    {'label': 'Spiritual Administration of Muslims of Russia', 'value': '14'},
    {'label': 'Moonsighting Committee', 'value': '15'},
    {'label': 'Dubai (Southeast Asia)', 'value': '16'},
  ];

  void _rebuild() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _theme.addListener(_rebuild);
    _lang.addListener(_rebuild);
    _loadSettings();
  }

  @override
  void dispose() {
    _theme.removeListener(_rebuild);
    _lang.removeListener(_rebuild);
    AzanService.stopPreview();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final azanId = await AzanService.getSelectedAzanId();
    final savedLocation = await LocationService.getSavedLocation();
    if (!mounted) return;
    setState(() {
      _selectedTimezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      _selectedMethod = prefs.getString('method') ?? '16';
      _notificationEnabled = prefs.getBool('notification') ?? true;
      _selectedAzanId = azanId;
      _selectedLocationName = savedLocation?['name'] as String?;
    });
  }

  Future<void> _showTestNotification() async {
    await NotificationService.showTest();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_lang.isThai ? 'ส่งแจ้งเตือนแล้ว!' : 'Notification sent!'),
        backgroundColor: const Color(0xFF1B5E20)));
    }
  }

  Future<void> _scheduleTest() async {
    await NotificationService.scheduleTestIn1Min();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_lang.isThai ? 'รอ 1 นาทีครับ 🔔' : 'Wait 1 minute 🔔'),
        backgroundColor: const Color(0xFF1B5E20)));
    }
  }

  void _showTimezoneSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _theme.cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(_lang.isThai ? 'เลือกเขตเวลา' : 'Select Timezone',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
        ),
        const SizedBox(height: 8),
        Expanded(child: ListView(children: _timezones.map((tz) {
          final isSelected = _selectedTimezone == tz['value'];
          return ListTile(
            title: Text(tz['label']!, style: TextStyle(color: _theme.textColor, fontSize: 14)),
            trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('timezone', tz['value']!);
              await PrayerService.clearCache(); // apply ทันที
              if (mounted) setState(() => _selectedTimezone = tz['value']!);
              if (context.mounted) Navigator.pop(context);
            },
          );
        }).toList())),
      ]),
    );
  }

  void _showMethodSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _theme.cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(children: [
        const SizedBox(height: 12),
        Container(width: 40, height: 4,
            decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(_lang.isThai ? 'เลือกวิธีคำนวณ' : 'Select Calculation Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
        ),
        const SizedBox(height: 8),
        Expanded(child: ListView(children: _methods.map((m) {
          final isSelected = _selectedMethod == m['value'];
          return ListTile(
            title: Text(m['label']!, style: TextStyle(color: _theme.textColor, fontSize: 14)),
            trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('method', m['value']!);
              await PrayerService.clearCache(); // apply ทันที
              if (mounted) setState(() => _selectedMethod = m['value']!);
              if (context.mounted) Navigator.pop(context);
            },
          );
        }).toList())),
      ]),
    );
  }

  void _showLocationSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _theme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _LocationSearchSheet(
        theme: _theme,
        lang: _lang,
        onLocationSelected: (name) {
          if (mounted) setState(() => _selectedLocationName = name);
        },
      ),
    );
  }

  // ── เลือกเสียงอาซาน: เล่นฟังก่อนได้ + โหลดเสียงที่ยังไม่มีในเครื่อง ──
  void _showAzanSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _theme.cardColor,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (sheetContext) => StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          String? playingId = AzanService.currentlyPlayingId;

          Future<void> togglePlay(String id) async {
            if (playingId == id) {
              await AzanService.stopPreview();
              if (sheetContext.mounted) setSheetState(() => playingId = null);
              return;
            }
            try {
              await AzanService.playPreview(id, onComplete: () {
                if (sheetContext.mounted) setSheetState(() => playingId = null);
              });
              if (sheetContext.mounted) setSheetState(() => playingId = id);
            } catch (e) {
              if (sheetContext.mounted) {
                ScaffoldMessenger.of(sheetContext).showSnackBar(SnackBar(
                  content: Text('$e'),
                  duration: const Duration(seconds: 4),
                  backgroundColor: Colors.red.shade700,
                ));
              }
            }
          }

          Future<void> download(String id, String url) async {
            _downloadProgress[id] = 0;
            if (sheetContext.mounted) setSheetState(() {});
            try {
              await AzanService.downloadAzan(
                id,
                url,
                onProgress: (received, total) {
                  if (total > 0) {
                    _downloadProgress[id] = received / total;
                    if (sheetContext.mounted) setSheetState(() {});
                  }
                },
              );
              _downloadProgress.remove(id);
              _downloadedIds.add(id);
              if (sheetContext.mounted) setSheetState(() {});
            } catch (e) {
              _downloadProgress.remove(id);
              if (sheetContext.mounted) {
                setSheetState(() {});
                ScaffoldMessenger.of(sheetContext).showSnackBar(SnackBar(
                  content: Text(_lang.isThai ? 'โหลดเสียงไม่สำเร็จ' : 'Download failed'),
                  backgroundColor: Colors.red.shade700,
                ));
              }
            }
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(width: 40, height: 4,
                  decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(_lang.isThai ? 'เลือกเสียงอาซาน' : 'Select Azan Sound',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _theme.textColor)),
              ),
              const SizedBox(height: 8),
              ...AzanService.azanList.map((azan) {
                final id = azan['id']!;
                final name = _lang.isThai ? azan['nameTh']! : azan['name']!;
                final isSelected = _selectedAzanId == id;
                final isPlaying = playingId == id;
                final isDownloadType = azan['type'] == 'download';
                final isDownloading = _downloadProgress.containsKey(id);

                return FutureBuilder<bool>(
                  future: isDownloadType && !_downloadedIds.contains(id)
                      ? AzanService.isDownloaded(id)
                      : Future.value(true),
                  builder: (context, snapshot) {
                    final downloaded = snapshot.data ?? false;
                    if (downloaded && isDownloadType) _downloadedIds.add(id);
                    final ready = !isDownloadType || downloaded;

                    return ListTile(
                      leading: GestureDetector(
                        onTap: ready ? () => togglePlay(id) : null,
                        child: _PulsingCircle(
                          playing: isPlaying,
                          child: Container(
                            width: 38, height: 38,
                            decoration: BoxDecoration(
                              color: isPlaying
                                  ? _theme.iconColor
                                  : _theme.iconColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                              color: isPlaying ? Colors.white : _theme.iconColor,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      title: Text(name, style: TextStyle(color: _theme.textColor)),
                      subtitle: isDownloading
                          ? Padding(
                              padding: const EdgeInsets.only(top: 6, right: 40),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: _downloadProgress[id],
                                  minHeight: 4,
                                  backgroundColor: _theme.isDark ? Colors.white12 : Colors.black12,
                                  color: _theme.iconColor,
                                ),
                              ),
                            )
                          : (isPlaying
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 6, right: 24),
                                  child: StreamBuilder<Duration>(
                                    stream: AzanService.durationStream,
                                    builder: (context, durSnap) {
                                      return StreamBuilder<Duration>(
                                        stream: AzanService.positionStream,
                                        builder: (context, posSnap) {
                                          final pos = posSnap.data ?? Duration.zero;
                                          final dur = durSnap.data ?? Duration.zero;
                                          final fraction = dur.inMilliseconds > 0
                                              ? (pos.inMilliseconds / dur.inMilliseconds).clamp(0.0, 1.0)
                                              : 0.0;
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.circular(4),
                                                child: LinearProgressIndicator(
                                                  value: fraction,
                                                  minHeight: 4,
                                                  backgroundColor:
                                                      _theme.isDark ? Colors.white12 : Colors.black12,
                                                  color: _theme.iconColor,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                '${_fmtDuration(pos)} / ${_fmtDuration(dur)}',
                                                style: TextStyle(
                                                    fontSize: 10, color: _theme.subTextColor),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                )
                              : (!ready
                                  ? Text(_lang.isThai ? 'ยังไม่ได้โหลด' : 'Not downloaded',
                                      style: TextStyle(color: _theme.subTextColor, fontSize: 12))
                                  : null)),
                      trailing: isDownloading
                          ? SizedBox(
                              width: 22, height: 22,
                              child: CircularProgressIndicator(
                                value: _downloadProgress[id],
                                strokeWidth: 2.5,
                                color: _theme.iconColor,
                              ),
                            )
                          : (!ready
                              ? GestureDetector(
                                  onTap: () => download(id, azan['url']!),
                                  child: Icon(Icons.download_rounded, color: _theme.iconColor),
                                )
                              : (isSelected
                                  ? Icon(Icons.check_circle, color: _theme.iconColor)
                                  : null)),
                      onTap: ready
                          ? () async {
                              // apply ทันที ไม่ต้องรอกด Save
                              await AzanService.setSelectedAzan(id);
                              await PrayerService.clearCache();
                              if (mounted) setState(() => _selectedAzanId = id);
                              if (sheetContext.mounted) Navigator.pop(sheetContext);
                            }
                          : null,
                    );
                  },
                );
              }),
              SizedBox(height: MediaQuery.of(sheetContext).padding.bottom + 16),
            ],
          );
        },
      ),
    ).whenComplete(() => AzanService.stopPreview());
  }

  @override
  Widget build(BuildContext context) {
    final bg = _theme.isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F7);
    final cardBg = _theme.isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = _theme.textColor;
    final subColor = _theme.subTextColor;
    final green = _theme.iconColor;
    final divColor = _theme.isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: green, size: 20)),
        title: Text(_lang.isThai ? 'เวลาละหมาดและการแจ้งเตือน' : 'Prayer & Notifications',
            style: TextStyle(color: textColor, fontSize: 16, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(children: [
        const SizedBox(height: 8),
        _buildGroup(cardBg, divColor, _theme.isDark, [
          _buildSwitchRow(
            icon: Icons.notifications_outlined,
            iconColor: Colors.red,
            label: _lang.isThai ? 'แจ้งเตือนละหมาด' : 'Prayer Notification',
            value: _notificationEnabled,
            textColor: textColor,
            activeTrackColor: green,
            onChanged: (v) async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('notification', v);
              if (!v) {
                await NotificationService.cancelAll();
              } else {
                await PrayerService.clearCache(); // trigger reschedule รอบถัดไป
              }
              if (mounted) setState(() => _notificationEnabled = v);
            },
          ),
          _buildNavRow(
            icon: Icons.location_on_outlined,
            iconColor: Colors.deepPurple,
            label: _lang.isThai ? 'ตำแหน่ง' : 'Location',
            value: _selectedLocationName ??
                (_lang.isThai ? 'อัตโนมัติ (GPS)' : 'Automatic (GPS)'),
            textColor: textColor,
            subColor: subColor,
            onTap: _showLocationSheet,
          ),
          _buildNavRow(
            icon: Icons.music_note_outlined,
            iconColor: Colors.purple,
            label: _lang.isThai ? 'เสียงอาซาน' : 'Azan Sound',
            value: AzanService.getAzanById(_selectedAzanId)[_lang.isThai ? 'nameTh' : 'name'] ?? '',
            textColor: textColor,
            subColor: subColor,
            onTap: _showAzanSheet,
          ),
          _buildNavRow(
            icon: Icons.public,
            iconColor: Colors.teal,
            label: _lang.isThai ? 'เขตเวลา' : 'Timezone',
            value: _timezones.firstWhere((t) => t['value'] == _selectedTimezone)['label']!.split(' ').first,
            textColor: textColor,
            subColor: subColor,
            onTap: _showTimezoneSheet,
          ),
          _buildNavRow(
            icon: Icons.calculate_outlined,
            iconColor: Colors.brown,
            label: _lang.isThai ? 'วิธีคำนวณ' : 'Calculation Method',
            value: _methods.firstWhere((m) => m['value'] == _selectedMethod)['label']!.split(' ').first,
            textColor: textColor,
            subColor: subColor,
            onTap: _showMethodSheet,
          ),
        ]),

        _sectionHeader(_lang.isThai ? 'ทดสอบ' : 'Testing', subColor),
        _buildGroup(cardBg, divColor, _theme.isDark, [
          _buildNavRow(
            icon: Icons.notifications_active_outlined,
            iconColor: Colors.orange,
            label: _lang.isThai ? 'ทดสอบการแจ้งเตือน' : 'Test Notification',
            value: '', textColor: textColor, subColor: subColor,
            onTap: _showTestNotification,
          ),
          _buildNavRow(
            icon: Icons.alarm_outlined,
            iconColor: Colors.deepOrange,
            label: _lang.isThai ? 'ทดสอบ Schedule (1 นาที)' : 'Schedule Test (1 min)',
            value: '', textColor: textColor, subColor: subColor,
            onTap: _scheduleTest,
          ),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── เกี่ยวกับ (About) ─────────────────────────────────────────────
// ══════════════════════════════════════════════════════════════

class _AboutSettingsPage extends StatefulWidget {
  const _AboutSettingsPage();

  @override
  State<_AboutSettingsPage> createState() => _AboutSettingsPageState();
}

class _AboutSettingsPageState extends State<_AboutSettingsPage> {
  final _theme = ThemeService();
  final _lang = LanguageService();

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

  Future<void> _shareApp() async {
    try {
      final text = _lang.isThai
          ? 'ลองใช้แอพ DEEN - แอพอิสลามสำหรับชีวิตประจำวัน 🕌\nโหลดฟรีได้เลย!'
          : 'Try DEEN - Your Islamic companion app 🕌\nFree to download!';
      await Share.share(text);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'), backgroundColor: Colors.red.shade700));
    }
  }

  Future<void> _rateApp() async {
    const packageName = 'com.example.flutter_application_1';
    try {
      final uri = Uri.parse(
          'https://play.google.com/store/apps/details?id=$packageName');
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_lang.isThai
              ? 'ไม่สามารถเปิด Play Store ได้'
              : 'Cannot open Play Store'),
          backgroundColor: Colors.red.shade700));
    }
  }

  void _copyVersion() {
    Clipboard.setData(const ClipboardData(text: 'DEEN v1.0.0'));
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_lang.isThai ? 'คัดลอกแล้ว' : 'Copied'),
      duration: const Duration(seconds: 1),
      backgroundColor: const Color(0xFF1B5E20)));
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
        content: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 72, height: 72,
            decoration: BoxDecoration(
              color: const Color(0xFF1B5E20),
              borderRadius: BorderRadius.circular(18)),
            child: const Icon(Icons.mosque, color: Colors.white, size: 40)),
          const SizedBox(height: 14),
          Text('DEEN', style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: _theme.textColor)),
          const SizedBox(height: 4),
          GestureDetector(
            onLongPress: _copyVersion,
            child: Text('Version 1.0.0',
                style: TextStyle(fontSize: 13, color: _theme.subTextColor))),
          const SizedBox(height: 12),
          Text(
            _lang.isThai
                ? 'แอพอิสลามสำหรับชีวิตประจำวัน\nพัฒนาด้วยความรักและศรัทธา 🕌'
                : 'Your Islamic companion for daily life\nBuilt with love and faith 🕌',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: _theme.subTextColor, height: 1.6)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            TextButton.icon(
              onPressed: _rateApp,
              icon: const Icon(Icons.star_outline, color: Color(0xFF1B5E20), size: 18),
              label: Text(_lang.isThai ? 'ให้คะแนน' : 'Rate',
                  style: const TextStyle(color: Color(0xFF1B5E20)))),
            TextButton.icon(
              onPressed: _shareApp,
              icon: const Icon(Icons.share_outlined, color: Color(0xFF1B5E20), size: 18),
              label: Text(_lang.isThai ? 'แชร์' : 'Share',
                  style: const TextStyle(color: Color(0xFF1B5E20)))),
          ]),
        ]),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK', style: TextStyle(color: _theme.iconColor, fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _theme.isDark ? const Color(0xFF111111) : const Color(0xFFF2F2F7);
    final cardBg = _theme.isDark ? const Color(0xFF1C1C1E) : Colors.white;
    final textColor = _theme.textColor;
    final subColor = _theme.subTextColor;
    final green = _theme.iconColor;
    final divColor = _theme.isDark ? const Color(0xFF2C2C2E) : const Color(0xFFE5E5EA);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Icon(Icons.arrow_back_ios, color: green, size: 20)),
        title: Text(_lang.isThai ? 'เกี่ยวกับ' : 'About',
            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: ListView(children: [
        const SizedBox(height: 8),
        _buildGroup(cardBg, divColor, _theme.isDark, [
          _buildNavRow(
            icon: Icons.info_outline, iconColor: Colors.blue,
            label: _lang.isThai ? 'เกี่ยวกับแอพ' : 'About App',
            value: 'v1.0.0', textColor: textColor, subColor: subColor,
            onTap: _showAboutDialog),
          _buildNavRow(
            icon: Icons.star_outline, iconColor: Colors.amber,
            label: _lang.isThai ? 'ให้คะแนนแอพ' : 'Rate App',
            value: '', textColor: textColor, subColor: subColor,
            onTap: _rateApp),
          _buildNavRow(
            icon: Icons.share_outlined, iconColor: Colors.green,
            label: _lang.isThai ? 'แชร์แอพ' : 'Share App',
            value: '', textColor: textColor, subColor: subColor,
            onTap: _shareApp),
        ]),
      ]),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ── หน้าค้นหาเมือง (Google Places Autocomplete) ──────────────────
// ══════════════════════════════════════════════════════════════

class _LocationSearchSheet extends StatefulWidget {
  final ThemeService theme;
  final LanguageService lang;
  final void Function(String locationName) onLocationSelected;

  const _LocationSearchSheet({
    required this.theme,
    required this.lang,
    required this.onLocationSelected,
  });

  @override
  State<_LocationSearchSheet> createState() => _LocationSearchSheetState();
}

class _LocationSearchSheetState extends State<_LocationSearchSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;

  List<Map<String, String>> _suggestions = [];
  bool _searching = false;
  bool _detecting = false;
  bool _selectingPlace = false;
  String? _errorText;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      setState(() {
        _suggestions = [];
        _errorText = null;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      setState(() {
        _searching = true;
        _errorText = null;
      });
      try {
        final found = await LocationService.autocompleteCity(query);
        if (!mounted) return;
        setState(() {
          _suggestions = found;
          _searching = false;
          if (found.isEmpty) {
            _errorText = widget.lang.isThai ? 'ไม่พบเมืองที่ค้นหา' : 'No city found';
          }
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _searching = false;
          _errorText = '$e';
        });
      }
    });
  }

  Future<void> _selectSuggestion(Map<String, String> s) async {
    setState(() => _selectingPlace = true);
    try {
      final loc = await LocationService.getPlaceLatLng(s['placeId']!, s['description']!);
      await LocationService.setSavedLocation(
        lat: loc['lat'] as double,
        lng: loc['lng'] as double,
        name: loc['name'] as String,
      );
      await PrayerService.clearCache();
      widget.onLocationSelected(loc['name'] as String);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _selectingPlace = false;
        _errorText = '$e';
      });
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _detecting = true;
      _errorText = null;
    });
    try {
      final loc = await LocationService.detectCurrentLocation();
      if (!mounted) return;
      await LocationService.setSavedLocation(
        lat: loc['lat'] as double,
        lng: loc['lng'] as double,
        name: loc['name'] as String,
      );
      await PrayerService.clearCache();
      widget.onLocationSelected(loc['name'] as String);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _detecting = false;
        _errorText = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = widget.theme;
    final lang = widget.lang;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(width: 40, height: 4,
              decoration: BoxDecoration(color: Colors.grey.shade400, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(lang.isThai ? 'ค้นหาเมือง' : 'Search City',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: theme.textColor)),
          ),
          const SizedBox(height: 12),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _controller,
              autofocus: true,
              style: TextStyle(color: theme.textColor),
              textInputAction: TextInputAction.search,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                hintText: lang.isThai ? 'เช่น สงขลา, Bangkok, London' : 'e.g. Songkhla, Bangkok, London',
                hintStyle: TextStyle(color: theme.subTextColor),
                prefixIcon: Icon(Icons.search, color: theme.subTextColor),
                filled: true,
                fillColor: theme.isDark ? Colors.white10 : const Color(0xFFF2F2F7),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _detecting ? null : _useCurrentLocation,
                icon: _detecting
                    ? SizedBox(
                        width: 16, height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: theme.iconColor))
                    : Icon(Icons.my_location, color: theme.iconColor, size: 18),
                label: Text(
                  _detecting
                      ? (lang.isThai ? 'กำลังค้นหาตำแหน่ง...' : 'Detecting...')
                      : (lang.isThai ? 'ใช้ตำแหน่งปัจจุบัน' : 'Use current location'),
                  style: TextStyle(color: theme.iconColor),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: theme.iconColor.withOpacity(0.4)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          if (_searching)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),

          if (_selectingPlace)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),

          if (_errorText != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Text(_errorText!,
                  style: TextStyle(color: Colors.red.shade400, fontSize: 13)),
            ),

          if (!_searching && !_selectingPlace && _suggestions.isNotEmpty)
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.only(top: 4),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final s = _suggestions[index];
                  return ListTile(
                    leading: Icon(Icons.location_on_outlined, color: theme.iconColor),
                    title: Text(s['description']!,
                        style: TextStyle(color: theme.textColor, fontSize: 14)),
                    onTap: () => _selectSuggestion(s),
                  );
                },
              ),
            ),

          if (_suggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text('Powered by Google',
                    style: TextStyle(fontSize: 10, color: theme.subTextColor)),
              ),
            ),

          SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
        ],
      ),
    );
  }
}