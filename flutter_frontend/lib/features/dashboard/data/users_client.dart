import 'dart:io';

import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/features/dashboard/domain/user_result.dart';
import 'package:five_jars_ultra/features/dashboard/models/user_model.dart';

class UsersClient {
  final ApiHttpClient _apiClient;

  UsersClient(this._apiClient);

  Future<UserResult> getMe() async {
    try {
      // The Interceptor automatically adds the JWT to this request
      final response = await _apiClient.get('/users/me');
      final UserModel user = UserModel.fromJson(response.data);
      return UserSuccess(user: user);
    } on ApiException catch (e) {
      // 401 = Invalid JWT, 403 = no JWT provided
      return switch (e.statusCode) {
        HttpStatus.unauthorized => const UserFailure(
          "Invalid session token. Your session may be expired",
        ),
        HttpStatus.forbidden => const UserFailure(
          "No session token provided. Please log in again.",
        ),
        _ => UserFailure(e.message),
      };
    }
  }
}
