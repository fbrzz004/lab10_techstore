# Laboratorio 10 · TechStore

Implementación de la sesión 10 del Taller de construcción de software móvil.

## Contenido

- `backend_techstore`: API REST con Flask, arquitectura MVC, SQLite, pruebas y configuración de despliegue.
- `app_flutter`: aplicación Flutter con arquitectura limpia, MVVM, Provider y consumo de la API.
- `docs`: entregable, guía de capturas, guía de despliegue, colección de Postman y evidencias.

## Backend

```bash
cd backend_techstore
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements-dev.txt
python app.py
```

La API queda en `http://127.0.0.1:5000`. La base de datos se crea en `database.db` con 2 usuarios y 8 productos.

Credenciales: `admin` / `admin123` y `vendedor1` / `pass123`.

## Aplicación

```bash
cd app_flutter
flutter pub get
flutter run
```

La aplicación usa `http://10.0.2.2:5000` en el emulador de Android y `http://localhost:5000` en web y escritorio. Para un dispositivo físico con `adb reverse`:

```bash
adb reverse tcp:5000 tcp:5000
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
```

Para una API desplegada:

```bash
flutter run --dart-define=API_BASE_URL=https://techstore-api.onrender.com
```

## Pruebas

```bash
cd backend_techstore
.venv/bin/python -m pytest -q

cd ../app_flutter
flutter analyze
flutter test
```

## Documentos

- [Entregable](docs/ENTREGABLE.md)
- [Guía de capturas](docs/GUIA_SCREENSHOTS.md)
- [Despliegue manual](docs/DESPLIEGUE.md)
- [Despliegue automático](docs/AUTOMATIZACION.md)

## Despliegue

- Backend: https://techstore-api-xb0d.onrender.com
- Aplicación web: https://techstore-lab10-fbrzz004.netlify.app
