import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class BuscarProductosUseCase {
  final ProductoRepository _repositorio;

  const BuscarProductosUseCase(this._repositorio);

  Future<List<Producto>> call(String query) =>
      _repositorio.buscarProductos(query);
}
