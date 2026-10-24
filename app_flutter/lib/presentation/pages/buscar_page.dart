import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/producto_state.dart';
import '../viewmodels/producto_viewmodel.dart';
import '../widgets/estado_vista.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/producto_card.dart';

class BuscarPage extends StatefulWidget {
  const BuscarPage({super.key});

  @override
  State<BuscarPage> createState() => _BuscarPageState();
}

class _BuscarPageState extends State<BuscarPage> {
  final _controlador = TextEditingController();
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<ProductoViewModel>().limpiarBusqueda();
      }
    });
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    _controlador.dispose();
    super.dispose();
  }

  void _alCambiar(String valor) {
    _temporizador?.cancel();
    if (valor.trim().isEmpty) {
      context.read<ProductoViewModel>().limpiarBusqueda();
      return;
    }
    _temporizador = Timer(const Duration(milliseconds: 350), () {
      if (mounted) {
        context.read<ProductoViewModel>().buscarProductos(valor);
      }
    });
  }

  void _limpiar() {
    _temporizador?.cancel();
    _controlador.clear();
    context.read<ProductoViewModel>().limpiarBusqueda();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProductoViewModel>();
    final estado = vm.state;

    return Scaffold(
      appBar: AppBar(title: const Text('Buscador de productos')),
      drawer: const NavDrawer(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
            child: TextField(
              controller: _controlador,
              autofocus: false,
              onChanged: _alCambiar,
              decoration: InputDecoration(
                hintText: 'Código, nombre o categoría',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controlador.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar',
                        onPressed: _limpiar,
                        icon: const Icon(Icons.close),
                      ),
              ),
            ),
          ),
          Expanded(
            child: switch (estado.status) {
              ProductoStatus.idle => const EstadoVista(
                icono: Icons.search,
                titulo: 'Buscar productos',
                mensaje: 'Ingrese un código, nombre o categoría.',
              ),
              ProductoStatus.loading => const Center(
                child: CircularProgressIndicator(),
              ),
              ProductoStatus.error => EstadoVista(
                icono: Icons.cloud_off,
                titulo: 'Error en la búsqueda',
                mensaje: estado.errorMessage,
                alReintentar: () => vm.buscarProductos(estado.query),
              ),
              ProductoStatus.success when estado.resultados.isEmpty =>
                const EstadoVista(
                  icono: Icons.search_off,
                  titulo: 'Sin resultados',
                  mensaje:
                      'No se encontraron productos para el término ingresado.',
                ),
              ProductoStatus.success => ListView.separated(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 24),
                itemCount: estado.resultados.length + 1,
                separatorBuilder: (_, _) => const SizedBox(height: 2),
                itemBuilder: (contexto, indice) {
                  if (indice == 0) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text(
                        '${estado.resultados.length} ${estado.resultados.length == 1 ? 'resultado' : 'resultados'}',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF5F6474),
                        ),
                      ),
                    );
                  }
                  return ProductoCard(producto: estado.resultados[indice - 1]);
                },
              ),
            },
          ),
        ],
      ),
    );
  }
}
