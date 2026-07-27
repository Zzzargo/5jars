import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/core/config/notification_service.dart';
import 'package:five_jars_ultra/features/dashboard/data/jars_client.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars_event.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JarsBloc extends Bloc<JarsEvent, JarsState> {
  final JarsClient _client;
  final NotificationService notificationService =
      serviceLocator<NotificationService>();

  JarsBloc(this._client) : super(JarsInitial()) {
    on<JarsFetchRequested>((event, emit) async {
      emit(JarsLoading());
      final result = await _client.getJars();

      switch (result) {
        case ResourceSuccess s:
          emit(JarsLoadSuccess(s.data));
        case ResourceError e:
          emit(JarsLoadFailure(e.message));
      }
    });

    on<NewJarRequested>((event, emit) async {
      List<JarModel> currentJars = [];
      if (state is JarsLoadSuccess) {
        currentJars = (state as JarsLoadSuccess).jars;
      }

      emit(JarsLoading());

      final result = await _client.createJar(event.createRequest);

      switch (result) {
        case ResourceSuccess s:
          final updatedJars = List<JarModel>.from(currentJars)..add(s.data);
          emit(JarsLoadSuccess(updatedJars));
        case ResourceError e:
          emit(JarsLoadFailure(e.message));
      }
    });

    on<JarDepositRequested>((event, emit) async {
      final result = await _client.depositToJar(event.jarId, event.request);

      switch (result) {
        case ResourceSuccess<JarModel> _:
          final currentState = state;
          if (currentState is JarsLoadSuccess) {
            // Create a new list with the updated jar replaced
            final updatedList = currentState.jars.map((j) {
              return j.id == result.data.id ? result.data : j;
            }).toList();

            emit(JarsLoadSuccess(updatedList));
          }
          break;

        case ResourceError<JarModel> e:
          notificationService.showError(e.message);
          break;
      }
    });

    on<JarWithdrawRequested>((event, emit) async {
      final result = await _client.withdrawFromJar(event.jarId, event.request);

      switch (result) {
        case ResourceSuccess<JarModel> _:
          final currentState = state;
          if (currentState is JarsLoadSuccess) {
            // Create a new list with the updated jar replaced
            final updatedList = currentState.jars.map((j) {
              return j.id == result.data.id ? result.data : j;
            }).toList();

            emit(JarsLoadSuccess(updatedList));
          }
          break;

        case ResourceError<JarModel> e:
          notificationService.showError(e.message);
          break;
      }
    });

    on<DistributeIncomeRequested>((event, emit) async {
      final result = await _client.distributeIncome(event.request);

      switch (result) {
        case ResourceSuccess<List<JarModel>> s:
          emit(JarsLoadSuccess(s.data));
          notificationService.showSuccess('Income distributed successfully');

        case ResourceError<List<JarModel>> e:
          notificationService.showError(e.message);
      }
    });
  }
}
