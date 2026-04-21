import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZAiMailApp()); // 👈 AdMob পরে চালু করবো, ক্র্যাশ আটকাবে
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
      home: const SplashScreen(), // 👈 আগে Splash দেখাবো
    );
  }
}

// 🔥 SPLASH SCREEN - স্মোক + রেডিয়াল ব্লার + বিজলি ইফেক্ট 🔥
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

    // 3 সেকেন্ড পর AdMob ইনিশিয়ালাইজ + হোমে যাও
    Timer(const Duration(seconds: 3), () async {
      await _initAdMob(); // 👈 সেফ ভাবে AdMob চালু
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ChooseAccountPage()),
        );
      }
    });
  }

  Future<void> _initAdMob() async {
    try {
      await MobileAds.instance.initialize(); // 👈 Try-Catch দিয়ে ক্র্যাশ আটকালাম
    } catch (e) {
      debugPrint('AdMob Init Error: $e'); // Error হলেও অ্যাপ চলবে
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZAiColors.crystalDark,
      body: Stack(
        children: [
          // রেডিয়াল ব্লার ব্যাকগ্রাউন্ড
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0x1A10B981), // Emerald glow
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // স্মোক ইফেক্ট
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.5),
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.03),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          // ZAI লোগো + বিজলি গ্লো
          Center(
            child: AnimatedBuilder(
              animation: _glowAnimation,
              builder: (context, child) {
                return Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: ZAiColors.emeraldGlow
                            .withOpacity(_glowAnimation.value * 0.6),
                        blurRadius: 100,
                        spreadRadius: 20,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // বিজলি আইকন
                      Icon(
                        Icons.flash_on,
                        size: 60,
                        color: ZAiColors.emeraldGlow
                            .withOpacity(_glowAnimation.value),
                      ),
                      const SizedBox(height: 16),
                      // Z A I টেক্সট - স্টেপ বাই স্টেপ ফেড ইন
                      const Text(
                        'Z A I',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'MAIL',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withOpacity(0.5),
                          letterSpacing: 12,
                        ),
                      ),
                    ],
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

// CHOOSE ACCOUNT PAGE + BANNER AD 🔥
class ChooseAccountPage extends StatefulWidget {
  const ChooseAccountPage({super.key});
  @override
  State<ChooseAccountPage> createState() => _ChooseAccountPageState();
}

class _ChooseAccountPageState extends State<ChooseAccountPage> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    _bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-3940256099942544/6300974706',
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed: $error'); // Error হলেও ক্র্যাশ করবে না
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget _buildPremiumLoginButton({
    required String title,
    required String subtitle,
    required String logoUrl,
    required Color glowColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: ZAiColors.cardColor,
          borderRadius: BorderRadius.circular(35),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 60, offset: const Offset(0, 20)),
            BoxShadow(color: glowColor.withOpacity(0.1), blurRadius: 30, spreadRadius: -5),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48, height: 48,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.all(8),
              child: Image.network
