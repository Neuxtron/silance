import 'package:dio/dio.dart';
import 'package:silance/core/error/exceptions.dart';

mixin DatasourceGuard {
  Future<T> guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on DioException catch (e) {
      switch (e.type) {
        case .connectionError:
        case .connectionTimeout:
          throw const NetworkException();
        case .sendTimeout:
        case .receiveTimeout:
          throw const NetworkException();
        default:
          break;
      }
      if (e.response?.statusCode == 401) {
        throw const UnauthorizedException();
      }
      final message = e.response?.data?['message'] as String?;
      throw ServerException(message);
    } catch (e) {
      rethrow;
    }
  }
}
