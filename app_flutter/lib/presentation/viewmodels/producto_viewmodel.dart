import 'package:flutter/foundation.dart';

import '../../core/errors.dart';
import '../../domain/entities/producto_input.dart';
import '../../domain/usecases/actualizar_producto_usecase.dart';
import '../../domain/usecases/buscar_productos_usecase.dart';
import '../../domain/usecases/crear_producto_usecase.dart';
import '../../domain/usecases/eliminar_producto_usecase.dart';
import '../../domain/usecases/listar_productos_usecase.dart';
import 'producto_state.dart';

class ProductoViewModel extends ChangeNotifier {
  final ListarProductosUseCase _listar;
  final BuscarProductosUseCase _buscar;
  final CrearProductoUseCase _crear;
  final ActualizarProductoUseCase _actualizar;
  final EliminarProductoUseCase _eliminar;

  ProductoState _state = const ProductoState();

  ProductoViewModel({
    required ListarProductosUseCase listar,
    required BuscarProductosUseCase buscar,
    required CrearProductoUseCase crear,
    required ActualizarProductoUseCase actualizar,
    required EliminarProductoUseCase eliminar,
  }) : _listar = listar,
       _buscar = buscar,
       _crear = crear,
       _actualizar = actualizar,
       _eliminar = eliminar;

  ProductoState get state => _state;

  Future<void> cargarProductos() async {
    _state = _state.copyWith(status: ProductoStatus.loading, errorMessage: '');
    notifyListeners();

    try {
      final lista = await _listar();
      _state = _state.copyWith(
        productos: lista,
        resultados: lista,
        status: ProductoStatus.success,
      );
    } on ApiException catch (error) {
      _state = _state.copyWith(
        status: ProductoStatus.error,
        errorMessage: error.message,
      );
    } catch (_) {
      _state = _state.copyWith(
        status: ProductoStatus.error,
        errorMessage: 'No se pudo cargar el catálogo.',
      );
    }
    notifyListeners();
  }

  Future<void> buscarProductos(String query) async {
    final termino = query.trim();
    if (termino.isEmpty) {
      limpiarBusqueda();
      return;
    }

    _state = _state.copyWith(
      query: termino,
      status: ProductoStatus.loading,
      errorMessage: '',
    );
    notifyListeners();

    try {
      final lista = await _buscar(termino);
      if (_state.query != termino) {
        return;
      }
      _state = _state.copyWith(
        resultados: lista,
        status: ProductoStatus.success,
      );
    } on ApiException catch (error) {
      _state = _state.copyWith(
        status: ProductoStatus.error,
        errorMessage: error.message,
      );
    } catch (_) {
      _state = _state.copyWith(
        status: ProductoStatus.error,
        errorMessage: 'No se pudo realizar la búsqueda.',
      );
    }
    notifyListeners();
  }

  void limpiarBusqueda() {
    _state = _state.copyWith(
      query: '',
      resultados: const [],
      status: ProductoStatus.idle,
      errorMessage: '',
    );
    notifyListeners();
  }

  Future<String?> guardar({int? id, required ProductoInput datos}) async {
    try {
      if (id == null) {
        await _crear(datos);
      } else {
        await _actualizar(id, datos);
      }
      return null;
    } on ApiException catch (error) {
      return error.message;
    } catch (_) {
      return 'No se pudo guardar el producto.';
    }
  }

  Future<String?> eliminar(int id) async {
    try {
      await _eliminar(id);
      return null;
    } on ApiException catch (error) {
      return error.message;
    } catch (_) {
      return 'No se pudo eliminar el producto.';
    }
  }
}
