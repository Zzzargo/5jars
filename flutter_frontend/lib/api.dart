import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:decimal/decimal.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5000"; // Flask server

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
}
