# Guía para obtener las capturas

## 1. Requisitos

- Flutter 3.38 o superior.
- Python 3.10 o superior.
- Android Studio con un emulador, o un dispositivo Android con depuración USB.
- Postman.
- DB Browser for SQLite.
- Navegador Chrome.

Las capturas de `docs/evidencias` se obtuvieron de esta implementación con un ancho de 390 píxeles. Puede usarlas o repetir los pasos.

## 2. Backend en ejecución

```bash
cd lab10_techstore/backend_techstore
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
python app.py
```

Verifique la dirección `http://127.0.0.1:5000/health` en el navegador. La respuesta debe ser `{"ok": true, "estado": "operativo"}`.

En Windows, la activación del entorno es `venv\Scripts\activate`.

## 3. Estructura de carpetas

En una terminal:

```bash
cd lab10_techstore
tree -L 3 backend_techstore -I '.venv|__pycache__|database.db'
tree -L 4 app_flutter/lib
```

Si no tiene `tree`, use el explorador de archivos de VS Code y despliegue las carpetas.

Capture la terminal con los dos árboles. Nómbrela `14_estructura_backend.png` y `15_estructura_flutter.png`.

## 4. Base de datos

1. Abra DB Browser for SQLite.
2. Pulse *Open Database* y seleccione `backend_techstore/database.db`.
3. Pulse la pestaña *Browse Data*.
4. Seleccione la tabla `usuario` y capture la pantalla.
5. Seleccione la tabla `producto` y capture la pantalla.

Alternativa con terminal:

```bash
cd backend_techstore
sqlite3 -header -column database.db "SELECT id, username, nombre, activo FROM usuario;"
sqlite3 -header -column database.db "SELECT id, codigo, nombre, categoria, precio, stock FROM producto;"
```

Guarde la captura como `16_base_datos.png`.

## 5. Pruebas de los endpoints con Postman

1. Abra Postman.
2. Pulse *Import* y seleccione `docs/TechStore.postman_collection.json`.
3. Abra la colección *TechStore API*.
4. En *Variables*, confirme `base_url` con el valor `http://127.0.0.1:5000`.
5. Pulse *Run collection*.
6. Confirme que las 9 solicitudes tienen código 2xx y las pruebas en verde.
7. Capture la ventana del *Collection Runner*.

Guarde la captura como `18_postman.png`.

La solicitud *Crear producto* guarda el identificador en la variable `producto_id`. Las solicitudes *Actualizar producto* y *Eliminar producto* usan esa variable. Ejecute la colección en orden. Si *Crear producto* devuelve 409, elimine el producto `PROD-999` y repita la ejecución.

La captura incluida `18_pruebas_endpoints.png` muestra la misma prueba con curl. Puede usar esa imagen o capturar Postman y guardarla como `18_postman.png`.

## 6. Pruebas automatizadas

```bash
cd backend_techstore
.venv/bin/python -m pytest -q
```

La salida debe indicar `15 passed`.

Guarde la captura como `17_pytest.png`.

## 7. Aplicación en ejecución

### 7.1. Emulador de Android

1. Abra Android Studio.
2. Inicie un emulador con Android 8.0 o superior.
3. Ejecute:

```bash
cd app_flutter
flutter pub get
flutter run
```

La aplicación usa `http://10.0.2.2:5000`, que corresponde a `127.0.0.1` de la computadora.

### 7.2. Dispositivo Android

1. Active *Opciones de desarrollador* y *Depuración USB*.
2. Conecte el dispositivo y confirme la autorización.
3. Ejecute:

```bash
adb devices
adb reverse tcp:5000 tcp:5000
cd app_flutter
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
```

### 7.3. Navegador

```bash
cd app_flutter
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:5000
```

Pulse F12, active el modo dispositivo y seleccione 390 × 844 píxeles.

### 7.4. Captura desde el dispositivo

```bash
adb exec-out screencap -p > docs/evidencias/01_login.png
```

En el emulador puede usar el botón de cámara. En Linux puede usar Flameshot o la herramienta de captura del escritorio. En Windows use el símbolo del sistema, no PowerShell, para conservar el formato PNG.

## 8. Capturas de la aplicación

### 8.1. Inicio de sesión

1. Abra la aplicación.
2. Espere la pantalla *Iniciar sesión*.
3. Capture la pantalla.

Archivo: `01_login.png`.

### 8.2. Inicio

1. Escriba `admin` en *Usuario*.
2. Escriba `admin123` en *Contraseña*.
3. Pulse *Ingresar*.
4. Espere el texto *Bienvenido, Administrador TechStore*.
5. Capture la pantalla.

Archivo: `02_inicio.png`.

### 8.3. Menú lateral

1. Pulse el icono de menú, en la esquina superior izquierda.
2. Capture la pantalla con las opciones Inicio, Información institucional, Catálogo de productos, Buscador de productos, Mantenimiento y Cerrar sesión.

Archivo: `03_menu_lateral.png`.

### 8.4. Información institucional

1. Abra el menú lateral.
2. Pulse *Información institucional*.
3. Capture la pantalla con los datos de la empresa.

Archivo: `04_institucional.png`.

### 8.5. Catálogo

