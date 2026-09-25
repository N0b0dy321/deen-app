import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:math';
import '../services/language_service.dart';
import '../services/theme_service.dart';

// ── ไอคอนกิบลัต (silhouette ขาว: เข็มทิศ + กะอ์บะฮ์) — path เดียวกับที่ใช้
// ในการ์ด "ค้นหากิบลัต" หน้า Home เลย โลโก้ตรงกันทั้งแอป
const String kQiblaIconAsset = 'image/decor/qibla_icon.png';
// ── ไอคอนมัสยิด (silhouette ขาว) — เก็บไว้เป็น fallback เผื่อภาพประกอบ
// กะอ์บะฮ์ด้านล่างโหลดไม่ขึ้น
const String kQiblaMosqueIconAsset = 'image/decor/mosque_icon.png';
// ── ภาพประกอบกะอ์บะฮ์ + มัสยิดฮะรอมเต็มสี (ไม่ใช่ silhouette ขาว ห้ามทาสีทับ)
// ใช้แทนหมุดกลางเข็มทิศ ขยายใหญ่ขึ้นจากเดิมเพื่อให้เห็นรายละเอียด ──
const String kQiblaKaabaIllustrationAsset = 'image/decor/kaaba_illustration.png';
// ── ลายมุมดาวทอง (path เดียวกับหน้าอื่นในแอป) ──
const String kQiblaCornerAsset = 'image/decor/corner_star.png';

List<Widget> _qiblaCornerDecor({double size = 30}) {
  Widget img() => Image.asset(kQiblaCornerAsset, width: size, height: size,
      errorBuilder: (_, __, ___) => const SizedBox.shrink());
  Widget flip(double sx, double sy, Widget child) => Transform(
      alignment: Alignment.center,
      transform: Matrix4.diagonal3Values(sx, sy, 1),
      child: child);
  return [
    Positioned(top: 4, right: 4, child: flip(-1, 1, img())),
    Positioned(bottom: 4, right: 4, child: flip(-1, -1, img())),
  ];
}

class QiblaPage extends StatefulWidget {
  const QiblaPage({super.key});
  @override
  State<QiblaPage> createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  double? _qiblaDirection;
  double? _compassHeading; // ค่าที่กรองแล้ว ใช้วาดจริง อัปเดตด้วย timer คงที่
  double? _rawHeading; // ค่าดิบล่าสุดจากเซ็นเซอร์ (อัปเดตถี่ ไม่ setState ตรง)
  bool _isLoading = true;
  String _errorMessage = '';
  bool _isPermissionPermanentlyDenied = false;
  double? _distanceToKaaba;
  final _lang = LanguageService();
  final _theme = ThemeService();

  StreamSubscription<CompassEvent>? _compassSub;
  Timer? _smoothTimer;

  static const double _kaabaLat = 21.4225;
  static const double _kaabaLng = 39.8262;

