import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/producto_state.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../widgets/estado_vista.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/producto_card.dart';

class CatalogoPage extends StatefulWidget {
  const CatalogoPage({super.key});

  @override
  State<CatalogoPage> createState() => _CatalogoPageState();
}

class _CatalogoPageState extends State<CatalogoPage> {
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

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductoViewModel>();
    final estado = vm.state;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de productos'),
        actions: [
          IconButton(
            tooltip: 'Actualizar catálogo',
            onPressed: _recargar,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      drawer: const NavDrawer(),
      body: switch (estado.status) {
        ProductoStatus.loading when estado.productos.isEmpty => const Center(
          child: CircularProgressIndicator(),
        ),
        ProductoStatus.error when estado.productos.isEmpty => EstadoVista(
          icono: Icons.cloud_off,
          titulo: 'No se pudo cargar el catálogo',
          mensaje: estado.errorMessage,
          alReintentar: _recargar,
        ),
        _ when estado.productos.isEmpty => EstadoVista(
          icono: Icons.inventory_2_outlined,
          titulo: 'Catálogo vacío',
          mensaje: 'No hay productos registrados en el backend.',
          alReintentar: _recargar,
        ),
        _ => RefreshIndicator(
          onRefresh: _recargar,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 24),
            itemCount: estado.productos.length + 1,
            separatorBuilder: (_, _) => const SizedBox(height: 2),
            itemBuilder: (contexto, indice) {
              if (indice == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '${estado.productos.length} ${estado.productos.length == 1 ? 'producto registrado' : 'productos registrados'}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF5F6474),
                    ),
                  ),
                );
              }
              return ProductoCard(producto: estado.productos[indice - 1]);
            },
          ),
        ),
      },
    );
  }
}
