import 'package:dartz/dartz.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';

abstract class AuthRepo {
  Future<Either<Failure, AppUser>> login(String username, String password);
  Future<Either<Failure, AppUser>> getProfile();
  Future<Either<Failure, AppUser?>> register({
    required String phone,
    required String username,
    required String displayName,
    required String password,
  });
  Future<void> logout();
}
