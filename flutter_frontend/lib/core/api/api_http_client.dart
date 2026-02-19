import 'package:dio/dio.dart';
import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/config/env_config.dart';
import 'package:logging/logging.dart';

class ApiHttpClient {
  final Dio _dio;

  static final Logger _logger = Logger('ApiClient');

  // This weird syntax is constructor with an initializer list. It allows to
  // initialize final fields before the constructor body runs
  ApiHttpClient(EnvConfig envConfig)
    : _dio = Dio(
        BaseOptions(
          baseUrl: envConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
          contentType: 'application/json',
        ),
      ) {
    _dio.interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        logPrint: (obj) => _logger.info(obj),
      ),
    );

    // TODO: jwt interceptor for auth
  }

  /// Generic dio GET request wrapper
  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      return await _dio.get(path, queryParameters: query);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic dio POST request wrapper
  Future<Response> post(String path, dynamic data) async {
    try {
      return await _dio.post(path, data: data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  /// Generic dio exception transformer
  ApiException _handleError(DioException e) {
    final statusCode = e.response?.statusCode;
    final message =
        e.response?.data?['detail'] ?? 'An unexpected error occurred';

    _logger.severe('API Error: ${e.type}[$statusCode] - $message');

    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return ApiException(
        message: 'Server unreachable. Check your internet connection',
        statusCode: statusCode,
      );
    }

    ApiException apiException = ApiException(
      message: message,
      statusCode: statusCode,
    );

    // Extract the "detail" field from Spring's ProblemDetail response
    return apiException;
  }
}
