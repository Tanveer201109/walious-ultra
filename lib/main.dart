import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:async';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ZAiMailApp());
}

class ZAiColors {
  static const crystalDark = Color(0xFF0c1110);
  static const emeraldGlow = Color(0xFF10B981);
  static const cardColor = Color(0xFF131918);
  static const googleRed = Color(0xFFDB4437);
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

    Timer(const Duration(seconds: 3), () async {
      await _initAdMob();
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ChooseAccountPage()),
        );
      }
    });
  }

  Future<void> _initAdMob() async {
    try {
      await MobileAds.instance.initialize();
    } catch (e) {
      debugPrint('AdMob Init Error: $e');
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
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.5,
                colors: [
                  Color(0x1A10B981),
                  Colors.transparent,
                ],
              ),
            ),
          ),
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
                      Icon(
                        Icons.flash_on,
                        size: 60,
                        color: ZAiColors.emeraldGlow
                            .withOpacity(_glowAnimation.value),
                      ),
                      const SizedBox(height: 16),
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
        onAdLoaded: (ad) {
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Ad failed: $error');
        },
      ),
    );
    _bannerAd!.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget _buildLoginButton({
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
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              blurRadius: 60,
              offset: const Offset(0, 20),
            ),
            BoxShadow(
              color: glowColor.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: -5,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(8),
              child: Image.network(
                logoUrl,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.error, color: Colors.red);
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ZAiColors.crystalDark,
      bottomNavigationBar: _isAdLoaded && _bannerAd != null
          ? SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Text(
                  'ZAI Mail',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  'One inbox for all your accounts',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Text(
                'CONTINUE WITH',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.4),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              _buildLoginButton(
                title: 'Google Mail',
                subtitle: 'Sign in with @gmail.com',
                logoUrl: 'https://img.icons8.com/color/96/gmail-new.png',
                glowColor: ZAiColors.googleRed,
              ),
              _buildLoginButton(
                title: 'Yahoo Mail',
                subtitle: 'Sign in with @yahoo.com',
                logoUrl: 'https://img.icons8.com/color/96/yahoo.png',
                glowColor: const Color(0xFF6001D2),
              ),
              _buildLoginButton(
                title: 'ZAI Mail',
                subtitle: 'Create or sign in @zaimail',
                logoUrl: 'https://img.icons8.com/fluency/96/new-post.png',
                glowColor: ZAiColors.emeraldGlow,
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
