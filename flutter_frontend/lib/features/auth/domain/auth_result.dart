// A sealed class is like an abstract class that defines an enum
import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';

sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  final String token;
  final UserModel user;

  const AuthSuccess({required this.token, required this.user});
}

class AuthFailure extends AuthResult {
  final String message;

  const AuthFailure(this.message);
}
