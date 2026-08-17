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

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedTimezone = 'Asia/Bangkok';
  String _selectedMethod = '16';
  bool _notificationEnabled = true;
  double _quranFontSize = 24.0;
  String _selectedAzanId = 'azan_makkah';
  String _pendingLang = 'th'; // ภาษาที่รอ save
  final _theme = ThemeService();
  final _lang = LanguageService();

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
    super.dispose();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final azanId = await AzanService.getSelectedAzanId();
    setState(() {
      _selectedTimezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      _selectedMethod = prefs.getString('method') ?? '16';
      _notificationEnabled = prefs.getBool('notification') ?? true;
      _quranFontSize = prefs.getDouble('quran_font_size') ?? 24.0;
      _selectedAzanId = azanId;
      _pendingLang = _lang.lang; // โหลดค่าภาษาปัจจุบัน
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('timezone', _selectedTimezone);
    await prefs.setString('method', _selectedMethod);
    await prefs.setBool('notification', _notificationEnabled);
    await prefs.setDouble('quran_font_size', _quranFontSize);
    await AzanService.setSelectedAzan(_selectedAzanId);
    await PrayerService.clearCache();
    if (!_notificationEnabled) await NotificationService.cancelAll();

    // Apply ภาษาตอน save
    await _lang.setLang(_pendingLang);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_pendingLang == 'th' ? 'บันทึกแล้ว!' : 'Settings saved!'),
        backgroundColor: const Color(0xFF1B5E20),
        duration: const Duration(seconds: 2),
      ));
      Navigator.pop(context, true);
    }
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
            onTap: () {
              setState(() => _selectedTimezone = tz['value']!);
              Navigator.pop(context);
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
            onTap: () {
              setState(() => _selectedMethod = m['value']!);
              Navigator.pop(context);
            },
          );
        }).toList())),
      ]),
    );
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
                    final isSelected = _pendingLang == lang['code'];
                    return ListTile(
                      leading: Text(lang['flag']!, style: const TextStyle(fontSize: 24)),
                      title: Text(lang['native']!, style: TextStyle(color: _theme.textColor, fontWeight: FontWeight.w500)),
                      subtitle: Text(lang['name']!, style: TextStyle(color: _theme.subTextColor, fontSize: 12)),
                      trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
                      onTap: () {
                        setState(() => _pendingLang = lang['code']!);
                        Navigator.pop(context);
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

  void _showAzanSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: _theme.cardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Column(
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
            return ListTile(
              leading: Icon(Icons.volume_up_outlined,
                  color: isSelected ? _theme.iconColor : _theme.subTextColor),
              title: Text(name, style: TextStyle(color: _theme.textColor)),
              trailing: isSelected ? Icon(Icons.check_circle, color: _theme.iconColor) : null,
              onTap: () {
                setState(() => _selectedAzanId = id);
                Navigator.pop(context);
              },
            );
          }),
          const SizedBox(height: 16),
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
        title: Text(_lang.isThai ? 'ตั้งค่า' : 'Settings',
            style: TextStyle(color: textColor, fontSize: 17, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: _saveSettings,
            child: Text(_lang.isThai ? 'บันทึก' : 'Save',
                style: TextStyle(color: green, fontWeight: FontWeight.w600, fontSize: 15)),
          ),
        ],
      ),
      body: ListView(children: [

        // ── APPEARANCE ──
        _sectionHeader(_lang.isThai ? 'หน้าตา' : 'Appearance'),
        _buildGroup(cardBg, divColor, [
          // Dark Mode → เปลี่ยนทันที
          _buildSwitchRow(
            icon: Icons.dark_mode_outlined,
            iconColor: Colors.indigo,
            label: _lang.isThai ? 'โหมดกลางคืน' : 'Dark Mode',
            value: _theme.isDark,
            textColor: textColor,
            onChanged: (_) => _theme.toggle(),
          ),
          // Language → รอ Save
          _buildNavRow(
            icon: Icons.language,
            iconColor: Colors.blue,
            label: _lang.isThai ? 'ภาษา' : 'Language',
            value: '${LanguageService.availableLanguages.firstWhere((l) => l['code'] == _pendingLang)['flag']} ${LanguageService.availableLanguages.firstWhere((l) => l['code'] == _pendingLang)['native']}',
            textColor: textColor,
            subColor: subColor,
            onTap: _showLanguageSheet,
          ),
        ]),

        // ── AL-QURAN ──
        _sectionHeader(_lang.isThai ? 'อัลกุรอาน' : 'Al-Quran'),
        _buildGroup(cardBg, divColor, [
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
                  onChanged: (v) => setState(() => _quranFontSize = v)),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('A', style: TextStyle(fontSize: 12, color: subColor)),
                Text('A', style: TextStyle(fontSize: 20, color: subColor, fontWeight: FontWeight.bold)),
              ]),
            ]),
          ),
        ]),

        // ── PRAYER TIMES ──
        _sectionHeader(_lang.isThai ? 'เวลาละหมาด' : 'Prayer Times'),
        _buildGroup(cardBg, divColor, [
          _buildSwitchRow(
            icon: Icons.notifications_outlined,
            iconColor: Colors.red,
            label: _lang.isThai ? 'แจ้งเตือนละหมาด' : 'Prayer Notification',
            value: _notificationEnabled,
            textColor: textColor,
            onChanged: (v) => setState(() => _notificationEnabled = v),
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

        // ── TESTING ──
        _sectionHeader(_lang.isThai ? 'ทดสอบ' : 'Testing'),
        _buildGroup(cardBg, divColor, [
          _buildNavRow(
            icon: Icons.notifications_active_outlined,
            iconColor: Colors.orange,
            label: _lang.isThai ? 'ทดสอบการแจ้งเตือน' : 'Test Notification',
            value: '', textColor: textColor, subColor: subColor,
            onTap: () async {
              await NotificationService.showTest();
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(_lang.isThai ? 'ส่งแจ้งเตือนแล้ว!' : 'Notification sent!'),
                backgroundColor: const Color(0xFF1B5E20)));
            },
          ),
          _buildNavRow(
            icon: Icons.alarm_outlined,
            iconColor: Colors.deepOrange,
            label: _lang.isThai ? 'ทดสอบ Schedule (1 นาที)' : 'Schedule Test (1 min)',
            value: '', textColor: textColor, subColor: subColor,
            onTap: () async {
              await NotificationService.scheduleTestIn1Min();
              if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(_lang.isThai ? 'รอ 1 นาทีครับ 🔔' : 'Wait 1 minute 🔔'),
                backgroundColor: const Color(0xFF1B5E20)));
            },
          ),
        ]),

        // ── ABOUT ──
        _sectionHeader(_lang.isThai ? 'เกี่ยวกับ' : 'About'),
        _buildGroup(cardBg, divColor, [
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

        const SizedBox(height: 8),
        Center(child: Text('DEEN v1.0.0 • Made with ❤️',
            style: TextStyle(fontSize: 12, color: subColor))),
        const SizedBox(height: 32),
      ]),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 6),
      child: Text(title.toUpperCase(),
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600,
              color: _theme.subTextColor, letterSpacing: 0.8)),
    );
  }

  Widget _buildGroup(Color bg, Color divColor, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        boxShadow: _theme.isDark ? [] : [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(children: [
        for (int i = 0; i < children.length; i++) ...[
          children[i],
          if (i < children.length - 1)
            Divider(height: 1, indent: 56, color: divColor),
        ]
      ]),
    );
  }

  Widget _buildSwitchRow({
    required IconData icon, required Color iconColor, required String label,
    required bool value, required Color textColor, required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        _iconBox(icon, iconColor),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 15, color: textColor))),
        Switch(value: value, onChanged: onChanged,
            activeColor: Colors.white, activeTrackColor: _theme.iconColor),
      ]),
    );
  }

  Widget _buildNavRow({
    required IconData icon, required Color iconColor, required String label,
    required String value, required Color textColor, required Color subColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(children: [
          _iconBox(icon, iconColor),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: TextStyle(fontSize: 15, color: textColor))),
          if (value.isNotEmpty)
            Text(value, style: TextStyle(fontSize: 14, color: subColor)),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right, color: subColor, size: 18),
        ]),
      ),
    );
  }

  Widget _iconBox(IconData icon, Color color) {
    return Container(
      width: 32, height: 32,
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }
}