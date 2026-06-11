import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000';
  final Dio _dio = Dio();
  static ApiService? _instance;

  ApiService._internal() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('access_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        return handler.next(response);
      },
      onError: (error, handler) {
        return handler.next(error);
      },
    ));
  }

  factory ApiService() {
    _instance ??= ApiService._internal();
    return _instance!;
  }

  Future<Response> login(String phone) async {
    return await _dio.post(
      '$baseUrl/api/v1/auth/login',
      data: {'phone': phone},
    );
  }

  Future<Response> analyzeJumpRope(String userId, String videoPath) async {
    final formData = FormData.fromMap({
      'user_id': userId,
      'video': await MultipartFile.fromFile(videoPath),
    });
    return await _dio.post(
      '$baseUrl/api/v1/jump-rope/analyze',
      data: formData,
    );
  }

  Future<Response> analyzeFootball(String userId, String videoPath) async {
    final formData = FormData.fromMap({
      'user_id': userId,
      'video': await MultipartFile.fromFile(videoPath),
    });
    return await _dio.post(
      '$baseUrl/api/v1/football/analyze',
      data: formData,
    );
  }

  Future<Response> getJumpRopeHistory(String userId) async {
    return await _dio.get('$baseUrl/api/v1/jump-rope/history/$userId');
  }

  Future<Response> getFootballHistory(String userId) async {
    return await _dio.get('$baseUrl/api/v1/football/history/$userId');
  }

  Future<Response> getUserProfile(String userId) async {
    return await _dio.get('$baseUrl/api/v1/users/profile/$userId');
  }

  Future<Response> updateUserProfile(String userId, Map<String, dynamic> data) async {
    return await _dio.put('$baseUrl/api/v1/users/profile/$userId', data: data);
  }
}