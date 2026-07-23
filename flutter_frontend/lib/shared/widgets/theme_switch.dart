import 'package:five_jars_ultra/core/state/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeSwitch extends StatelessWidget {
  final bool useAltColor; // If true, uses light colors

  const ThemeSwitch({super.key, this.useAltColor = false});

  @override
  Widget build(BuildContext context) {
    final themeCubit = context.watch<ThemeCubit>();
    final themeMode = themeCubit.state;
    final isDark = themeMode == ThemeMode.dark;

    final color = useAltColor
        ? Colors.white.withValues(alpha: 0.8)
        : Theme.of(context).colorScheme.primary;

    return IconButton(
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
        color: color,
        size: 32,
      ),
      onPressed: () => themeCubit.toggle(context),
    );
  }
}
