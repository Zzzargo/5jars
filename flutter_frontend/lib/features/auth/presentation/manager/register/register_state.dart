import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';

sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final UserModel user;
  RegisterSuccess(this.user);
}

final class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}
