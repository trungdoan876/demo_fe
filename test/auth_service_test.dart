import 'package:flutter_test/flutter_test.dart';
import 'package:demo_01/services/auth_service.dart';
import 'package:demo_01/services/api_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'mock_api_client.dart';

void main() {
  group('AuthService Tests', () {
    late AuthService authService;
    late MockApiClient mockApiClient;

    setUpAll(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      // Mock SharedPreferences để tránh plugin issues
      SharedPreferences.setMockInitialValues({});
    });

    setUp(() {
      mockApiClient = MockApiClient();
      authService = AuthService(apiClient: mockApiClient);
      mockApiClient.reset();
    });

    test('login should call API with correct parameters', () async {
      // Arrange
      const username = 'test@example.com';
      const password = 'password123';
      const expectedToken = 'mock-token';
      
      mockApiClient.setMockPostResponse({
        'token': expectedToken,
      });

      // Act
      final result = await authService.login(
        usernameOrEmail: username,
        password: password,
      );

      // Assert
      expect(result, equals(expectedToken));
      expect(mockApiClient.lastPostPath, equals('/api/auth/login'));
      expect(mockApiClient.lastPostBody, equals({
        'username': username,
        'password': password,
      }));
    });

    test('login should throw exception when no token received', () async {
      // Arrange
      mockApiClient.setMockPostResponse({});

      // Act & Assert
      expect(
        () => authService.login(usernameOrEmail: 'test@example.com', password: 'password'),
        throwsA(isA<Exception>()),
      );
    });

    test('getSavedToken should return saved token', () async {
      // Arrange
      const token = 'saved-token';
      SharedPreferences.setMockInitialValues({'auth_token': token});

      // Act
      final result = await authService.getSavedToken();

      // Assert
      expect(result, equals(token));
    });

    test('logout should remove token from storage', () async {
      // Arrange
      SharedPreferences.setMockInitialValues({'auth_token': 'some-token'});

      // Act
      await authService.logout();

      // Assert
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('auth_token'), isNull);
    });

    test('register should call API with correct parameters', () async {
      // Arrange
      const email = 'test@example.com';
      const password = 'password123';
      
      mockApiClient.setMockPostResponse({});

      // Act
      await authService.register(email: email, password: password);

      // Assert
      expect(mockApiClient.lastPostPath, equals('/api/auth/register'));
      expect(mockApiClient.lastPostBody, equals({
        'username': email,
        'email': email,
        'password': password,
        'confirmPassword': password,
      }));
    });
  });
}

