import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  // Man I love Dart
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }
}
