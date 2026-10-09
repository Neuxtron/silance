import 'package:silance/core/network/api_client.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';

class RemoteAuthRepo implements AuthRepo {
  new(this.api);

  final ApiClient api;

  @override
  Future<AppUser?> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<AppUser?> login(String username, String password) async {
    final response = await api.post(
      '/auth/login',
      data: {
        'username': username,
        'phone': username,
        'password': password,
      },
    );

    final data = response.data!['data'];
    if (response.data == null) return null;
    return AppUser.fromJson(data['user']);
  }

  @override
  Future<AppUser?> register(
    String phone,
    String username,
    String displayName,
    String password,
  ) {
    // TODO: implement register
    throw UnimplementedError();
  }
}
