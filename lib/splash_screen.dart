import 'dart:math';
import 'package:flutter/material.dart';
import 'ring_painter.dart';
import 'lightning_painter.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _haloController;
  late AnimationController _flashController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _haloController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _startLightningLoop();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  void _startLightningLoop() async {
    await Future.delayed(const Duration(milliseconds: 600));
    while (mounted) {
      int burstSize = _random.nextInt(3) + 2;
      for (int i = 0; i < burstSize; i++) {
        if (!mounted) return;
        _flashController.forward(from: 0);
        await Future.delayed(
            Duration(milliseconds: 60 + _random.nextInt(70)));
      }
      await Future.delayed(
          Duration(milliseconds: 1500 + _random.nextInt(2000)));
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    _haloController.dispose();
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: AnimatedBuilder(
        animation: _flashController,
        builder: (context, child) {
          return Stack(
            children: [
              if (_flashController.value > 0)
                Container(
                  color: const Color(0xFFB4DCFF)
                      .withOpacity(0.18 * _flashController.value),
                ),
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'সম্পন্ন করা হয়েছে দ্বারা ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 12,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      'Tanveer ভাই',
                      style: TextStyle(
                        color: const Color(0xFF0081FB).withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              RotationTransition(
                turns: _ringController,
                child: CustomPaint(
                  size: const Size(280, 280),
                  painter: RingPainter(),
                ),
              ),
              ClipOval(
                child: SizedBox(
                  width: 274,
                  height: 274,
                  child: CustomPaint(
                    painter: LightningPainter(
                        _flashController.value, _random),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(
                          fontFamily: 'Georgia', fontSize: 52),
                      children: [
                        TextSpan(
                            text: '[',
                            style: TextStyle(
                                color: const Color(0xFFC8C8C8),
                                fontWeight: FontWeight.w300,
                                letterSpacing: -2,
                                shadows: [
                                  Shadow(
                                      color: Colors.grey
                                          .withOpacity(0.6),
                                      blurRadius: 20)
                                ])),
                        const TextSpan(
                            text: '১৮ ULTRA AI',
                            style: TextStyle(
                                fontSize: 56,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      color: Colors.white,
                                      blurRadius: 8)
                                ])),
                        TextSpan(
                            text: ']',
                            style: TextStyle(
                                color: const Color(0xFFC8C8C8),
                                fontWeight: FontWeight.w300,
                                letterSpacing: -2,
                                shadows: [
                                  Shadow(
                                      color: Colors.grey
                                          .withOpacity(0.6),
                                      blurRadius: 20)
                                ])),
                      ],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'সম্পন্ন করা হয়েছে',
                    style: TextStyle(
                      fontSize: 11,
                      letterSpacing: 4,
                      color:
                          const Color(0xFFD4AF37).withOpacity(0.8),
                      shadows: [
                        Shadow(
                            color: const Color(0xFFD4AF37)
                                .withOpacity(0.5),
                            blurRadius: 10)
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
