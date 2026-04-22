name: ZAI Mail APK Builder

on:
  workflow_dispatch:
  push:
    branches: [ main ]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'
          
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'
          cache: true
          
      - name: Fix Gradle Project # এই স্টেপটা নতুন
        run: flutter create --platforms=android --project-name zai_mail .
          
      - name: Create main.dart - Ring Glow + Lightning
        run: |
          mkdir -p lib
          cat > lib/main.dart << 'EOF'
          import 'package:flutter/material.dart';
          import 'dart:async';
          import 'dart:math';
          void main() { runApp(const ZAiMailApp()); }
          class ZAiMailApp extends StatelessWidget {
            const ZAiMailApp({super.key});
            @override
            Widget build(BuildContext context) {
              return MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0A0A0A)),
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
            late AnimationController _ringController, _flashController, _scaleController;
            late Animation<double> _ringGlow, _flash, _scale;
            final Random _random = Random();
            @override
            void initState() {
              super.initState();
              _ringController = AnimationController(duration: const Duration(seconds: 2), vsync: this)..repeat(reverse: true);
              _flashController = AnimationController(duration: const Duration(milliseconds: 100), vsync: this);
              _scaleController = AnimationController(duration: const Duration(milliseconds: 1000), vsync: this);
              _ringGlow = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _ringController, curve: Curves.easeInOut));
              _flash = Tween<double>(begin: 0.0, end: 1.0).animate(_flashController);
              _scale = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut));
              _startSequence();
            }
            void _startSequence() async {
              await _scaleController.forward();
              _lightningLoop();
              await Future.delayed(const Duration(seconds: 4));
              if (mounted) { Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen())); }
            }
            void _lightningLoop() async {
              while(mounted) {
                await Future.delayed(Duration(milliseconds: 600 + _random.nextInt(2500)));
                if (!mounted) break;
                await _flashController.forward();
                await _flashController.reverse();
              }
            }
            @override
            void dispose() { _ringController.dispose(); _flashController.dispose(); _scaleController.dispose(); super.dispose(); }
            @override
            Widget build(BuildContext context) {
              return Scaffold(
                backgroundColor: const Color(0xFF0A0A0A),
                body: Center(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([_ringController, _flashController, _scaleController]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scale.value,
                        child: Container(
                          width: 300, height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: const Color(0xFFFFD700).withOpacity(0.7 * _ringGlow.value), blurRadius: 50 * _ringGlow.value, spreadRadius: 8 * _ringGlow.value),
                              BoxShadow(color: Colors.white.withOpacity(1.0 * _flash.value), blurRadius: 120 * _flash.value, spreadRadius: 25 * _flash.value),
                            ],
                          ),
                          child: Image.asset('assets/logo.png'),
                        ),
                      );
                    },
                  ),
                ),
              );
            }
          }
          class HomeScreen extends StatelessWidget {
            const HomeScreen({super.key});
            @override
            Widget build(BuildContext context) {
              return const Scaffold(backgroundColor: Color(0xFF0A0A0A), body: Center(child: Text('ZAI Mail Home', style: TextStyle(fontSize: 24, color: Colors.white))));
            }
          }
          EOF
          
      - name: Fix pubspec.yaml
        run: |
          sed -i "s/sdk: '>=3.0.0 <4.0.0'/sdk: '>=3.5.0 <4.0.0'/" pubspec.yaml
          if ! grep -q "assets/logo.png" pubspec.yaml; then
            sed -i '/flutter:/a \  assets:\n    - assets/logo.png' pubspec.yaml
          fi
          
      - name: Get packages
        run: flutter pub get
        
      - name: Build APK
        run: flutter build apk --release
        
      - name: Upload APK
        uses: actions/upload-artifact@v4
        with:
          name: zai-mail-apk
          path: build/app/outputs/flutter-apk/app-release.apk
