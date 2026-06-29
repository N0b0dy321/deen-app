import 'package:flutter/material.dart';
import '../services/prayer_service.dart';
import '../services/language_service.dart';
import '../services/theme_service.dart';
import 'package:DEEN/services/Setting_Time.dart';

class PrayerTimesPage extends StatefulWidget {
  const PrayerTimesPage({super.key});
  @override
  State<PrayerTimesPage> createState() => _PrayerTimesPageState();
}

class _PrayerTimesPageState extends State<PrayerTimesPage> {
  bool _isLoading = true;
  Map<String, dynamic>? _prayerData;
  final _lang = LanguageService();
  final _theme = ThemeService();

  final List<Map<String, dynamic>> _prayerInfo = [
    {'key': 'Fajr', 'label': 'Fajr', 'labelTh': 'ฟัจร์', 'icon': Icons.wb_twilight, 'arabic': 'الفجر'},
    {'key': 'Sunrise', 'label': 'Sunrise', 'labelTh': 'ดวงอาทิตย์ขึ้น', 'icon': Icons.wb_sunny_outlined, 'arabic': 'الشروق'},
    {'key': 'Dhuhr', 'label': 'Dhuhr', 'labelTh': 'ซุฮร์', 'icon': Icons.wb_sunny, 'arabic': 'الظهر'},
    {'key': 'Asr', 'label': 'Asr', 'labelTh': 'อัศร์', 'icon': Icons.sunny_snowing, 'arabic': 'العصر'},
    {'key': 'Maghrib', 'label': 'Maghrib', 'labelTh': 'มัฆริบ', 'icon': Icons.nights_stay_outlined, 'arabic': 'المغرب'},
    {'key': 'Isha', 'label': 'Isha', 'labelTh': 'อิชาอ์', 'icon': Icons.nightlight, 'arabic': 'العشาء'},
  ];

  @override
  void initState() {
    super.initState();
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
    _loadPrayerTimes();
  }

  @override
  void dispose() {
    _lang.removeListener(() => setState(() {}));
    _theme.removeListener(() => setState(() {}));
    super.dispose();
  }

  Future<void> _loadPrayerTimes() async {
    setState(() => _isLoading = true);
    final data = await PrayerService.getPrayerTimes();
    setState(() { _prayerData = data; _isLoading = false; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(child: _isLoading
            ? Center(child: CircularProgressIndicator(color: _theme.iconColor))
            : _prayerData == null ? _buildError() : _buildContent()),
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
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22)),
              GestureDetector(
                onTap: () async {
                  final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
                  if (result == true) _loadPrayerTimes();
                },
                child: const Icon(Icons.settings, color: Colors.white70, size: 26)),
            ]),
            const SizedBox(height: 8),
            const Icon(Icons.access_time, color: Color(0xFFFFD700), size: 40),
            const SizedBox(height: 8),
            Text(_lang.prayerTimes,
                style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            if (_prayerData != null)
              Text(_prayerData!['date'], style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  Widget _buildContent() {
    final timings = _prayerData!['timings'];
    final nextPrayer = _prayerData!['nextPrayer'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(children: [
        // Next Prayer Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _theme.isDark
                  ? [const Color(0xFF0D3B1E), const Color(0xFF1A6B35)]
                  : [const Color(0xFF1B5E20), const Color(0xFF43A047)],
              begin: Alignment.centerLeft, end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: _theme.isDark ? Border.all(color: const Color(0xFF2ECC71).withOpacity(0.3)) : null,
          ),
          child: Column(children: [
            Text(_lang.nextPrayerLabel, style: const TextStyle(color: Colors.white70, fontSize: 13)),
            const SizedBox(height: 8),
            Text(nextPrayer['name'], style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
            Text(nextPrayer['time'], style: const TextStyle(color: Colors.white, fontSize: 22)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
              child: Text(nextPrayer['timeUntil'], style: const TextStyle(color: Colors.white, fontSize: 13)),
            ),
          ]),
        ),

        const SizedBox(height: 16),

        ..._prayerInfo.map((prayer) {
          final time = timings[prayer['key']] ?? '-';
          final isNext = nextPrayer['name'] == prayer['label'];
          final label = _lang.isThai ? prayer['labelTh'] : prayer['label'];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: isNext ? const Color(0xFF1B5E20) : _theme.cardColor,
              borderRadius: BorderRadius.circular(16),
              border: !isNext && _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
              boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: Row(children: [
              Icon(prayer['icon'] as IconData,
                  color: isNext ? Colors.white : _theme.iconColor, size: 24),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,
                    color: isNext ? Colors.white : _theme.textColor)),
                Text(prayer['arabic'], style: TextStyle(fontSize: 12,
                    color: isNext ? Colors.white70 : _theme.subTextColor)),
              ])),
              Text(time, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,
                  color: isNext ? Colors.white : _theme.iconColor)),
              if (isNext)
                const Padding(padding: EdgeInsets.only(left: 8),
                  child: Icon(Icons.notifications_active, color: Colors.white, size: 18)),
            ]),
          );
        }),

        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _loadPrayerTimes,
            icon: const Icon(Icons.refresh, color: Colors.white),
            label: Text(_lang.refresh, style: const TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B5E20),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
          ),
        ),
      ]),
    );
  }

  Widget _buildError() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      const Icon(Icons.error_outline, color: Colors.red, size: 48),
      const SizedBox(height: 16),
      Text(_lang.couldNotLoad, style: TextStyle(color: _theme.subTextColor)),
      const SizedBox(height: 16),
      ElevatedButton(onPressed: _loadPrayerTimes,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
        child: Text(_lang.tryAgain, style: const TextStyle(color: Colors.white))),
    ]));
  }
}