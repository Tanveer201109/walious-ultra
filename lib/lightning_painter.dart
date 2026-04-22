import 'dart:math';
import 'package:flutter/material.dart';

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
