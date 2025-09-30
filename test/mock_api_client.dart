import 'package:demo_01/services/api_client.dart';

class MockApiClient implements ApiClient {
  Map<String, dynamic>? _mockGetResponse;
  Map<String, dynamic>? _mockPostResponse;
  String? _mockError;
  int? _mockStatusCode;
  
  // Tracking calls
  String? lastGetPath;
  String? lastPostPath;
  Map<String, String>? lastGetHeaders;
  Map<String, String>? lastPostHeaders;
  Map<String, dynamic>? lastPostBody;
  Map<String, dynamic>? lastGetQuery;

  MockApiClient();

  // Setup methods
  void setMockGetResponse(Map<String, dynamic> response) {
    _mockGetResponse = response;
    _mockError = null;
    _mockStatusCode = 200;
  }

  void setMockPostResponse(Map<String, dynamic> response) {
    _mockPostResponse = response;
    _mockError = null;
    _mockStatusCode = 200;
  }

  void setMockError(String error, {int statusCode = 500}) {
    _mockError = error;
    _mockStatusCode = statusCode;
    _mockGetResponse = null;
    _mockPostResponse = null;
  }

  void setMockEmptyResponse() {
    _mockGetResponse = null;
    _mockPostResponse = null;
    _mockError = null;
    _mockStatusCode = 200;
  }

  @override
  Future<dynamic> getJson(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    lastGetPath = path;
    lastGetHeaders = headers;
    lastGetQuery = query;

    if (_mockError != null) {
      throw ApiException(
        statusCode: _mockStatusCode!,
        message: _mockError!,
      );
    }

    if (_mockStatusCode == 200) {
      if (_mockGetResponse == null) {
        return null; // Empty response
      }
      return _mockGetResponse;
    }

    throw ApiException(
      statusCode: _mockStatusCode ?? 500,
      message: 'Mock error',
    );
  }

  @override
  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    lastPostPath = path;
    lastPostHeaders = headers;
    lastPostBody = body;

    if (_mockError != null) {
      throw ApiException(
        statusCode: _mockStatusCode!,
        message: _mockError!,
      );
    }

    if (_mockStatusCode == 200) {
      if (_mockPostResponse == null) {
        return <String, dynamic>{}; // Empty response
      }
      return _mockPostResponse!;
    }

    throw ApiException(
      statusCode: _mockStatusCode ?? 500,
      message: 'Mock error',
    );
  }

  // Reset method for test cleanup
  void reset() {
    _mockGetResponse = null;
    _mockPostResponse = null;
    _mockError = null;
    _mockStatusCode = 200;
    lastGetPath = null;
    lastPostPath = null;
    lastGetHeaders = null;
    lastPostHeaders = null;
    lastPostBody = null;
    lastGetQuery = null;
  }
}
