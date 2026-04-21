// 2. CHOOSE ACCOUNT PAGE - প্রিমিয়াম লোগো সহ 🔥
class ChooseAccountPage extends StatelessWidget {
  const ChooseAccountPage({super.key});

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
        borderRadius: BorderRadius.circular(35), // squircle-medium
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: ZAiColors.cardColor,
            borderRadius: BorderRadius.circular(35), // squircle-medium
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 60,
                offset: const Offset(0, 20),
              ), // premium-shadow
              BoxShadow(
                color: glowColor.withOpacity(0.1),
                blurRadius: 30,
                spreadRadius: -5,
              ), // Brand Glow
            ],
          ),
          child: Row(
            children: [
              // Premium Logo Container
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16), // Squircle Logo BG
                ),
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
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.white.withOpacity(0.3)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MatteFinish(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                // Header
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: ZAiColors.cardColor,
                      borderRadius: BorderRadius.circular(72), // squircle-large
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.6), blurRadius: 100)],
                    ),
                    child: const Icon(Icons.mail_rounded, size: 64, color: ZAiColors.emeraldGlow),
                  ),
                ),
                const SizedBox(height: 32),
                const Center(
                  child: Text('ZAI Mail', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: Colors.white)),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text('One inbox for all your accounts', 
                    style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),
                
                Text('CONTINUE WITH', 
                  style: TextStyle(
                    fontSize: 12, 
                    color: Colors.white.withOpacity(0.4), 
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  )
                ),
                const SizedBox(height: 16),

                // 1. Google Mail
                _buildPremiumLoginButton(
                  context: context,
                  title: 'Google Mail',
                  subtitle: 'Sign in with your @gmail.com',
                  logoUrl: 'https://img.icons8.com/color/96/gmail-new.png',
                  glowColor: ZAiColors.googleRed,
                  onTap: () => _showToast(context, 'Google Mail Login Coming Soon'),
                ),

                // 2. Yahoo Mail
                _buildPremiumLoginButton(
                  context: context,
                  title: 'Yahoo Mail',
                  subtitle: 'Sign in with your @yahoo.com',
                  logoUrl: 'https://img.icons8.com/color/96/yahoo.png',
                  glowColor: const Color(0xFF6001D2),
                  onTap: () => _showToast(context, 'Yahoo Mail Login Coming Soon'),
                ),

                // 3. Facebook
                _buildPremiumLoginButton(
                  context: context,
                  title: 'Facebook',
                  subtitle: 'Continue with Facebook account',
                  logoUrl: 'https://img.icons8.com/color/96/facebook-new.png',
                  glowColor: ZAiColors.facebookBlue,
                  onTap: () => _showToast(context, 'Facebook Login Coming Soon'),
                ),

                // 4. X / Twitter
                _buildPremiumLoginButton(
                  context: context,
                  title: 'X / Twitter',
                  subtitle: 'Sign in with your @x account',
                  logoUrl: 'https://img.icons8.com/ios-filled/100/ffffff/twitterx.png',
                  glowColor: Colors.white,
                  onTap: () => _showToast(context, 'X Login Coming Soon'),
                ),

                // 5. ZAI Mail - Main
                _buildPremiumLoginButton(
                  context: context,
                  title: 'ZAI Mail',
                  subtitle: 'Create or sign in @zaimail',
                  logoUrl: 'https://img.icons8.com/fluency/96/new-post.png',
                  glowColor: ZAiColors.emeraldGlow,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LoginPage())),
                ),

                const SizedBox(height: 32),
                Center(
                  child: Text('বস, সব মেইল এক জায়গায় 🔥 ১৮ XOXO', 
                    style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showToast(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: ZAiColors.cardColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
