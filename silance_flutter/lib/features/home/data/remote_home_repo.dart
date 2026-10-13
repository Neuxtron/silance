import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/core/network/api_client.dart';
import 'package:silance/features/home/domain/entities/home_user.dart';
import 'package:silance/features/home/domain/repositories/home_repo.dart';

class RemoteHomeRepo(final ApiClient api) extends HomeRepo {
  @override
  Future<Either<Failure, List<HomeUser>>> getUsers() async {
    try {
      final data = await api.get('/users');
      final usersJson = data?['data'] as List?;
      if (usersJson == null) {
        final message = data?['message'];
        return Left(ServerFailure(message));
      }

      final users = usersJson.map((e) => HomeUser.fromJson(e)).toList();
      return Right(users);
    } catch (e) {
      debugPrint(e.toString());
      return const Left(AppFailure());
    }
  }
}
