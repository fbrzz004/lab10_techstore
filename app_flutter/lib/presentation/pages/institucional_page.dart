import 'package:flutter/material.dart';

import '../widgets/nav_drawer.dart';

class InstitucionalPage extends StatelessWidget {
  const InstitucionalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información institucional')),
      drawer: const NavDrawer(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor: Color(0xFF303F9F),
            child: Icon(Icons.store, size: 38, color: Colors.white),
          ),
          const SizedBox(height: 10),
          const Center(
            child: Text(
              'TechStore S.A.C.',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Color(0xFF303F9F),
              ),
            ),
          ),
          const Center(
            child: Text(
              'Comercio de productos tecnológicos',
              style: TextStyle(fontSize: 13, color: Color(0xFF5F6474)),
            ),
          ),
          const SizedBox(height: 14),
          const _Seccion(
            titulo: 'Datos generales',
            contenido:
                'Razón social: TechStore S.A.C.\n'
                'Fundación: 2018\n'
                'Sede: Lima, Perú\n'
                'Actividad: venta y distribución de productos tecnológicos',
          ),
          const _Seccion(
            titulo: 'Descripción',
            contenido:
                'TechStore S.A.C. es una empresa peruana dedicada a la venta y distribución '
                'de productos tecnológicos. Atiende a clientes de Lima mediante una tienda '
                'física y una aplicación móvil de consulta.',
          ),
          const _Seccion(
            titulo: 'Misión',
            contenido:
                'Proveer soluciones tecnológicas con una experiencia de compra digital '
                'confiable para los clientes de TechStore S.A.C.',
          ),
          const _Seccion(
            titulo: 'Visión',
            contenido:
                'Liderar el comercio tecnológico en Perú hacia el año 2030.',
          ),
          const _Seccion(
            titulo: 'Línea de productos',
            contenido:
                'Laptops y computadoras\n'
                'Smartphones y tablets\n'
                'Periféricos y accesorios\n'
                'Monitores y almacenamiento\n'
                'Audio y video',
          ),
          const _Seccion(
            titulo: 'Contacto',
            contenido:
                'Dirección: Av. Universitaria 1801, Lima, Perú\n'
                'Teléfono: +51 990 123 456\n'
                'Correo: ventas@techstore.com.pe',
          ),
        ],
      ),
    );
  }
}

class _Seccion extends StatelessWidget {
  final String titulo;
  final String contenido;

  const _Seccion({required this.titulo, required this.contenido});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF303F9F),
              ),
            ),
            const SizedBox(height: 6),
            Text(contenido, style: const TextStyle(fontSize: 13, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
