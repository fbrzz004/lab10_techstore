import '../../core/constants.dart';
import '../../domain/entities/producto.dart';
import '../../domain/entities/producto_input.dart';
import '../../domain/repositories/producto_repository.dart';
import '../datasources/api_service.dart';
import '../models/producto_model.dart';

class ProductoRepositoryImpl implements ProductoRepository {
  final ApiService _api;

  const ProductoRepositoryImpl(this._api);

  @override
  Future<List<Producto>> listarProductos() async {
    final datos = await _api.get(AppConstants.productosEndpoint);
    return _convertirLista(datos);
  }

  @override
  Future<List<Producto>> buscarProductos(String query) async {
    final url =
        '${AppConstants.buscarEndpoint}?q=${Uri.encodeComponent(query)}';
    final datos = await _api.get(url);
    return _convertirLista(datos);
  }

  @override
  Future<int> crearProducto(ProductoInput datos) async {
    final respuesta = await _api.post(
      AppConstants.productosEndpoint,
      _cuerpo(datos, incluirCodigo: true),
    );
    if (respuesta is Map<String, dynamic> && respuesta['id'] is int) {
      return respuesta['id'] as int;
    }
    return 0;
  }

  @override
  Future<void> actualizarProducto(int id, ProductoInput datos) async {
    await _api.put('${AppConstants.productosEndpoint}/$id', _cuerpo(datos));
  }

  @override
  Future<void> eliminarProducto(int id) async {
    await _api.delete('${AppConstants.productosEndpoint}/$id');
  }

  List<Producto> _convertirLista(dynamic datos) {
    if (datos is! List) {
      return const [];
    }
    return datos
        .whereType<Map<String, dynamic>>()
        .map(ProductoModel.fromJson)
        .toList();
  }

  Map<String, dynamic> _cuerpo(
    ProductoInput datos, {
    bool incluirCodigo = false,
  }) {
    return {
      if (incluirCodigo) 'codigo': datos.codigo,
      'nombre': datos.nombre,
      'categoria': datos.categoria,
      'precio': datos.precio,
      'stock': datos.stock,
      'descripcion': datos.descripcion,
    };
  }
}
