# Despliegue en la nube

## 1. Backend en Render

### 1.1. Repositorio

1. Cree un repositorio en GitHub.
2. Suba la carpeta `lab10_techstore`.
3. Confirme que `backend_techstore/requirements.txt`, `backend_techstore/app.py` y `backend_techstore/render.yaml` están en el repositorio.

### 1.2. Servicio web

1. Cree una cuenta en Render.
2. Pulse *New* y seleccione *Web Service*.
3. Conecte el repositorio.
4. Complete el formulario:
   - Nombre: `techstore-api`
   - Región: la más cercana a Lima.
   - *Root Directory*: `lab10_techstore/backend_techstore`
   - *Runtime*: Python 3.
   - *Build Command*: `pip install -r requirements.txt`
   - *Start Command*: `gunicorn "app:create_app()" --bind 0.0.0.0:$PORT --workers 2 --timeout 60`
   - *Health Check Path*: `/health`
   - Plan: Free.
5. En *Environment Variables* agregue:
   - `SECRET_KEY`: valor generado por Render.
   - `CORS_ORIGINS`: `*`
   - `DATABASE_PATH`: `database.db`
   - `PYTHON_VERSION`: `3.12.4`
6. Pulse *Deploy Web Service*.
7. Espere el estado *Live*.
8. Abra `https://[nombre-del-servicio].onrender.com/health`.

La respuesta debe ser:

```json
{"estado":"operativo","ok":true}
```

También puede crear el servicio con el archivo `render.yaml` de la raíz del repositorio: *New* > *Blueprint* > seleccione el repositorio. Render lee el archivo y crea el servicio con la carpeta `backend_techstore`.

### 1.3. Persistencia de SQLite

El plan Free usa un disco temporal. La base de datos se crea de nuevo en cada despliegue o reinicio con los 2 usuarios y los 8 productos iniciales.

Para conservar los cambios:

1. Cambie el plan a Starter.
2. Agregue un disco con punto de montaje `/var/data`.
3. Cambie `DATABASE_PATH` a `/var/data/database.db`.

### 1.4. Verificación

```bash
curl https://[nombre-del-servicio].onrender.com/health
curl -X POST https://[nombre-del-servicio].onrender.com/api/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
curl https://[nombre-del-servicio].onrender.com/api/productos
```

### 1.5. Disponibilidad

El plan Free suspende el servicio después de 15 minutos sin solicitudes. La primera solicitud posterior tarda algunos segundos.

Para mantener el servicio activo, cree un monitor HTTP en UptimeRobot con la URL `/health` y un intervalo de 5 minutos. Confirme el estado en el panel de Render y en el monitor.

## 2. Aplicación web en Netlify

1. Genere la compilación con la URL del backend:

```bash
cd app_flutter
flutter build web --release --dart-define=API_BASE_URL=https://[nombre-del-servicio].onrender.com
```

2. Abra [https://app.netlify.com/drop](https://app.netlify.com/drop).
3. Arrastre la carpeta `app_flutter/build/web`.
4. Espere la URL pública.
5. Abra la URL, inicie sesión con `admin` y `admin123`, y compruebe el catálogo.

La aplicación web usa las mismas pantallas y el mismo backend.

## 3. Aplicación para Android

1. Genere el APK con la URL del backend:

```bash
flutter build apk --release --dart-define=API_BASE_URL=https://[nombre-del-servicio].onrender.com
```

2. Instale `build/app/outputs/flutter-apk/app-release.apk` en el dispositivo.
3. Abra la aplicación e inicie sesión.

El tráfico HTTPS no requiere configuración adicional. Para el backend local con HTTP, el archivo `AndroidManifest.xml` tiene `usesCleartextTraffic="true"`.

## 4. Prueba local del comando de producción

```bash
cd backend_techstore
.venv/bin/pip install -r requirements.txt
.venv/bin/gunicorn "app:create_app()" --bind 127.0.0.1:5001 --workers 2 --timeout 60
curl http://127.0.0.1:5001/health
```

## 5. Seguridad

1. Cambie las contraseñas iniciales antes de una entrega pública.
2. Use un valor propio en `SECRET_KEY`.
3. Restrinja `CORS_ORIGINS` a la URL de la aplicación web.
4. Mantenga el backend en HTTPS.
5. No publique `database.db` ni el archivo `.env`.

## 6. Capturas

1. Capture `https://[nombre-del-servicio].onrender.com/health` en el navegador: `docs/evidencias/19_health.png`.
2. Capture el panel de Render con el servicio en estado *Live*: `docs/evidencias/20_render.png`.
3. Capture la aplicación web desplegada con la sesión iniciada: `docs/evidencias/21_app_web.png`.
