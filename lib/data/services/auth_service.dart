import 'package:shared_preferences/shared_preferences.dart';

import 'api_client.dart';

class AuthService {
  AuthService({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();
//
  final ApiClient _api;

  static const String _tokenKey = 'auth_token';

  //lấy token đã lưu
  Future<String?> getSavedToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
//Đăng nhập và lưu token
  Future<Map<String, dynamic>?> login(String email, String password) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'username': email,
      'password': password,
    };

    final Map<String, dynamic> data = await _api.postJson('/api/auth/login', body: payload);
    final String token = (data['token'] ?? data['accessToken'] ?? '') as String;
    if (token.isEmpty) {
      throw Exception('Không nhận được token từ máy chủ');
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    return data;
  }

  Future<Map<String, dynamic>?> register(String email, String password, String name) async {
    final Map<String, dynamic> payload = <String, dynamic>{
      'username': email,
      'email': email,
      'password': password,
      'confirmPassword': password,
      'name': name,
    };
    return await _api.postJson('/api/auth/register', body: payload);
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final token = await getSavedToken();
    if (token == null) return null;
    
    try {
      return await _api.getJson('/api/auth/me');
    } catch (e) {
      return null;
    }
  }
}


