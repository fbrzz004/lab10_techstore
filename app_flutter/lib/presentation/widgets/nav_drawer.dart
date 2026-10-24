import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/buscar_page.dart';
import '../pages/catalogo_page.dart';
import '../pages/home_page.dart';
import '../pages/institucional_page.dart';
import '../pages/login_page.dart';
import '../pages/mantenimiento_page.dart';
import '../viewmodels/login_viewmodel.dart';

class NavDrawer extends StatelessWidget {
  const NavDrawer({super.key});

  void _ir(BuildContext context, Widget pagina, {bool reemplazar = false}) {
    final navegador = Navigator.of(context);
    navegador.pop();
    final ruta = MaterialPageRoute<void>(builder: (_) => pagina);
    if (reemplazar) {
      navegador.pushReplacement(ruta);
    } else {
      navegador.push(ruta);
    }
  }

  void _cerrarSesion(BuildContext context) {
    context.read<LoginViewModel>().reset();
    final navegador = Navigator.of(context);
    navegador.pop();
    navegador.pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF303F9F), Color(0xFF5C6BC0)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.store, size: 30, color: Color(0xFF303F9F)),
                ),
                const SizedBox(height: 10),
                const Text(
                  'TechStore S.A.C.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  'Sistema de gestión',
                  style: TextStyle(color: Colors.indigo.shade100, fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home_outlined),
            title: const Text('Inicio'),
            onTap: () => _ir(context, const HomePage(), reemplazar: true),
          ),
          ListTile(
            leading: const Icon(Icons.business_outlined),
            title: const Text('Información institucional'),
            onTap: () => _ir(context, const InstitucionalPage()),
          ),
          ListTile(
            leading: const Icon(Icons.inventory_2_outlined),
            title: const Text('Catálogo de productos'),
            onTap: () => _ir(context, const CatalogoPage()),
          ),
          ListTile(
            leading: const Icon(Icons.search_outlined),
            title: const Text('Buscador de productos'),
            onTap: () => _ir(context, const BuscarPage()),
          ),
          ListTile(
            leading: const Icon(Icons.settings_suggest_outlined),
            title: const Text('Mantenimiento'),
            onTap: () => _ir(context, const MantenimientoPage()),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFB3261E)),
            title: const Text(
              'Cerrar sesión',
              style: TextStyle(color: Color(0xFFB3261E)),
            ),
            onTap: () => _cerrarSesion(context),
          ),
        ],
      ),
    );
  }
}
