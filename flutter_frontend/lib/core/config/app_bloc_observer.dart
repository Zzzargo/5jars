import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

class AppBlocObserver extends BlocObserver {
  final _logger = Logger('BLoC');

  @override
  void onEvent(Bloc bloc, Object? event) {
    super.onEvent(bloc, event);
    // Log every event dispatched to any BLoC
    _logger.fine('[${bloc.runtimeType}] Event: $event');
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    super.onTransition(bloc, transition);
    // Log the full transition: Current State -> Event -> Next State
    _logger.fine(
      '[${bloc.runtimeType}] Transition: '
      '{${transition.currentState.runtimeType}} '
      '(${transition.event.runtimeType}) -> '
      '{${transition.nextState.runtimeType}}',
    );
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    super.onError(bloc, error, stackTrace);
    // Catch unhandled exceptions in any BLoC/Cubit
    _logger.severe('[${bloc.runtimeType}] Error: $error', error, stackTrace);
  }
}
