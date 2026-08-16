import 'package:five_jars_ultra/core/api/api_exception.dart';
import 'package:five_jars_ultra/core/api/api_http_client.dart';
import 'package:five_jars_ultra/core/common/resource.dart';
import 'package:five_jars_ultra/features/transactions/models/transaction_model.dart';

class TransactionsClient {
  final ApiHttpClient _apiClient;

  TransactionsClient(this._apiClient);

  Future<Resource<List<TransactionModel>>> getAllTransactions({
    int page = 0,
    int pageSize = 20,
  }) async {
    try {
      final response = await _apiClient.get(
        '/transactions',
        query: {'page': page, 'size': pageSize},
      );
      final data = response.data as List<dynamic>;
      final List<TransactionModel> transactions = data
          .map(
            (json) => TransactionModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
      return ResourceSuccess(transactions);
    } on ApiException catch (e) {
      return ResourceError(e.message, errorCode: e.statusCode);
    } catch (e) {
      return ResourceError('An unexpected error occurred: $e');
    }
  }
}
