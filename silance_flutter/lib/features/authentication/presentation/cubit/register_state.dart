enum SubmitStatus { initial, loading, success, error }

class RegisterState({
  final String? errorMessage,
  final SubmitStatus status = .initial,
}) {
  RegisterState copyWith({
    String? Function()? errorMessage,
    SubmitStatus? status,
  }) {
    return RegisterState(
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      status: status ?? this.status,
    );
  }
}
