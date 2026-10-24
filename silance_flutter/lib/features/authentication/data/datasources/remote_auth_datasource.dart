import 'package:silance/core/error/exceptions.dart';
import 'package:silance/core/network/api_client.dart';
import 'package:silance/core/utils/remote_datasource_guard.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';

abstract class RemoteAuthDatasource {
  Future<AppUser> getProfile();
  Future<AppUser> login(String username, String password);
  Future<AppUser?> register(
    String phone,
    String username,
    String displayName,
    String password,
  );
  Future<void> logout();
}

class const RemoteAuthDatasourceImpl(final ApiClient api)
    with RemoteDatasourceGuard
    implements RemoteAuthDatasource {
  @override
  Future<AppUser> getProfile() async {
    return guard(() async {
      final hasToken = await api.checkToken();
      if (!hasToken) throw const UnauthorizedException();
      final data = await api.get('/auth/profile');
      final userJson = data?['data'];
      if (userJson == null) {
        final message = data?['message'];
        throw ServerException(message);
      }
      return AppUser.fromJson(userJson);
    });
  }

  @override
  Future<AppUser> login(String username, String password) async {
    return guard(() async {
      final data = await api.post(
        '/auth/login',
        data: {
          'username': username,
          'phone': username,
          'password': password,
        },
      );
      final userJson = data?['data']['user'];
      final token = data?['data']['token'];
      if (userJson == null || token == null) {
        final message = data?['message'];
        throw ServerException(message);
      }
      api.setToken(token);
      return AppUser.fromJson(userJson);
    });
  }

  @override
  Future<AppUser?> register(
    String phone,
    String username,
    String displayName,
    String password,
  ) async {
    return guard(() async {
      final data = await api.post(
        '/auth/register',
        data: {
          'phone': phone,
          'username': username,
          'display_name': displayName,
          'password': password,
        },
      );

      final userJson = data?['data']['user'];
      final token = data?['data']['token'];
      if (userJson == null) {
        final message = data?['message'];
        throw ServerException(message);
      }
      if (token == null) return null;

      api.setToken(token);
      return AppUser.fromJson(userJson);
    });
  }

  @override
  Future<void> logout() => api.setToken(null);
}
