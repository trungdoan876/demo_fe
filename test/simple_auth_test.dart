import 'package:flutter_test/flutter_test.dart';
import 'package:demo_01/services/api_client.dart';
import 'mock_api_client.dart';

void main() {
  group('Simple AuthService Tests', () {
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
      mockApiClient.reset();
    });

    test('MockApiClient should work with login flow', () async {
      // Arrange
      mockApiClient.setMockPostResponse({
        'token': 'test-token-123'
      });

      // Act
      final result = await mockApiClient.postJson('/api/auth/login', body: {
        'username': 'test@example.com',
        'password': 'password123'
      });

      // Assert
      expect(result, equals({'token': 'test-token-123'}));
      expect(mockApiClient.lastPostPath, equals('/api/auth/login'));
      expect(mockApiClient.lastPostBody, equals({
        'username': 'test@example.com',
        'password': 'password123'
      }));
    });

    test('MockApiClient should handle errors', () async {
      // Arrange
      mockApiClient.setMockError('Invalid credentials', statusCode: 401);

      // Act & Assert
      expect(
        () => mockApiClient.postJson('/api/auth/login'),
        throwsA(isA<ApiException>()),
      );
    });

    test('MockApiClient should track headers', () async {
      // Arrange
      mockApiClient.setMockGetResponse({'data': 'test'});

      // Act
      await mockApiClient.getJson('/api/surveys/questions/active', headers: {
        'Authorization': 'Bearer test-token'
      });

      // Assert
      expect(mockApiClient.lastGetPath, equals('/api/surveys/questions/active'));
      expect(mockApiClient.lastGetHeaders?['Authorization'], equals('Bearer test-token'));
    });
  });
}
