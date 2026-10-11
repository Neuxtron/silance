import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/core/network/api_client.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';

class const RemoteAuthRepo(final ApiClient api) implements AuthRepo {
  @override
  Future<Either<Failure, AppUser>> getProfile() async {
    try {
      final hasToken = await api.checkToken();
      if (!hasToken) return const Left(UnauthorizedFailure());
      final data = await api.get('/auth/profile');
      final userJson = data?['data'];
      if (userJson == null) {
        final message = data?['message'];
        return Left(ServerFailure(message));
      }
      return Right(AppUser.fromJson(userJson));
    } on DioException catch (e) {
      if (e.type == .connectionTimeout) {
        return const Left(NetworkFailure());
      }

      if (e.response?.statusCode == 401) {
        return const Left(UnauthorizedFailure());
      }

      final message = e.response?.data?['message'] as String?;
      return Left(ServerFailure(message));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(AppFailure());
    }
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
      final token = data?['data']['token'];
      if (userJson == null || token == null) {
        final message = data?['message'];
        return Left(ServerFailure(message));
      }

      api.setToken(token);
      return Right(AppUser.fromJson(userJson));
    } on DioException catch (e) {
      if (e.type == .connectionTimeout) {
        return const Left(NetworkFailure());
      }
      final message = e.response?.data?['message'] as String?;
      return Left(ServerFailure(message));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(AppFailure());
    }
  }

  @override
  Future<Either<Failure, AppUser?>> register({
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
      final token = data?['data']['token'];
      if (userJson == null) {
        final message = data?['message'];
        return Left(ServerFailure(message));
      }
      if (token == null) return const Right(null);

      api.setToken(token);
      return Right(AppUser.fromJson(userJson));
    } on DioException catch (e) {
      if (e.type == .connectionTimeout) {
        return const Left(NetworkFailure());
      }
      final message = e.response?.data?['message'] as String?;
      return Left(ServerFailure(message));
    } catch (e) {
      debugPrint(e.toString());
      return const Left(AppFailure());
    }
  }

  @override
  Future<void> logout() => api.setToken(null);
}
