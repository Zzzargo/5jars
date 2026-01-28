import 'api_client.dart';

class AuthRepository {
  static Future<AuthResult> login({
    required String username,
    required String password,
  }) async {
    final response = await ApiClient.loginUser(
      username: username,
      password: password,
    );

    if (response['success'] == true && response['statusCode'] == 202) {
      return AuthResult.success();
    }

    if (response['statusCode'] == 401) {
      return AuthResult.failure('Invalid username or password');
    }

    return AuthResult.failure(response['error']);
  }

  static Future<AuthResult> register({
    required String nickname,
    required String username,
    required String password,
  }) async {
    final response = await ApiClient.registerUser(
      nickname: nickname,
      username: username,
      password: password,
    );

    if (response['success'] == true && response['statusCode'] == 201) {
      return AuthResult.success();
    }

    if (response['statusCode'] == 409) {
      return AuthResult.failure('Username already exists');
    }

    return AuthResult.failure(response['error']);
  }
}

class AuthResult {
  final bool success;
  final String? error;

  AuthResult._(this.success, this.error);

  factory AuthResult.success() => AuthResult._(true, null);
  factory AuthResult.failure(String error) => AuthResult._(false, error);
}
