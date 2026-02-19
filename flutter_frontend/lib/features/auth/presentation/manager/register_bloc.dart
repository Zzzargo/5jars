import 'package:five_jars_ultra/features/auth/data/auth_client.dart';
import 'package:five_jars_ultra/features/auth/domain/auth_result.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/register_event.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/register_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final AuthClient _authClient;

  RegisterBloc(this._authClient) : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());

    final authResult = await _authClient.register(
      username: event.username,
      password: event.password,
    );

    switch (authResult) {
      case AuthSuccess():
        // TODO: store the jwt in the client secure storage
        emit(RegisterSuccess());

      case AuthFailure f:
        emit(RegisterFailure(f.message));
    }
  }
}
