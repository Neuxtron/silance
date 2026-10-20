import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:silance/core/error/exceptions.dart';
import 'package:silance/core/error/failures.dart';

mixin RepositoryGuard {
  Future<Either<Failure, T>> guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(AppFailure());
    }
  }
}
