import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Core brand palette (Configured for Light Theme matching the cyan/navy Nakshatra logo)
  static const Color goldPrimary = Color(
    0xFF00BDD6,
  ); // Teal/Cyan Accent from Logo
  static const Color goldLight = Color(0xFF80DEEA); // Light Teal
  static const Color goldDark = Color(
    0xFF0D4863,
  ); // Dark Teal from Logo Gradient
  static const Color deepBlack = Color(
    0xFFF8FAFC,
  ); // Light Slate/Ice Scaffold Background
  static const Color richBlack = Color(
    0xFFF1F5F9,
  ); // Light Slate Section Background
  static const Color cardBlack = Color(
    0xFFFFFFFF,
  ); // Pure White Card Background
  static const Color surfaceBlack = Color(
    0xFFF1F5F9,
  ); // Light Slate Input Surface Background
  static const Color ivory = Color(
    0xFF0A1C30,
  ); // Dark Navy/Slate Text (High Contrast)
  static const Color ivoryDark = Color(0xFF1E293B); // Slate Gray Heading Text
  static const Color textSecondary = Color(
    0xFF475569,
  ); // Medium Slate Gray Secondary Text
  static const Color success = Color(0xFF10B981); // Emerald Success Green
  static const Color danger = Color(0xFFEF4444); // Rose Danger Red
  static const Color warning = Color(0xFFF59E0B); // Amber Warning Orange
  static const Color info = Color(0xFF3B82F6); // Bright Info Blue

  static LinearGradient get goldGradient => const LinearGradient(
    colors: [
      Color(0xFF00BDD6),
      Color(0xFF0D4863),
    ], // Cyan to Dark Teal Gradient
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient get darkGradient => const LinearGradient(
    colors: [Color(0xFFF1F5F9), Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static LinearGradient get cardGradient => const LinearGradient(
    colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static BoxDecoration get goldCard => BoxDecoration(
    gradient: const LinearGradient(
      colors: [Color(0xFF00BDD6), Color(0xFF00ACC1), Color(0xFF0D4863)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: goldPrimary.withOpacity(0.3),
        blurRadius: 15,
        offset: const Offset(0, 6),
      ),
    ],
  );

  static BoxDecoration get darkCard => BoxDecoration(
    color: cardBlack,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: goldPrimary.withOpacity(0.15), width: 1),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  static ThemeData get theme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: deepBlack,
    primaryColor: goldPrimary,
    colorScheme: const ColorScheme.light(
      primary: goldPrimary,
      secondary: goldLight,
      surface: cardBlack,
      background: deepBlack,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.playfairDisplay(
        color: ivory,
        fontSize: 36,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        color: ivory,
        fontSize: 28,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.playfairDisplay(
        color: ivory,
        fontSize: 24,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: GoogleFonts.playfairDisplay(
        color: ivory,
        fontSize: 20,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: GoogleFonts.lato(
        color: ivory,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      titleMedium: GoogleFonts.lato(
        color: ivory,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: GoogleFonts.lato(
        color: textSecondary,
        fontSize: 15,
        fontWeight: FontWeight.w400,
      ),
      bodyMedium: GoogleFonts.lato(
        color: textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w400,
      ),
      labelLarge: GoogleFonts.lato(
        color: goldPrimary,
        fontSize: 14,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: ivory,
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      iconTheme: const IconThemeData(color: goldPrimary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceBlack,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: goldPrimary.withOpacity(0.2)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: goldPrimary.withOpacity(0.15)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: goldPrimary, width: 1.5),
      ),
      hintStyle: GoogleFonts.lato(color: const Color(0xFF94A3B8), fontSize: 14),
      labelStyle: GoogleFonts.lato(color: goldPrimary, fontSize: 14),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: goldPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        textStyle: GoogleFonts.lato(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: cardBlack,
      selectedItemColor: goldPrimary,
      unselectedItemColor: const Color(0xFF94A3B8),
      showSelectedLabels: true,
      showUnselectedLabels: true,
      selectedLabelStyle: GoogleFonts.lato(
        fontSize: 11,
        fontWeight: FontWeight.w600,
      ),
      unselectedLabelStyle: GoogleFonts.lato(fontSize: 11),
      type: BottomNavigationBarType.fixed,
    ),
  );
}
