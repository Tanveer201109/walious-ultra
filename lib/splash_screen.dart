import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'lightning_painter.dart';
import 'ring_painter.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Ring rotation controller
  late AnimationController _ringController;

  // Ring glow pulse controller
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  // Lightning flash controller
  late AnimationController _lightningController;
  late Animation<double> _lightningAnim;

  // Logo fade-in
  late AnimationController _logoController;
  late Animation<double> _logoFadeAnim;
  late Animation<double> _logoScaleAnim;

  // Lightning trigger state
  bool _showLightning = false;
  int _lightningKey = 0;
  Timer? _burstTimer;

  // Weather + Moonlight state
  Color _moonColor = const Color(0xFFD4AF37); // Default golden
  double _moonOpacity = 0.12;
  String _weatherDesc = 'Clear';

  @override
  void initState() {
    super.initState();

    // Weather দিয়ে moonlight কালার সেট করি
    _fetchWeatherAndSetMoonlight();

    // Rotating ring
    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    // Glow pulse
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Lightning flash opacity
    _lightningController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _lightningAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _lightningController, curve: Curves.easeOut),
    );

    // Logo fade in after 0.5s
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );
    _logoScaleAnim = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOut),
    );

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _logoController.forward();
    });

    // Start lightning bursts after 600ms
    Future.delayed(const Duration(milliseconds: 600), _scheduleBurst);

    // 3 সেকেন্ড পর HomePage এ যাও
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    });
  }

  Future<void> _fetchWeatherAndSetMoonlight() async {
    try {
      // Location permission চেক
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        return; // Permission নাই, default কালার থাকবে
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.low,
      );

      // OpenWeatherMap free API - তোমার API key বসাও
      const apiKey = 'YOUR_OPENWEATHERMAP_API_KEY';
      final url =
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey';

      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final weatherMain = data['weather'][0]['main'] as String;
        final clouds = data['clouds']['all'] as int; // 0-100
        final isNight = _isNightTime();

        setState(() {
          _weatherDesc = weatherMain;
          _setMoonlightByWeather(weatherMain, clouds, isNight);
        });
      }
    } catch (e) {
      // Weather fail হলে default golden moonlight থাকবে
      debugPrint('Weather fetch error: $e');
    }
  }

  bool _isNightTime() {
    final hour = DateTime.now().hour;
    return hour < 6 || hour >= 18; // 6PM to 6AM = night
  }

  void _setMoonlightByWeather(String weather, int cloudPercent, bool isNight) {
    if (!isNight) {
      // দিনের বেলা: হালকা নীলচে সাদা
      _moonColor = const Color(0xFFB0E0E6);
      _moonOpacity = 0.08;
      return;
    }

    // রাতের বেলা weather অনুযায়ী
    switch (weather.toLowerCase()) {
      case 'clear':
        _moonColor = const Color(0xFFE6E6FA); // Lavender moonlight
        _moonOpacity = 0.15;
        break;
      case 'clouds':
        _moonColor = const Color(0xFFC0C0C0); // Silver, মেঘলা
        _moonOpacity = 0.08 + (1 - cloudPercent / 100) * 0.07;
        break;
      case 'rain':
      case 'drizzle':
        _moonColor = const Color(0xFF708090); // Slate gray, বৃষ্টি
        _moonOpacity = 0.05;
        break;
      case 'thunderstorm':
        _moonColor = const Color(0xFF4B0082); // Indigo, বজ্রপাত
        _moonOpacity = 0.1;
        break;
      case 'snow':
        _moonColor = const Color(0xFFF0F8FF); // Alice blue, বরফ
        _moonOpacity = 0.18;
        break;
      case 'mist':
      case 'fog':
        _moonColor = const Color(0xFFD3D3D3); // Light gray, কুয়াশা
        _moonOpacity = 0.06;
        break;
      default:
        _moonColor = const Color(0xFFD4AF37); // Default golden
        _moonOpacity = 0.12;
    }
  }

  void _scheduleBurst() {
    if (!mounted) return;
    final burstSize = 2 + (DateTime.now().millisecondsSinceEpoch % 3).toInt();
    _doBurst(burstSize, 0);
  }

  void _doBurst(int total, int current) {
    if (!mounted) return;
    if (current >= total) {
      final pauseMs =
          1500 + (DateTime.now().millisecondsSinceEpoch % 2000).toInt();
      _burstTimer = Timer(Duration(milliseconds: pauseMs), _scheduleBurst);
      setState(() {
        _showLightning = false;
      });
      return;
    }

    setState(() {
      _showLightning = true;
      _lightningKey++;
    });
    _lightningController.forward(from: 0);

    final holdMs = 80 + (DateTime.now().millisecondsSinceEpoch % 50).toInt();
    _burstTimer = Timer(Duration(milliseconds: holdMs), () {
      if (!mounted) return;
      _lightningController.reverse();
      final gapMs = 60 + (DateTime.now().millisecondsSinceEpoch % 140).toInt();
      _burstTimer = Timer(Duration(milliseconds: gapMs), () {
        _doBurst(total, current + 1);
      });
    });
  }

  @override
  void dispose() {
    _ringController.dispose();
    _glowController.dispose();
    _lightningController.dispose();
    _logoController.dispose();
    _burstTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080808),
      body: Center(
        child: SizedBox(
          width: 320,
          height: 320,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Ambient outer glow - এখন moonlight
              AnimatedBuilder(
                animation: _glowAnim,
                builder: (_, __) => Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Color.fromRGBO(
                          _moonColor.red,
                          _moonColor.green,
                          _moonColor.blue,
                          _glowAnim.value * _moonOpacity,
                        ),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 1.0],
                    ),
                  ),
                ),
              ),

              // Rotating ring
              AnimatedBuilder(
                animation: _ringController,
                builder: (_, __) => Transform.rotate(
                  angle: _ringController.value * 2 * 3.14159,
                  child: AnimatedBuilder(
                    animation: _glowAnim,
                    builder: (_, __) => CustomPaint(
                      size: const Size(280, 280),
                      painter: RingPainter(glowIntensity: _glowAnim.value),
                    ),
                  ),
                ),
              ),

              // Lightning inside ring
              ClipOval(
                child: SizedBox(
                  width: 270,
                  height: 270,
                  child: AnimatedBuilder(
                    animation: _lightningAnim,
                    builder: (_, __) => Opacity(
                      opacity: _showLightning ? _lightningAnim.value : 0.0,
                      child: CustomPaint(
                        key: ValueKey(_lightningKey),
                        size: const Size(270, 270),
                        painter: LightningPainter(),
                      ),
                    ),
                  ),
                ),
              ),

              // Logo [xAI WALLET]
              AnimatedBuilder(
                animation: _logoController,
                builder: (_, __) => Opacity(
                  opacity: _logoFadeAnim.value,
                  child: Transform.scale(
                    scale: _logoScaleAnim.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildLogoText(),
                        const SizedBox(height: 8),
                        _buildTagline(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        // x
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFB0B0B0)],
          ).createShader(bounds),
          child: const Text(
            'x',
            style: TextStyle(
              fontSize: 38,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
        // A
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFB0B0B0)],
          ).createShader(bounds),
          child: const Text(
            'A',
            style: TextStyle(
              fontSize: 50,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
        // I
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFB0B0B0)],
          ).createShader(bounds),
          child: const Text(
            'I',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.0,
            ),
          ),
        ),
        const SizedBox(width: 12),
        // WALLET
        Text(
          'WALLET',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w300,
            color: Colors.white.withOpacity(0.85),
            letterSpacing: 4,
            height: 1.0,
            shadows: [
              Shadow(
                color: Colors.white.withOpacity(0.3),
                blurRadius: 12,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTagline() {
    return Text(
      _weatherDesc.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        letterSpacing: 3.5,
        color: _moonColor.withOpacity(0.85),
        fontWeight: FontWeight.w400,
        shadows: [
          Shadow(
            color: _moonColor.withOpacity(0.5),
            blurRadius: 10,
          ),
        ],
      ),
    );
  }
}
