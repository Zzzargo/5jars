import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:decimal/decimal.dart';
import 'package:logging/logging.dart';

class BackendAPI {
  static const String baseUrl = "http://localhost:5000"; // Flask server
  static final Logger _logger = Logger('BackendAPI');

  /// Generic response handler
  ///
  /// Private method of the backend API class
  ///
  /// Takes a http response and returns a JSON-like map with keys:
  /// - success: bool
  /// - data: dynamic (the response body parsed as JSON)
  /// - statusCode: int (HTTP status code)
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return {
        'success': data['success'] ?? false, // I like this operator
        'data': data,
        'statusCode': response.statusCode,
      };
    } catch (_) {
      return {
        'success': false,
        'error': 'Invalid response from server.',
        'statusCode': response.statusCode,
      };
    }
  }

  /// Fetches a COBOL-generated test value from the backend
  static Future<Decimal?> fetchCobolTest() async {
    final response = await http.get(Uri.parse('$baseUrl/coboltest'));
    if (response.statusCode != 200) {
      _logger.severe(
        'Failed to load COBOL test, status code: ${response.statusCode}',
      );
      throw Exception(
        'Failed to load COBOL test. Invalid response from server.',
      );
    }

    final data = jsonDecode(response.body);
    if (data['success'] == true) {
      Decimal res = Decimal.parse(data['output'].trim());
      return res + Decimal.fromInt(1);
    } else {
      _logger.warning('COBOL test failed: ${data['error']}');
      return null;
    }
  }

  /// User registration API
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String nickname,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users');
    final body = jsonEncode({
      'username': username,
      'nickname': nickname,
      'password': password,
    });

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return _handleResponse(response);
  }

  /// User login API
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'username': username, 'password': password});

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    return _handleResponse(response);
  }
}
