class const ServerException(
  String? message, {
  final String? code,
  final Object? error,
}) implements Exception {
  this : message = message ?? 'Something went wrong, please try again';

  final String message;

  @override
  String toString() => 'ServerException: $message';
}

class const UnauthorizedException({
  final String message = 'Failed to authenticate, please login again',
  final String? code,
  final Object? error,
}) implements Exception {
  @override
  String toString() => 'UnauthorizedException: $message';
}

class const NetworkException({
  final String message =
      'Can\'t connect to the server, plaese check your connection',
  final String? code,
  final Object? error,
}) implements Exception {
  @override
  String toString() => 'NetworkException: $message';
}
