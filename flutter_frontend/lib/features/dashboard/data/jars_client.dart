import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/create_jar_request.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';
import 'package:five_jars_ultra/features/dashboard/dtos/money_op_request.dart';

class JarsClient {
  final ApiHttpClient _apiClient;

  JarsClient(this._apiClient);

  Future<Resource<List<JarModel>>> getJars() async {
    try {
      final response = await _apiClient.get('/jars');
      // Cast to List<dynamic> to satisfy the type system
      final data = response.data as List<dynamic>;
      final List<JarModel> jars = data
          .map((json) => JarModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return ResourceSuccess(jars);
    } on ApiException catch (e) {
      return ResourceError(e.message, errorCode: e.statusCode);
    } catch (e) {
      return ResourceError('An unexpected error occurred: $e');
    }
  }

  Future<Resource<List<JarModel>>> distributeIncome(
    MoneyOpRequest distRequest,
  ) async {
    try {
      final response = await _apiClient.post(
        '/jars/income',
        distRequest.toJson(),
      );
      final data = response.data as List<dynamic>;
      final List<JarModel> jars = data
          .map((json) => JarModel.fromJson(json as Map<String, dynamic>))
          .toList();
      return ResourceSuccess(jars);
    } on ApiException catch (e) {
      return ResourceError(e.message, errorCode: e.statusCode);
    } catch (e) {
      return ResourceError('An unexpected error occurred: $e');
    }
  }

  Future<Resource<JarModel>> depositToJar(
    String jarId,
    MoneyOpRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        '/jars/$jarId/deposit',
        request.toJson(),
      );
      return ResourceSuccess(JarModel.fromJson(response.data));
    } on ApiException catch (e) {
      return ResourceError(e.message, errorCode: e.statusCode);
    } catch (e) {
      return ResourceError('An unexpected error occurred: $e');
    }
  }

  Future<Resource<JarModel>> withdrawFromJar(
    String jarId,
    MoneyOpRequest request,
  ) async {
    try {
      final response = await _apiClient.post(
        '/jars/$jarId/withdraw',
        request.toJson(),
      );
      return ResourceSuccess(JarModel.fromJson(response.data));
    } on ApiException catch (e) {
      return ResourceError(e.message, errorCode: e.statusCode);
    } catch (e) {
      return ResourceError('An unexpected error occurred: $e');
    }
  }

  Future<Resource<JarModel>> createJar(CreateJarRequest request) async {
    try {
      final response = await _apiClient.post('/jars', request.toJson());
      return ResourceSuccess(JarModel.fromJson(response.data));
    } on ApiException catch (e) {
      return ResourceError(e.message, errorCode: e.statusCode);
    } catch (e) {
      return ResourceError('An unexpected error occurred: $e');
    }
  }
}
