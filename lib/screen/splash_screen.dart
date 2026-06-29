import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  // Controllers
  late AnimationController _mainController;      // รูปหลัก fade+scale
  late AnimationController _glowController;      // glow pulse
  late AnimationController _starController;      // ดาวกะพริบ
  late AnimationController _textController;      // ข้อความ
  late AnimationController _particleController;  // particle เคลื่อนที่

  // Main image
  late Animation<double> _imageFade;
  late Animation<double> _imageScale;

  // Text
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // Main: fade + scale รูปภาพ
    _mainController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _imageFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _mainController,
            curve: const Interval(0.0, 0.6, curve: Curves.easeIn)));
    _imageScale = Tween<double>(begin: 1.08, end: 1.0).animate(
        CurvedAnimation(parent: _mainController,
            curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic)));

    // Glow pulse loop
    _glowController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2000))
      ..repeat(reverse: true);

    // Star twinkle loop
    _starController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat();

    // Particle float loop
    _particleController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000))
      ..repeat();

    // Text: fade + slide up
    _textController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeIn));
    _textSlide = Tween<Offset>(
        begin: const Offset(0, 0.4), end: Offset.zero).animate(
        CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic));

    // เล่น sequence
    _runSequence();

    // ออกจาก Splash
    Future.delayed(const Duration(milliseconds: 3200), () {
      if (mounted) {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.of(context).pushReplacement(PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 700),
          pageBuilder: (_, __, ___) => const HomePage(),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
        ));
      }
    });
  }

  Future<void> _runSequence() async {
    _mainController.forward();
    await Future.delayed(const Duration(milliseconds: 900));
    _textController.forward();
  }

  @override
  void dispose() {
    _mainController.dispose();
    _glowController.dispose();
    _starController.dispose();
    _textController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _mainController, _glowController,
          _starController, _textController, _particleController,
        ]),
        builder: (context, _) {
          return Stack(
            fit: StackFit.expand,
            children: [
              // ── รูปภาพหลัก ──
              FadeTransition(
                opacity: _imageFade,
                child: ScaleTransition(
                  scale: _imageScale,
                  child: Image.asset('image/Mirza.png', fit: BoxFit.cover),
                ),
              ),

              // ── Glow overlay บริเวณมัสยิด ──
              FadeTransition(
                opacity: _imageFade,
                child: Align(
                  alignment: const Alignment(0, -0.15),
                  child: Container(
                    width: 220,
                    height: 220,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(
                              0.08 + _glowController.value * 0.12),
                          blurRadius: 60 + _glowController.value * 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── ดาวกะพริบ ──
              FadeTransition(
                opacity: _imageFade,
                child: _buildTwinkleStars(size),
              ),

              // ── Particles ลอยขึ้น ──
              FadeTransition(
                opacity: _imageFade,
                child: _buildFloatingParticles(size),
              ),

              // ── Shimmer sweep ผ่านรูป ──
              FadeTransition(
                opacity: _imageFade,
                child: _buildShimmer(size),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── ดาวกะพริบ ──
  Widget _buildTwinkleStars(Size size) {
    // ตำแหน่งดาวจากรูปจริง
    final stars = [
      // ดาวบริเวณมัสยิด
      _StarData(0.38, 0.22, 6, 0.0),
      _StarData(0.62, 0.18, 4, 0.2),
      _StarData(0.45, 0.30, 3, 0.4),
      _StarData(0.55, 0.28, 3, 0.15),
      _StarData(0.50, 0.15, 5, 0.35),
      // ดาวบริเวณ DEEN
      _StarData(0.22, 0.62, 4, 0.1),
      _StarData(0.75, 0.65, 4, 0.3),
      _StarData(0.60, 0.70, 3, 0.5),
      _StarData(0.30, 0.68, 3, 0.25),
      _StarData(0.80, 0.58, 5, 0.45),
      _StarData(0.18, 0.55, 3, 0.6),
    ];

    return Stack(
      children: stars.map((star) {
        final t = (_starController.value + star.delay) % 1.0;
        final opacity = t < 0.5 ? t * 2 : (1.0 - t) * 2;
        return Positioned(
          left: star.x * size.width,
          top: star.y * size.height,
          child: _buildStar(star.size, opacity),
        );
      }).toList(),
    );
  }

  Widget _buildStar(double size, double opacity) {
    return Opacity(
      opacity: opacity.clamp(0.0, 1.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // กลีบแนวตั้ง
          Container(
            width: 1.5,
            height: size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.white,
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // กลีบแนวนอน
          Container(
            width: size,
            height: 1.5,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, Colors.white, Colors.transparent],
              ),
            ),
          ),
          // จุดกลาง
          Container(
            width: 2.5,
            height: 2.5,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.8),
                  blurRadius: 4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Particles ลอยขึ้น ──
  Widget _buildFloatingParticles(Size size) {
    final random = Random(42);
    final particles = List.generate(20, (i) {
      return _ParticleData(
        x: random.nextDouble(),
        delay: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        speed: random.nextDouble() * 0.3 + 0.1,
      );
    });

    return Stack(
      children: particles.map((p) {
        final t = (_particleController.value * p.speed + p.delay) % 1.0;
        final y = 1.0 - t; // ลอยขึ้น
        final opacity = t < 0.2 ? t * 5 : t > 0.8 ? (1.0 - t) * 5 : 1.0;
        return Positioned(
          left: p.x * size.width,
          top: y * size.height * 0.9 + size.height * 0.05,
          child: Opacity(
            opacity: (opacity * 0.6).clamp(0.0, 1.0),
            child: Container(
              width: p.size,
              height: p.size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFD700),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFD700).withOpacity(0.5),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ── Shimmer sweep ──
  Widget _buildShimmer(Size size) {
    final t = _particleController.value;
    final x = -0.3 + t * 1.6; // ปัดจากซ้ายไปขวา
    return Opacity(
      opacity: 0.12,
      child: Transform.translate(
        offset: Offset(x * size.width, 0),
        child: Container(
          width: size.width * 0.25,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.6),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StarData {
  final double x, y, size, delay;
  const _StarData(this.x, this.y, this.size, this.delay);
}

class _ParticleData {
  final double x, delay, size, speed;
  const _ParticleData({required this.x, required this.delay, required this.size, required this.speed});
}