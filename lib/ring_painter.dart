import 'package:flutter/material.dart';

class RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    final paint = Paint()
    ..shader = const SweepGradient(
        colors: [
          Color(0xFFD4AF37),
          Color(0xFFFFF8DC),
          Color(0xFFD4AF37),
          Color(0xFFA07820),
          Color(0xFFD4AF37),
          Color(0xFFFFF8DC),
          Color(0xFFD4AF37),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5;

    canvas.drawCircle(center, radius - 1.25, paint);

    final glowPaint = Paint()
    ..color = const Color(0xFFD4AF37).withOpacity(0.5)
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2.5
    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10);
    
    canvas.drawCircle(center, radius - 1.25, glowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
