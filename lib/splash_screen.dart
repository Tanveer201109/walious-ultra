import 'dart:math';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    )..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        const Color(0xFF00FF88).withOpacity(0.15 + _controller.value * 0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: CustomPaint(
                    size: const Size(200, 200),
                    painter: GreenLightningPainter(_controller.value),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Z', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: Colors.white.withOpacity(0.9), letterSpacing: 12)),
                    Text('A', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: Colors.white.withOpacity(0.9), letterSpacing: 12)),
                    Text('I', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: Colors.white.withOpacity(0.9))),
                  ],
                ),
                const SizedBox(height: 8),
                Text('MAIL', style: TextStyle(fontSize: 16, letterSpacing: 8, color: Colors.white.withOpacity(0.6), fontWeight: FontWeight.w300)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class GreenLightningPainter extends CustomPainter {
  final double value;
  GreenLightningPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
     ..color = const Color(0xFF00FF88).withOpacity(0.8 + value * 0.2)
     ..strokeWidth = 4
     ..strokeCap = StrokeCap.round
     ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
     ..style = PaintingStyle.fill;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);

    path.moveTo(center.dx, center.dy - 60);
    path.lineTo(center.dx - 15, center.dy - 10);
    path.lineTo(center.dx + 5, center.dy - 10);
    path.lineTo(center.dx - 10, center.dy + 60);
    path.lineTo(center.dx + 15, center.dy + 10);
    path.lineTo(center.dx - 5, center.dy + 10);
    path.close();

    canvas.drawPath(path, paint);

    final glowPaint = Paint()
     ..color = const Color(0xFF00FF88).withOpacity(0.3)
     ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawPath(path, glowPaint);
  }

  @override
  bool shouldRepaint(GreenLightningPainter oldDelegate) => true;
}