1. Abra el menú lateral.
2. Pulse *Catálogo de productos*.
3. Espere la lista con los productos y el texto *productos registrados*.
4. Capture la pantalla.

Archivo: `05_catalogo.png`.

### 8.6. Búsqueda con resultados

1. Abra el menú lateral.
2. Pulse *Inicio*.
3. Pulse la tarjeta *Buscador*.
4. Escriba `laptop`.
5. Espere el resultado *Laptop HP Pavilion 15*.
6. Capture la pantalla.

Archivo: `06_busqueda.png`.

### 8.7. Búsqueda sin resultados

1. En el buscador, pulse el icono de la equis.
2. Escriba `xyz123`.
3. Espere el texto *Sin resultados*.
4. Capture la pantalla.

Archivo: `07_busqueda_sin_resultados.png`.

### 8.8. Mantenimiento

1. Abra el menú lateral.
2. Pulse *Inicio*.
3. Pulse la tarjeta *Mantenimiento*.
4. Espere la lista con el icono de tres puntos en cada producto.
5. Capture la pantalla.

Archivo: `08_mantenimiento.png`.

### 8.9. Registro de producto

1. Pulse *Nuevo producto*.
2. Complete los campos con estos datos:
   - Código: `PROD-009`
   - Nombre: `Webcam Logitech C920`
   - Categoría: `Periféricos`
   - Precio: `249.90`
   - Stock: `6`
   - Descripción: `Cámara Full HD 1080p con micrófono`
3. Capture la pantalla antes de guardar.

Archivo: `09_formulario_producto.png`.

### 8.10. Producto registrado

1. Pulse *Guardar*.
2. Espere el mensaje *Producto registrado*.
3. Capture la pantalla.
4. Desplace la lista hasta el final y capture la fila *Webcam Logitech C920*.

Archivos: `10_producto_registrado.png` y `11_producto_en_lista.png`.

### 8.11. Error de credenciales

1. Abra el menú lateral.
2. Pulse *Cerrar sesión*.
3. Escriba `admin` y `0000`.
4. Pulse *Ingresar*.
5. Capture la pantalla mientras aparece el mensaje rojo *Credenciales incorrectas*.

Archivo: `12_error_credenciales.png`.

### 8.12. Error de conexión

1. Detenga el backend con Ctrl + C.
2. En la pantalla de inicio de sesión, borre la contraseña anterior, escriba `admin` y `admin123`.
3. Pulse *Ingresar*.
4. Capture la pantalla mientras aparece el mensaje *No se pudo conectar con el servidor*.
5. Reinicie el backend con `python app.py`.

Archivo: `13_error_conexion.png`.

## 9. Capturas del despliegue

Siga `docs/DESPLIEGUE.md`.

1. Abra `https://[servicio].onrender.com/health` y capture la respuesta JSON. Archivo: `19_health.png`.
2. Capture el panel de Render con el servicio en estado *Live*. Archivo: `20_render.png`.
3. Abra la aplicación web desplegada, inicie sesión y capture la pantalla. Archivo: `21_app_web.png`.

## 10. Inserción de las capturas en el entregable

Abra `docs/ENTREGABLE.md`. Cada marcador `[[screenshot de ...]]` se reemplaza por la imagen correspondiente.

En Markdown:

```markdown
![Inicio de sesión](evidencias/01_login.png)
```

En Word o PDF: borre el marcador y pegue la imagen en ese lugar.

| Marcador | Archivo |
| --- | --- |
| Árbol de carpetas del backend | `14_estructura_backend.png` |
| Árbol de carpetas de lib en Flutter | `15_estructura_flutter.png` |
| Tablas en DB Browser for SQLite | `16_base_datos.png` |
| Salida de pytest | `17_pytest.png` |
| Postman con las pruebas | `18_pruebas_endpoints.png` o `18_postman.png` |
| Inicio de sesión | `01_login.png` |
| Inicio | `02_inicio.png` |
| Menú lateral | `03_menu_lateral.png` |
| Información institucional | `04_institucional.png` |
| Catálogo | `05_catalogo.png` |
| Búsqueda de laptop | `06_busqueda.png` |
| Búsqueda sin resultados | `07_busqueda_sin_resultados.png` |
| Mantenimiento | `08_mantenimiento.png` |
| Formulario de producto | `09_formulario_producto.png` |
| Producto registrado | `10_producto_registrado.png` |
| Producto en la lista | `11_producto_en_lista.png` |
| Error de credenciales | `12_error_credenciales.png` |
| Error de conexión | `13_error_conexion.png` |
| Ruta /health desplegada | `19_health.png` |
| Panel de Render | `20_render.png` |
| Aplicación web desplegada | `21_app_web.png` |

## 11. Lista de verificación

- [ ] Las 15 pruebas de pytest están aprobadas.
- [ ] `flutter analyze` no reporta problemas.
- [ ] Las capturas de la aplicación están en el entregable.
- [ ] Los datos del estudiante están completos.
- [ ] Las URL del backend y de la aplicación web están en el entregable.
- [ ] El enlace del repositorio está en el entregable.
- [ ] El archivo final está en DOCX o PDF con el nombre `Lab10_Roman_Suyo_Andre_Fabrizzio.docx`.
