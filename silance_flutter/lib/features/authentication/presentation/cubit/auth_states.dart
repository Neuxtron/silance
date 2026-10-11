import 'package:silance/features/authentication/domain/entities/app_user.dart';

abstract class const AuthStates() {}

class const AuthInitial() extends AuthStates {}

class const Authenticated(final AppUser user) extends AuthStates {}

class const UnAuthenticated() extends AuthStates {}