  // ── ระบบเสถียรขึ้น: เก็บ listener ไว้ตัวเดียว (ไม่สร้างซ้ำ) เพื่อ
  // removeListener ได้ถูกตัวตอน dispose แทนการสร้างฟังก์ชันใหม่ทุกครั้ง ──
  void _onThemeOrLangChanged() { if (mounted) setState(() {}); }

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onThemeOrLangChanged);
    _theme.addListener(_onThemeOrLangChanged);
    _initialize();
  }

  @override
  void dispose() {
    _lang.removeListener(_onThemeOrLangChanged);
    _theme.removeListener(_onThemeOrLangChanged);
    _compassSub?.cancel(); // ── เดิมไม่ได้ยกเลิก stream ตอนออกจากหน้า ──
    _smoothTimer?.cancel();
    super.dispose();
  }

  Future<void> _initialize() async {
    await _compassSub?.cancel();
    _compassSub = null;
    _smoothTimer?.cancel();
    _smoothTimer = null;
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _isPermissionPermanentlyDenied = false;
    });
    await _getLocationAndCalculateQibla();
    if (mounted && _errorMessage.isEmpty) _listenCompass();
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

  // ── ขอสิทธิ์ตำแหน่ง + คำนวณกิบลัต ── เพิ่ม timeLimit กันค้างโหลดตลอดกาล
  // และแยกกรณี "ปฏิเสธถาวร" ให้พาไปหน้าตั้งค่าเครื่องแทนขอซ้ำเปล่าๆ ──
  Future<void> _getLocationAndCalculateQibla() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = _lang.isThai
              ? 'กรุณาเปิดบริการตำแหน่ง (GPS) ของเครื่องก่อน'
              : 'Please enable location services first';
          _isLoading = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = _lang.isThai
              ? 'สิทธิ์ตำแหน่งถูกปิดถาวร กรุณาเปิดจากตั้งค่าเครื่อง'
              : 'Location permission is permanently denied. Please enable it in Settings.';
          _isPermissionPermanentlyDenied = true;
          _isLoading = false;
        });
        return;
      }
      if (permission == LocationPermission.denied) {
        setState(() {
          _errorMessage = _lang.isThai
              ? 'แอปต้องการสิทธิ์เข้าถึงตำแหน่งเพื่อคำนวณทิศกิบลัต'
              : 'Location permission is required to calculate the Qibla direction';
          _isLoading = false;
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 12),
      );

      if (!mounted) return;
      setState(() {
        _qiblaDirection = _calculateQibla(position.latitude, position.longitude);
        _distanceToKaaba = _calculateDistance(position.latitude, position.longitude);
        _isLoading = false;
      });
    } on TimeoutException {
      if (!mounted) return;
      setState(() {
        _errorMessage = _lang.isThai
            ? 'หาตำแหน่งไม่สำเร็จ (หมดเวลา) ลองใหม่อีกครั้ง'
            : 'Could not get a location fix in time. Please try again.';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = _lang.isThai
            ? 'ไม่สามารถหาตำแหน่งได้ ลองใหม่อีกครั้ง'
            : 'Could not determine your location. Please try again.';
        _isLoading = false;
      });
    }
  }

  // ── ฟังค่าเข็มทิศเครื่อง ── แยกการ "รับค่าดิบ" ออกจาก "อัปเดตหน้าจอ"
  // เด็ดขาด: stream ของเซ็นเซอร์ยิงถี่และสั่นไม่คงที่ (10-50 ครั้ง/วิ
  // แล้วแต่รุ่นเครื่อง) ถ้า setState ตรงทุกครั้งจะกระตุกและกินแบตเปล่าๆ
  // ── ที่นี่แค่เก็บค่าดิบไว้ ไม่ setState ──────────────────────────
  void _listenCompass() {
    if (FlutterCompass.events == null) {
      setState(() {
        _errorMessage = _lang.isThai
            ? 'อุปกรณ์นี้ไม่มีเซ็นเซอร์เข็มทิศ'
            : 'This device has no compass sensor';
      });
      return;
    }
    _compassSub = FlutterCompass.events!.listen(
      (event) {
        if (event.heading == null) return;
        _rawHeading = event.heading;
      },
      onError: (_) {
        if (!mounted) return;
        setState(() {
          _errorMessage = _lang.isThai
              ? 'อ่านค่าจากเข็มทิศเครื่องไม่ได้'
              : 'Could not read the device compass';
        });
      },
      cancelOnError: false,
    );

    // ── ตัวจับเวลาความถี่คงที่ (~60fps) เป็นตัวเดียวที่ setState — เดิน
    // เข้าหาค่าดิบทีละ "ก้าวคงที่สูงสุด" ต่อรอบ (rate limiter) แทนสัดส่วน
    // เปอร์เซ็นต์ของระยะทาง ทำให้ความเร็วหมุนจอคงที่และไม่กระตุกเมื่อ
    // เซ็นเซอร์อ่านค่ากระโดดผิดปกติจากสัญญาณรบกวน (โลหะ/ไฟฟ้าใกล้เครื่อง) ──
    _smoothTimer = Timer.periodic(const Duration(milliseconds: 16), (_) {
      if (!mounted || _rawHeading == null) return;
      final next = _stepTowards(_compassHeading ?? _rawHeading!, _rawHeading!, 1.6);
      if (_compassHeading == null || (next - _compassHeading!).abs() > 0.03) {
        setState(() => _compassHeading = next);
      }
    });
  }

  // ── เดินจากมุมเดิมเข้าหามุมเป้าหมายไม่เกิน [maxStepDeg] องศาต่อครั้ง
  // ผ่านเส้นทางสั้นที่สุดรอบวงกลม (wrap-around 0/360 ถูกต้อง) — จำกัด
  // ก้าวสูงสุดแทนสัดส่วน % ทำให้ความเร็วหมุนคงที่ ไม่แปรผันตามขนาดของ
  // ค่าที่กระโดดผิดปกติ จึงเสถียรกว่าการใช้ low-pass factor เพียงอย่างเดียว ──
  double _stepTowards(double previous, double target, double maxStepDeg) {
    double diff = ((target - previous + 540) % 360) - 180;
    final step = diff.clamp(-maxStepDeg, maxStepDeg);
    return (previous + step + 360) % 360;
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
      clipBehavior: Clip.antiAlias,
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
        child: Stack(children: [
          // ── ภาพประกอบกะอ์บะฮ์เส้นเอาท์ไลน์สีทอง เป็นภาพสี่เหลี่ยมจัตุรัส
          // (350x350) ถ้าใช้ BoxFit.cover เต็ม header (ซึ่งแนวนอนยาวกว่ามาก)
          // จะซูมเข้าไปเห็นแค่ส่วนเดียวของภาพ — กำหนดความกว้างคงที่ + contain
          // แทน ให้เห็นทั้งองค์ประกอบ (กะอ์บะฮ์+หอคอย+ดาว) ครบ ──
          Positioned(
            left: 0, right: 250, bottom: -10,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Opacity(
                opacity: 0.7,
                child: SizedBox(
                  width: 160,
                  child: Image.asset(
                    kQiblaKaabaIllustrationAsset,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ),
            ),
          ),
          // ── ลายมุมดาวทอง 2 มุมขวา (บน+ล่าง) ไม่ใส่ฝั่งซ้ายเพราะมีภาพ
          // กะอ์บะฮ์อยู่แล้ว กันแน่นเกินไป ──
          ..._qiblaCornerDecor(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(children: [
              Row(children: [
                GestureDetector(onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 22)),
              ]),
              const SizedBox(height: 8),
              Image.asset(
                kQiblaIconAsset,
                width: 44, height: 44,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.explore, color: Color(0xFFFFD700), size: 40),
              ),
              const SizedBox(height: 8),
              Text(_lang.qiblaTitle,
                  style: const TextStyle(color: Color(0xFFFFD700), fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              if (_distanceToKaaba != null)
                Text('${_distanceToKaaba!.toStringAsFixed(0)} ${_lang.fromMakkah}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 36),
            ]),
          ),
        ]),
      ),
    );
  }

  Widget _buildCompass() {
    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
          20, 24, 20, 24 + MediaQuery.of(context).padding.bottom),
      child: Column(children: [
        // ── การ์ด "เวที" เดียวที่รวมสถานะ + เข็มทิศ + ตัวเลของศาไว้ด้วยกัน
        // แทนที่จะปล่อยให้แต่ละชิ้นลอยแยกกันบนพื้นหลังเทาเฉยๆ แบบเดิม
        // ให้ความรู้สึกเป็นชิ้นเดียวที่ประณีตขึ้น ──────────────────────
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: BorderRadius.circular(32),
            border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
            boxShadow: _theme.isDark ? null : [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 24, offset: const Offset(0, 8)),
            ],
          ),
          child: Column(children: [
            // ── ป้ายสถานะแบบเรียบ ไม่มีกรอบ/พื้นหลังกล่อง ใช้แค่จุดไฟและ
            // สีข้อความบอกสถานะ ดูโล่งและพรีเมียมกว่าป้ายกล่องขอบหนาเดิม ──
            Row(mainAxisSize: MainAxisSize.min, children: [
              Container(width: 8, height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle,
                  color: _isFacingQibla ? const Color(0xFF3FC96B) : const Color(0xFFD4AF37),
                  boxShadow: [BoxShadow(color: (_isFacingQibla ? const Color(0xFF3FC96B) : const Color(0xFFD4AF37)).withOpacity(0.6), blurRadius: 6)])),
              const SizedBox(width: 8),
              Text(_isFacingQibla ? _lang.facingQibla : _lang.rotateQibla,
                  style: TextStyle(
                      color: _isFacingQibla ? const Color(0xFF3FC96B) : _theme.subTextColor,
                      fontWeight: FontWeight.w700, fontSize: 13, letterSpacing: 0.3)),
            ]),

            const SizedBox(height: 30),

            // ── เข็มทิศ: เข็มบางเรียวสไตล์นาฬิกาหรูลอยนิ่งชี้ขึ้นตลอด
            // (ไม่หมุน) ส่วนพื้นหลังทั้งวง (ขีดองศา, ตัวอักษรทิศ, เหรียญลาย,
            // หมุดกิบลัตสีทอง) หมุนไปตามทิศเครื่องแทน — เมื่อหมุดกิบลัตมา
            // อยู่ตรงปลายเข็มพอดี ทั้งเข็มและหมุดจะเรืองแสงเขียว ──────────
            SizedBox(width: 256, height: 256,
              child: Stack(alignment: Alignment.center, children: [
                // หน้าปัดไล่เฉดเขียวมรกตเข้มเรียบเนียนชั้นเดียว (แทนวงซ้อน
                // หลายสีแบบเดิม) พร้อมเส้นขอบทองบางๆ — เงาเบามากแค่ยกตัว
                // ขึ้นจากพื้นการ์ดนิดเดียว ไม่ให้เกิดวงมืดรอบขอบ
                Container(width: 250, height: 250,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(center: Alignment(-0.3, -0.4),
                        colors: [Color(0xFF1E6B33), Color(0xFF0D3B1E)], stops: [0.0, 1.0]),
                    border: Border.all(color: const Color(0xFFD4AF37), width: 1.6),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 14, offset: const Offset(0, 6))],
                  ),
                ),

                Transform.rotate(
                  angle: _compassAngle,
                  child: SizedBox(width: 232, height: 232,
                    child: Stack(alignment: Alignment.center, children: [
                      CustomPaint(size: const Size(232, 232), painter: _QiblaTickPainter()),
                      _buildDirection('N', 0, -98),
                      _buildDirection('S', 0, 98),
                      _buildDirection('E', 98, 0),
                      _buildDirection('W', -98, 0),
                      // เหรียญลายเรขาคณิตอิสลาม 8 แฉกตรงกลาง แบบเส้นบางลอยตรงบน
                      // หน้าปัดตรงๆ ไม่มีแผ่นกลมพื้นหลังทึบ ให้ดูโปร่งเบา
                      CustomPaint(size: const Size(108, 108), painter: _QiblaMedallionPainter()),
                      // หมุดกิบลัต: ฝังอยู่ที่มุม _qiblaDirection บนขอบวง
                      if (_qiblaDirection != null) _buildQiblaPin(_qiblaDirection!),
                    ]),
                  ),
                ),

                // ── เข็มบางทรงเพชร ลอยนิ่งชี้ขึ้นตลอด (ไม่หมุน) ──────────
                CustomPaint(size: const Size(30, 224), painter: _QiblaNeedlePainter(isFacing: _isFacingQibla)),

                // จุดหมุนตรงกลาง: อัญมณีทองเล็กๆ (ไม่หมุน)
                Container(width: 12, height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(center: Alignment(-0.35, -0.35), colors: [Color(0xFFFCEAB0), Color(0xFFC9971E)]),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.35), blurRadius: 4, offset: const Offset(0, 1))])),
              ]),
            ),

            const SizedBox(height: 26),
            Container(height: 1, color: (_theme.isDark ? Colors.white : Colors.black).withOpacity(0.06)),
            const SizedBox(height: 18),

            // ── แถวตัวเลของศา: เรียบ ไม่มีกรอบกล่อง คั่นด้วยเส้นบางตรงกลาง
            // ให้ความรู้สึกเป็นส่วนหนึ่งของการ์ดเดียวกัน ไม่ใช่การ์ดแยก ──
            IntrinsicHeight(
              child: Row(children: [
                Expanded(child: _buildDegreeReadout(
                    label: _lang.qiblaDirection,
                    value: _qiblaDirection != null ? '${_qiblaDirection!.toStringAsFixed(1)}°' : '-')),
                VerticalDivider(width: 1, thickness: 1, color: (_theme.isDark ? Colors.white : Colors.black).withOpacity(0.08)),
                Expanded(child: _buildDegreeReadout(
                    label: _lang.compass,
                    value: _compassHeading != null ? '${_compassHeading!.toStringAsFixed(1)}°' : '-')),
              ]),
            ),
          ]),
        ),

        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: _theme.isDark ? Border.all(color: ThemeService.darkBorder) : null,
            boxShadow: [BoxShadow(color: _theme.shadowColor, blurRadius: 8, offset: const Offset(0, 2))],
          ),
          child: Row(children: [
            Container(width: 32, height: 32,
              decoration: BoxDecoration(
                color: _theme.iconColor.withOpacity(0.12),
                shape: BoxShape.circle),
              child: Icon(Icons.info_outline, color: _theme.iconColor, size: 18)),
            const SizedBox(width: 10),
            Expanded(child: Text(_lang.holdPhone, style: TextStyle(fontSize: 12, color: _theme.subTextColor))),
          ]),
        ),
      ]),
    );
  }

  // ── หมุดกิบลัต: วางที่มุม [bearingDeg] รอบวง (มุม 0 = ตำแหน่งเดียวกับ N)
  // ใช้เทคนิคเดียวกับขีดองศา: หมุนก่อนเลื่อนออกไปตามรัศมี แล้วหมุนกลับให้
  // ตัวไอคอนตั้งตรงเสมอไม่ว่าจะอยู่มุมไหนของวง ─────────────────────────
  Widget _buildQiblaPin(double bearingDeg) {
    final rad = bearingDeg * pi / 180;
    return Transform.rotate(
      angle: rad,
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Transform.rotate(
            angle: -rad,
            child: CustomPaint(size: const Size(22, 28), painter: _QiblaPinPainter(isFacing: _isFacingQibla)),
          ),
        ),
      ),
    );
  }

  Widget _buildDirection(String label, double x, double y) {
    final isNorth = label == 'N';
    return Transform.translate(offset: Offset(x, y),
      child: Text(label,
          style: TextStyle(
              fontFamily: 'serif',
              fontSize: isNorth ? 26 : 22,
              fontWeight: FontWeight.w900,
              fontStyle: FontStyle.italic,
              color: isNorth ? const Color(0xFFD4AF37) : const Color(0xFFEFF4F0),
              shadows: const [Shadow(color: Colors.black38, offset: Offset(1, 1), blurRadius: 1)])));
  }

  // ── แถวตัวเลของศาแบบเรียบในการ์ดเดียวกับเข็มทิศ ไม่มีกรอบ/ไอคอนกล่อง
  // เหมือนของเดิม (_buildInfoCard) — แค่ตัวเลขใหญ่ + label เล็กใต้เส้นคั่น ──
  Widget _buildDegreeReadout({required String label, required String value}) {
    return Column(mainAxisSize: MainAxisSize.min, children: [
      Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: _theme.textColor, letterSpacing: 0.2)),
      const SizedBox(height: 4),
      Text(label, style: TextStyle(fontSize: 11.5, color: _theme.subTextColor, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
    ]);
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 48),
          const SizedBox(height: 16),
          Text(_errorMessage, style: TextStyle(color: _theme.subTextColor), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          if (_isPermissionPermanentlyDenied)
            ElevatedButton(
              onPressed: () => Geolocator.openAppSettings(),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
              child: Text(_lang.isThai ? 'เปิดตั้งค่าเครื่อง' : 'Open Settings',
                  style: const TextStyle(color: Colors.white)),
            )
          else
            ElevatedButton(onPressed: _initialize,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B5E20)),
              child: Text(_lang.tryAgain, style: const TextStyle(color: Colors.white))),
        ]),
      ),
    );
  }
}

