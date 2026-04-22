import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // সবুজ বিজলি আইকন
              Icon(Icons.flash_on, size: 80, color: const Color(0xFF00FF88)),
              const SizedBox(height: 24),
              const Text(
                'ZAI MAIL',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Text(
                'Secure. Fast. Yours.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 50),

              // Google Button
              ElevatedButton.icon(
                onPressed: () => _handleGoogleSignIn(context),
                icon: const Icon(Icons.g_mobiledata, color: Colors.black, size: 28),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Facebook Button
              ElevatedButton.icon(
                onPressed: () => _handleFacebookSignIn(context),
                icon: const Icon(Icons.facebook, color: Colors.white),
                label: const Text('Continue with Facebook'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ZAI MAIL Create Button
              OutlinedButton.icon(
                onPressed: () => _handleZaiMailCreate(context),
                icon: const Icon(Icons.mail, color: Color(0xFF00FF88)),
                label: const Text('Create ZAI MAIL Account'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00FF88),
                  side: const BorderSide(color: Color(0xFF00FF88), width: 1.5),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: const [
                  Expanded(child: Divider(color: Colors.grey)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR', style: TextStyle(color: Colors.grey)),
                  ),
                  Expanded(child: Divider(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 20),

              // Login Button
              ElevatedButton(
                onPressed: () => _handleLogin(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF88),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Google Sign In
  Future<void> _handleGoogleSignIn(BuildContext context) async {
    try {
      _showSnack(context, 'Signing in with Google...');
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // User canceled

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      _showSnack(context, 'Google Sign In Success');
      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage()));
    } catch (e) {
      _showSnack(context, 'Google Sign In Failed: $e');
    }
  }

  // Facebook Sign In - Meta SDK
  Future<void> _handleFacebookSignIn(BuildContext context) async {
    try {
      _showSnack(context, 'Signing in with Facebook...');
      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final OAuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);
        
        await FirebaseAuth.instance.signInWithCredential(credential);
        _showSnack(context, 'Facebook Sign In Success');
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => DashboardPage()));
      } else {
        _showSnack(context, 'Facebook Sign In Cancelled');
      }
    } catch (e) {
      _showSnack(context, 'Facebook Sign In Failed: $e');
    }
  }

  // ZAI MAIL Create
  void _handleZaiMailCreate(BuildContext context) {
    _showSnack(context, 'Opening Register Page...');
    // Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterPage()));
  }

  // Login
  void _handleLogin(BuildContext context) {
    _showSnack(context, 'Opening Login Page...');
    // Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
