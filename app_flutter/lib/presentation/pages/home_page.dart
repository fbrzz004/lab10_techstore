import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../viewmodels/login_viewmodel.dart';
import '../widgets/nav_drawer.dart';
import 'buscar_page.dart';
import 'catalogo_page.dart';
import 'institucional_page.dart';
import 'mantenimiento_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<LoginViewModel>().state.usuario;
    final ancho = MediaQuery.sizeOf(context).width;
    final columnas = ancho >= 760 ? 4 : 2;

    return Scaffold(
      appBar: AppBar(title: const Text('TechStore · Inicio')),
      drawer: const NavDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: const Color(0xFF303F9F),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.store,
                      size: 30,
                      color: Color(0xFF303F9F),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          usuario == null
                              ? 'Bienvenido'
                              : 'Bienvenido, ${usuario.nombre}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'Seleccione una opción del menú.',
                          style: TextStyle(
                            color: Colors.indigo.shade100,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Accesos',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          GridView.count(
            crossAxisCount: columnas,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.05,
            children: [
              _Acceso(
                icono: Icons.business_outlined,
                titulo: 'Institucional',
                detalle: 'Misión, visión y contacto',
                alTocar: () => _abrir(context, const InstitucionalPage()),
              ),
              _Acceso(
                icono: Icons.inventory_2_outlined,
                titulo: 'Catálogo',
                detalle: 'Productos y existencias',
                alTocar: () => _abrir(context, const CatalogoPage()),
              ),
              _Acceso(
                icono: Icons.search_outlined,
                titulo: 'Buscador',
                detalle: 'Código, nombre o categoría',
                alTocar: () => _abrir(context, const BuscarPage()),
              ),
              _Acceso(
                icono: Icons.settings_suggest_outlined,
                titulo: 'Mantenimiento',
                detalle: 'Registro, edición y baja',
                alTocar: () => _abrir(context, const MantenimientoPage()),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _abrir(BuildContext context, Widget pagina) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => pagina));
  }
}

class _Acceso extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String detalle;
  final VoidCallback alTocar;

  const _Acceso({
    required this.icono,
    required this.titulo,
    required this.detalle,
    required this.alTocar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: alTocar,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFE7E9F7),
                child: Icon(icono, size: 22, color: const Color(0xFF303F9F)),
              ),
              const Spacer(),
              Text(
                titulo,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                detalle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11, color: Color(0xFF5F6474)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
