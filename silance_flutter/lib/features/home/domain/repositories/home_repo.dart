import 'package:dartz/dartz.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/features/home/domain/entities/home_user.dart';

abstract class HomeRepo {
  Future<Either<Failure, List<HomeUser>>> getUsers();
}
