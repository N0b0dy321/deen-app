import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  @override
  void initState() {
    super.initState();
    _theme.addListener(() => setState(() {}));
    _lang.addListener(() => setState(() {}));
    _loadSettings();
  }

  @override
  void dispose() {
    _theme.removeListener(() => setState(() {}));
    _lang.removeListener(() => setState(() {}));
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

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lang.isThai ? 'บันทึกแล้ว!' : 'Settings saved!'),
          backgroundColor: const Color(0xFF1B5E20),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.pop(context, true);
    }
  }

  Future<void> _testNotification() async {
    await NotificationService.showTest();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lang.isThai ? 'ส่งการแจ้งเตือนทดสอบแล้ว!' : 'Test notification sent!'),
          backgroundColor: const Color(0xFF1B5E20),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: _theme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(children: [
          const Icon(Icons.mosque, color: Color(0xFF1B5E20), size: 28),
          const SizedBox(width: 10),
          Text('DEEN', style: TextStyle(color: _theme.textColor, fontWeight: FontWeight.bold, fontSize: 20)),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _aboutRow(Icons.info_outline, _lang.isThai ? 'เวอร์ชัน' : 'Version', '1.0.0'),
            const SizedBox(height: 8),
            _aboutRow(Icons.code, _lang.isThai ? 'พัฒนาด้วย' : 'Built with', 'Flutter'),
            const SizedBox(height: 8),
            _aboutRow(Icons.favorite, _lang.isThai ? 'สร้างด้วยใจ' : 'Made with', '❤️ for Muslims'),
            const SizedBox(height: 16),
            Text(
              _lang.isThai
                  ? 'แอพอิสลามสำหรับชีวิตประจำวัน รวมถึงอัลกุรอาน เวลาละหมาด กิบลัต และอื่นๆ'
                  : 'An Islamic companion app for daily life including Quran, Prayer Times, Qibla and more.',
              style: TextStyle(fontSize: 13, color: _theme.subTextColor, height: 1.5),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_lang.isThai ? 'ปิด' : 'Close',
                style: const TextStyle(color: Color(0xFF1B5E20))),
          ),
        ],
      ),
    );
  }

  Widget _aboutRow(IconData icon, String label, String value) {
    return Row(children: [
      Icon(icon, size: 16, color: _theme.iconColor),
      const SizedBox(width: 8),
      Text('$label: ', style: TextStyle(fontSize: 13, color: _theme.subTextColor)),
      Text(value, style: TextStyle(fontSize: 13, color: _theme.textColor, fontWeight: FontWeight.w500)),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── APPEARANCE ──
                  _sectionLabel(_lang.isThai ? '🎨 หน้าตา' : '🎨 Appearance'),
                  const SizedBox(height: 8),
                  _buildCard(children: [
                    _buildToggleRow(
                      icon: _theme.isDark ? Icons.dark_mode : Icons.light_mode,
                      label: _lang.isThai ? 'โหมดกลางคืน' : 'Dark Mode',
                      subtitle: _lang.isThai ? 'เปลี่ยนธีมแอพ' : 'Switch app theme',
                      value: _theme.isDark,
                      onChanged: (_) => _theme.toggle(),
                    ),
                    _divider(),
                    _buildActionRow(
                      icon: Icons.language,
                      label: _lang.isThai ? 'ภาษา' : 'Language',
                      subtitle: _lang.isThai ? 'ภาษาไทย' : 'English',
                      trailing: GestureDetector(
                        onTap: () => _lang.setLang(_lang.isThai ? 'en' : 'th'),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _theme.iconColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _lang.isThai ? '🇹🇭 TH' : '🇬🇧 EN',
                            style: TextStyle(color: _theme.iconColor, fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── QURAN ──
                  _sectionLabel(_lang.isThai ? '📖 อัลกุรอาน' : '📖 Al-Quran'),
                  const SizedBox(height: 8),
                  _buildCard(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Row(children: [
                          Icon(Icons.format_size, color: _theme.iconColor, size: 22),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(_lang.isThai ? 'ขนาดตัวอักษรอาหรับ' : 'Arabic Font Size',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _theme.textColor)),
                            Text(_lang.isThai ? 'ปรับขนาดตัวอักษรในอัลกุรอาน' : 'Adjust Quran text size',
                                style: TextStyle(fontSize: 12, color: _theme.subTextColor)),
                          ])),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _theme.iconColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text('${_quranFontSize.toInt()}px',
                                style: TextStyle(color: _theme.iconColor, fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ]),
                        const SizedBox(height: 8),
                        Center(
                          child: Text('بِسْمِ ٱللَّهِ',
                              style: TextStyle(fontSize: _quranFontSize, color: _theme.textColor, height: 1.8),
                              textDirection: TextDirection.rtl),
                        ),
                        SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            activeTrackColor: _theme.iconColor,
                            inactiveTrackColor: _theme.iconColor.withOpacity(0.2),
                            thumbColor: _theme.iconColor,
                            overlayColor: _theme.iconColor.withOpacity(0.1),
                          ),
                          child: Slider(
                            value: _quranFontSize, min: 16.0, max: 36.0, divisions: 10,
                            onChanged: (v) => setState(() => _quranFontSize = v),
                          ),
                        ),
                        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                          Text('A', style: TextStyle(fontSize: 12, color: _theme.subTextColor)),
                          Text('A', style: TextStyle(fontSize: 20, color: _theme.subTextColor, fontWeight: FontWeight.bold)),
                        ]),
                      ]),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── PRAYER TIMES ──
                  _sectionLabel(_lang.isThai ? '🕌 เวลาละหมาด' : '🕌 Prayer Times'),
                  const SizedBox(height: 8),
                  _buildCard(children: [
                    _buildToggleRow(
                      icon: Icons.notifications,
                      label: _lang.isThai ? 'แจ้งเตือนละหมาด' : 'Prayer Notification',
                      subtitle: _lang.isThai ? 'แจ้งเตือนตอนเวลาละหมาด' : 'Notify at prayer time',
                      value: _notificationEnabled,
                      onChanged: (v) => setState(() => _notificationEnabled = v),
                    ),
                    _divider(),
                    _buildActionRow(
                      icon: Icons.notifications_active,
                      label: _lang.isThai ? 'ทดสอบการแจ้งเตือน' : 'Test Notification',
                      subtitle: _lang.isThai ? 'กดเพื่อทดสอบเสียงอาซาน' : 'Tap to test azan sound',
                      trailing: Icon(Icons.chevron_right, color: _theme.subTextColor),
                      onTap: _testNotification,
                    ),
                    _divider(),
                    _buildActionRow(
                      icon: Icons.alarm,
                      label: _lang.isThai ? 'ทดสอบ Schedule (1 นาที)' : 'Schedule Test (1 min)',
                      subtitle: _lang.isThai ? 'แจ้งเตือนหลัง 1 นาที เพื่อทดสอบระบบ' : 'Notification after 1 min to test system',
                      trailing: Icon(Icons.chevron_right, color: _theme.subTextColor),
                      onTap: () async {
                        await NotificationService.scheduleTestIn1Min();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(_lang.isThai
                                  ? 'ตั้งเวลาแล้ว! รอ 1 นาทีครับ 🔔'
                                  : 'Scheduled! Wait 1 minute 🔔'),
                              backgroundColor: const Color(0xFF1B5E20),
                              duration: const Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                    ),
                    _divider(),
                    _buildDropdownRow(
                      icon: Icons.access_time,
                      label: _lang.isThai ? 'เขตเวลา' : 'Timezone',
                      value: _selectedTimezone,
                      items: _timezones,
                      onChanged: (v) => setState(() => _selectedTimezone = v!),
                    ),
                    _divider(),
                    _buildDropdownRow(
                      icon: Icons.calculate,
                      label: _lang.isThai ? 'วิธีคำนวณ' : 'Calculation Method',
                      value: _selectedMethod,
                      items: _methods,
                      onChanged: (v) => setState(() => _selectedMethod = v!),
                    ),
                  ]),

                  const SizedBox(height: 20),

                  // ── AZAN SOUND ──
                  _sectionLabel(_lang.isThai ? '🔊 เสียงอาซาน' : '🔊 Azan Sound'),
                  const SizedBox(height: 8),
                  _buildCard(children: [
                    ...AzanService.azanList.asMap().entries.map((entry) {
                      final i = entry.key;
                      final azan = entry.value;
                      final id = azan['id']!;
                      final name = _lang.isThai ? azan['nameTh']! : azan['name']!;
                      final isSelected = _selectedAzanId == id;

                      return Column(children: [
                        if (i > 0) _divider(),
                        InkWell(
                          onTap: () => setState(() => _selectedAzanId = id),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            child: Row(children: [
                              // Radio button
                              Container(
                                width: 24, height: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: _theme.iconColor, width: 2),
                                  color: isSelected ? _theme.iconColor : Colors.transparent,
                                ),
                                child: isSelected
                                    ? const Icon(Icons.check, color: Colors.white, size: 14)
                                    : null,
                              ),
                              const SizedBox(width: 14),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                Text(name, style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: _theme.textColor)),
                                Text(
                                  _lang.isThai ? 'ไฟล์เสียงในตัวเครื่อง' : 'Built-in sound',
                                  style: TextStyle(fontSize: 12, color: _theme.subTextColor),
                                ),
                              ])),
                              if (isSelected)
                                Icon(Icons.volume_up, color: _theme.iconColor, size: 22),
                            ]),
                          ),
                        ),
                      ]);
                    }),
                  ]),

                  const SizedBox(height: 20),

                  // ── ABOUT ──
                  _sectionLabel(_lang.isThai ? 'ℹ️ เกี่ยวกับ' : 'ℹ️ About'),
                  const SizedBox(height: 8),
                  _buildCard(children: [
                    _buildActionRow(
                      icon: Icons.info_outline,
                      label: _lang.isThai ? 'เกี่ยวกับแอพ' : 'About App',
                      subtitle: _lang.isThai ? 'เวอร์ชัน 1.0.0' : 'Version 1.0.0',
                      trailing: Icon(Icons.chevron_right, color: _theme.subTextColor),
                      onTap: _showAboutDialog,
                    ),
                    _divider(),
                    _buildActionRow(
                      icon: Icons.star_outline,
                      label: _lang.isThai ? 'ให้คะแนนแอพ' : 'Rate App',
                      subtitle: _lang.isThai ? 'ถ้าชอบแอพนี้ช่วยให้คะแนนด้วยนะ' : 'Enjoy the app? Leave a review!',
                      trailing: Icon(Icons.chevron_right, color: _theme.subTextColor),
                      onTap: () {},
                    ),
                    _divider(),
                    _buildActionRow(
                      icon: Icons.share_outlined,
                      label: _lang.isThai ? 'แชร์แอพ' : 'Share App',
                      subtitle: _lang.isThai ? 'แนะนำให้เพื่อนๆ' : 'Share with friends',
                      trailing: Icon(Icons.chevron_right, color: _theme.subTextColor),
                      onTap: () {},
                    ),
                  ]),

                  const SizedBox(height: 32),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveSettings,
                      icon: const Icon(Icons.save, color: Colors.white),
                      label: Text(
                        _lang.isThai ? 'บันทึก' : 'Save Settings',
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(child: Text('DEEN v1.0.0',
                      style: TextStyle(fontSize: 12, color: _theme.subTextColor))),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String label) {
    return Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold,
        color: _theme.subTextColor, letterSpacing: 0.5));
  }

  Widget _buildCard({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: _theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
        boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(children: children),
    );
  }

  Widget _divider() {
    return Divider(height: 1, indent: 54,
        color: _theme.isDark ? ThemeService.darkBorder : Colors.grey.shade200);
  }

  Widget _buildToggleRow({
    required IconData icon, required String label, required String subtitle,
    required bool value, required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(color: _theme.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: _theme.iconColor, size: 20)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _theme.textColor)),
          Text(subtitle, style: TextStyle(fontSize: 12, color: _theme.subTextColor)),
        ])),
        Switch(value: value, onChanged: onChanged, activeColor: _theme.iconColor),
      ]),
    );
  }

  Widget _buildActionRow({
    required IconData icon, required String label, required String subtitle,
    required Widget trailing, VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(children: [
          Container(width: 38, height: 38,
            decoration: BoxDecoration(color: _theme.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: _theme.iconColor, size: 20)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _theme.textColor)),
            Text(subtitle, style: TextStyle(fontSize: 12, color: _theme.subTextColor)),
          ])),
          trailing,
        ]),
      ),
    );
  }

  Widget _buildDropdownRow({
    required IconData icon, required String label, required String value,
    required List<Map<String, String>> items, required ValueChanged<String?> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(children: [
        Container(width: 38, height: 38,
          decoration: BoxDecoration(color: _theme.iconColor.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: _theme.iconColor, size: 20)),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: _theme.textColor)),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value, isExpanded: true, dropdownColor: _theme.cardColor,
              icon: Icon(Icons.keyboard_arrow_down, color: _theme.iconColor, size: 18),
              style: TextStyle(fontSize: 12, color: _theme.subTextColor),
              items: items.map((item) => DropdownMenuItem(
                value: item['value'],
                child: Text(item['label']!, style: TextStyle(fontSize: 13, color: _theme.textColor)),
              )).toList(),
              onChanged: onChanged,
            ),
          ),
        ])),
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
              : [const Color(0xFF1B5E20), const Color(0xFF2E7D32)],
        ),
        borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22)),
            ]),
            const SizedBox(height: 8),
            const Icon(Icons.settings, color: Color(0xFFFFD700), size: 40),
            const SizedBox(height: 8),
            Text(_lang.isThai ? 'ตั้งค่า' : 'Settings',
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(_lang.isThai ? 'ปรับแต่งแอพตามใจชอบ' : 'Customize your experience',
                style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }
}