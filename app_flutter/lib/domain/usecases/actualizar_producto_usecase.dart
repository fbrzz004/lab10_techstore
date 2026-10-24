import '../entities/producto_input.dart';
import '../repositories/producto_repository.dart';

class ActualizarProductoUseCase {
  final ProductoRepository _repositorio;

  const ActualizarProductoUseCase(this._repositorio);

  Future<void> call(int id, ProductoInput datos) =>
      _repositorio.actualizarProducto(id, datos);
}
