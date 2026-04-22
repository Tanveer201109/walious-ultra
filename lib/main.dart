import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const ZaiMailApp());
}

class ZaiMailApp extends StatelessWidget {
  const ZaiMailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAI Mail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF080808),
        fontFamily: 'Georgia',
      ),
      home: const SplashScreen(),
    );
  }
 }

// আপাতত ডামি হোম পেজ। পরে মেইল UI বসাবা
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('[zAi] Mail'),
        backgroundColor: const Color(0xFF0A0A0A),
      ),
      body: const Center(
        child: Text(
          'ZAI Mail Inbox\nThe Faith Standard',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 24, color: Color(0xFFD4AF37)),
        ),
      ),
    );
  }
}
