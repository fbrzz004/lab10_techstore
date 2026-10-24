import '../repositories/producto_repository.dart';

class EliminarProductoUseCase {
  final ProductoRepository _repositorio;

  const EliminarProductoUseCase(this._repositorio);

  Future<void> call(int id) => _repositorio.eliminarProducto(id);
}
