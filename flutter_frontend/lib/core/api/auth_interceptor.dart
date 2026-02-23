import 'package:dio/dio.dart';
import 'package:five_jars_ultra/core/config/storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip if this is an auth request as it's redundant
    if (options.path.contains('/auth/')) {
      return handler.next(options);
    }

    final token = await _storage.getToken();
    // If a JWT exists for the current session, put it into the header
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    // Let the request continue
    return handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO: if backend returns 401, the token is invalid
    if (err.response?.statusCode == 401) {
      // TODO: eventually trigger a logout in the auth session bloc
    }
    return handler.next(err);
  }
}
