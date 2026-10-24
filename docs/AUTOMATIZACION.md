# Despliegue automático

## 1. Estado del repositorio

Repositorio: `git@github.com:fbrzz004/lab10_techstore.git`.

El remoto actual usa HTTPS porque la clave `~/.ssh/ssh_for_fbrzz004.pub` no está registrada en la cuenta `fbrzz004`. Para cambiar a SSH:

```bash
bash scripts/setup_ssh.sh
```

El script solicita autorización en el navegador, registra la clave y cambia el remoto a `git@github.com-fbrzz004:fbrzz004/lab10_techstore.git`.

## 2. Credenciales

Cree el archivo `.env.deploy` a partir de `.env.deploy.example`:

```bash
cp .env.deploy.example .env.deploy
```

Complete estas variables:

- `RENDER_API_KEY`: Render > Account Settings > API Keys > Create API Key.
- `NETLIFY_AUTH_TOKEN`: Netlify > User settings > Applications > Personal access tokens > New access token.

Opcionales:

- `RENDER_SERVICE_NAME`: nombre del servicio. Valor por defecto: `techstore-api`.
- `NETLIFY_SITE_NAME`: nombre del sitio. Valor por defecto: `techstore-lab10-fbrzz004`.
- `RENDER_REGION`: región de Render. Valor por defecto: `oregon`.
- `RENDER_OWNER_ID`: identificador del espacio de trabajo, si la cuenta tiene varios.
- `NETLIFY_SITE_ID`: identificador de un sitio existente.

`.env.deploy` está en `.gitignore`. No lo suba al repositorio.

## 3. Despliegue completo

```bash
python3 scripts/deploy.py
```

El script realiza estas operaciones:

1. Consulta el espacio de trabajo de Render.
2. Crea el servicio web `techstore-api` con el plan Free, la región `oregon`, la carpeta `backend_techstore` y las variables de entorno.
3. Activa el despliegue y espera el estado `live`.
4. Comprueba la ruta `/health`.
5. Compila Flutter web con la URL del backend.
6. Crea el sitio `techstore-lab10-fbrzz004` en Netlify si no existe.
7. Comprime `app_flutter/build/web`, lo sube y espera el estado `ready`.
8. Guarda las URL en `deploy_urls.json`.

La primera ejecución tarda varios minutos. Las siguientes reutilizan el servicio y el sitio.

## 4. Despliegues parciales

Solo backend:

```bash
python3 scripts/deploy.py --solo-backend
```

Solo aplicación web, con una URL de backend conocida:

```bash
python3 scripts/deploy.py --solo-web --backend-url https://techstore-api.onrender.com
```

También puede definir `BACKEND_URL` en `.env.deploy`.

## 5. Verificación

```bash
BACKEND=$(python3 -c "import json; print(json.load(open('deploy_urls.json'))['backend'])")
WEB=$(python3 -c "import json; print(json.load(open('deploy_urls.json'))['web'])")

curl -fsS "$BACKEND/health"
curl -fsS -X POST "$BACKEND/api/login" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin123"}'
curl -fsS "$BACKEND/api/productos"
```

Abra `$WEB` en el navegador e inicie sesión con `admin` y `admin123`.

## 6. Subida de cambios

```bash
bash scripts/push.sh "Descripción del cambio"
```

El remoto HTTPS usa la sesión de `gh`. Si ejecutó `scripts/setup_ssh.sh`, el remoto usa SSH.

## 7. Notas de Render

- El plan Free suspende el servicio después de 15 minutos sin solicitudes.
- El script crea el sitio con acceso público. Si el equipo de Netlify tiene activada la protección con inicio de sesión, el script la desactiva.
- El plan Free usa un disco temporal. La base de datos se crea de nuevo en cada despliegue con los 8 productos iniciales.
- Para conservar los datos, cambie a un plan pagado, agregue un disco en `/var/data` y defina `DATABASE_PATH=/var/data/database.db`.
- El servicio usa `autoDeployTrigger: off`. Cada despliegue se activa con el script. Para desplegar con cada `push`, cambie la opción en el panel de Render y conecte la aplicación de GitHub.
- El backend permite CORS desde cualquier origen. Para producción, restrinja `CORS_ORIGINS` a la URL de Netlify.
