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
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    // 3 সেকেন্ড পর HomePage এ যাবে
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
          return Container(
            decoration: BoxDecoration(
              // ছবির মতো সবুজ রেডিয়াল গ্লো
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 0.6 + _controller.value * 0.1,
                colors: [
                  const Color(0xFF00FF88).withOpacity(0.15 + _controller.value * 0.1),
                  const Color(0xFF0A0A0A),
                ],
                stops: const [0.0, 1.0],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // সবুজ বিজলি আইকন
                  Icon(
                    Icons.flash_on,
                    size: 60,
                    color: const Color(0xFF00FF88),
                    shadows: [
                      Shadow(
                        color: const Color(0xFF00FF88).withOpacity(0.8),
                        blurRadius: 20 + _controller.value * 10,
                      )
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Z A I টেক্সট
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Z', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w300, color: Colors.white, letterSpacing: 20)),
                      Text('A', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w300, color: Colors.white, letterSpacing: 20)),
                      Text('I', style: TextStyle(fontSize: 52, fontWeight: FontWeight.w300, color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // MAIL টেক্সট
                  Text(
                    'M A I L',
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 12,
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
