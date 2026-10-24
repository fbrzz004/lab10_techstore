import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/producto.dart';
import '../../domain/entities/producto_input.dart';
import '../viewmodels/producto_viewmodel.dart';

class ProductoFormPage extends StatefulWidget {
  final Producto? producto;

  const ProductoFormPage({super.key, this.producto});

  @override
  State<ProductoFormPage> createState() => _ProductoFormPageState();
}

class _ProductoFormPageState extends State<ProductoFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codigoCtrl;
  late final TextEditingController _nombreCtrl;
  late final TextEditingController _categoriaCtrl;
  late final TextEditingController _precioCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _descripcionCtrl;
  bool _guardando = false;

  bool get _esNuevo => widget.producto == null;

  @override
  void initState() {
    super.initState();
    final producto = widget.producto;
    _codigoCtrl = TextEditingController(text: producto?.codigo ?? '');
    _nombreCtrl = TextEditingController(text: producto?.nombre ?? '');
    _categoriaCtrl = TextEditingController(text: producto?.categoria ?? '');
    _precioCtrl = TextEditingController(
      text: producto == null ? '' : producto.precio.toStringAsFixed(2),
    );
    _stockCtrl = TextEditingController(text: producto?.stock.toString() ?? '0');
    _descripcionCtrl = TextEditingController(text: producto?.descripcion ?? '');
  }

  @override
  void dispose() {
    _codigoCtrl.dispose();
    _nombreCtrl.dispose();
    _categoriaCtrl.dispose();
    _precioCtrl.dispose();
    _stockCtrl.dispose();
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _guardar() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _guardando = true);
    final datos = ProductoInput(
      codigo: _codigoCtrl.text.trim(),
      nombre: _nombreCtrl.text.trim(),
      categoria: _categoriaCtrl.text.trim(),
      precio: double.parse(_precioCtrl.text.replaceAll(',', '.').trim()),
      stock: int.parse(_stockCtrl.text.trim()),
      descripcion: _descripcionCtrl.text.trim(),
    );

    final error = await context.read<ProductoViewModel>().guardar(
      id: widget.producto?.id,
      datos: datos,
    );

    if (!mounted) {
      return;
    }
    setState(() => _guardando = false);

    if (error != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    Navigator.of(context).pop(true);
  }

  String? _validarCodigo(String? valor) {
    if (_esNuevo && (valor == null || valor.trim().isEmpty)) {
      return 'Ingrese el código.';
    }
    return null;
  }

  String? _validarTexto(String? valor) {
    if (valor == null || valor.trim().isEmpty) {
      return 'Campo obligatorio.';
    }
    return null;
  }

  String? _validarPrecio(String? valor) {
    final numero = double.tryParse((valor ?? '').replaceAll(',', '.').trim());
    if (numero == null || numero <= 0) {
      return 'Ingrese un precio mayor que cero.';
    }
    return null;
  }

  String? _validarStock(String? valor) {
    final numero = int.tryParse((valor ?? '').trim());
    if (numero == null || numero < 0) {
      return 'Ingrese un stock entero mayor o igual que cero.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_esNuevo ? 'Nuevo producto' : 'Editar producto'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _codigoCtrl,
                    enabled: _esNuevo,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      labelText: 'Código',
                      hintText: 'PROD-009',
                      prefixIcon: Icon(Icons.qr_code_2),
                    ),
                    validator: _validarCodigo,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _nombreCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    validator: _validarTexto,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _categoriaCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Categoría',
                      hintText: 'Periféricos',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    validator: _validarTexto,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _precioCtrl,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Precio (S/)',
                            prefixIcon: Icon(Icons.payments_outlined),
                          ),
                          validator: _validarPrecio,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          controller: _stockCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Stock',
                            prefixIcon: Icon(Icons.numbers),
                          ),
                          validator: _validarStock,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descripcionCtrl,
                    maxLines: 3,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Descripción',
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(height: 22),
                  FilledButton.icon(
                    onPressed: _guardando ? null : _guardar,
                    icon: _guardando
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(_guardando ? 'Guardando...' : 'Guardar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
