import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';
import 'package:silance/features/authentication/presentation/cubit/login_state.dart';

class LoginCubit(final AuthRepo repo) extends Cubit<LoginState> {
  this : super(LoginState());

  void usernameChanged(String value) {
    emit(state.copyWith(username: value));
  }

  void passwordChanged(String value) {
    emit(state.copyWith(password: value));
  }

  Future<void> submit() async {
    final error = _validate();
    emit(state.copyWith(errorMessage: () => error));
    if (error != null) return;

    emit(state.copyWith(status: .loading));
    final result = await repo.login(state.username, state.password);

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: .error,
            errorMessage: () => failure.message,
          ),
        );
      },
      (user) => emit(state.copyWith(status: .success)),
    );
  }

  String? _validate() {
    if (state.username.isEmpty) {
      return 'Please enter either your username or phone number';
    }
    if (state.password.isEmpty) return 'Please enter your password';
    return null;
  }
}
