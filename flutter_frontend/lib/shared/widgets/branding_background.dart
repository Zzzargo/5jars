import 'package:five_jars_ultra/shared/palette.dart';
import 'package:flutter/material.dart';

class BrandingBackground extends StatelessWidget {
  final Widget child;

  const BrandingBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final List<Color> lightColors = [
      cs.primary.withValues(alpha: 0.7),
      cs.surface,
    ];

    final List<Color> darkColors = [
      cs.primary.withValues(alpha: 0.25),
      cs.surface,
    ];

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: cs.surface),
      child: Stack(
        children: [
          // Layer 1: Subtle Linear background to give the screen "weight"
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [
                          Colors.white.withValues(alpha: 0.05),
                          Palette.transparent,
                        ]
                      : [
                          cs.primary.withValues(alpha: 0.1),
                          Palette.transparent,
                        ],
                ),
              ),
            ),
          ),

          // Layer 2: The Spotlight (Radial)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0.0, -0.6),
                  radius: 1.2,
                  colors: isDark ? darkColors : lightColors,
                  stops: const [0, 0.9],
                ),
              ),
            ),
          ),

          // THE CONTENT
          child,
        ],
      ),
    );
  }
}
