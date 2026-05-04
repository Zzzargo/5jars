import 'package:five_jars_ultra/shared/palette.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  AppTextStyles._();

  // Using DM Sans as body font and Playfair Display as display font
  // Add to pubspec.yaml:
  //   google_fonts: ^6.1.0
  // Then: import 'package:google_fonts/google_fonts.dart';
  // And replace TextStyle(...) with GoogleFonts.dmSans(...) etc.

  static const TextTheme _base = TextTheme(
    displayLarge: TextStyle(
      fontSize: 58,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
    ),
    displayMedium: TextStyle(
      fontSize: 45,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.0,
    ),
    displaySmall: TextStyle(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.5,
    ),

    headlineLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
    ),
    headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),

    titleLarge: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.15,
      height: 1.6,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.2,
      height: 1.5,
    ),
    bodySmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w400,
      letterSpacing: 0.3,
      height: 1.5,
    ),

    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    ),
    labelMedium: TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.4,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  static TextTheme dark() => _base.apply(
    bodyColor: Palette.darkTextBody,
    displayColor: Palette.darkTextDisplay,
    decorationColor: Palette.darkTextDecorations,
  );

  static TextTheme light() => _base.apply(
    bodyColor: Palette.lightTextBody,
    displayColor: Palette.lightTextDisplay,
    decorationColor: Palette.lightTextDecorations,
  );
}
