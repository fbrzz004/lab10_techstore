import '../entities/usuario.dart';

abstract class AuthRepository {
  Future<Usuario?> login(String username, String password);
}
