import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:decimal/decimal.dart';
import 'package:logging/logging.dart';
import 'dart:async';

class ApiClient {
  static final Logger _logger = Logger('ApiClient');

  // Flask server
  static String get baseUrl {
    if (Platform.isAndroid) {
      return 'http://10.0.2.2:5000'; // Localhost for Android emulator
    } else {
      return 'http://localhost:5000'; // Localhost for desktop
    }
  }

  /// Generic request maker
  ///
  /// Takes a http request, waits for response, handles errors and timeouts,
  /// and returns a JSON-like map with keys:
  /// - success: bool
  /// - data/error: dynamic (the response body parsed or error message)
  /// - statusCode: HTTP response status code
  static Future<Map<String, dynamic>> _makeRequest({
    required http.Request request,
    Duration timeout = const Duration(seconds: 5), // Default timeout
  }) async {
    try {
      final response = await request.send().timeout(timeout);
      final responseBody = await http.Response.fromStream(response);
      return _handleResponse(responseBody);
    } on TimeoutException {
      _logger.severe('Request timed out after ${timeout.inSeconds}s');
      return {
        'success': false,
        'error': 'Request timed out. Server may be down.',
        'statusCode': 503,
      };
    } on SocketException catch (e) {
      _logger.severe('Couldn\'t connect to the backend: $e');
      return {
        'success': false,
        'error': 'Network error: ${e.message}',
        'statusCode': 500,
      };
    }
  }

  /// Generic response handler
  ///
  /// Takes a http response and returns a JSON-like map with keys:
  /// - success: bool
  /// - data: dynamic (the response body parsed)
  /// - statusCode: HTTP response status code
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return response.statusCode < 400
          ? {'success': true, 'data': data, 'statusCode': response.statusCode}
          : {
              'success': false,
              'error': data['error'] ?? 'Unknown error',
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

  static Future<Map<String, dynamic>> registerUser({
    required String nickname,
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/users');
    final body = jsonEncode({
      'nickname': nickname,
      'username': username,
      'password': password,
    });

    return await _makeRequest(
      request: http.Request('POST', url)
        ..headers.addAll({'Content-Type': 'application/json'})
        ..body = body,
    );
  }

  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');
    final body = jsonEncode({'username': username, 'password': password});

    return await _makeRequest(
      request: http.Request('POST', url)
        ..headers.addAll({'Content-Type': 'application/json'})
        ..body = body,
    );
  }
}
