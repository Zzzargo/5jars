sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  final String username;
  RegisterSuccess(this.username);
}

final class RegisterFailure extends RegisterState {
  final String message;
  RegisterFailure(this.message);
}
