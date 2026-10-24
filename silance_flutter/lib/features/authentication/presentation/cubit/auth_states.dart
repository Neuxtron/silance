import 'package:silance/features/authentication/domain/entities/app_user.dart';

abstract class const AuthState() {}

class const AuthInitial() extends AuthState {}

class const Authenticated(final AppUser user) extends AuthState {}

class const UnAuthenticated() extends AuthState {}
