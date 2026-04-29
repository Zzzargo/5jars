import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/features/dashboard/data/jars_client.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_event.dart';
import 'package:five_jars_ultra/features/dashboard/presentation/manager/jars/jars_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class JarsBloc extends Bloc<JarsEvent, JarsState> {
  final JarsClient _client;

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
  }
}
