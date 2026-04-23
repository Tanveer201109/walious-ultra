import 'dart:math';
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
name: ZAI MAIL Green Build
on:
  push:
    branches: [ main ]
  workflow_dispatch:

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: 0. Checkout repo
        uses: actions/checkout@v4

      - name: Setup Java 17
        uses: actions/setup-java@v4
        with:
          distribution: 'zulu'
          java-version: '17'

      - name: Setup Flutter 3.24
        uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
          channel: 'stable'

      - name: 1. Create fresh Flutter project
        run: flutter create --org com.zaimail --project-name zai_mail --platforms android .

      - name: 2. Add auth dependencies
        run: |
          flutter pub add firebase_core
          flutter pub add firebase_auth
          flutter pub add google_sign_in
          flutter pub add flutter_facebook_auth

      - name: 3. Write lib/main.dart
        run: |
          cat > lib/main.dart << 'EOF'
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
                debugShowCheckedModeBanner: false,
                theme: ThemeData.dark().copyWith(
                  scaffoldBackgroundColor: const Color(0xFF0A0A0A),
                ),
                home: const SplashScreen(),
              );
            }
          }
          EOF

      - name: 4. Write lib/splash_screen.dart
        run: |
          cat > lib/splash_screen.dart << 'EOF'
          import 'dart:math';
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
                duration: const Duration(milliseconds: 150),
              )..repeat(reverse: true);

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
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF00FF88).withOpacity(0.15 + _controller.value * 0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: CustomPaint(
                              size: const Size(200, 200),
                              painter: GreenLightningPainter(_controller.value),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Z', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: Colors.white.withOpacity(0.9), letterSpacing: 12)),
                              Text('A', style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, color: Colors.white.withOpacity(0.9), letterSpacing: 12)),
                              Text('I', style:
