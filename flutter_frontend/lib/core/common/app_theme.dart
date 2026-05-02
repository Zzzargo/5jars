import 'package:five_jars_ultra/core/common/app_text_styles.dart';
import 'package:five_jars_ultra/core/common/palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,
      // Brand
      primary: Palette.accentPurple,
      onPrimary: Colors.white,
      primaryContainer: Palette.primaryPurple,
      onPrimaryContainer: Palette.mutedPurple,
      // Secondary
      secondary: Palette.softPurple,
      onSecondary: Palette.darkBackground,
      secondaryContainer: Palette.darkSurfaceVariant,
      onSecondaryContainer: Palette.softPurple,
      // Surface
      surface: Palette.darkSurface,
      onSurface: Palette.darkTextMain,
      surfaceContainerHighest: Palette.darkSurfaceVariant,
      onSurfaceVariant: Palette.darkTextDim,
      // Outline
      outline: Palette.darkBorder,
      outlineVariant: Palette.darkBorder.withAlpha(120),
      // Semantic
      error: Palette.error,
      onError: Colors.white,
      errorContainer: Palette.errorLight.withAlpha(30),
      onErrorContainer: Palette.error,
      // Misc
      inverseSurface: Palette.lightSurface,
      onInverseSurface: Palette.lightTextMain,
      inversePrimary: Palette.primaryPurple,
      shadow: Colors.black,
      scrim: Colors.black,
    );

    return _buildTheme(colorScheme, AppTextStyles.dark());
  }

  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      // Brand
      primary: Palette.primaryPurple,
      onPrimary: Colors.white,
      primaryContainer: Palette.mutedPurple,
      onPrimaryContainer: Palette.primaryPurple,
      // Secondary
      secondary: Palette.accentPurple,
      onSecondary: Colors.white,
      secondaryContainer: Palette.lightSurfaceVariant,
      onSecondaryContainer: Palette.primaryPurple,
      // Surface
      surface: Palette.lightSurface,
      onSurface: Palette.lightTextMain,
      surfaceContainerHighest: Palette.lightSurfaceVariant,
      onSurfaceVariant: Palette.lightTextDim,
      // Outline
      outline: Palette.lightBorder,
      outlineVariant: Palette.lightBorder.withAlpha(180),
      // Semantic
      error: Palette.error,
      onError: Colors.white,
      errorContainer: Palette.errorLight,
      onErrorContainer: Color(0xFFB91C1C),
      // Misc
      inverseSurface: Palette.darkSurface,
      onInverseSurface: Palette.darkTextMain,
      inversePrimary: Palette.accentPurple,
      shadow: Color(0x1A7B2CBF), // purple-tinted shadow
      scrim: Colors.black,
    );

    return _buildTheme(colorScheme, AppTextStyles.light());
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, TextTheme textTheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: isDark
          ? Palette.darkBackground
          : Palette.lightBackground,

      // ── AppBar ──────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: isDark ? Palette.darkSurface : Palette.lightSurface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),

      // ── Cards ───────────────────────────────
      cardTheme: CardThemeData(
        color: isDark ? Palette.darkSurface : Palette.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: isDark ? 4 : 2,
        shadowColor: isDark
            ? Colors.black.withAlpha(120)
            : const Color(0x1A7B2CBF),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withAlpha(isDark ? 80 : 120),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 0),
      ),

      // ── Input Fields ────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? Palette.darkSurfaceVariant
            : Palette.lightSurfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outline, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error, width: 2),
        ),
        labelStyle: TextStyle(color: colorScheme.onSurfaceVariant),
        floatingLabelStyle: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(
          color: isDark ? Palette.darkTextMuted : Palette.lightTextMuted,
        ),
        prefixIconColor: WidgetStateColor.resolveWith((states) {
          if (states.contains(WidgetState.focused)) {
            return colorScheme.primary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        suffixIconColor: colorScheme.onSurfaceVariant,
      ),

      // ── Elevated Buttons ────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withAlpha(30);
            }
            return colorScheme.primary;
          }),
          foregroundColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.disabled)) {
              return colorScheme.onSurface.withAlpha(90);
            }
            return colorScheme.onPrimary;
          }),
          overlayColor: WidgetStateProperty.all(Colors.white.withAlpha(20)),
          elevation: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.pressed)) return 1;
            if (states.contains(WidgetState.hovered)) return 4;
            return 2;
          }),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textStyle: WidgetStateProperty.all(
            textTheme.labelLarge?.copyWith(letterSpacing: 0.5),
          ),
          animationDuration: const Duration(milliseconds: 200),
        ),
      ),

      // ── Text Buttons ────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
          overlayColor: WidgetStateProperty.all(
            colorScheme.primary.withAlpha(15),
          ),
          textStyle: WidgetStateProperty.all(
            textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ),

      // ── Outlined Buttons ────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.all(colorScheme.primary),
          side: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.focused) ||
                states.contains(WidgetState.pressed)) {
              return BorderSide(color: colorScheme.primary, width: 2);
            }
            return BorderSide(color: colorScheme.outline, width: 1);
          }),
          overlayColor: WidgetStateProperty.all(
            colorScheme.primary.withAlpha(15),
          ),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
      ),

      // ── Snackbar ────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark
            ? Palette.darkSurfaceVariant
            : Palette.lightTextMain,
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: isDark ? Palette.darkTextMain : Palette.lightSurface,
        ),
        actionTextColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),

      // ── Divider ─────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outline.withAlpha(80),
        thickness: 1,
        space: 1,
      ),

      // ── Chip ────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: isDark
            ? Palette.darkSurfaceVariant
            : Palette.lightSurfaceVariant,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        side: BorderSide(color: colorScheme.outline.withAlpha(100)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ── List Tile ───────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: Colors.transparent,
        selectedTileColor: colorScheme.primaryContainer.withAlpha(60),
        selectedColor: colorScheme.primary,
        iconColor: colorScheme.onSurfaceVariant,
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),

      // ── Icon ────────────────────────────────
      iconTheme: IconThemeData(color: colorScheme.onSurfaceVariant, size: 24),
      primaryIconTheme: IconThemeData(color: colorScheme.primary, size: 24),

      // ── Progress Indicator ──────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primaryContainer.withAlpha(60),
        circularTrackColor: colorScheme.primaryContainer.withAlpha(40),
      ),

      // ── Navigation Bar ──────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: isDark ? Palette.darkSurface : Palette.lightSurface,
        surfaceTintColor: Colors.transparent,
        shadowColor: isDark ? Colors.black : const Color(0x1A7B2CBF),
        elevation: 4,
        indicatorColor: colorScheme.primaryContainer.withAlpha(
          isDark ? 60 : 120,
        ),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            );
          }
          return textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          );
        }),
      ),

      // ── Drawer ──────────────────────────────
      drawerTheme: DrawerThemeData(
        backgroundColor: isDark ? Palette.darkSidebar : Palette.lightSidebar,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.horizontal(right: Radius.circular(20)),
        ),
        elevation: 8,
      ),

      // ── Floating Action Button ───────────────
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Dialog ──────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: isDark ? Palette.darkSurface : Palette.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),

      // ── Bottom Sheet ────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: isDark ? Palette.darkSurface : Palette.lightSurface,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),

      // ── Switch ──────────────────────────────
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.onPrimary;
          }
          return colorScheme.onSurfaceVariant;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline.withAlpha(80);
        }),
      ),

      // ── Checkbox ────────────────────────────
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(color: colorScheme.outline, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Tooltip ─────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? Palette.darkSurfaceVariant : Palette.lightTextMain,
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: isDark ? Palette.darkTextMain : Palette.lightSurface,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
