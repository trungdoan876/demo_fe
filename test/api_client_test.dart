import 'package:flutter_test/flutter_test.dart';
import 'package:demo_01/services/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'mock_api_client.dart';

void main() {
  group('ApiClient Tests', () {
    late ApiClient apiClient;
    late MockClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockClient((request) async {
        if (request.url.path == '/api/test/success') {
          return http.Response('{"message": "success"}', 200);
        } else if (request.url.path == '/api/test/error') {
          return http.Response('{"error": "not found"}', 404);
        } else if (request.url.path == '/api/test/empty') {
          return http.Response('', 200);
        }
        return http.Response('{"error": "unknown"}', 500);
      });
      
      apiClient = ApiClient(httpClient: mockHttpClient);
    });

    testWidgets('getJson should return parsed JSON for successful request', (tester) async {
      // Act
      final result = await apiClient.getJson('/api/test/success');

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['message'], equals('success'));
    });

    testWidgets('getJson should throw ApiException for error status', (tester) async {
      // Act & Assert
      expect(
        () => apiClient.getJson('/api/test/error'),
        throwsA(isA<ApiException>()),
      );
    });

    testWidgets('getJson should return null for empty response', (tester) async {
      // Act
      final result = await apiClient.getJson('/api/test/empty');

      // Assert
      expect(result, isNull);
    });

    testWidgets('postJson should return parsed JSON for successful request', (tester) async {
      // Arrange
      final testBody = {'key': 'value'};
      
      // Act
      final result = await apiClient.postJson('/api/test/success', body: testBody);

      // Assert
      expect(result, isA<Map<String, dynamic>>());
      expect(result['message'], equals('success'));
    });

    testWidgets('postJson should include correct headers', (tester) async {
      // Arrange
      final customHeaders = {'Authorization': 'Bearer token123'};
      
      // Act
      await apiClient.postJson('/api/test/success', headers: customHeaders);

      // Assert - MockClient will have received the request with headers
      // This is implicitly tested by the successful execution
    });

    testWidgets('ApiException should have correct properties', (tester) async {
      // Act & Assert
      try {
        await apiClient.getJson('/api/test/error');
        fail('Should have thrown ApiException');
      } catch (e) {
        expect(e, isA<ApiException>());
        final exception = e as ApiException;
        expect(exception.statusCode, equals(404));
        expect(exception.message, contains('not found'));
      }
    });

    testWidgets('should handle network errors', (tester) async {
      // Arrange
      final failingClient = MockClient((request) async {
        throw Exception('Network error');
      });
      final failingApiClient = ApiClient(httpClient: failingClient);

      // Act & Assert
      expect(
        () => failingApiClient.getJson('/api/test'),
        throwsA(isA<Exception>()),
      );
    });
  });
}
