import 'package:flutter/material.dart';

void main() {
  runApp(const ZAiMailApp());
}

// CUSTOM COLORS - তোমার CSS থেকে
class ZAiColors {
  static const crystalDark = Color(0xFF0c1110);
  static const emeraldGlow = Color(0xFF10B981);
  static const matteOverlay = Color(0x0AFFFFFF);
  static const cardColor = Color(0xFF131918);
}

class ZAiMailApp extends StatelessWidget {
  const ZAiMailApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZAI Mail', // নাম চেঞ্জ ✅
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: ZAiColors.crystalDark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: ZAiColors.emeraldGlow,
          brightness: Brightness.dark,
          background: ZAiColors.crystalDark,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        cardTheme: CardThemeData(
          color: ZAiColors.cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          elevation: 0,
          shadowColor: Colors
