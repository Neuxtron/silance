import 'package:equatable/equatable.dart';

abstract class const Failure([String? message]) extends Equatable {
  this : message = message ?? 'Something went wrong, please try again';
  final String message;

  @override
  List<Object?> get props => [message];
}

class const ServerFailure(super.message) extends Failure {}

class const UnauthorizedFailure([
  super.message = 'Failed to authenticate, please login again',
]) extends Failure {}

class const NetworkFailure([
  super.message = 'Can\'t connect to the server, plaese check your connection',
]) extends Failure {}

class const AppFailure() extends Failure {}
