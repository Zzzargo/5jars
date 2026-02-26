import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:five_jars_ultra/shared/widgets/branding.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(mobile: _buildMobile, desktop: _buildDesktop);
  }

  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          strokeWidth: 3,
          valueColor: AlwaysStoppedAnimation<Color>(
            Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      // Using Stack because we want the branding background to fill the screen
      // This way anything we put on top stacks, permitting overlap
      body: Stack(
        children: [
          const Center(
            child: Hero(
              // TODO: fix hero transition
              tag: 'branding', // Hero allows a smooth transition to Login
              child: Branding(),
            ),
          ),
          Align(
            alignment: const Alignment(0, 0.6), // 60% down the screen
            child: SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
