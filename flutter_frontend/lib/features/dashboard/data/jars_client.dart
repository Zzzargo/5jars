import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';

class JarsClient {
  final ApiHttpClient _apiClient;

  JarsClient(this._apiClient);

  Future<List<JarModel>> getJars() async {
    try {
      // The Interceptor automatically adds the JWT to this request
      final response = await _apiClient.get('/jars');
      final List<JarModel> jars = response.data
          .map((json) => JarModel.fromJson(json))
          .toList();
      return jars;
    } on ApiException catch (e) {
      return switch (e.statusCode) {
        _ => throw ApiException(
          message: 'Failed to fetch jars: ${e.message}',
          statusCode: e.statusCode,
        ),
      };
    } catch (e) {
      throw ApiException(message: 'An unexpected error occurred: $e');
    }
  }
}
