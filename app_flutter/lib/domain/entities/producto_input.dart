class ProductoInput {
  final String codigo;
  final String nombre;
  final String categoria;
  final double precio;
  final int stock;
  final String descripcion;

  const ProductoInput({
    this.codigo = '',
    required this.nombre,
    required this.categoria,
    required this.precio,
    this.stock = 0,
    this.descripcion = '',
  });
}
