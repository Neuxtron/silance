import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/core/error/failures.dart';
import 'package:silance/features/authentication/domain/entities/app_user.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';
import 'package:silance/features/authentication/presentation/cubit/auth_states.dart';

class AuthCubit(final AuthRepo repo) extends Cubit<AuthStates> {
  this : super(const AuthInitial());

  AppUser? get user {
    if (state is! Authenticated) return null;
    return (state as Authenticated).user;
  }

  void authenticate([AppUser? user]) async {
    if (user != null) {
      emit(Authenticated(user));
      return;
    }

    final result = await repo.getProfile();

    result.fold(
      (failure) {
        if (state is AuthInitial) {
          emit(const UnAuthenticated());
        } else if (failure is UnauthorizedFailure) {
          emit(const UnAuthenticated());
        }
      },
      (newUser) {
        emit(Authenticated(newUser));
        state;
      },
    );
  }

  Future<void> logout() async {
    emit(const UnAuthenticated());
    await repo.logout();
  }
}
