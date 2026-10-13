import 'package:dio/dio.dart';

class ErrorMessageInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final data = err.response?.data;
    final message = data is Map<String, dynamic>
        ? data['message'] as String?
        : null;
    return handler.next(err.copyWith(message: message));
  }
}
