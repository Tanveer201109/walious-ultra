import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'xAi Wallet',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomPaint(
          painter: RingPainter(),
          child: const SizedBox(
            width: 300,
            height: 300,
          ),
        ),
      ),
    );
  }
}

class RingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromRGBO(128, 128, 128, 0.5) // চাঁদের আলোর প্রতিফলন
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 5, paint);

    final rediumPaint = Paint()
      ..color = Color.fromRGBO(255, 0, 0, 0.2) // রেডিয়াম স্মোক রঙ
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 4);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 10, rediumPaint);

    final smokePaint = Paint()
      ..color = Color.fromRGBO(128, 128, 128, 0.1) // ধোঁয়া রঙ
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 2);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 15, smokePaint);

    final lightningPaint = Paint()
      ..color = Color.fromRGBO(255, 255, 255, 0.5) // বিজলি রঙ
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 1);

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2 - 20, lightningPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
