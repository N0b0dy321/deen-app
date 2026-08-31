import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import '../services/language_service.dart';
import '../services/theme_service.dart';

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});
  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _qiblaDirection;
  double? _compassHeading;
  bool _isLoading = true;
  String _errorMessage = '';
  double? _distanceToKaaba;
  final _lang = LanguageService();
  final _theme = ThemeService();

  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  @override
  void initState() {
    super.initState();
    _lang.addListener(() => setState(() {}));
    _theme.addListener(() => setState(() {}));
    _initialize();
  }

  @override
  void dispose() {
    _lang.removeListener(() => setState(() {}));
    _theme.removeListener(() => setState(() {}));
    super.dispose();
  }

  Future<void> _initialize() async {
    await _getLocationAndCalculateQibla();
    _listenCompass();
  }

  double _calculateQibla(double myLat, double myLng) {
    final dLng = (_kaabaLng - myLng) * pi / 180;
    final lat1 = myLat * pi / 180;
    final lat2 = _kaabaLat * pi / 180;
    final x = sin(dLng) * cos(lat2);
    final y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLng);
    return (atan2(x, y) * 180 / pi + 360) % 360;
  }

  double _calculateDistance(double myLat, double myLng) =>
      Geolocator.distanceBetween(myLat, myLng, _kaabaLat, _kaabaLng) / 1000;

  Future<void> _getLocationAndCalculateQibla() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() { _errorMessage = 'Location permission denied'; _isLoading = false; });
          return;
        }
      }
      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _qiblaDirection = _calculateQibla(position.latitude, position.longitude);
        _distanceToKaaba = _calculateDistance(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      setState(() { _errorMessage = 'Could not get location: $e'; _isLoading = false; });
    }
  }

  void _listenCompass() {
    FlutterCompass.events?.listen((event) {
      if (mounted) setState(() => _compassHeading = event.heading);
    });
  }

  double get _arrowAngle {
    if (_compassHeading == null || _qiblaDirection == null) return 0;
    return (_qiblaDirection! - _compassHeading!) * pi / 180;
  }

  double get _compassAngle {
    if (_compassHeading == null) return 0;
    return -_compassHeading! * pi / 180;
  }

  bool get _isFacingQibla {
    if (_compassHeading == null || _qiblaDirection == null) return false;
    final diff = ((_qiblaDirection! - _compassHeading!) % 360 + 360) % 360;
    return diff < 5 || diff > 355;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _theme.bgColor,
      body: Column(children: [
        _buildHeader(context),
        Expanded(child: _isLoading
            ? Center(child: CircularProgressIndicator(color: _theme.iconColor))
            : _errorMessage.isNotEmpty ? _buildError() : _buildCompass()),
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
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24.r), bottomRight: Radius.circular(24.r)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(children: [
            Row(children: [
              GestureDetector(onTap: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios, color: Colors.white, size: 22.sp)),
            ]),
            SizedBox(height: 8.h),
            Icon(Icons.explore, color: Color(0xFFFFD700), size: 40.sp),
            SizedBox(height: 8.h),
            Text(_lang.qiblaTitle,
                style: TextStyle(color: Color(0xFFFFD700), fontSize: 22.sp, fontWeight: FontWeight.bold)),
            SizedBox(height: 4.h),
            if (_distanceToKaaba != null)
              Text('${_distanceToKaaba!.toStringAsFixed(0)} ${_lang.fromMakkah}',
                  style: TextStyle(color: Colors.white70, fontSize: 13.sp)),
            SizedBox(height: 16.h),
          ]),
        ),
      ),
    );
  }

  Widget _buildCompass() {
    final compassBg = _theme.isDark ? const Color(0xFF1A2535) : Colors.white;
    final compassShadow = _theme.isDark ? Colors.black54 : Colors.black12;

    return SingleChildScrollView(
      padding: EdgeInsets.all(24.w),
      child: Column(children: [
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: _isFacingQibla
                ? Colors.green.withOpacity(0.15)
                : _theme.cardColor,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: _isFacingQibla ? Colors.green : _theme.borderColor.withOpacity(0.5)),
          ),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(_isFacingQibla ? Icons.check_circle : Icons.rotate_right,
                color: _isFacingQibla ? Colors.green : _theme.subTextColor, size: 18.sp),
            SizedBox(width: 8.w),
            Text(_isFacingQibla ? _lang.facingQibla : _lang.rotateQibla,
                style: TextStyle(color: _isFacingQibla ? Colors.green : _theme.subTextColor, fontWeight: FontWeight.bold)),
          ]),
        ),

        SizedBox(height: 40.h),

        SizedBox(width: 280.w, height: 280.h,
          child: Stack(alignment: Alignment.center, children: [
            Transform.rotate(angle: _compassAngle,
              child: Stack(alignment: Alignment.center, children: [
                Container(width: 280.w, height: 280.h,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: compassBg,
                    boxShadow: [BoxShadow(color: compassShadow, blurRadius: 20, offset: const Offset(0, 5))])),
                _buildDirection('N', 0, -110),
                _buildDirection('S', 0, 110),
                _buildDirection('E', 110, 0),
                _buildDirection('W', -110, 0),
                ...List.generate(36, (i) {
                  final angle = i * 10 * pi / 180;
                  final isMain = i % 9 == 0;
                  return Transform.rotate(angle: angle,
                    child: Align(alignment: Alignment.topCenter,
                      child: Container(width: isMain ? 2 : 1, height: isMain ? 16 : 10,
                        margin: EdgeInsets.only(top: 16.h),
                        color: isMain ? _theme.iconColor : _theme.subTextColor.withOpacity(0.4))));
                }),
              ]),
            ),
            Transform.rotate(angle: _arrowAngle,
              child: Icon(Icons.navigation,
                  color: _isFacingQibla ? Colors.green : _theme.iconColor, size: 80.sp)),
            Container(width: 36.w, height: 36.h,
              decoration: BoxDecoration(
                color: _isFacingQibla ? Colors.green : _theme.iconColor,
                shape: BoxShape.circle),
              child: Icon(Icons.mosque, color: Colors.white, size: 20.sp)),
          ]),
        ),

        SizedBox(height: 32.h),

        Row(children: [
          Expanded(child: _buildInfoCard(icon: Icons.explore, label: _lang.qiblaDirection,
              value: _qiblaDirection != null ? '${_qiblaDirection!.toStringAsFixed(1)}°' : '-')),
          SizedBox(width: 12.w),
          Expanded(child: _buildInfoCard(icon: Icons.compass_calibration, label: _lang.compass,
              value: _compassHeading != null ? '${_compassHeading!.toStringAsFixed(1)}°' : '-')),
        ]),

        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: BorderRadius.circular(16.r),
            border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
            boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            Icon(Icons.info_outline, color: _theme.iconColor, size: 20.sp),
            SizedBox(width: 10.w),
            Expanded(child: Text(_lang.holdPhone, style: TextStyle(fontSize: 12.sp, color: _theme.subTextColor))),
          ]),
        ),
      ]),
    );
  }

  Widget _buildDirection(String label, double x, double y) {
    return Transform.translate(offset: Offset(x, y),
      child: Text(label, style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold,
          color: label == 'N' ? _theme.iconColor : _theme.subTextColor)));
  }

  Widget _buildInfoCard({required IconData icon, required String label, required String value}) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: _theme.cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
        boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(children: [
        Icon(icon, color: _theme.iconColor, size: 24.sp),
        SizedBox(height: 8.h),
        Text(value, style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: _theme.textColor)),
        SizedBox(height: 4.h),
        Text(label, style: TextStyle(fontSize: 11.sp, color: _theme.subTextColor), textAlign: TextAlign.center),
      ]),
    );
  }

  Widget _buildError() {
    return Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(Icons.error_outline, color: Colors.red, size: 48.sp),
      SizedBox(height: 16.h),
      Text(_errorMessage, style: TextStyle(color: _theme.subTextColor), textAlign: TextAlign.center),
      SizedBox(height: 16.h),
      ElevatedButton(onPressed: _initialize,
        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
        child: Text(_lang.tryAgain, style: const TextStyle(color: Colors.white))),
    ]));
  }
}