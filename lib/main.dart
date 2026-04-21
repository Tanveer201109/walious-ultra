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
      adUnitId: 'ca-app-pub-3940256099942544/6300974706', // Google এর টেস্ট ID
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

  // তোমার আগের _buildPremiumLoginButton ফাংশন এখানে থাকবে...
  Widget _buildPremiumLoginButton({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String logoUrl,
    required Color glowColor,
    required VoidCallback onTap,
  }) {
    // তোমার Commit এর কোড এখানে পেস্ট করো, কোনো চেঞ্জ নাই
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
      // Banner Ad নিচে ফিক্সড থাকবে 🔥 ইউজার যতক্ষণ অ্যাপে থাকবে, ইনকাম চলবে
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
              children: [
                const SizedBox(height: 40),
                const Center(child: Text('ZAI Mail', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white))),
                const SizedBox(height: 48),
                // তোমার বাটনগুলা এখানে... আগের মতোই
                _buildPremiumLoginButton(context: context, title: 'Google Mail', subtitle: 'Sign in with @gmail.com', logoUrl: 'https://img.icons8.com/color/96/gmail-new.png', glowColor: Colors.red, onTap: () {}),
                _buildPremiumLoginButton(context: context, title: 'Yahoo Mail', subtitle: 'Sign in with @yahoo.com', logoUrl: 'https://img.icons8.com/color/96/yahoo.png', glowColor: Color(0xFF6001D2), onTap: () {}),
                _buildPremiumLoginButton(context: context, title: 'ZAI Mail', subtitle: 'Create or sign in @zaimail', logoUrl: 'https://img.icons8.com/fluency/96/new-post.png', glowColor: ZAiColors.emeraldGlow, onTap: () {}),
                const SizedBox(height: 80), // Ad এর জন্য জায়গা
              ],
            ),
          ),
        ),
      ),
    );
  }
}
