import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';

sealed class UserResult {
  const UserResult();
}

class UserSuccess extends UserResult {
  final UserModel user;

  const UserSuccess({required this.user});
}

class UserFailure extends UserResult {
  final String message;

  const UserFailure(this.message);
}
