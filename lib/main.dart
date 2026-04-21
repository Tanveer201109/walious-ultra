import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart'; // 👈 নতুন Import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize(); // 👈 AdMob চালু
  runApp(const ZAiMailApp());
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
        colorScheme: ColorScheme.fromSeed(
          seedColor: ZAiColors.emeraldGlow,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const ChooseAccountPage(),
    );
  }
}

// MATTE FINISH WIDGET
class MatteFinish extends StatelessWidget {
  final Widget child;
  const MatteFinish({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.2,
          colors: [ZAiColors.matteOverlay, Colors.transparent],
        ),
        color: ZAiColors.crystalDark,
      ),
      child: child,
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
      adUnitId: 'ca-app-pub-3940256099942544/6300974706', // Test ID
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) => setState(() => _isAdLoaded = true),
        onAdFailedToLoad: (ad, error) => ad.dispose(),
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Widget _buildPremiumLoginButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String logoUrl,
    required Color glowColor,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(35),
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
                child: Image.network(logoUrl, fit: BoxFit.contain),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: TextStyle(fontSize: 13, color: Colors.white.withOpacity(0.5))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _isAdLoaded
          ? Container(
              color: ZAiColors.crystalDark,
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            )
          : null,
      body: MatteFinish(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                const Center(child: Text('ZAI Mail', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white))),
                const SizedBox(height: 8),
                Center(child: Text('One inbox for all your accounts', style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6)))),
                const SizedBox(height: 48),
                Text('CONTINUE WITH', style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.4), fontWeight: FontWeight.w700, letterSpacing: 1.2)),
                const SizedBox(height: 16),
                _buildPremiumLoginButton(context: context, title: 'Google Mail', subtitle: 'Sign in with @gmail.com', logoUrl: 'https://img.icons8.com/color/96/gmail-new.png', glowColor: ZAiColors.googleRed, onTap: () {}),
                _buildPremiumLoginButton(context: context, title: 'Yahoo Mail', subtitle: 'Sign in with @yahoo.com', logoUrl: 'https://img.icons8.com/color/96/yahoo.png', glowColor: const Color(0xFF6001D2), onTap: () {}),
                _buildPremiumLoginButton(context: context, title: 'Facebook', subtitle: 'Continue with Facebook', logoUrl: 'https://img.icons8.com/color/96/facebook-new.png', glowColor: ZAiColors.facebookBlue, onTap: () {}),
                _buildPremiumLoginButton(context: context, title: 'X / Twitter', subtitle: 'Sign in with @x account', logoUrl: 'https://img.icons8.com/ios-filled/100/ffffff/twitterx.png', glowColor: Colors.white, onTap: () {}),
                _buildPremiumLoginButton(context: context, title: 'ZAI Mail', subtitle: 'Create or sign in @zaimail', logoUrl: 'https://img.icons8.com/fluency/96/new-post.png', glowColor: ZAiColors.emeraldGlow, onTap: () {}),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
