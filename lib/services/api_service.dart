import 'dart:io';

class ApiService {
  static Future<dynamic> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'status': 'success'};
  }

  static Future<dynamic> upload(
    String url, {
    File? file,
    String? token,
    Map<String, String>? fields,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    return {'status': 'uploaded'};
  }
}
