import '../../core/constants.dart';
import '../../domain/entities/usuario.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/api_service.dart';
import '../models/usuario_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _api;

  const AuthRepositoryImpl(this._api);

  @override
  Future<Usuario?> login(String username, String password) async {
    final respuesta = await _api.post(AppConstants.loginEndpoint, {
      'username': username,
      'password': password,
    });

    if (respuesta is Map<String, dynamic> && respuesta['ok'] == true) {
      final usuario = respuesta['usuario'];
      if (usuario is Map<String, dynamic>) {
        return UsuarioModel.fromJson(usuario);
      }
    }
    return null;
  }
}
