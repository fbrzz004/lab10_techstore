import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme.dart';
import 'data/datasources/api_service.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/repositories/producto_repository_impl.dart';
import 'domain/repositories/auth_repository.dart';
import 'domain/repositories/producto_repository.dart';
import 'domain/usecases/actualizar_producto_usecase.dart';
import 'domain/usecases/buscar_productos_usecase.dart';
import 'domain/usecases/crear_producto_usecase.dart';
import 'domain/usecases/eliminar_producto_usecase.dart';
import 'domain/usecases/listar_productos_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'presentation/pages/login_page.dart';
import 'presentation/viewmodels/login_viewmodel.dart';
import 'presentation/viewmodels/producto_viewmodel.dart';

void main() {
  runApp(const TechStoreApp());
}

class TechStoreApp extends StatelessWidget {
  const TechStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService api = ApiService();
    final AuthRepository authRepository = AuthRepositoryImpl(api);
    final ProductoRepository productoRepository = ProductoRepositoryImpl(api);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginViewModel(LoginUseCase(authRepository)),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductoViewModel(
            listar: ListarProductosUseCase(productoRepository),
            buscar: BuscarProductosUseCase(productoRepository),
            crear: CrearProductoUseCase(productoRepository),
            actualizar: ActualizarProductoUseCase(productoRepository),
            eliminar: EliminarProductoUseCase(productoRepository),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'TechStore S.A.C.',
        debugShowCheckedModeBanner: false,
        theme: construirTema(),
        home: const LoginPage(),
      ),
    );
  }
}
