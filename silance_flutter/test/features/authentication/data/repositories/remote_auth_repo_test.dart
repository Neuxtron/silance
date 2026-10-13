import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/core/network/api_client.dart';
import 'package:silance/features/authentication/data/repositories/remote_auth_repo.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockApiClient api;
  late RemoteAuthRepo repo;

  setUp(() {
    api = MockApiClient();
    repo = RemoteAuthRepo(api);
  });

  DioException dioError(DioExceptionType type, {Response? res}) {
    return DioException(
      type: type,
      requestOptions: RequestOptions(),
      response: res,
    );
  }

  group('Login', () {
    setUp(() {
      when(() => api.setToken(any())).thenAnswer((_) async {});
    });

    test(
      'Given correct credentials When login Then login successful',
      () async {
        final tJson =
            jsonDecode(fixture('auth/login/200.json')) as Map<String, dynamic>;
        final tModel = AppUser.fromJson(tJson['data']['user']);

        when(() => api.post(any(), data: any(named: 'data')))
            .thenAnswer((_) async => tJson);

        final result = await repo.login('username', 'password');

        expect(result, Right(tModel));
      },
    );

    test('Given wrong credentials When login Then login Failed', () async {
      final tJson =
          jsonDecode(fixture('auth/login/401.json')) as Map<String, dynamic>;

      when(() => api.post(any(), data: any(named: 'data'))).thenThrow(
        dioError(
          .badResponse,
          res: Response(
            requestOptions: RequestOptions(),
            statusCode: 401,
            data: tJson,
          ),
        ),
      );

      final result = await repo.login('username', 'password');

      expect(result, Left(ServerFailure(tJson['message'])));
    });
  });
}
