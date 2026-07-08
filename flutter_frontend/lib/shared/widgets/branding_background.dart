import 'package:flutter/material.dart';

class BrandingBackground extends StatelessWidget {
  final Widget child;

  const BrandingBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        // Radial gradient creates a sophisticated "glow" from the top center
        gradient: RadialGradient(
          center: const Alignment(0.0, -0.7), // Spotlight starts near the top
          radius: 1.5,
          colors: isDark
              ? [
                  // Dark Mode: Deep purple core fading into the black background
                  cs.primary.withValues(alpha: 45),
                  cs.surface,
                ]
              : [
                  // Light Mode: Soft lavender core fading into the white background
                  cs.primary.withValues(alpha: 180),
                  cs.surface,
                ],
          stops: const [0.0, 0.8], // Concentrates the glow at the top
        ),
      ),
      child: child,
    );
  }
}
