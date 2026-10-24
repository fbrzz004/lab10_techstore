import '../../domain/entities/usuario.dart';

enum LoginStatus { idle, loading, success, failure, error }

class LoginState {
  final String username;
  final String password;
  final LoginStatus status;
  final String errorMessage;
  final Usuario? usuario;

  const LoginState({
    this.username = '',
    this.password = '',
    this.status = LoginStatus.idle,
    this.errorMessage = '',
    this.usuario,
  });

  bool get isLoading => status == LoginStatus.loading;
  bool get isFormValid => username.trim().isNotEmpty && password.isNotEmpty;

  LoginState copyWith({
    String? username,
    String? password,
    LoginStatus? status,
    String? errorMessage,
    Usuario? usuario,
  }) {
    return LoginState(
      username: username ?? this.username,
      password: password ?? this.password,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      usuario: usuario ?? this.usuario,
    );
  }
}
