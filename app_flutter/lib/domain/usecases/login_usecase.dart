import '../entities/usuario.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repositorio;

  const LoginUseCase(this._repositorio);

  Future<Usuario?> call(String username, String password) {
    return _repositorio.login(username, password);
  }
}
