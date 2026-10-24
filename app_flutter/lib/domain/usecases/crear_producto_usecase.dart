import '../entities/producto_input.dart';
import '../repositories/producto_repository.dart';

class CrearProductoUseCase {
  final ProductoRepository _repositorio;

  const CrearProductoUseCase(this._repositorio);

  Future<int> call(ProductoInput datos) => _repositorio.crearProducto(datos);
}
