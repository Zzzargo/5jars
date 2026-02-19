class AuthResponse {
  final String token;
  final String username;

  AuthResponse({required this.token, required this.username});

  // Man I love Dart
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      username: json['username'] as String,
    );
  }
}
