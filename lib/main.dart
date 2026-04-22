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
  late AnimationController _flashController;

  @override
  void initState() {
    super.initState();
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _startLightning();
    
    // 3 সেকেন্ড পর হোমে যাবে
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacementNamed(context, '/home');
    });
  }

  void _startLightning() async {
    await Future.delayed(const Duration(milliseconds: 600));
    while (mounted) {
      int burstSize = Random().nextInt(3) + 2; // 2-4 টা ফ্ল্যাশ
      for (int i = 0; i < burstSize; i++) {
        _flashController.forward(from: 0);
        await Future.delayed(Duration(milliseconds: 60 + Random().nextInt(70)));
      }
      await Future.delayed(Duration(milliseconds: 1500 + Random().nextInt(2000)));
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Halo
          Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFD4AF37).withOpacity(0.08),
                  blurRadius: 60,
                  spreadRadius: 20,
                ),
              ],
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
                    Color(0xFFD4AF37), Color(0xFFFFF8DC), Color(0xFFD4AF37),
                    Color(0xFFA07820), Color(0xFFD4AF37), Color(0xFFFFF8DC),
                    Color(0xFFD4AF37),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFD4AF37).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 5,
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

          // Lightning Painter
          AnimatedBuilder(
            animation: _flashController,
            builder: (context, child) {
              return CustomPaint(
                size: const Size(274, 274),
                painter: LightningPainter(_flashController.value),
              );
            },
          ),

          // Logo Text
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(fontFamily: 'Georgia', fontSize: 52),
                  children: [
                    TextSpan(
                        text: '[',
                        style: TextStyle(
                            color: const Color(0xFFC8C8C8),
                            fontWeight: FontWeight.w300,
                            shadows: [
                              Shadow(
                                  color: Colors.grey.withOpacity(0.6),
                                  blurRadius: 20)
                            ])),
                    const TextSpan(
                        text: 'z',
                        style: TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const TextSpan(
                        text: 'A',
                        style: TextStyle(
                            fontSize: 56,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    const TextSpan(
                        text: 'i',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white)),
                    TextSpan(
                        text: ']',
                        style: TextStyle(
                            color: const Color(0xFFC8C8C8),
                            fontWeight: FontWeight.w300,
                            shadows: [
                              Shadow(
                                  color: Colors.grey.withOpacity(0.6),
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
                  color: const Color(0xFFD4AF37).withOpacity(0.8),
                  shadows: [
                    Shadow(
                        color: const Color(0xFFD4AF37).withOpacity(0.5),
                        blurRadius: 10)
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Lightning Painter
class LightningPainter extends CustomPainter {
  final double flashValue;
  LightningPainter(this.flashValue);
  final Random _random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    if (flashValue == 0) return;
    
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
     ..color = const Color(0xFFC8E6FF).withOpacity(flashValue)
     ..strokeWidth = 1.5
     ..style = PaintingStyle.stroke
     ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

    int bolts = _random.nextInt(3) + 2;
    for (int i = 0; i < bolts; i++) {
      double angle = _random.nextDouble() * 2 * pi;
      double r = size.width / 2 * (0.7 + _random.nextDouble() * 0.25);
      Offset start = Offset(center.dx + r * cos(angle), center.dy + r * sin(angle));
      Offset end = Offset(
          center.dx + _random.nextDouble() * 80 - 40,
          center.dy + _random.nextDouble() * 80 - 40);
      _drawBolt(canvas, paint, start, end, 8);
    }
  }

  void _drawBolt(Canvas canvas, Paint paint, Offset p1, Offset p2, int depth) {
    if (depth == 0) {
      canvas.drawLine(p1, p2, paint);
      return;
    }
    double mx = (p1.dx + p2.dx) / 2 + _random.nextDouble() * 40 - 20;
    double my = (p1.dy + p2.dy) / 2 + _random.nextDouble() * 40 - 20;
    Offset mid = Offset(mx, my);
    _drawBolt(canvas, paint, p1, mid, depth - 1);
    _drawBolt(canvas, paint, mid, p2, depth - 1);
  }

  @override
  bool shouldRepaint(covariant LightningPainter oldDelegate) => true;
}
