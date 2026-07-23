import 'package:five_jars_ultra/features/auth/presentation/widgets/login_form.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:five_jars_ultra/shared/widgets/branding.dart';
import 'package:five_jars_ultra/shared/widgets/branding_background.dart';
import 'package:five_jars_ultra/shared/widgets/theme_switch.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(mobile: _buildMobile, desktop: _buildDesktop);
  }

  Widget _buildMobile(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 26),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints
                            .maxHeight, // Forces content to fill the screen
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Hero(
                            tag: 'logo',
                            child: Material(
                              type: MaterialType.transparency,
                              child: Branding(
                                fillColor: isDark ? cs.secondary : cs.primary,
                                isCompact: true,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 500),
                            child: const LoginForm(),
                          ),

                          // Footer spacer to keep things balanced
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  );
                },
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
                    child: Branding(
                      // fillColor: isDark ? cs.secondary : cs.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Right side - Login form
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
                      child: const LoginForm(),
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
