import '../services/auth_service.dart';
import '../../domain/models/user.dart';

//repositories - cầu nối giữa UI và data
//class này quản lý về Authentication
class AuthRepository {
  final AuthService _authService;

  AuthRepository(this._authService);

  Future<User?> login(String email, String password) async {
    try {
      final response = await _authService.login(email, password);
      if (response != null) {
        return User.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Login failed: $e');
    }
  }

  Future<User?> register(String email, String password, String name) async {
    try {
      final response = await _authService.register(email, password, name);
      if (response != null) {
        return User.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Registration failed: $e');
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final response = await _authService.getCurrentUser();
      if (response != null) {
        return User.fromJson(response);
      }
      return null;
    } catch (e) {
      throw Exception('Get current user failed: $e');
    }
  }
}
