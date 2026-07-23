import 'package:flutter/material.dart';

/// Base class for application screens, providing adaptive layout capabilities
class AdaptiveScreen extends StatelessWidget {
  /// Mobile build method
  final Widget Function(BuildContext context, bool isDesktop) mobile;

  /// Desktop build method
  final Widget Function(BuildContext context, bool isDesktop) desktop;

  const AdaptiveScreen({
    super.key,
    required this.mobile,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    // Pass the isDesktop flag to the build methods
    // So the screens are aware of the current layout context
    final isDesktop = MediaQuery.of(context).size.width > 896;
    return isDesktop ? desktop(context, true) : mobile(context, false);
  }
}
