abstract class const Failure([
  final String message = 'Something went wrong, please try again',
]) {}

class const ServerFailure(super.message) extends Failure {}

class const NetworkFailure([
  super.message = 'Can\'t connect to the server, plaese check your connection',
]) extends Failure {}

class const AppFailure() extends Failure {}