// ── ขีดบอกองศารอบวงเข็มทิศ ทุก 10° เส้นยาว มุมหลัก (N/E/S/W) เส้นยาวกว่า ──
class _QiblaTickPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final rOuter = size.width / 2;
    final paint = Paint()..color = const Color(0xFF0F3D22).withOpacity(0.55);
    for (int deg = 0; deg < 360; deg += 10) {
      final major = deg % 90 == 0;
      final rInner = rOuter - (major ? 20.0 : 12.0);
      final rad = (deg - 90) * pi / 180;
      final p1 = center + Offset(rInner * cos(rad), rInner * sin(rad));
      final p2 = center + Offset((rOuter - 3) * cos(rad), (rOuter - 3) * sin(rad));
      canvas.drawLine(p1, p2, paint..strokeWidth = major ? 1.8 : 1.1);
    }
  }

  @override
  bool shouldRepaint(covariant _QiblaTickPainter oldDelegate) => false;
}

// ── ลายเรขาคณิตอิสลาม 8 แฉกตรงกลางเหรียญ (สี่เหลี่ยมซ้อน 45° x2 ชั้น) ──
class _QiblaMedallionPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final scale = size.width / 120;

    Path square(double r, double phaseDeg) {
      final path = Path();
      for (int i = 0; i < 4; i++) {
        final ang = (phaseDeg + i * 90) * pi / 180;
        final pt = c + Offset(r * scale * cos(ang), r * scale * sin(ang));
        if (i == 0) {
          path.moveTo(pt.dx, pt.dy);
        } else {
          path.lineTo(pt.dx, pt.dy);
        }
      }
      path.close();
      return path;
    }

    final outer = Paint()
      ..color = const Color(0xFFF6D98A).withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3;
    final inner = Paint()
      ..color = const Color(0xFFF6D98A).withOpacity(0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    canvas.drawPath(square(46, 0), outer);
    canvas.drawPath(square(46, 45), outer);
    canvas.drawPath(square(30, 0), inner);
    canvas.drawPath(square(30, 45), inner);
    canvas.drawCircle(c, 4.5, Paint()..color = const Color(0xFFF6D98A).withOpacity(0.85));
  }

  @override
  bool shouldRepaint(covariant _QiblaMedallionPainter oldDelegate) => false;
}

