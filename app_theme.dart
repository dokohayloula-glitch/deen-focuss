import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // Core Colors
  static const Color carbonBlack = Color(0xFF0D0D0D);
  static const Color deepCharcoal = Color(0xFF1C1C1E);
  static const Color surfaceGray = Color(0xFF2C2C2E);
  static const Color surfaceGrayLight = Color(0xFF3A3A3C);

  // Accent Colors
  static const Color islamicGold = Color(0xFFD4AF37);
  static const Color islamicGoldLight = Color(0xFFE8C547);
  static const Color islamicGoldDark = Color(0xFF8A7968);
  static const Color primaryBlue = Color(0xFF007AFF);
  static const Color deepEmerald = Color(0xFF2E8B57);
  static const Color alertRed = Color(0xFFFF3B30);
  static const Color successGreen = Color(0xFF34C759);

  // Text Colors
  static const Color primaryText = Colors.white;
  static final Color secondaryText = Colors.white.withOpacity(0.6);
  static final Color tertiaryText = Colors.white.withOpacity(0.3);

  // Gradient Decorations
  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [islamicGoldLight, islamicGold, islamicGoldDark],
  );

  static const LinearGradient emeraldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3CB371), deepEmerald],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [deepCharcoal, carbonBlack],
  );

  // Shadows
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> goldGlow = [
    BoxShadow(
      color: islamicGold.withOpacity(0.3),
      blurRadius: 20,
      offset: const Offset(0, 4),
    ),
  ];

  // Text Styles
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: primaryText,
    letterSpacing: -0.5,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: primaryText,
  );

  static TextStyle get headlineLarge => GoogleFonts.notoSansArabic(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: primaryText,
  );

  static TextStyle get headlineMedium => GoogleFonts.notoSansArabic(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: primaryText,
  );

  static TextStyle get bodyLarge => GoogleFonts.notoSansArabic(
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: primaryText,
  );

  static TextStyle get bodyMedium => GoogleFonts.notoSansArabic(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: primaryText,
  );

  static TextStyle get bodySmall => GoogleFonts.notoSansArabic(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: secondaryText,
  );

  static TextStyle get caption => GoogleFonts.notoSansArabic(
    fontSize: 13,
    fontWeight: FontWeight.normal,
    color: tertiaryText,
  );

  static TextStyle get goldTitle => GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: islamicGold,
  );

  // Button Styles
  static ButtonStyle get primaryButton => ElevatedButton.styleFrom(
    backgroundColor: deepEmerald,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: GoogleFonts.notoSansArabic(
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
  );

  static ButtonStyle get goldButton => ElevatedButton.styleFrom(
    backgroundColor: islamicGold,
    foregroundColor: carbonBlack,
    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    textStyle: GoogleFonts.notoSansArabic(
      fontSize: 16,
      fontWeight: FontWeight.w700,
    ),
  );

  // Input Decoration
  static InputDecoration get inputDecoration => InputDecoration(
    filled: true,
    fillColor: surfaceGray,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: islamicGold, width: 2),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    hintStyle: TextStyle(color: tertiaryText),
  );
}
