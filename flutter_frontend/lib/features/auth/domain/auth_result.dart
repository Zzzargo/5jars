// A sealed class is like an abstract class that defines an enum
sealed class AuthResult {
  const AuthResult();
}

class AuthSuccess extends AuthResult {
  final String token;
  final String username;

  const AuthSuccess({required this.token, required this.username});
}

class AuthFailure extends AuthResult {
  final String message;

  const AuthFailure(this.message);
}
