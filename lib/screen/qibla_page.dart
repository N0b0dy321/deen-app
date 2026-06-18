import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';

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

  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  @override
  void initState() {
    super.initState();
    _initialize();
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

  double _calculateDistance(double myLat, double myLng) {
    return Geolocator.distanceBetween(myLat, myLng, _kaabaLat, _kaabaLng) / 1000;
  }

  Future<void> _getLocationAndCalculateQibla() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permission denied';
            _isLoading = false;
          });
          return;
        }
      }
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _qiblaDirection = _calculateQibla(position.latitude, position.longitude);
        _distanceToKaaba = _calculateDistance(position.latitude, position.longitude);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not get location: $e';
        _isLoading = false;
      });
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
      backgroundColor: const Color(0xFFF0F0F0),
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: Color(0xFF1B5E20)))
                : _errorMessage.isNotEmpty
                    ? _buildError()
                    : _buildCompass(),
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
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Icon(Icons.explore, color: Color(0xFFFFD700), size: 40),
              const SizedBox(height: 8),
              const Text('Qibla Finder',
                  style: TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (_distanceToKaaba != null)
                Text('${_distanceToKaaba!.toStringAsFixed(0)} km from Makkah',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCompass() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 16),

          // Status
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: _isFacingQibla ? Colors.green.withValues(alpha: 0.1) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: _isFacingQibla ? Colors.green : Colors.grey.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isFacingQibla ? Icons.check_circle : Icons.rotate_right,
                  color: _isFacingQibla ? Colors.green : Colors.grey,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  _isFacingQibla ? 'Facing Qibla! 🕋' : 'Rotate to find Qibla',
                  style: TextStyle(
                      color: _isFacingQibla ? Colors.green : Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // เข็มทิศ
          SizedBox(
            width: 280,
            height: 280,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // วงกลม + N S E W + เส้นขีด หมุนตามเข็มทิศจริง
                Transform.rotate(
                  angle: _compassAngle,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // วงกลมพื้นหลัง
                      Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),

                      // ทิศหลัก N S E W
                      _buildDirection('N', 0, -110),
                      _buildDirection('S', 0, 110),
                      _buildDirection('E', 110, 0),
                      _buildDirection('W', -110, 0),

                      // เส้นขีด
                      ...List.generate(36, (i) {
                        final angle = i * 10 * pi / 180;
                        final isMain = i % 9 == 0;
                        return Transform.rotate(
                          angle: angle,
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Container(
                              width: isMain ? 2 : 1,
                              height: isMain ? 16 : 10,
                              margin: const EdgeInsets.only(top: 16),
                              color: isMain
                                  ? const Color(0xFF1B5E20)
                                  : Colors.grey.withValues(alpha: 0.4),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),

                // ลูกศร Qibla (ไม่หมุนตามเข็มทิศ)
                Transform.rotate(
                  angle: _arrowAngle,
                  child: Icon(
                    Icons.navigation,
                    color: _isFacingQibla ? Colors.green : const Color(0xFF1B5E20),
                    size: 80,
                  ),
                ),

                // ไอคอนกะอ์บะฮ์ตรงกลาง
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: _isFacingQibla ? Colors.green : const Color(0xFF1B5E20),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.mosque, color: Colors.white, size: 20),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ข้อมูล
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.explore,
                  label: 'Qibla Direction',
                  value: _qiblaDirection != null
                      ? '${_qiblaDirection!.toStringAsFixed(1)}°'
                      : '-',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.compass_calibration,
                  label: 'Compass',
                  value: _compassHeading != null
                      ? '${_compassHeading!.toStringAsFixed(1)}°'
                      : '-',
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: const [
                Icon(Icons.info_outline, color: Color(0xFF1B5E20), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Hold your phone flat and away from metal objects for accurate reading.',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirection(String label, double x, double y) {
    return Transform.translate(
      offset: Offset(x, y),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: label == 'N' ? const Color(0xFF1B5E20) : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF1B5E20), size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(_errorMessage,
              style: const TextStyle(color: Colors.grey),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _initialize,
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
            child: const Text('Try Again', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}