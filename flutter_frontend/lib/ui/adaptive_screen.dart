import 'package:flutter/material.dart';

/// Base class for application screens, providing adaptive layout capabilities
class AdaptiveScreen extends StatelessWidget {
  /// Mobile build method
  final Widget Function(BuildContext) mobile;

  /// Desktop build method
  final Widget Function(BuildContext) desktop;

  const AdaptiveScreen({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return isDesktop ? desktop(context) : mobile(context);
  }
}
