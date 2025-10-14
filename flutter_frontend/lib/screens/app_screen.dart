import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';

abstract class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  // Platform indicator with its getter
  bool get isDesktop {
    final TargetPlatform platform = defaultTargetPlatform;
    return platform == TargetPlatform.macOS ||
        platform == TargetPlatform.windows ||
        platform == TargetPlatform.linux;
  }

  /// Abstract build method for an [AppScreen]'s mobile UI implementation
  Widget buildMobile(BuildContext context);

  /// Abstract build method for an [AppScreen]'s desktop UI implementation
  Widget buildDesktop(BuildContext context);
}

// createState methods of the appScreen subclasses will extend this behaviour
abstract class AppScreenState<T extends AppScreen> extends State<T> {
  /// Loading state - prevents some bugs and shows placeholders
  bool isLoading = false;

  /// Abstract build method - chooses layout based on platform
  @override
  Widget build(BuildContext context) {
    return widget.isDesktop
        ? widget.buildDesktop(context)
        : widget.buildMobile(context);
  }
}
