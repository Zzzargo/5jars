import 'dart:io';

import 'package:dio/dio.dart';
import 'package:five_jars_ultra/core/config/injection_container.dart';
import 'package:five_jars_ultra/core/config/storage.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_bloc.dart';
import 'package:five_jars_ultra/features/auth/presentation/manager/session/auth_session_event.dart';

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
    // If backend returns 401, the token is invalid, log out
    if (err.response?.statusCode == HttpStatus.unauthorized) {
      serviceLocator<AuthSessionBloc>().add(UserLoggedOut());
    }
    return handler.next(err);
  }
}
