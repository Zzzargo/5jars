import 'package:five_jars_ultra/shared/app_text_styles.dart';
import 'package:five_jars_ultra/shared/palette.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData dark() {
    final colorScheme = ColorScheme(
      brightness: Brightness.dark,

      // Brand
      primary: Palette.darkPrimary,
      onPrimary: Palette.darkOnPrimary,
      primaryContainer: Palette.darkPrimaryContainer,
      onPrimaryContainer: Palette.darkOnPrimaryContainer,

      // Secondary
      secondary: Palette.darkSecondary,
      onSecondary: Palette.darkOnSecondary,
      secondaryContainer: Palette.darkSecondaryContainer,
      onSecondaryContainer: Palette.darkOnSecondaryContainer,

      // Surface
      surface: Palette.darkSurface,
      onSurface: Palette.darkOnSurface,
      onSurfaceVariant: Palette.darkOnSurfaceVariant,
      surfaceContainerLowest: Palette.darkSurfaceLowest,
      surfaceContainerLow: Palette.darkSurfaceLow,
      surfaceContainer: Palette.darkSurfaceContainer,
      surfaceContainerHigh: Palette.darkSurfaceHigh,
      surfaceContainerHighest: Palette.darkSurfaceHighest,

      // Outline
      outline: Palette.darkBorder,
      outlineVariant: Palette.darkBorderSubtle,

      // Semantic
      error: Palette.error,
      onError: Palette.onError,
      errorContainer: Palette.darkErrorContainer,
      onErrorContainer: Palette.darkOnErrorContainer,

      // Misc
      inversePrimary: Palette.darkInversePrimary,
      inverseSurface: Palette.darkInverseSurface,
      onInverseSurface: Palette.darkOnInverseSurface,
      shadow: Palette.darkShadow,
      scrim: Palette.darkScrim,
    );

    return _buildTheme(colorScheme, AppTextStyles.dark());
  }

  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,

      // Brand
      primary: Palette.lightPrimary,
      onPrimary: Palette.lightOnPrimary,
      primaryContainer: Palette.lightPrimaryContainer,
      onPrimaryContainer: Palette.lightOnPrimaryContainer,

      // Secondary
      secondary: Palette.lightSecondary,
      onSecondary: Palette.lightOnSecondary,
      secondaryContainer: Palette.lightSecondaryContainer,
      onSecondaryContainer: Palette.lightOnSecondaryContainer,

      // Surface
      surface: Palette.lightSurface,
      onSurface: Palette.lightOnSurface,
      onSurfaceVariant: Palette.lightOnSurfaceVariant,
      surfaceContainerLowest: Palette.lightSurfaceLowest,
      surfaceContainerLow: Palette.lightSurfaceLow,
      surfaceContainer: Palette.lightSurfaceContainer,
      surfaceContainerHigh: Palette.lightSurfaceHigh,
      surfaceContainerHighest: Palette.lightSurfaceHighest,

      // Outline
      outline: Palette.lightBorder,
      outlineVariant: Palette.lightBorderSubtle,

      // Semantic
      error: Palette.error,
      onError: Palette.onError,
      errorContainer: Palette.lightErrorContainer,
      onErrorContainer: Palette.lightOnErrorContainer,

      // Misc
      inversePrimary: Palette.lightInversePrimary,
      inverseSurface: Palette.lightInverseSurface,
      onInverseSurface: Palette.lightOnInverseSurface,
      shadow: Palette.lightShadow,
      scrim: Palette.lightScrim,
    );

    return _buildTheme(colorScheme, AppTextStyles.light());
  }

  static ThemeData _buildTheme(ColorScheme colorScheme, TextTheme textTheme) {
    final isDark = colorScheme.brightness == Brightness.dark;

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: textTheme,
      scaffoldBackgroundColor: colorScheme.surface,
      splashColor: colorScheme.primary.withAlpha(30),
      highlightColor: colorScheme.primary.withAlpha(10),

      // ── AppBar ──────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.displaySmall?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // ── Cards ───────────────────────────────
      cardTheme: CardThemeData(
        color: colorScheme.surfaceContainer,
        surfaceTintColor: Palette.transparent,
        elevation: isDark ? 4 : 2,
        shadowColor: colorScheme.shadow,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: colorScheme.outline.withAlpha(isDark ? 50 : 80),
            width: 1,
          ),
        ),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),

      // ── Input Fields ────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceContainerLow,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.outlineVariant, width: 1),
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
        floatingLabelStyle: TextStyle(color: colorScheme.primary),
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
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
            colorScheme.primary.withAlpha(30),
          ),
          textStyle: WidgetStateProperty.all(textTheme.labelLarge),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            return BorderSide(color: colorScheme.outline, width: 1.5);
          }),
          overlayColor: WidgetStateProperty.all(
            colorScheme.primary.withAlpha(20),
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
        backgroundColor: colorScheme.secondaryContainer,
        contentTextStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSecondaryContainer,
        ),
        actionTextColor: colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),

      // ── Divider ─────────────────────────────
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 3,
      ),

      // ── Chip ────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceContainerHighest,
        selectedColor: colorScheme.primaryContainer,
        labelStyle: textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        side: BorderSide(color: colorScheme.outline.withAlpha(120)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),

      // ── List Tile ───────────────────────────
      listTileTheme: ListTileThemeData(
        tileColor: colorScheme.secondaryContainer,
        selectedTileColor: colorScheme.primaryContainer.withAlpha(60),
        selectedColor: colorScheme.primary,
        iconColor: colorScheme.onSecondaryContainer,
        titleTextStyle: textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),

      // ── Icon ────────────────────────────────
      iconTheme: IconThemeData(color: colorScheme.primary, size: 24),
      primaryIconTheme: IconThemeData(color: colorScheme.primary, size: 24),

      // ── Progress Indicator ──────────────────
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.primaryContainer.withAlpha(60),
        circularTrackColor: colorScheme.primaryContainer.withAlpha(40),
      ),

      // ── Navigation Bar ──────────────────────
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shadowColor: colorScheme.shadow,
        elevation: 4,
        indicatorColor: colorScheme.secondaryContainer,
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(color: colorScheme.primary);
          }
          return IconThemeData(color: colorScheme.onSurfaceVariant);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return textTheme.labelLarge?.copyWith(color: colorScheme.primary);
          }
          return textTheme.labelLarge?.copyWith(
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
        focusElevation: 1,
        hoverElevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      // ── Dialog ──────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: textTheme.bodyMedium,
      ),

      // ── Bottom Sheet ────────────────────────
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colorScheme.surfaceContainer,
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
        side: BorderSide(color: colorScheme.outline, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),

      // ── Tooltip ─────────────────────────────
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainerHigh,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline, width: 2),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Palette.darkShadowElevated
                  : Palette.lightShadowElevated,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        textStyle: textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),

      // ── Filled Button ───────────────────────
      filledButtonTheme: FilledButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colorScheme.primary),
          foregroundColor: WidgetStateProperty.all(colorScheme.onPrimary),
          iconColor: WidgetStateProperty.all(colorScheme.onPrimary),
        ),
      ),

      // ── Icon Button ───────────────────────────
      iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
          iconColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return colorScheme.onPrimary;
            }
            return colorScheme.onSurfaceVariant;
          }),
        ),
      ),
    );
  }
}
