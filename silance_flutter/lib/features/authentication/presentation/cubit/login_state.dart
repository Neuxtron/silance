import 'package:silance/features/authentication/domain/entities/app_user.dart';

enum SubmitStatus { initial, loading, success, error }

class LoginState({
  final String? errorMessage,
  final SubmitStatus status = .initial,
  final AppUser? user,
}) {
  LoginState copyWith({
    String? Function()? errorMessage,
    SubmitStatus? status,
    AppUser? user,
  }) {
    return LoginState(
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }
}
