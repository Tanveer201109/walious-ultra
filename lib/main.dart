import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart'; // 👈 এই লাইন কমেন্ট করো
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZAiMailApp());
}

// ... বাকি সব সেম থাকবে ...

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // ... সেম কোড ...
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);

    Timer(const Duration(seconds: 3), () {
      // await _initAdMob(); // 👈 এই লাইন কমেন্ট করো
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChooseAccountPage()),
        );
      }
    });
  }

  // Future<void> _initAdMob() async { ... } // 👈 পুরা ফাংশন কমেন্ট করো

  // ... বাকি build সেম ...
}

class _ChooseAccountPageState extends State<ChooseAccountPage> {
  // BannerAd? _bannerAd; // 👈 কমেন্ট
  // bool _isAdLoaded = false; // 👈 কমেন্ট

  @override
  void initState() {
    super.initState();
    // _loadBannerAd(); // 👈 কমেন্ট
  }

  // void _loadBannerAd() { ... } // 👈 পুরা ফাংশন কমেন্ট

  @override
  void dispose() {
    // _bannerAd?.dispose(); // 👈 কমেন্ট
    super.dispose();
  }

  // ... _buildLoginButton সেম ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZAiColors.crystalDark,
      // bottomNavigationBar: null, // 👈 Ad বাদ
      body: // ... বাকি সেম ...
    );
  }
}
