import 'package:flutter_test/flutter_test.dart';
import 'package:demo_01/services/api_client.dart';
import 'mock_api_client.dart';

void main() {
  group('Simple MockApiClient Tests', () {
    late MockApiClient mockApiClient;

    setUp(() {
      mockApiClient = MockApiClient();
      mockApiClient.reset();
    });

    test('MockApiClient should return mock response', () async {
      // Arrange
      mockApiClient.setMockPostResponse({
        'token': 'test-token-123'
      });

      // Act
      final result = await mockApiClient.postJson('/api/test');

      // Assert
      expect(result, equals({'token': 'test-token-123'}));
      expect(mockApiClient.lastPostPath, equals('/api/test'));
    });

    test('MockApiClient should throw error when set', () async {
      // Arrange
      mockApiClient.setMockError('Test error', statusCode: 404);

      // Act & Assert
      expect(
        () => mockApiClient.postJson('/api/test'),
        throwsA(isA<ApiException>()),
      );
    });

    test('MockApiClient should track calls correctly', () async {
      // Arrange
      mockApiClient.setMockGetResponse({'data': 'test'});

      // Act
      await mockApiClient.getJson('/api/test', headers: {'Authorization': 'Bearer token'});

      // Assert
      expect(mockApiClient.lastGetPath, equals('/api/test'));
      expect(mockApiClient.lastGetHeaders?['Authorization'], equals('Bearer token'));
    });
  });
}
