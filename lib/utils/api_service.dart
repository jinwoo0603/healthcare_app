import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:5000/auth/login/user';

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse(_baseUrl);
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Login successful'};
    } else {
      final data = jsonDecode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Login failed'};
    }
  }
}
