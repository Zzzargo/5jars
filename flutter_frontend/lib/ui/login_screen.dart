import 'package:five_jars_ultra/ui/widgets/branding.dart';
import 'package:five_jars_ultra/ui/widgets/login_form.dart';
import 'package:flutter/material.dart';
import 'package:five_jars_ultra/ui/adaptive_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

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
              child: const LoginForm(),
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
          Expanded(flex: 1, child: const Branding()),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [const LoginForm()],
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
