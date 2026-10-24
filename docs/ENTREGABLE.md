Backend: https://techstore-api-xb0d.onrender.com  
Aplicación web: https://techstore-lab10-fbrzz004.netlify.app  
Repositorio: https://github.com/fbrzz004/lab10_techstore

Curso: Taller de construcción de software móvil  
Profesor: Dr. Ivan Petrlik Azabache  
Estudiante: André Fabrizzio Román Suyo  
Código: 22200098

## Implementación

- Backend (backend_techstore): Flask 3.1.3, Flask-CORS 6.0.5 y SQLite 3.
- Backend con MVC: modelos de datos, vistas JSON y controladores de rutas.
- Aplicación (app_flutter): Flutter 3.38.8, Dart 3.10.7, Provider 6.1.2 y http 1.2.1.
- Aplicación con arquitectura limpia: capas de dominio, datos y presentación.
- Patrón MVVM: modelos de vista con notificadores de cambios.
- Contraseñas: valor hash calculado con Werkzeug.

![Estructura de carpetas del backend](evidencias/14_estructura_backend.png){width=13cm}

![Estructura de carpetas de lib en Flutter](evidencias/15_estructura_flutter.png){width=13cm}

## Base de datos

| Tabla | Campos |
| --- | --- |
| usuario | id, username, password, nombre, activo |
| producto | id, codigo, nombre, categoria, precio, stock, descripcion |

Datos iniciales: 2 usuarios y 8 productos. La base de datos incluye el producto PROD-009 de la prueba de registro.

![Tablas usuario y producto](evidencias/16_base_datos.png){width=15.5cm}

## Pruebas de endpoints

- POST /api/login: credenciales válidas, 200.
- POST /api/login: contraseña incorrecta, 401.
- POST /api/login: datos incompletos, 400.
- GET /api/productos: lista de productos, 200.
- GET /api/productos/buscar?q=laptop: coincidencia por nombre, 200.
- GET /api/productos/buscar?q=xyz123: sin coincidencias, 200.
- POST /api/productos: registro de producto, 201.
- POST /api/productos: código duplicado, 409.
- PUT /api/productos/{id}: edición de producto, 200.
- DELETE /api/productos/{id}: baja de producto, 200.
- GET /health: estado del servicio, 200.

Pruebas con pytest: 15 aprobadas de 15.

![Salida de pytest](evidencias/17_pytest.png){width=15.5cm}

![Pruebas de endpoints con curl](evidencias/18_pruebas_endpoints.png){width=15.5cm}

## Aplicación

![Inicio de sesión](evidencias/01_login.png){width=6.2cm}

![Inicio con el usuario administrador](evidencias/02_inicio.png){width=6.2cm}

![Menú lateral](evidencias/03_menu_lateral.png){width=6.2cm}

![Información institucional](evidencias/04_institucional.png){width=6.2cm}

![Catálogo con productos del backend](evidencias/05_catalogo.png){width=6.2cm}

![Búsqueda del término laptop](evidencias/06_busqueda.png){width=6.2cm}

![Búsqueda del término xyz123](evidencias/07_busqueda_sin_resultados.png){width=6.2cm}

![Lista de mantenimiento](evidencias/08_mantenimiento.png){width=6.2cm}

![Formulario con los datos de PROD-009](evidencias/09_formulario_producto.png){width=6.2cm}

![Mensaje de producto registrado](evidencias/10_producto_registrado.png){width=6.2cm}

![Producto PROD-009 en la lista](evidencias/11_producto_en_lista.png){width=6.2cm}

![Alerta por contraseña incorrecta](evidencias/12_error_credenciales.png){width=6.2cm}

![Alerta con el backend apagado](evidencias/13_error_conexion.png){width=6.2cm}

## Capturas del despliegue

![Ruta /health del backend desplegado](evidencias/19_health.png){width=15.5cm}

![Aplicación web desplegada](evidencias/21_app_web.png){width=6.2cm}

![Catálogo desde la aplicación web desplegada](evidencias/22_app_web_catalogo.png){width=6.2cm}
