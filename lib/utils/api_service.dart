import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static final _client = http.Client(); // 세션 쿠키 유지
  static const String _baseUrl = 'http://localhost:5000';

  /// 로그인 API
  static Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login/user');
    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Login successful',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
  
  /// 회원가입 API
  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String name,
    required double height,
    required String birthdate,
    required String gender,
    required int smokingHistory,
    required String socialId,
  }) async {
    final url = Uri.parse('$_baseUrl/auth/register/user');
    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
          'height': height,
          'birthdate': birthdate,
          'gender': gender,
          'smoking_history': smokingHistory,
          'social_id': socialId,
        }),
      );

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': 'User registered successfully',
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  /// History API
  static Future<Map<String, dynamic>> createHistory({
    required double weight,
    required int bloodGlucose,
    required int bloodPressure,
  }) async {
    final url = Uri.parse('$_baseUrl/history');
    try {
      final response = await _client.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'weight': weight,
          'blood_glucose': bloodGlucose,
          'blood_pressure': bloodPressure,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'History created successfully',
          'prediction': data['prediction'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to create history',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  /// 최근 기록 및 평균값 가져오기
  static Future<Map<String, dynamic>> viewHistorySummary() async {
    final url = Uri.parse('$_baseUrl/history/summary');
    try {
      final response = await _client.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'recent_record': data['recent_record'],
          'averages': data['averages'],
        };
      } else {
        final data = jsonDecode(response.body);
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to fetch history summary',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
