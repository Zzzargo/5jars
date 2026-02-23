sealed class AuthSessionState {
  const AuthSessionState();
}

// This is the initial state when the app is launched and the
// auto-authentication is not done
final class AuthSessionNone extends AuthSessionState {}

final class AuthSessionAuthenticated extends AuthSessionState {
  final String username;
  AuthSessionAuthenticated(this.username);
}

final class AuthSessionUnauthenticated extends AuthSessionState {}
