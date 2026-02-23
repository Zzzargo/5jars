import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:five_jars_ultra/features/auth/data/auth_client.dart';
import 'package:five_jars_ultra/features/auth/domain/auth_result.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/login/login_event.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/login/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthClient _authClient;

  // Initial state = LoginInitial, at construction
  LoginBloc(this._authClient) : super(LoginInitial()) {
    // On a LoginSubmitted event, call the handler to emit a new state
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    // Tell the UI to show a spinner placeholder
    emit(LoginLoading());

    final authResult = await _authClient.login(event.username, event.password);

    switch (authResult) {
      case AuthSuccess s:
        emit(LoginSuccess(s.username));

      case AuthFailure f:
        emit(LoginFailure(f.message));
    }
  }
}
