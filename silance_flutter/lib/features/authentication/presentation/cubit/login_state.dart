enum SubmitStatus { initial, loading, success, error }

class LoginState({
  final String? errorMessage,
  final SubmitStatus status = .initial,
}) {
  LoginState copyWith({
    String? Function()? errorMessage,
    SubmitStatus? status,
  }) {
    return LoginState(
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      status: status ?? this.status,
    );
  }
}
