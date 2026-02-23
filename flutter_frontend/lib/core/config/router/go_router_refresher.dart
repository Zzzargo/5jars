import 'dart:async';
import 'package:flutter/widgets.dart';

// This tells the router to rerun the redirect logic whenever the state changes
class GoRouterRefresher extends ChangeNotifier {
  late final StreamSubscription<dynamic> _subscription;

  GoRouterRefresher(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
