import '../entities/producto.dart';
import '../repositories/producto_repository.dart';

class ListarProductosUseCase {
  final ProductoRepository _repositorio;

  const ListarProductosUseCase(this._repositorio);

  Future<List<Producto>> call() => _repositorio.listarProductos();
}
