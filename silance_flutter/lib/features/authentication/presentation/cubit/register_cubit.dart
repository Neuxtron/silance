import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';
import 'package:silance/features/authentication/presentation/cubit/register_state.dart';

class RegisterCubit(final AuthRepo repo) extends Cubit<RegisterState> {
  this : super(RegisterState());

  void nameChanged(String value) => state.name = value;
  void phoneChanged(String value) => state.phone = value;
  void usernameChanged(String value) => state.username = value;
  void passwordChanged(String value) => state.password = value;
  void confirmPasswordChanged(String value) => state.confirmPassword = value;

  Future<void> submit() async {
    final error = _validate();
    emit(state.copyWith(errorMessage: () => error));
    if (error != null) return;

    emit(state.copyWith(status: .loading));
    final result = await repo.register(
      phone: state.phone,
      username: state.username,
      displayName: state.name,
      password: state.password,
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
      (user) => emit(state.copyWith(status: .success)),
    );
  }

  String? _validate() {
    if (state.name.isEmpty) return 'Please enter your name';
    if (state.phone.isEmpty) return 'Please enter your phone number';
    if (state.password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    if (state.password != state.confirmPassword) return 'Passwords must match';

    return null;
  }
}
