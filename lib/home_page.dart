import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
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
                  color: Colors.white,
                  letterSpacing: 4,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Secure. Fast. Simple.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.5)),
              ),
              const SizedBox(height: 50),

              // Google Button
              ElevatedButton.icon(
                onPressed: () => _showSnack(context, 'Google Sign In'),
                icon: const Icon(Icons.g_mobiledata, color: Colors.black, size: 28),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // Facebook Button
              ElevatedButton.icon(
                onPressed: () => _showSnack(context, 'Facebook Sign In'),
                icon: const Icon(Icons.facebook, color: Colors.white),
                label: const Text('Continue with Facebook'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),

              // ZAI MAIL Create Button
              OutlinedButton.icon(
                onPressed: () => _showSnack(context, 'Create ZAI MAIL Account'),
                icon: const Icon(Icons.mail, color: Color(0xFF00FF88)),
                label: const Text('Create ZAI MAIL Account'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00FF88),
                  side: const BorderSide(color: Color(0xFF00FF88), width: 2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR', style: TextStyle(color: Colors.white.withOpacity(0.4))),
                  ),
                  Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                ],
              ),
              const SizedBox(height: 24),

              // Login Button
              ElevatedButton(
                onPressed: () => _showSnack(context, 'Login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00FF88),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'LOG IN',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 2),
                ),
              ),

              const SizedBox(height: 40),
              Text(
                'Powered by Meta',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.3)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