// ── เข็มบางทรงเพชร (diamond) ลอยนิ่งชี้ขึ้นตลอด (ไม่หมุน): ท่อนบนทอง
// แหลมยาวชี้ทาง ท่อนล่างครีมสั้นกว่าถ่วงสมดุล คอดกิ่วตรงกลางแบบเข็ม
// นาฬิกาหรู — เรืองแสงเขียวเมื่อหมุดกิบลัตหมุนมาตรงปลายเข็มพอดี ──────
class _QiblaNeedlePainter extends CustomPainter {
  final bool isFacing;
  _QiblaNeedlePainter({required this.isFacing});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final cx = w * 0.5;
    final headColor = isFacing ? const Color(0xFF3FC96B) : const Color(0xFFD4AF37);

    // ท่อนบน: เพชรเรียวยาว จากปลายแหลมสุดถึงจุดคอดกลาง
    final headPath = Path()
      ..moveTo(cx, 0)
      ..lineTo(w * 0.82, h * 0.46)
      ..lineTo(cx, h * 0.52)
      ..lineTo(w * 0.18, h * 0.46)
      ..close();
    // ท่อนล่าง: เพชรสั้นกว่า ป้อมกว่า ถ่วงสมดุลด้านหาง
    final tailPath = Path()
      ..moveTo(cx, h * 0.48)
      ..lineTo(w * 0.68, h * 0.7)
      ..lineTo(cx, h)
      ..lineTo(w * 0.32, h * 0.7)
      ..close();

