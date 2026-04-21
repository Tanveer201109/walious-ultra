import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZAiMailApp());
}

// CUSTOM COLORS
class ZAiColors {
  static const crystalDark = Color(0xFF0c1110);
  static const emeraldGlow = Color(0xFF10B981);
  static const matteOverlay = Color(0x0AFFFFFF);
  static const cardColor = Color(0xFF131918);
  static const googleRed = Color(0xFFDB4437);
  static const facebookBlue = Color(0xFF1877F2);
}

class ZAiMailApp extends StatelessWidget {
  const ZAiMailApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAI Mail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ZAiColors.crystalDark,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// SPLASH SCREEN - স্মোক + রেডিয়াল ব্লার + বিজলি ইফেক্ট
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
