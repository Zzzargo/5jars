import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:decimal/decimal.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5000"; // Flask server

  // ==============================COBOL TEST===================================

  static Future<Decimal?> fetchCobolTest() async {
    final response = await http.get(Uri.parse('$baseUrl/coboltest'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        Decimal res = Decimal.parse(data['output'].trim());
        return res + Decimal.fromInt(1);
      } else {
        print("COBOL Error: ${data['error']}");
        return null;
      }
    } else {
      throw Exception('Failed to load COBOL test');
    }
  }

  // ==============================USER REGISTRATION============================

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

  // ==============================USER LOGIN===================================

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

  // ==============================GENERIC RESPONSE HANDLER=====================

  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final data = jsonDecode(response.body);
      return {
        'success': data['success'] ?? false,
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
}
