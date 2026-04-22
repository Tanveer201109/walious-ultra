import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZAiMailApp());
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
        scaffoldBackgroundColor: const Color(0xFF0A0A0A),
        useMaterial3: true,
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
  late AnimationController _textController;

  late Animation<double> _ringScale;
  late Animation<double> _ringFade;
  late Animation<double> _flashOpacity;
  late Animation<double> _textFade;
  late Animation<double> _textGlow;

  @override
  void initState() {
    super.initState();

    // 1. রিং অ্যানিমেশন - 1.2s
    _ringController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _ringScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOutBack),
    );
    _ringFade = Tween<double>(begin: 0.0, end: 1.0).animate(_ringController);

    // 2. বিদ্যুৎ ফ্ল্যাশ - 0.2s
    _flashController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _flashOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flashController, curve: Curves.easeInOut),
    );

    // 3. টেক্সট অ্যানিমেশন - 0.6s
    _textController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(_textController);
    _textGlow = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    _startSequence();
  }

  void _startSequence() async {
    // স্টেপ 1: রিং আসবে
    await _ringController.forward();

    // স্টেপ 2: বিদ্যুৎ ফ্ল্যাশ
    _flashController.forward().then((_) => _flashController.reverse());
    await Future.delayed(const Duration(milliseconds: 100));

    // স্টেপ 3: [zAi] টেক্সট জ্যাপ করে আসবে
    await _textController.forward();

    // স্টেপ 4: 2s পর Home এ যাবে
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _ringController.dispose();
    _flashController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          // Grok স্টাইল স্মোক - ডান দিক থেকে
          Positioned(
            right: -100,
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.7, 0),
                  radius: 1.2,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),
          ),

          // মেইন লোগো এরিয়া
          Center(
            child: SizedBox(
              width: 300,
              height: 300,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // 1. গোল্ডেন রিং - প্রথমে আসবে
                  FadeTransition(
                    opacity: _ringFade,
                    child: ScaleTransition(
                      scale: _ringScale,
                      child: Container(
                        width: 280,
                        height: 280,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFD700).withOpacity(0.4),
                              blurRadius: 60,
                              spreadRadius: 8,
                            ),
                          ],
                        ),
                        child: Image.asset(
                          'assets/logo_ring.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // 2. বিদ্যুৎ ফ্ল্যাশ ইফেক্ট
                  FadeTransition(
                    opacity: _flashOpacity,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.9),
                            blurRadius: 50,
                            spreadRadius: 25,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // 3. [zAi] টেক্সট - বিদ্যুতের মতো জ্যাপ করে আসবে
                  FadeTransition(
                    opacity: _textFade,
                    child: AnimatedBuilder(
                      animation: _textGlow,
                      builder: (context, child) {
                        return Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFFFD700)
                                   .withOpacity(0.6 * _textGlow.value),
                                blurRadius: 40 * _textGlow.value,
                                spreadRadius: 5 * _textGlow.value,
                              ),
                              BoxShadow(
                                color: Colors.white
                                   .withOpacity(0.8 * _textGlow.value),
                                blurRadius: 20 * _textGlow.value,
                              ),
                            ],
                          ),
                          child: Image.asset(
                            'assets/logo_text.png',
                            width: 180,
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
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
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: Text(
          'Home Screen - Login UI নেক্সট',
          style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 18),
        ),
      ),
    );
  }
}
