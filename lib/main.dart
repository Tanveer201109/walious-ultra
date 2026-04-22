import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAI Mail',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
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
  late AnimationController _textController;
  late Animation<double> _ringScale;
  late Animation<double> _ringOpacity;
  late Animation<double> _textReveal;

  @override
  void initState() {
    super.initState();

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _ringScale = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeOutBack),
    );

    _ringOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _ringController, curve: Curves.easeIn),
    );

    _textReveal = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeOutCubic),
    );

    _startAnimationSequence();
  }

  void _startAnimationSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _ringController.forward();
    await Future.delayed(const Duration(milliseconds: 1000));
    _textController.forward();
  }

  @override
  void dispose() {
    _ringController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: AnimatedBuilder(
        animation: Listenable.merge([_ringController, _textController]),
        builder: (context, _) {
          return Stack(
            children: [
              // ধোঁয়ার ব্যাকগ্রাউন্ড
              Positioned(
                right: -150,
                top: -80,
                bottom: -80,
                child: Opacity(
                  opacity: 0.9,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: const Alignment(0.75, 0.0),
                        radius: 1.4,
                        colors: [
                          Colors.white.withOpacity(0.20),
                          Colors.white.withOpacity(0.08),
                          Colors.white.withOpacity(0.02),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.3, 0.6, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // রিং + ]zAi[ লোগো
              Center(
                child: Opacity(
                  opacity: _ringOpacity.value,
                  child: Transform.scale(
                    scale: _ringScale.value,
                    child: SizedBox(
                      width: 320,
                      height: 320,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // রিং + Shader Effect
                          Container(
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFFD700).withOpacity(0.3),
                                  blurRadius: 70,
                                  spreadRadius: 8,
                                ),
                                BoxShadow(
                                  color: const Color(0xFF00E5FF).withOpacity(0.5 * _ringOpacity.value),
                                  blurRadius: 100,
                                  spreadRadius: 20,
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.25 * _ringOpacity.value),
                                  blurRadius: 140,
                                  spreadRadius: 30,
                                ),
                              ],
                            ),
                            child: Image.asset(
                              'assets/logo_ring.png',
                              width: 300,
                              fit: BoxFit.contain,
                            ),
                          ),

                          // ]zAi[ টেক্সট বিদ্যুৎ রিভিল
                          ClipRect(
                            child: Align(
                              alignment: Alignment.centerLeft,
                              widthFactor: _textReveal.value,
                              child: ShaderMask(
                                shaderCallback: (bounds) => LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: const [
                                    Colors.white,
                                    Color(0xFF00E5FF),
                                    Color(0xFF0088FF),
                                    Colors.white,
                                  ],
                                  stops: [
                                    0.0,
                                    _textReveal.value * 0.5,
                                    _textReveal.value,
                                    1.0,
                                  ],
                                ).createShader(bounds),
                                blendMode: BlendMode.srcATop,
                                child: Image.asset(
                                  'assets/logo_text.png',
                                  width: 180,
                                  fit: BoxFit.contain,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
