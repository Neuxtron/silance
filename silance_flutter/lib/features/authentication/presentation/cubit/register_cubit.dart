import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';
import 'package:silance/features/authentication/presentation/cubit/register_state.dart';

class RegisterCubit(final AuthRepo repo) extends Cubit<RegisterState> {
  this : super(RegisterState());

  String _name = '';
  String _phone = '';
  String _username = '';
  String _password = '';
  String _confirmPassword = '';

  void nameChanged(String value) => _name = value;
  void phoneChanged(String value) => _phone = value;
  void usernameChanged(String value) => _username = value;
  void passwordChanged(String value) => _password = value;
  void confirmPasswordChanged(String value) => _confirmPassword = value;

  Future<void> submit() async {
    final error = _validate();
    emit(state.copyWith(errorMessage: () => error));
    if (error != null) return;

    emit(state.copyWith(status: .loading));
    final result = await repo.register(
      phone: _phone,
      username: _username,
      displayName: _name,
      password: _password,
    );

    result.fold(
      (failure) {
        emit(
          state.copyWith(
            status: .error,
            errorMessage: () => failure.message,
          ),
        );
      },
      (user) => emit(state.copyWith(status: .success, user: user)),
    );
  }

  String? _validate() {
    if (_name.isEmpty) return 'Please enter your name';
    if (_phone.isEmpty) return 'Please enter your phone number';
    if (_password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (_password != _confirmPassword) return 'Passwords must match';

    return null;
  }
}
