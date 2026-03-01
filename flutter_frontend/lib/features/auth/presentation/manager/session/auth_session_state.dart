import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';

sealed class AuthSessionState {
  const AuthSessionState();
}

// This is the initial state when the app is launched and the
// auto-authentication is not done
final class AuthSessionNone extends AuthSessionState {}

final class AuthSessionAuthenticated extends AuthSessionState {
  final UserModel user;
  AuthSessionAuthenticated(this.user);
}

final class AuthSessionUnauthenticated extends AuthSessionState {}
