import 'package:flutter/material.dart';

class Palette {
  Palette._();

  // Shared Brand Accents
  static const Color primaryPurple = Color(0xFF7B2CBF);
  static const Color accentPurple = Color(0xFFA052E0);
  // lighter tint for dark surfaces
  static const Color softPurple = Color(0xFFBA86EF);
  // very light for light surfaces
  static const Color mutedPurple = Color(0xFFE8D5FA);

  // Dark Theme
  static const Color darkBackground = Color(0xFF0D0A13); // Deepest
  static const Color darkSurfaceLowest = Color(0xFF120F1A); // +1 step
  static const Color darkSurfaceLow = Color(0xFF171220); // +2 step
  static const Color darkSurface = Color(0xFF1C1628);
  static const Color darkSurfaceHigh = Color(0xFF221B30);
  static const Color darkSurfaceVariant = Color(0xFF291F39);
  static const Color darkSidebar = Color(0xFF100D18);
  static const Color darkBorder = Color(0xFF2F2042);
  static const Color darkTextMain = Color(0xFFE4DEEF);
  static const Color darkTextDim = Color(0xFF9E9E9E);
  static const Color darkTextMuted = Color(0xFF6B6075);

  // Light Theme
  static const Color lightBackground = Color(0xFFF7F4FB);
  static const Color lightSurfaceVariant = Color(0xFFF0EAF8);
  static const Color lightSurfaceHigh = Color(0xFFF5F0FA);
  static const Color lightSurface = Color(0xFFF4F2F8);
  static const Color lightSurfaceLow = Color(0xFFF9F3FD);
  static const Color lightSurfaceLowest = Color(0xFFFDFCFF);
  static const Color lightSidebar = Color(0xFFEDE6F7);
  static const Color lightBorder = Color(0xFFD2B2F9);
  static const Color lightTextMain = Color(0xFF1A0D2E);
  static const Color lightTextDim = Color(0xFF5E5370);
  static const Color lightTextMuted = Color(0xFFAA9EBB);

  // Semantic Colors (shared)
  static const Color success = Color(0xFF2ECC71);
  static const Color successLight = Color(0xFFD4F5E4);
  static const Color error = Color(0xFFE53E3E);
  static const Color errorLight = Color(0xFFFFE5E5);
  static const Color warning = Color(0xFFF6AD55);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF4299E1);
  static const Color infoLight = Color(0xFFE8F4FD);
}
