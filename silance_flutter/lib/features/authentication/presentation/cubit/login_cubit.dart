import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:silance/features/authentication/domain/repositories/auth_repo.dart';
import 'package:silance/features/authentication/presentation/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  new(this.repo) : super(LoginState());

  final AuthRepo repo;

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
    try {
      final user = await repo.login(state.username, state.password);
      if (user == null) throw Exception('User is null');
      emit(state.copyWith(status: .success));
    } on Exception catch (e) {
      String message = 'Something went wrong, please try again';
      if (e is DioException) message = e.message ?? message;
      emit(
        state.copyWith(
          status: .error,
          errorMessage: () => message,
        ),
      );
    }
  }

  String? _validate() {
    if (state.username.isEmpty) {
      return 'Please enter either your username or phone number';
    }
    if (state.password.isEmpty) return 'Please enter your password';
    return null;
  }
}
