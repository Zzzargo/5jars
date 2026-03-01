import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';

sealed class LoginState {
  const LoginState();
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final UserModel user;
  LoginSuccess(this.user);
}

final class LoginFailure extends LoginState {
  final String message;
  LoginFailure(this.message);
}
