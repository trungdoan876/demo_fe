import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class AuthService {
  AuthService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  static const String _tokenKey = 'auth_token';

  Future<String> login({required String usernameOrEmail, required String password}) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      // Backend của bạn có thể nhận 'username' hoặc 'email'.
      // Ở đây ta map vào 'username' theo DTO LoginRequest(username, password)
      'username': usernameOrEmail,
      'password': password,
    };

    final Map<String, dynamic> data = await _api.postJson('/api/auth/login', body: payload);
    final String token = (data['token'] ?? data['accessToken'] ?? '') as String;
    if (token.isEmpty) {
      throw Exception('Không nhận được token từ máy chủ');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    return token;
  }

  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  Future<void> register({required String email, required String password}) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'username': email, // backend có thể map username/email; ở đây dùng email làm username
      'email': email,
      'password': password,
      'confirmPassword': password,
    };
    await _api.postJson('/api/auth/register', body: payload);
  }
}


