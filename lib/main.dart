import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ZAiMailApp());
}

class ZAiMailApp extends StatelessWidget {
  const ZAiMailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
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

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _ringController;
  late AnimationController _flashController;
  late Animation<double> _scale;
  late Animation<double> _flash;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _scale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.elasticOut),
    );
    _flash = Tween<double>(begin: 0.0, end: 1.0).animate(_flashController);
    _glow = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _ringController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeIn),
      ),
    );

    _startAnim();
  }

  void _startAnim() async {
    await _ringController.forward();
    await _flashController.forward();
    await _flashController.reverse();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
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
      body: Stack(
        children: [
          // ধোঁয়ার ব্যাকগ্রাউন্ড - ডান দিক থেকে
          Positioned(
            right: -150,
            top: -100,
            bottom: -100,
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.8, 0),
                  radius: 1.0,
                  colors: [
                    Colors.white.withOpacity(0.12),
                    Colors.white.withOpacity(0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // লোগো + বিদ্যুৎ ইফেক্ট
          Center(
            child: AnimatedBuilder(
              animation: Listenable.merge([_ringController, _flashController]),
              builder: (context, child) {
                return Transform.scale(
                  scale: _scale.value,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFD700).withOpacity(0.5 * _glow.value),
                          blurRadius: 80 * _glow.value,
                          spreadRadius: 10 * _glow.value,
                        ),
                        BoxShadow(
                          color: Colors.white.withOpacity(0.9 * _flash.value),
                          blurRadius: 60 * _flash.value,
                          spreadRadius: 30 * _flash.value,
                        ),
                      ],
                    ),
                    child: Image.asset('assets/logo.png'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'ZAI Mail Home - Login UI নেক্সট',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }
}
