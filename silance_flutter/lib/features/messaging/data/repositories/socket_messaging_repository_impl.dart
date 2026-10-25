import 'package:dartz/dartz.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/core/utils/repository_guard.dart';
import 'package:silance/features/messaging/data/datasources/socket_messaging_datasource.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';
import 'package:silance/features/messaging/domain/repositories/socket_messaging_repository.dart';

class const SocketMessagingRepositoryImpl(
  final SocketMessagingDatasource dataSource,
) with RepositoryGuard implements SocketMessagingRepository {
  @override
  Stream<Either<Failure, Message>> watchMessages(
    String userId,
    String targetId,
  ) async* {
    yield* streamGuard(() => dataSource.watchMessages(userId, targetId));
  }

  @override
  Future<Either<Failure, void>> sendMessage(Message message) async {
    return guard(() async => dataSource.sendMessage(message));
  }

  @override
  Future<Either<Failure, void>> disconnect() {
    return guard(dataSource.disconnect);
  }
}
