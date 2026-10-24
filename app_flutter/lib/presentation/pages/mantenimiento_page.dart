import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/producto.dart';
import '../viewmodels/producto_state.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../widgets/estado_vista.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/producto_card.dart';
import 'producto_form_page.dart';

class MantenimientoPage extends StatefulWidget {
  const MantenimientoPage({super.key});

  @override
  State<MantenimientoPage> createState() => _MantenimientoPageState();
}

class _MantenimientoPageState extends State<MantenimientoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductoViewModel>().cargarProductos();
      }
    });
  }

  Future<void> _recargar() {
    return context.read<ProductoViewModel>().cargarProductos();
  }

  void _mostrarMensaje(String mensaje, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: error ? null : const Color(0xFF2E6B3A),
      ),
    );
  }

  Future<void> _abrirFormulario([Producto? producto]) async {
    final guardado = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => ProductoFormPage(producto: producto)),
    );
    if (!mounted || guardado != true) {
      return;
    }
    _mostrarMensaje(
      producto == null ? 'Producto registrado.' : 'Producto actualizado.',
    );
    await _recargar();
  }

  Future<void> _confirmarEliminacion(Producto producto) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (contexto) => AlertDialog(
        title: const Text('Eliminar producto'),
        content: Text(
          '¿Desea eliminar ${producto.nombre} (${producto.codigo})?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(contexto).pop(false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(contexto).pop(true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) {
      return;
    }

    final error = await context.read<ProductoViewModel>().eliminar(producto.id);
    if (!mounted) {
      return;
    }
    if (error != null) {
      _mostrarMensaje(error, error: true);
      return;
    }
    _mostrarMensaje('Producto eliminado.');
    await _recargar();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductoViewModel>();
    final estado = vm.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mantenimiento de productos'),
        actions: [
          IconButton(
            tooltip: 'Actualizar lista',
            onPressed: _recargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const NavDrawer(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _abrirFormulario(),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo producto'),
      ),
      body: switch (estado.status) {
        ProductoStatus.loading when estado.productos.isEmpty => const Center(
          child: CircularProgressIndicator(),
        ),
        ProductoStatus.error when estado.productos.isEmpty => EstadoVista(
          icono: Icons.cloud_off,
          titulo: 'No se pudo cargar la lista',
          mensaje: estado.errorMessage,
          alReintentar: _recargar,
        ),
        _ when estado.productos.isEmpty => EstadoVista(
          icono: Icons.inventory_2_outlined,
          titulo: 'Sin productos',
          mensaje: 'Registre el primer producto con el botón Nuevo producto.',
          alReintentar: _recargar,
        ),
        _ => ListView.separated(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 90),
          itemCount: estado.productos.length,
          separatorBuilder: (_, _) => const SizedBox(height: 2),
          itemBuilder: (contexto, indice) {
            final producto = estado.productos[indice];
            return ProductoCard(
              producto: producto,
              acciones: PopupMenuButton<String>(
                tooltip: 'Acciones',
                onSelected: (accion) {
                  if (accion == 'editar') {
                    _abrirFormulario(producto);
                  } else {
                    _confirmarEliminacion(producto);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'editar', child: Text('Editar')),
                  PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
                ],
              ),
            );
          },
        ),
      },
    );
  }
}
