import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/prayer_service.dart';
import '../services/theme_service.dart';
import '../services/language_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _selectedTimezone = 'Asia/Bangkok';
  String _selectedMethod = '16';
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
    setState(() {
      _selectedTimezone = prefs.getString('timezone') ?? 'Asia/Bangkok';
      _selectedMethod = prefs.getString('method') ?? '16';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('timezone', _selectedTimezone);
    await prefs.setString('method', _selectedMethod);
    await PrayerService.clearCache();

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

  @override
  Widget build(BuildContext context) {
    final isDark = _theme.isDark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF0F0F0);
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;
    final subTextColor = isDark ? Colors.white60 : Colors.black54;

    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ── Dark Mode Toggle ──
                  Text(_lang.isThai ? 'ธีม' : 'Theme',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: Row(
                      children: [
                        Icon(isDark ? Icons.dark_mode : Icons.light_mode,
                            color: const Color(0xFF1B5E20), size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            isDark
                                ? (_lang.isThai ? 'โหมดกลางคืน' : 'Dark Mode')
                                : (_lang.isThai ? 'โหมดกลางวัน' : 'Light Mode'),
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: textColor),
                          ),
                        ),
                        Switch(
                          value: isDark,
                          onChanged: (_) => _theme.toggle(),
                          activeColor: const Color(0xFF1B5E20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Timezone ──
                  Text(_lang.isThai ? 'เขตเวลา' : 'Timezone',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedTimezone,
                        isExpanded: true,
                        dropdownColor: cardColor,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1B5E20)),
                        items: _timezones.map((tz) => DropdownMenuItem(
                          value: tz['value'],
                          child: Text(tz['label']!, style: TextStyle(fontSize: 14, color: textColor)),
                        )).toList(),
                        onChanged: (value) => setState(() => _selectedTimezone = value!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── Calculation Method ──
                  Text(_lang.isThai ? 'วิธีคำนวณ' : 'Calculation Method',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 2))],
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedMethod,
                        isExpanded: true,
                        dropdownColor: cardColor,
                        icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF1B5E20)),
                        items: _methods.map((m) => DropdownMenuItem(
                          value: m['value'],
                          child: Text(m['label']!, style: TextStyle(fontSize: 14, color: textColor)),
                        )).toList(),
                        onChanged: (value) => setState(() => _selectedMethod = value!),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Save Button ──
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
        ),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                ),
              ]),
              const SizedBox(height: 8),
              const Icon(Icons.settings, color: Color(0xFFFFD700), size: 40),
              const SizedBox(height: 8),
              Text(
                _lang.isThai ? 'ตั้งค่า' : 'Settings',
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                _lang.isThai ? 'ตั้งค่าเวลาละหมาดและธีม' : 'Prayer time & theme preferences',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}