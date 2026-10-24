import 'package:flutter/foundation.dart';

import '../../core/errors.dart';
import '../../domain/usecases/login_usecase.dart';
import 'login_state.dart';

class LoginViewModel extends ChangeNotifier {
  final LoginUseCase _loginUseCase;
  LoginState _state = const LoginState();

  LoginViewModel(this._loginUseCase);

  LoginState get state => _state;

  void setUsername(String value) {
    _state = _state.copyWith(
      username: value,
      status: _state.status == LoginStatus.failure
          ? LoginStatus.idle
          : _state.status,
      errorMessage: '',
    );
    notifyListeners();
  }

  void setPassword(String value) {
    _state = _state.copyWith(
      password: value,
      status: _state.status == LoginStatus.failure
          ? LoginStatus.idle
          : _state.status,
      errorMessage: '',
    );
    notifyListeners();
  }

  Future<bool> login() async {
    if (!_state.isFormValid) {
      _state = _state.copyWith(
        status: LoginStatus.failure,
        errorMessage: 'Ingrese usuario y contraseña.',
      );
      notifyListeners();
      return false;
    }

    _state = _state.copyWith(status: LoginStatus.loading, errorMessage: '');
    notifyListeners();

    try {
      final usuario = await _loginUseCase(
        _state.username.trim(),
        _state.password,
      );
      if (usuario == null) {
        _state = _state.copyWith(
          status: LoginStatus.failure,
          errorMessage: 'Credenciales incorrectas.',
        );
        return false;
      }
      _state = _state.copyWith(
        status: LoginStatus.success,
        usuario: usuario,
        errorMessage: '',
      );
      return true;
    } on ApiException catch (error) {
      _state = _state.copyWith(
        status: LoginStatus.failure,
        errorMessage: error.message,
      );
      return false;
    } catch (_) {
      _state = _state.copyWith(
        status: LoginStatus.error,
        errorMessage: 'No se pudo conectar con el servidor.',
      );
      return false;
    } finally {
      notifyListeners();
    }
  }

  void reset() {
    _state = const LoginState();
    notifyListeners();
  }
}
