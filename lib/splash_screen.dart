import 'dart:math';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _haloController;
  late AnimationController _flashController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    // গোল্ডেন রিং ঘুরবে
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // হ্যালো পালস
    _haloController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);

    // বিজলি ফ্ল্যাশ
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _startLightningLoop();
    
    // 4 সেকেন্ড পর হোমে যাবে
    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _startLightningLoop() async {
    await Future.delayed(const Duration(milliseconds: 600));
    while (mounted) {
      int burstSize = _random.nextInt(3) + 2; // 2-4 টা ফ্ল্যাশ
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
              // স্ক্রিন ফ্ল্যাশ ওভারলে
              if (_flashController.value > 0)
                Container(
                  color: const Color(0xFFB4DCFF)
                     .withOpacity(0.18 * _flashController.value),
                ),
              
              // মেইন সিন
              Center(
                child: SizedBox(
                  width: 320,
                  height: 320,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Halo
                      ScaleTransition(
                        scale: Tween(begin: 1.0, end: 1.15).animate(
                          CurvedAnimation(
                              parent: _haloController, curve: Curves.easeInOut),
                        ),
                        child: Container(
                          width: 320,
                          height: 320,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFD4AF37).withOpacity(0.08),
                                Colors.transparent,
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Golden Ring
                      RotationTransition(
                        turns: _ringController,
                        child: Container(
                          width: 280,
                          height: 280,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const SweepGradient(
                              colors: [
                                Color(0xFFD4AF37), Color(0xFFFFF8DC),
                                Color(0xFFD4AF37), Color(0xFFA07820),
                                Color(0xFFD4AF37), Color(0xFFFFF8DC),
                                Color(0xFFD4AF37),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                              BoxShadow(
                                color: const Color(0xFFD4AF37).withOpacity(0.2),
                                blurRadius: 50,
                                spreadRadius: 10,
                              ),
                            ],
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(2.5),
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFF080808),
                            ),
                          ),
                        ),
                      ),

                      // Lightning Canvas
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

                      // Logo Text
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
                                    text: 'z',
                                    style: TextStyle(
                                        fontSize: 44,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                              color: Colors.white,
                                              blurRadius: 8)
                                        ])),
                                const TextSpan(
                                    text: 'A',
                                    style: TextStyle(
                                        fontSize: 56,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        shadows: [
                                          Shadow(
                                              color: Colors.white,
                                              blurRadius: 8)
                                        ])),
                                const TextSpan(
                                    text: 'i',
                                    style: TextStyle(
                                        fontSize: 48,
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
                            'THE FAITH STANDARD',
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
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// বিজলি আঁকার ক্লাস
class LightningPainter extends CustomPainter {
  final double flashValue;
  final Random random;
  LightningPainter(this.flashValue, this.random);

  @override
  void paint(Canvas canvas, Size size) {
    if (flashValue < 0.1) return;

    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
     ..color = const Color(0xFFC8E6FF).withOpacity(flashValue)
     ..strokeWidth = 1.5
     ..style = PaintingStyle.stroke
     ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    final glowPaint = Paint()
     ..color = const Color(0xFF96C8FF).withOpacity(flashValue * 0.35)
     ..strokeWidth = 6
     ..style = PaintingStyle.stroke
     ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    int bolts = random.nextInt(3) + 2;
    for (int i = 0; i < bolts; i++) {
      double angle = random.nextDouble() * 2 * pi;
      double r = size.width / 2 * (0.7 + random.nextDouble() * 0.25);
      Offset start = Offset(center.dx + r * cos(angle),
          center.dy + r * sin(angle));
      Offset end = Offset(center.dx + random.nextDouble() * 80 - 40,
          center.dy + random.nextDouble() * 80 - 40);
      
      _drawBolt(canvas, glowPaint, start, end, 8);
      _drawBolt(canvas, paint, start, end, 8);
    }
  }

  void _drawBolt(Canvas canvas, Paint paint, Offset p1, Offset p2, int depth) {
    if (depth == 0) {
      canvas.drawLine(p1, p2, paint);
      return;
    }
    double mx = (p1.dx + p2.dx) / 2 + random.nextDouble() * 50 - 25;
    double my = (p1.dy + p2.dy) / 2 + random.nextDouble() * 50 - 25;
    Offset mid = Offset(mx, my);
    _drawBolt(canvas, paint, p1, mid, depth - 1);
    _drawBolt(canvas, paint, mid, p2, depth - 1);
  }

  @override
  bool shouldRepaint(covariant LightningPainter oldDelegate) => true;
}
