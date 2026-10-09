enum SubmitStatus { initial, loading, success, error }

class LoginState {
  final String username;
  final String password;
  final String? errorMessage;
  final SubmitStatus status;

  new({
    this.username = '',
    this.password = '',
    this.errorMessage,
    this.status = SubmitStatus.initial,
  });

  LoginState copyWith({
    String? username,
    String? password,
    String? Function()? errorMessage,
    SubmitStatus? status,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      status: status ?? this.status,
    );
  }
}
