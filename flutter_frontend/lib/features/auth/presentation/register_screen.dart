import 'package:five_jars_ultra/features/auth/presentation/widgets/register_form.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:five_jars_ultra/shared/widgets/branding.dart';
import 'package:five_jars_ultra/shared/widgets/branding_background.dart';
import 'package:five_jars_ultra/shared/widgets/theme_switch.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(mobile: _buildMobile, desktop: _buildDesktop);
  }

  Widget _buildMobile(BuildContext context, bool isDesktop) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 26),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: const RegisterForm(),
                ),
              ),
            ),

            Positioned(
              bottom: 20,
              right: 20,
              child: const SafeArea(child: ThemeSwitch()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktop(BuildContext context, bool isDesktop) {
    return Scaffold(
      body: Row(
        children: [
          // Left side - Branding section
          Expanded(
            flex: 1,
            child: Hero(
              tag: "branding_bkgr",
              child: BrandingBackground(
                child: Center(
                  child: Material(
                    type: MaterialType.transparency,
                    child: Branding(),
                  ),
                ),
              ),
            ),
          ),
          // Right side - Register form
          Expanded(
            flex: 1,
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(42),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 480,
                        minWidth: 320,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [const RegisterForm()],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: const SafeArea(child: ThemeSwitch()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
