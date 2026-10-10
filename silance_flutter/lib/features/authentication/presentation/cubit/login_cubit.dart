import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';
import 'package:silance/features/authentication/presentation/cubit/login_state.dart';

class LoginCubit(final AuthRepo repo) extends Cubit<LoginState> {
  this : super(LoginState());

  String _username = '';
  String _password = '';

  void usernameChanged(String value) => _username = value;
  void passwordChanged(String value) => _password = value;

  Future<void> submit() async {
    final error = _validate();
    emit(state.copyWith(errorMessage: () => error));
    if (error != null) return;

    emit(state.copyWith(status: .loading));
    final result = await repo.login(_username, _password);

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
    if (_username.isEmpty) {
      return 'Please enter either your username or phone number';
    }
    if (_password.isEmpty) return 'Please enter your password';
    return null;
  }
}
