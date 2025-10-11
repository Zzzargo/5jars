import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'login_mobile.dart';
import 'login_desktop.dart';

class LoginScreen extends StatelessWidget {
  // Constructor
  const LoginScreen({super.key});

  // Platform indicator with its getter
  bool get _isDesktop {
    final platform = defaultTargetPlatform;
    return platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux;
  }

  // Build method - decides which layout to use
  @override
  Widget build(BuildContext context) {
    return _isDesktop ? const LoginDesktop() : const LoginMobile();
  }
}