    if (isFacing) {
      canvas.drawPath(
          headPath,
          Paint()
            ..color = headColor.withOpacity(0.55)
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 9));
    }
    canvas.drawPath(tailPath, Paint()..color = const Color(0xFFFDFBF4));
    canvas.drawPath(headPath, Paint()..color = headColor);
  }

  @override
  bool shouldRepaint(covariant _QiblaNeedlePainter oldDelegate) => oldDelegate.isFacing != isFacing;
}

// ── หมุดกิบลัตบนหน้าปัด: ทรงหยดน้ำเล็กชี้ออกจากศูนย์กลาง — เขียวเรืองแสง
// เมื่อหมุนมาตรงกับตัวชี้คงที่ด้านบนพอดี (คือกำลังหันตรงกิบลัต) ──────
class _QiblaPinPainter extends CustomPainter {
  final bool isFacing;
  _QiblaPinPainter({required this.isFacing});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final color = isFacing ? const Color(0xFF3FC96B) : const Color(0xFFD4AF37);
    final path = Path()
      ..moveTo(w * 0.5, 0)
      ..cubicTo(w * 0.95, h * 0.42, w * 0.8, h * 0.72, w * 0.5, h)
      ..cubicTo(w * 0.2, h * 0.72, w * 0.05, h * 0.42, w * 0.5, 0)
      ..close();
    if (isFacing) {
      canvas.drawPath(path, Paint()..color = color.withOpacity(0.5)..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6));
    }
    canvas.drawPath(path, Paint()..color = color);
    canvas.drawCircle(Offset(w * 0.5, h * 0.32), w * 0.16, Paint()..color = Colors.white.withOpacity(0.85));
  }

  @override
  bool shouldRepaint(covariant _QiblaPinPainter oldDelegate) => oldDelegate.isFacing != isFacing;
}