enum SubmitStatus { initial, loading, success, error }

class RegisterState({
  var String name = '',
  var String phone = '',
  var String username = '',
  var String password = '',
  var String confirmPassword = '',
  var SubmitStatus status = .initial,
  var String? errorMessage = '',
}) {
  RegisterState copyWith({
    String? name,
    String? phone,
    String? username,
    String? password,
    String? confirmPassword,
    SubmitStatus? status,
    String? Function()? errorMessage,
  }) {
    return RegisterState(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      username: username ?? this.username,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      status: status ?? this.status,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
    );
  }
}
