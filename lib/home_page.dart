import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      appBar: AppBar(
        title: const Text(
          '[zAi] Mail',
          style: TextStyle(
            fontFamily: 'Georgia',
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AF37),
          ),
        ),
        backgroundColor: const Color(0xFF0A0A0A),
        elevation: 0,
        centerTitle: true,
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to ZAI Mail',
              style: TextStyle(
                fontSize: 28,
                color: Color(0xFFD4AF37),
                fontFamily: 'Georgia',
              ),
            ),
            SizedBox(height: 8),
            Text(
              'THE FAITH STANDARD',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 4,
                color: Color(0xFFC8C8C8),
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Inbox Coming Soon...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
