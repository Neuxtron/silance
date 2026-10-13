import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:silance/core/network/interceptors.dart';
import 'package:silance/core/utils/constants.dart';

class ApiClient([Dio? dio]) {
  this : _dio = dio ?? _createDio();

  final Dio _dio;

  static Dio _createDio() {
    final baseUrl = dotenv.env['BASE_URL'];
    if (baseUrl == null) {
      throw EmptyEnvFileError();
    }

    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    )..interceptors.add(ErrorMessageInterceptor());
  }

  Future<bool> checkToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.tokenKey);
    if (token == null) return false;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    return true;
  }

  Future<void> setToken(String? token) async {
    final prefs = await SharedPreferences.getInstance();
    if (token != null) {
      prefs.setString(AppConstants.tokenKey, token);
      _dio.options.headers['Authorization'] = 'Bearer $token';
    } else {
      prefs.remove(AppConstants.tokenKey);
      _dio.options.headers.remove('Authorization');
    }
  }

  Future<Map<String, dynamic>?> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> post(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> put(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.put<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }

  Future<Map<String, dynamic>?> delete(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    final response = await _dio.delete<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
    );
    return response.data;
  }
}
