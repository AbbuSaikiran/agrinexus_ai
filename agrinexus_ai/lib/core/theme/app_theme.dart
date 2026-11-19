import 'package:flutter/material.dart';

class AppTheme {
  // Brand Color Palette
  static const Color primaryGreen = Color(0xFF1B5E20);      // Deep Forest Green
  static const Color brandGreen = Color(0xFF2E7D32);        // Vibrant Emerald
  static const Color lightGreen = Color(0xFF4CAF50);        // Sprout Green
  static const Color accentGold = Color(0xFFFFB300);        // Golden Harvest
  static const Color darkSlate = Color(0xFF0F172A);         // Deep charcoal heading
  static const Color lightBg = Color(0xFFF8FAFC);           // Slate 50 clean background
  static const Color cardBg = Color(0xFFFFFFFF);            // Pure white cards
  static const Color surfaceMuted = Color(0xFFF1F5F9);      // Slate 100 soft surface
  static const Color textDark = Color(0xFF1E293B);          // Slate 800 body text
  static const Color textGrey = Color(0xFF64748B);          // Slate 500 secondary text
  static const Color borderSubtle = Color(0xFFE2E8F0);      // Slate 200 clean borders
  static const Color errorRed = Color(0xFFDC2626);          // Red 600
  static const Color successGreen = Color(0xFF16A34A);      // Green 600
  static const Color warningOrange = Color(0xFFEA580C);     // Orange 600

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: brandGreen,
          primary: brandGreen,
          secondary: accentGold,
          surface: cardBg,
          error: errorRed,
        ),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: brandGreen,
            foregroundColor: Colors.white,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: brandGreen,
            side: const BorderSide(color: brandGreen, width: 1.5),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            textStyle: const TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: borderSubtle),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: borderSubtle),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: brandGreen, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: errorRed),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          labelStyle: const TextStyle(color: textGrey, fontSize: 13),
          hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
        ),
        cardTheme: CardThemeData(
          color: cardBg,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: borderSubtle, width: 1),
          ),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: surfaceMuted,
          selectedColor: brandGreen.withValues(alpha: 0.15),
          labelStyle: const TextStyle(fontSize: 12, fontFamily: 'Poppins'),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: borderSubtle),
          ),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            color: darkSlate,
            letterSpacing: -0.5,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: darkSlate,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: darkSlate,
          ),
          titleMedium: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: darkSlate,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textDark,
          ),
          bodyMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w400,
            color: textGrey,
          ),
          labelLarge: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: darkSlate,
          ),
        ),
        scaffoldBackgroundColor: lightBg,
      );
}
