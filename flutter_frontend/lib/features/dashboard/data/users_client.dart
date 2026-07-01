import 'dart:io';

import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/features/auth/models/user_model.dart';

class UsersClient {
  final ApiHttpClient _apiClient;

  UsersClient(this._apiClient);

  Future<Resource<UserModel>> getMe() async {
    try {
      // The Interceptor automatically adds the JWT to this request
      final response = await _apiClient.get('/users/me');
      final UserModel user = UserModel.fromJson(response.data);
      return ResourceSuccess(user);
    } on ApiException catch (e) {
      // 401 = Invalid JWT, 403 = no JWT provided
      return switch (e.statusCode) {
        HttpStatus.unauthorized => const ResourceError(
          "Invalid session token. Your session may be expired",
        ),
        HttpStatus.forbidden => const ResourceError(
          "No session token provided. Please log in again.",
        ),
        _ => ResourceError(e.message),
      };
    }
  }
}
