import 'package:five_jars_ultra/core/state/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppStateCubit extends Cubit<AppState> {
  // At initialization, the app is loading
  AppStateCubit() : super(AppState.loading);

  /// Takes a list of tasks and ensures they all complete
  /// but waits at least [minDuration]
  Future<void> runTasks({
    required List<Future<void>> tasks,
    Duration minDuration = const Duration(seconds: 1),
  }) async {
    emit(AppState.loading);

    // Run the tasks and the timer in parallel
    await Future.wait([...tasks, Future.delayed(minDuration)]);

    emit(AppState.ready);
  }
}
