@override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF0A0A0A), // Grok এর ডার্ক
    body: Stack(
      children: [
        // ধোঁয়ার ব্যাকগ্রাউন্ড - ডান দিক থেকে
        Positioned(
          right: -100,
          top: 0,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.7, 0),
                radius: 1.2,
                colors: [
                  Colors.white.withOpacity(0.15),
                  Colors.white.withOpacity(0.05),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 1.0],
              ),
            ),
          ),
        ),
        // তোমার গোল্ডেন রিং লোগো - মিডিলে
        Center(
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD700).withOpacity(0.3),
                  blurRadius: 80,
                  spreadRadius: 10,
                ),
              ],
            ),
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.contain,
            ),
          ),
        ),
      ],
    ),
  );
}
