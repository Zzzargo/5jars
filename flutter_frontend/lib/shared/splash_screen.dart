import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:five_jars_ultra/shared/widgets/branding.dart';
import 'package:five_jars_ultra/shared/widgets/branding_background.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(
      mobile: _buildBase,
      // This reminds me of currying. Shoutout to Dan Popovici
      desktop: (context, isDesktop) => _buildBase(context, true),
    );
  }

  Widget _buildBase(BuildContext context, bool isDesktop) {
    // Define the Logo Unit conditionally

    Widget logoUnit = const Material(
      type: MaterialType.transparency,
      child: Branding(),
    );

    // On mobile the hero is the logo
    if (!isDesktop) {
      logoUnit = Hero(tag: "logo", child: logoUnit);
    }

    // Define the shared content
    Widget content = BrandingBackground(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            logoUnit,
            const SizedBox(height: 48),
            CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );

    // On desktop, the hero is the entire branding section, not just the logo
    if (isDesktop) {
      content = Hero(tag: "branding_bkgr", child: content);
    }

    return Scaffold(body: content);
  }
}
