import '../entities/producto.dart';
import '../entities/producto_input.dart';

abstract class ProductoRepository {
  Future<List<Producto>> listarProductos();
  Future<List<Producto>> buscarProductos(String query);
  Future<int> crearProducto(ProductoInput datos);
  Future<void> actualizarProducto(int id, ProductoInput datos);
  Future<void> eliminarProducto(int id);
}
