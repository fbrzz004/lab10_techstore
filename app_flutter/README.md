# TechStore App

Aplicación Flutter del laboratorio 10.

## Arquitectura

- `lib/core`: constantes, errores y tema.
- `lib/domain`: entidades, contratos de repositorios y casos de uso.
- `lib/data`: servicio HTTP, modelos y repositorios.
- `lib/presentation`: páginas, widgets, estados y modelos de vista.

## Ejecución

```bash
flutter pub get
flutter run
```

La dirección del backend se define con `API_BASE_URL`:

```bash
flutter run --dart-define=API_BASE_URL=http://127.0.0.1:5000
```

Valores por defecto: `http://10.0.2.2:5000` en Android y `http://localhost:5000` en web y escritorio.

## Pruebas

```bash
flutter analyze
flutter test
```
