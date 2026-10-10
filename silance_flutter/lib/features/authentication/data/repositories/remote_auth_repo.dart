import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/core/network/api_client.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';

class const RemoteAuthRepo(final ApiClient api) implements AuthRepo {
  @override
  Future<Either<Failure, AppUser>> getProfile() {
    // TODO: implement getProfile
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, AppUser>> login(
    String username,
    String password,
  ) async {
    try {
      final data = await api.post(
        '/auth/login',
        data: {
          'username': username,
          'phone': username,
          'password': password,
        },
      );

      final userJson = data?['data']['user'];
      if (userJson == null) {
        final message = data?['message'];
        return Left(ServerFailure(message));
      }

      return Right(AppUser.fromJson(userJson));
    } on DioException catch (e) {
      if (e.type == .connectionTimeout) {
        return const Left(NetworkFailure());
      }
      final message = e.response?.data?['message'];
      return Left(ServerFailure(message));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(AppFailure());
    }
  }

  @override
  Future<Either<Failure, AppUser>> register({
    required String phone,
    required String username,
    required String displayName,
    required String password,
  }) async {
    try {
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
      if (userJson == null) {
        final message = data?['message'];
        return Left(ServerFailure(message));
      }

      return Right(AppUser.fromJson(userJson));
    } on DioException catch (e) {
      if (e.type == .connectionTimeout) {
        return const Left(NetworkFailure());
      }
      final message = e.response?.data?['message'];
      return Left(ServerFailure(message));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(AppFailure());
    }
  }
}
