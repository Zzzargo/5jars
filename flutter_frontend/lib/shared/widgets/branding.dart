import 'package:five_jars_ultra/shared/palette.dart';
import 'package:flutter/material.dart';

class Branding extends StatelessWidget {
  final Color? fillColor;
  final bool isCompact;

  const Branding({super.key, this.fillColor, this.isCompact = false});

  @override
  Widget build(BuildContext context) {
    final color = fillColor ?? Palette.lightOnPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.account_balance_wallet_outlined, size: 100, color: color),
        if (!isCompact) const SizedBox(height: 12),
        Text(
          '5 Jars',
          style: TextStyle(
            fontSize: 56,
            color: color,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        if (!isCompact) const SizedBox(height: 12),
        Text(
          'Smart Money Management',
          style: TextStyle(
            fontSize: 20,
            color: color.withValues(alpha: 0.7),
            fontWeight: FontWeight.w300,
          ),
        ),
      ],
    );
  }
}
