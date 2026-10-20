import 'package:equatable/equatable.dart';

abstract class const Failure([String? message]) extends Equatable {
  this : message = message ?? 'Something went wrong, please try again';
  final String message;

  @override
  List<Object?> get props => [message];
}

class const ServerFailure(super.message) extends Failure {}

class const UnauthorizedFailure([super.message]) extends Failure {}

class const NetworkFailure([super.message]) extends Failure {}

class const AppFailure() extends Failure {}
