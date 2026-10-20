import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:silance/core/error/exceptions.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/core/network/api_client.dart';
import 'package:silance/features/authentication/data/datasources/remote_auth_datasource.dart';
import 'package:silance/features/authentication/data/repositories/remote_auth_repo.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockDataSource extends Mock implements RemoteAuthDatasource {}

void main() {
  late RemoteAuthRepo repo;
  late MockDataSource dataSource;

  setUp(() {
    dataSource = MockDataSource();
    repo = RemoteAuthRepo(dataSource);
  });

  group('Login', () {
    test(
      'Given correct credentials When login Then login successful',
      () async {
        final tJson =
            jsonDecode(fixture('auth/login/200.json')) as Map<String, dynamic>;
        final tModel = AppUser.fromJson(tJson['data']['user']);

        when(() => dataSource.login(any(), any()))
            .thenAnswer((_) async => tModel);

        final result = await repo.login('username', 'password');

        expect(result, Right(tModel));
      },
    );

    test('Given wrong credentials When login Then login Failed', () async {
      final tJson =
          jsonDecode(fixture('auth/login/401.json')) as Map<String, dynamic>;

      when(() => dataSource.login(any(), any()))
          .thenThrow(ServerException(tJson['message']));

      final result = await repo.login('username', 'password');

      expect(result, Left(ServerFailure(tJson['message'])));
    });
  });
}
