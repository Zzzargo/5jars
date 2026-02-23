sealed class AuthSessionEvent {}

final class AppStarted extends AuthSessionEvent {}

// Triggered when LoginBloc or RegisterBloc succeeds
final class UserLoggedIn extends AuthSessionEvent {
  final String username;
  UserLoggedIn(this.username);
}

final class UserLoggedOut extends AuthSessionEvent {}
