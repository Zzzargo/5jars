import 'package:five_jars_ultra/shared/widgets/branding.dart';
import 'package:five_jars_ultra/shared/widgets/branding_background.dart';
import 'package:flutter/material.dart';
import 'package:five_jars_ultra/shared/adaptive_screen.dart';
import 'package:five_jars_ultra/features/auth/presentation/widgets/register_form.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AdaptiveScreen(mobile: _buildMobile, desktop: _buildDesktop);
  }

  Widget _buildMobile(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 26),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: const RegisterForm(),
            ),
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
          Expanded(flex: 1, child: const BrandingBackground(child: Branding())),
          // Right side - Register form
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [const RegisterForm()],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
