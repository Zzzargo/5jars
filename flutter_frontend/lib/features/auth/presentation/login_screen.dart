import 'package:five_jars_ultra/shared/widgets/branding.dart';
import 'package:five_jars_ultra/features/auth/presentation/widgets/login_form.dart';
import 'package:five_jars_ultra/shared/widgets/branding_background.dart';
import 'package:flutter/material.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(mobile: _buildMobile, desktop: _buildDesktop);
  }

  Widget _buildMobile(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Center(
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
                            fillColor: cs.primary,
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
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side - Branding section
          Expanded(
            flex: 1,
            child: Hero(
              tag: "branding_bkgr",
              child: BrandingBackground(
                child:
                    // Hero(
                    // tag: "branding",
                    // child:
                    const Material(
                      type: MaterialType.transparency,
                      child: Branding(),
                    ),
                // ),
              ),
            ),
          ),
          // Right side - Login form
          Expanded(
            flex: 1,
            child: Center(
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
          ),
        ],
      ),
    );
  }
}
