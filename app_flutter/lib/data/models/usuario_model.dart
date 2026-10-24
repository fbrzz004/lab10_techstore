import '../../domain/entities/usuario.dart';

class UsuarioModel extends Usuario {
  const UsuarioModel({
    required super.id,
    required super.username,
    required super.nombre,
  });

  factory UsuarioModel.fromJson(Map<String, dynamic> json) {
    return UsuarioModel(
      id: json['id'] as int,
      username: json['username'] as String? ?? '',
      nombre: json['nombre'] as String? ?? '',
    );
  }
}
