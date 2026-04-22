import 'package:flutter/material.dart';

void main() {
  runApp(const WaliousUltraApp());
}

class WaliousUltraApp extends StatelessWidget {
  const WaliousUltraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAI Mail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _textController;
  late AnimationController _smokeController;
  
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;
  late Animation<double> _textReveal;
  late Animation<double> _smokeOpacity;

  @override
  void initState() {
    super.initState();

    // 1. ধোঁয়ার অ্যানিমেশন - সবার আগে ফেড ইন
    _smokeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // 2. রিং অ্যানিমেশন - ধোঁয়ার 300ms পর
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // 3. টেক্সট বিদ্যুৎ অ্যানিমেশন - রিং এর 1000ms পর
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _smokeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _smokeController, curve: Curves.easeIn),
    );

    _ringScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOutBack),
    );

    _ringOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeIn),
    );

    _textReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _
