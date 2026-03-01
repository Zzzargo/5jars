import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';

sealed class AuthSessionEvent {}

final class AppStarted extends AuthSessionEvent {}

// Triggered when LoginBloc or RegisterBloc succeeds
final class UserLoggedIn extends AuthSessionEvent {
  final UserModel user;
  UserLoggedIn(this.user);
}

final class UserLoggedOut extends AuthSessionEvent {}
