import 'package:dartz/dartz.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/core/utils/repository_guard.dart';
import 'package:silance/features/authentication/data/datasources/remote_auth_datasource.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';

class const RemoteAuthRepo(final RemoteAuthDatasource dataSource)
    with RepositoryGuard
    implements AuthRepo {
  @override
  Future<Either<Failure, AppUser>> getProfile() async {
    return guard(() => dataSource.getProfile());
  }

  @override
  Future<Either<Failure, AppUser>> login(
    String username,
    String password,
  ) async {
    return guard(() => dataSource.login(username, password));
  }

  @override
  Future<Either<Failure, AppUser?>> register({
    required String phone,
    required String username,
    required String displayName,
    required String password,
  }) async {
    return guard(() {
      return dataSource.register(phone, username, displayName, password);
    });
  }

  @override
  Future<void> logout() => guard(() => dataSource.logout());
}
