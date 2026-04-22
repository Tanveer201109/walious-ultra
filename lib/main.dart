import 'package:flutter/material.dart';
import 'dart:math' as math;

class RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 6.0;
    
    final paint = Paint()
     ..shader = const LinearGradient(
        colors: [
          Color(0xFFFFD700),
          Color(0xFFD4AF37),
          Color(0xFFFFD700),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
     ..style = PaintingStyle.stroke
     ..strokeWidth = strokeWidth
     ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 3);

    canvas.drawCircle(center, radius, paint);

    final innerPaint = Paint()
     ..color = const Color(0xFFFFD700).withOpacity(0.3)
     ..style = PaintingStyle.stroke
     ..strokeWidth = 1.5;
    
    canvas.drawCircle(center, radius - 10, innerPaint);
    canvas.drawCircle(center, radius + 10, innerPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
    
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
              // 1. Screen Flash
              if (_flashController.value > 0)
                Container(
                  color: const Color(0xFFB4DCFF)
                     .withOpacity(0.18 * _flashController.value),
                ),
              
              // 2. Main Logo Center এ
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
                        child: CustomPaint(
                          size: const Size(280, 280),
                          painter: RingPainter(),
                        ),
                      ),

                      // Lightning
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

              // 3. Powered by Meta - একদম নিচে
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Powered by ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                        fontSize: 11,
                        letterSpacing: 1.5,
                      ),
                    ),
                    Text(
                      'Meta',
                      style: TextStyle(
                        color: const Color(0xFF0081FB).withOpacity(0.5),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
