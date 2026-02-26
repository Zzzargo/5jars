import 'dart:io';

import 'package:dio/dio.dart';
import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/core/config/storage.dart';
import 'package:five_jars_ultra/features/auth/domain/auth_result.dart';
import 'package:five_jars_ultra/features/auth/models/auth_response.dart';

class AuthClient {
  final ApiHttpClient _apiClient;
  final SecureStorage _secureStorage;

  // This post was made by the Dependency Injection Gang
  AuthClient(this._apiClient, this._secureStorage);

  Future<AuthResult> login(String username, String password) async {
    return _handleAuthRequest(
      () => _apiClient.post('/auth/login', {
        'username': username,
        'password': password,
      }),
    );
  }

  Future<AuthResult> register({
    required String username,
    required String password,
  }) async {
    return _handleAuthRequest(
      () => _apiClient.post('/auth/register', {
        'username': username,
        'password': password,
      }),
    );
  }

  Future<AuthResult> _handleAuthRequest(
    Future<Response> Function() requestMethod,
  ) async {
    try {
      final response = await requestMethod();
      // Map JSON to Model
      final authResponse = AuthResponse.fromJson(response.data);

      // Authentication successful. Store the JWT on the client side
      await _secureStorage.saveToken(authResponse.token);
      // And the username for UX
      await _secureStorage.saveUsername(authResponse.username);

      return AuthSuccess(
        token: authResponse.token,
        username: authResponse.username,
      );
    } on ApiException catch (e) {
      return switch (e.statusCode) {
        HttpStatus.unauthorized => const AuthFailure(
          "Invalid username or password.",
        ),
        HttpStatus.forbidden => const AuthFailure("Nonono. Bad cat!"),
        HttpStatus.conflict => const AuthFailure("Username already taken."),
        HttpStatus.internalServerError => const AuthFailure("Server error."),
        _ => AuthFailure(e.toString()),
      };
    } catch (e) {
      // This should never happen, but if it does it's a bug in the http client
      return AuthFailure("An unknown error occurred: ${e.toString()}");
    }
  }
}
