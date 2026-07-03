import 'package:flutter/material.dart';

class Palette {
  Palette._();

  // Dark Theme
  static const Color darkPrimary = Color(0xFF7B2CBF);
  static const Color darkOnPrimary = Colors.white;

  static const Color darkPrimaryContainer = Color(0xFFA052E0);
  static const Color darkOnPrimaryContainer = Color(0xFF2A0A44);

  static const Color darkSecondary = Color(0xFFA052E0);
  static const Color darkOnSecondary = Color(0xFF0D0A13);

  static const Color darkSecondaryContainer = Color(0xFF291F39);
  static const Color darkOnSecondaryContainer = Color(0xFFE8D5FA);

  static const Color darkSurface = Color(0xFF0D0A13); // Deepest
  static const Color darkSurfaceLowest = Color(0xFF120F1A); // +1
  static const Color darkSurfaceLow = Color(0xFF171220); // +2
  static const Color darkSurfaceContainer = Color(0xFF1C1628); // +3
  static const Color darkOnSurface = Color(0xFFE4DEEF);
  static const Color darkOnSurfaceVariant = Color(0xFFC4B6C9);
  static const Color darkSurfaceHigh = Color(0xFF221B30); // +4
  static const Color darkSurfaceHighest = Color(0xFF291F39); // +5

  static const Color darkSidebar = Color(0xFF100D18);
  static const Color darkBorder = Color(0xFF2F2042);
  static const Color darkBorderSubtle = Color(0x662F2042);

  static const Color darkShadow = Color(0xFF000000);
  static const Color darkShadowElevated = Color(0x78000000);
  static const Color darkScrim = Color(0xFF000000);

  static const Color darkTextDisplay = Color(0xFFE4DEEF);
  static const Color darkTextBody = Color(0xFFCEC5D8);
  static const Color darkTextDecorations = Color(0xFF8A7A9A);

  static const Color darkInversePrimary = Color(0xFFA451E9);
  static const Color darkInverseSurface = Color(0xFFF4F2F8);
  static const Color darkOnInverseSurface = Color(0xFF1A0D2E);

  // ----------------- Light Theme ---------------------------------------------
  static const Color lightPrimary = Color(0xFFA451E9);
  static const Color lightOnPrimary = Colors.white;

  static const Color lightPrimaryContainer = Color(0xFFB96CF9);
  static const Color lightOnPrimaryContainer = Color(0xFFF6F6F6);

  static const Color lightSecondary = Color(0xFFC48EF0);
  static const Color lightOnSecondary = Colors.white;

  static const Color lightSecondaryContainer = Color(0xFFF0EAF8);
  static const Color lightOnSecondaryContainer = Color(0xFF823EB9);

  static const Color lightSurface = Color(0xFFF7F4FB); // Lightest
  static const Color lightSurfaceLowest = Color(0xFFF7EEFF); // -1
  static const Color lightSurfaceLow = Color(0xFFF2E3FF); // -2
  static const Color lightSurfaceContainer = Color(0xFFEDD8FF); // -3
  static const Color lightOnSurface = Color(0xFF240F37);
  static const Color lightOnSurfaceVariant = Color(0xFF705D7E);
  static const Color lightSurfaceHigh = Color(0xFFE9CFFF); // -4
  static const Color lightSurfaceHighest = Color(0xFFE4C4FF); // -5

  static const Color lightSidebar = Color(0xFFEDE6F7);
  static const Color lightBorder = Color(0xFFD2B2F9);
  static const Color lightBorderSubtle = Color(0xB4D2B2F9);
  static const Color lightShadow = Color(0x1A7B2CBF);
  static const Color lightShadowElevated = Color(0x1A7B2CBF);
  static const Color lightScrim = Color(0xFF000000);

  static const Color lightTextDisplay = Color(0xFF1C0C2C);
  static const Color lightTextBody = Color(0xFF463B57);
  static const Color lightTextDecorations = Color(0xFFA194B4);

  static const Color lightInversePrimary = Color(0xFFA451E9);
  static const Color lightInverseSurface = Color(0xFF1C1628);
  static const Color lightOnInverseSurface = Color(0xFFE4DEEF);

  // Semantic Colors (shared)
  static const Color success = Color(0xFF2ECC71);
  static const Color successLight = Color(0xFFD4F5E4);

  static const Color error = Color(0xFFE53E3E);
  static const Color errorLight = Color(0xFFFFE5E5);
  static const Color onError = Colors.white;

  static const Color darkErrorContainer = Color(0x6AD67F7F);
  static const Color darkOnErrorContainer = error;

  static const Color lightErrorContainer = Color(0xFFFFE5E5);
  static const Color lightOnErrorContainer = Color(0xFFB91C1C);

  static const Color warning = Color(0xFFF6AD55);
  static const Color warningLight = Color(0xFFFFF3E0);

  static const Color info = Color(0xFF4299E1);
  static const Color infoLight = Color(0xFFE8F4FD);

  // Misc
  static const Color transparent = Color(0x00000000);
  static const Color buttonOverlayPrimary = Color(0x0FA451E9);
  static const Color buttonOverlayLight = Color(0x14FFFFFF);
}
