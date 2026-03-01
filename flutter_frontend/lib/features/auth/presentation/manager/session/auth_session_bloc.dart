import 'dart:async';

import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/features/dashboard/data/users_client.dart';
import 'package:five_jars_ultra/features/dashboard/domain/user_result.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:five_jars_ultra/core/config/storage.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_event.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_state.dart';
import 'package:logging/logging.dart';

class AuthSessionBloc extends Bloc<AuthSessionEvent, AuthSessionState> {
  final SecureStorage _storage;
  final Logger _logger = Logger('AuthSessionBloc');

  // A Completer to tell when async work is done
  final _completer = Completer<void>();

  // Expose the future so AppStateCubit can await it
  Future<void> get isReady => _completer.future;

  AuthSessionBloc(this._storage) : super(AuthSessionNone()) {
    _logger.fine('Created');

    // Check for a jwt on startup
    on<AppStarted>(_onAppStarted);

    on<UserLoggedIn>((event, emit) {
      emit(AuthSessionAuthenticated(event.user));
      _logger.info('User logged in: ${event.user.username}');
    });

    on<UserLoggedOut>((event, emit) async {
      await _storage.clearAll();
      emit(AuthSessionUnauthenticated());
      _logger.info('User logged out');
    });
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthSessionState> emit,
  ) async {
    try {
      _logger.info('App started, checking for existing session');

      final token = await _storage.getToken();

      if (token != null) {
        // Make sure the token is still valid with the backend
        final authResult = await serviceLocator<UsersClient>().getMe();

        switch (authResult) {
          case UserSuccess():
            final localUsername = await _storage.getUsername();
            if (localUsername == null) {
              // This should never happen
              await _storage.clearAll();
              emit(AuthSessionUnauthenticated());
              _logger.warning('JWT found but no username. Clearing session.');
              return;
            }

            if (authResult.user.username != localUsername) {
              // Update the local username (most likely the user changed name)
              _logger.info(
                'Updating stale local username:'
                ' $localUsername -> ${authResult.user.username}',
              );
              await _storage.saveUsername(authResult.user.username);
            }

            emit(AuthSessionAuthenticated(authResult.user));
            _logger.info('Existing session found for user: $localUsername');

          case UserFailure():
            await _storage.clearAll();

            emit(AuthSessionUnauthenticated());
            _logger.info('Invalid JWT. User must log in again.');
          // TODO: notify the user their session expired
        }
      } else {
        emit(AuthSessionUnauthenticated());
        _logger.info('No existing session found, user is unauthenticated');
      }
    } finally {
      // Complete the future to signal that the session check is done
      if (!_completer.isCompleted) {
        _completer.complete();
      }
    }
  }
}
