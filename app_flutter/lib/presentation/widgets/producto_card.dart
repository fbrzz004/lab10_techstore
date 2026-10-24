import 'package:flutter/material.dart';

import '../../domain/entities/producto.dart';

class ProductoCard extends StatelessWidget {
  final Producto producto;
  final Widget? acciones;

  const ProductoCard({super.key, required this.producto, this.acciones});

  @override
  Widget build(BuildContext context) {
    final inicial = producto.nombre.trim().isEmpty
        ? '?'
        : producto.nombre.trim().substring(0, 1).toUpperCase();

    final Color colorStock;
    if (producto.stock == 0) {
      colorStock = const Color(0xFFB3261E);
    } else if (producto.stock <= 5) {
      colorStock = const Color(0xFFB26A00);
    } else {
      colorStock = const Color(0xFF2E6B3A);
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 6, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: const Color(0xFFE7E9F7),
              foregroundColor: const Color(0xFF303F9F),
              child: Text(
                inicial,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${producto.codigo} · ${producto.categoria}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF5F6474),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'S/ ${producto.precio.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF303F9F),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorStock.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Stock: ${producto.stock}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: colorStock,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ?acciones,
          ],
        ),
      ),
    );
  }
}
