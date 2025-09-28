class AppConfig {
  const AppConfig._();

  // TODO: chỉnh sửa BASE_URL theo môi trường backend của bạn
  static const String baseUrl = 'http://10.0.2.2:8080';
  // Khi chạy trên device thật trong LAN: thay bằng IP máy backend, ví dụ:
  // static const String baseUrl = 'http://192.168.1.100:8080';
}


