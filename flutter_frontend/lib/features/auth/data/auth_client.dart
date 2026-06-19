import 'dart:io';

import 'package:dio/dio.dart';
import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/core/config/storage.dart';
import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/features/auth/models/auth_response.dart';
import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';
import 'package:logging/logging.dart';

class AuthClient {
  final ApiHttpClient _apiClient;
  final SecureStorage _secureStorage;
  static final Logger _logger = Logger("Auth Client");

  // This post was made by the Dependency Injection Gang
  AuthClient(this._apiClient, this._secureStorage);

  Future<Resource<({String token, UserModel user})>> login(
    String username,
    String password,
  ) async {
    return _handleAuthRequest(
      () => _apiClient.post('/auth/login', {
        'username': username,
        'password': password,
      }),
    );
  }

  Future<Resource<({String token, UserModel user})>> register({
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

  Future<Resource<({String token, UserModel user})>> _handleAuthRequest(
    Future<Response> Function() requestMethod,
  ) async {
    try {
      final response = await requestMethod();
      // Map JSON to Model
      final authResponse = AuthResponse.fromJson(response.data);

      // Authentication successful. Store the JWT on the client side
      await _secureStorage.saveToken(authResponse.token);
      // And the username for UX
      await _secureStorage.saveUsername(authResponse.user.username);

      return ResourceSuccess((
        token: authResponse.token,
        user: authResponse.user,
      ));
    } on ApiException catch (e) {
      return switch (e.statusCode) {
        HttpStatus.unauthorized => const ResourceError(
          "Invalid username or password.",
        ),
        HttpStatus.forbidden => const ResourceError("Nonono. Bad cat!"),
        HttpStatus.conflict => const ResourceError("Username already taken."),
        HttpStatus.internalServerError => const ResourceError("Server error."),
        _ => const ResourceError("An unknown error occurred."),
      };
    } catch (e) {
      // This should never happen, but if it does it's a bug in the http client
      _logger.severe("Unexpected error: $e");
      return const ResourceError("An unknown error occurred.");
    }
  }
}
