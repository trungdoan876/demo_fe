import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../config/app_config.dart';

//class này là HTTP Client chung
//service - giao tiếp với api
class ApiClient {
  ApiClient({http.Client? httpClient}) : _client = httpClient ?? http.Client();

  final http.Client _client;

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    return Uri.parse('${AppConfig.baseUrl}$path').replace(queryParameters: query);
  }

  Future<dynamic> getJson(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? query,
  }) async {
    final mergedHeaders = <String, String>{
      'Accept': 'application/json',
      if (headers != null) ...headers,
    };

    final response = await _client.get(_uri(path, query), headers: mergedHeaders);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }
    throw ApiException(
      statusCode: response.statusCode,
      message: response.body.isNotEmpty ? response.body : 'HTTP ${response.statusCode}',
    );
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final mergedHeaders = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (headers != null) ...headers,
    };

    final response = await _client.post(
      _uri(path),
      headers: mergedHeaders,
      body: jsonEncode(body ?? <String, dynamic>{}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return <String, dynamic>{};
      return jsonDecode(response.body) as Map<String, dynamic>;
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: response.body.isNotEmpty ? response.body : 'HTTP ${response.statusCode}',
    );
  }
}

class ApiException implements Exception {
  ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}


