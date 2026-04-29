import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/features/dashboard/models/jar_model.dart';

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
}
