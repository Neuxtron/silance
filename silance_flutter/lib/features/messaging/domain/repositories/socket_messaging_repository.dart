import 'package:dartz/dartz.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/features/messaging/domain/entities/message.dart';

abstract class SocketMessagingRepository {
  Stream<Either<Failure, Message>> watchMessages();
  Future<Either<Failure, void>> sendMessage(Message message);
  Future<Either<Failure, void>> disconnect();
}
