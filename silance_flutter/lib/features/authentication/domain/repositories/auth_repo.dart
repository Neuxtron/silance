import 'package:silance/features/authentication/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<AppUser?> login(String username, String password);
  Future<AppUser?> getProfile();
  Future<AppUser?> register(
    String phone,
    String username,
    String displayName,
    String password,
  );
}
