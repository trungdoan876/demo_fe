//model - Cấu trúc dữ liệu
//Generic API Response
class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? error;

  const ApiResponse({
    required this.success,
    this.message,
    this.data,
    this.error,
  });
//Generic factory constructor để convert JSON thành ApiResponse
  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json)? fromJsonT,
  ) {
    return ApiResponse<T>(
      success: json['success'] as bool,
      message: json['message'] as String?,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : null,
      error: json['error'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data,
      'error': error,
    };
  }

  bool get isSuccess => success && error == null;
  bool get isError => !success || error != null;
}
