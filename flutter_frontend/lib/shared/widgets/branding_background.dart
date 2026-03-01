import 'package:flutter/material.dart';

class BrandingBackground extends StatelessWidget {
  final Widget child;

  const BrandingBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          // TODO: Move these colors to an AppTheme
          colors: [Colors.purpleAccent.shade700, Colors.pink.shade600],
        ),
      ),
      child: child,
    );
  }
}
