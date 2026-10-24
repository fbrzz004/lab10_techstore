#!/usr/bin/env python3
"""Despliega el backend en Render y la aplicación web en Netlify."""

from __future__ import annotations

import argparse
import json
import os
import shutil
import subprocess
import sys
import tempfile
import time
import urllib.error
import urllib.parse
import urllib.request
import zipfile
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[1]
ARCHIVO_ENV = RAIZ / ".env.deploy"
ARCHIVO_URLS = RAIZ / "deploy_urls.json"

RENDER_API = "https://api.render.com/v1"
NETLIFY_API = "https://api.netlify.com/api/v1"

REPO = "https://github.com/fbrzz004/lab10_techstore"
RAMA = "main"
COMANDO_BUILD = "pip install -r requirements.txt"
COMANDO_START = 'gunicorn "app:create_app()" --bind 0.0.0.0:$PORT --workers 2 --timeout 60'


def nombre_servicio() -> str:
    return os.getenv("RENDER_SERVICE_NAME", "techstore-api")


def nombre_sitio() -> str:
    return os.getenv("NETLIFY_SITE_NAME", "techstore-lab10-fbrzz004")


def region_render() -> str:
    return os.getenv("RENDER_REGION", "oregon")


def cargar_env() -> None:
    if not ARCHIVO_ENV.exists():
        return
    for linea in ARCHIVO_ENV.read_text(encoding="utf-8").splitlines():
        linea = linea.strip()
        if not linea or linea.startswith("#") or "=" not in linea:
            continue
        clave, valor = linea.split("=", 1)
        os.environ.setdefault(clave.strip(), valor.strip().strip('"').strip("'"))


def pedir(
    url: str,
    token: str,
    metodo: str = "GET",
    cuerpo: dict | None = None,
    crudo: bytes | None = None,
    tipo: str = "application/json",
) -> tuple[int, object | None]:
    datos = crudo
    if datos is None and cuerpo is not None:
        datos = json.dumps(cuerpo).encode("utf-8")

    solicitud = urllib.request.Request(url, data=datos, method=metodo)
    solicitud.add_header("Authorization", f"Bearer {token}")
    solicitud.add_header("Accept", "application/json")
    if datos is not None:
        solicitud.add_header("Content-Type", tipo)

    try:
        with urllib.request.urlopen(solicitud, timeout=180) as respuesta:
            texto = respuesta.read()
            return respuesta.status, json.loads(texto) if texto else None
    except urllib.error.HTTPError as error:
        detalle = error.read().decode("utf-8", errors="replace")
        raise SystemExit(f"Error HTTP {error.code} en {metodo} {url}\n{detalle}") from error
    except urllib.error.URLError as error:
        raise SystemExit(f"No se pudo conectar con {url}: {error.reason}") from error


def desenvolver(datos: object, clave: str) -> dict:
    if isinstance(datos, dict) and isinstance(datos.get(clave), dict):
        return datos[clave]
    if isinstance(datos, dict):
        return datos
    raise SystemExit(f"Respuesta inesperada de la API: {datos!r}")


def token_render() -> str:
    token = os.getenv("RENDER_API_KEY", "").strip()
    if not token:
        raise SystemExit(
            "Falta RENDER_API_KEY. Copie .env.deploy.example a .env.deploy y agregue la clave."
        )
    return token


def token_netlify() -> str:
    token = os.getenv("NETLIFY_AUTH_TOKEN", "").strip()
    if not token:
        raise SystemExit(
            "Falta NETLIFY_AUTH_TOKEN. Copie .env.deploy.example a .env.deploy y agregue el token."
        )
    return token


def owner_render(token: str) -> str:
    configurado = os.getenv("RENDER_OWNER_ID", "").strip()
    if configurado:
        return configurado
    _, datos = pedir(f"{RENDER_API}/owners?limit=1", token)
    if not isinstance(datos, list) or not datos:
        raise SystemExit("No se encontró un espacio de trabajo en Render.")
    primero = datos[0]
    return desenvolver(primero, "owner")["id"]


def buscar_servicio(token: str, owner: str) -> dict | None:
    consulta = urllib.parse.urlencode(
        {"name": nombre_servicio(), "ownerId": owner, "limit": 1}
    )
    _, datos = pedir(f"{RENDER_API}/services?{consulta}", token)
    if isinstance(datos, list) and datos:
        return desenvolver(datos[0], "service")
    return None


def crear_servicio(token: str, owner: str) -> tuple[dict, str | None]:
    cuerpo = {
        "type": "web_service",
        "name": nombre_servicio(),
        "ownerId": owner,
        "repo": os.getenv("GITHUB_REPO_URL", REPO),
        "branch": os.getenv("GITHUB_BRANCH", RAMA),
        "rootDir": "backend_techstore",
        "autoDeployTrigger": "off",
        "envVars": [
            {"key": "SECRET_KEY", "generateValue": True},
            {"key": "CORS_ORIGINS", "value": "*"},
            {"key": "DATABASE_PATH", "value": "database.db"},
            {"key": "PYTHON_VERSION", "value": "3.12.4"},
        ],
        "serviceDetails": {
            "runtime": "python",
            "plan": "free",
            "region": region_render(),
            "healthCheckPath": "/health",
            "envSpecificDetails": {
                "buildCommand": COMANDO_BUILD,
                "startCommand": COMANDO_START,
            },
        },
    }
    _, datos = pedir(f"{RENDER_API}/services", token, "POST", cuerpo)
    servicio = desenvolver(datos, "service")
    deploy_id = datos.get("deployId") if isinstance(datos, dict) else None
    return servicio, deploy_id


def esperar_deploy_render(token: str, servicio_id: str, deploy_id: str) -> None:
    estados_finales = {"build_failed", "update_failed", "canceled", "pre_deploy_failed"}
    for intento in range(1, 121):
        _, datos = pedir(
            f"{RENDER_API}/services/{servicio_id}/deploys/{deploy_id}", token
        )
        deploy = desenvolver(datos, "deploy")
        estado = deploy.get("status", "desconocido")
        print(f"  Render: {estado} ({intento})")
        if estado == "live":
            return
        if estado in estados_finales:
            raise SystemExit(f"El despliegue de Render terminó en estado {estado}.")
        time.sleep(10)
    raise SystemExit("El despliegue de Render no terminó en 20 minutos.")


def verificar_salud(url: str) -> None:
    for _ in range(12):
        try:
            with urllib.request.urlopen(f"{url}/health", timeout=20) as respuesta:
                if respuesta.status == 200:
                    print("  /health: 200")
                    return
        except Exception:
            pass
        time.sleep(5)
    print("  Aviso: /health no respondió todavía. El servicio puede tardar en iniciar.")


def desplegar_backend() -> str:
    token = token_render()
    owner = owner_render(token)
    servicio = buscar_servicio(token, owner)

    if servicio is None:
        print(f"Creando el servicio {nombre_servicio()} en Render...")
        servicio, deploy_id = crear_servicio(token, owner)
    else:
        print(f"El servicio {nombre_servicio()} ya existe.")
        deploy_id = None

    servicio_id = servicio["id"]
    if not deploy_id:
        _, deploy = pedir(
            f"{RENDER_API}/services/{servicio_id}/deploys",
            token,
            "POST",
            {"clearCache": "do_not_clear"},
        )
        deploy_id = desenvolver(deploy, "deploy")["id"]

    print(f"Despliegue de Render: {deploy_id}")
    esperar_deploy_render(token, servicio_id, deploy_id)

    _, datos = pedir(f"{RENDER_API}/services/{servicio_id}", token)
    servicio = desenvolver(datos, "service")
    url = servicio.get("serviceDetails", {}).get("url") or (
        f"https://{servicio.get('slug', nombre_servicio())}.onrender.com"
    )
    print(f"Backend: {url}")
    verificar_salud(url)
    return url.rstrip("/")


def buscar_sitio(token: str) -> dict | None:
    configurado = os.getenv("NETLIFY_SITE_ID", "").strip()
    if configurado:
        _, datos = pedir(f"{NETLIFY_API}/sites/{configurado}", token)
        return desenvolver(datos, "site")

    consulta = urllib.parse.urlencode({"name": nombre_sitio()})
    _, datos = pedir(f"{NETLIFY_API}/sites?{consulta}", token)
    if isinstance(datos, list):
        for sitio in datos:
            if sitio.get("name") == nombre_sitio():
                return sitio
    return None


def crear_sitio(token: str) -> dict:
    print(f"Creando el sitio {nombre_sitio()} en Netlify...")
    _, datos = pedir(f"{NETLIFY_API}/sites", token, "POST", {"name": nombre_sitio()})
    return desenvolver(datos, "site")


def construir_web(backend_url: str) -> Path:
    if shutil.which("flutter") is None:
        raise SystemExit("No se encontró flutter en PATH.")
    carpeta = RAIZ / "app_flutter"
    print("Compilando la aplicación web...")
    subprocess.run(["flutter", "pub", "get"], cwd=carpeta, check=True)
    subprocess.run(
        [
            "flutter",
            "build",
            "web",
            "--release",
            f"--dart-define=API_BASE_URL={backend_url}",
        ],
        cwd=carpeta,
        check=True,
    )
    return carpeta / "build" / "web"


def comprimir_web(carpeta: Path) -> Path:
    descriptor, nombre = tempfile.mkstemp(suffix=".zip")
    os.close(descriptor)
    archivo = Path(nombre)
    with zipfile.ZipFile(archivo, "w", zipfile.ZIP_DEFLATED) as z:
        for ruta in carpeta.rglob("*"):
            if ruta.is_file():
                z.write(ruta, ruta.relative_to(carpeta))
    return archivo


def esperar_deploy_netlify(token: str, deploy_id: str) -> None:
    for intento in range(1, 121):
        _, datos = pedir(f"{NETLIFY_API}/deploys/{deploy_id}", token)
        estado = datos.get("state", "desconocido") if isinstance(datos, dict) else "desconocido"
        print(f"  Netlify: {estado} ({intento})")
        if estado == "ready":
            return
        if estado in {"error", "rejected"}:
            raise SystemExit(f"El despliegue de Netlify terminó en estado {estado}.")
        time.sleep(5)
    raise SystemExit("El despliegue de Netlify no terminó en 10 minutos.")


def desplegar_web(backend_url: str) -> str:
    token = token_netlify()
    sitio = buscar_sitio(token) or crear_sitio(token)
    carpeta = construir_web(backend_url)

    print("Subiendo la compilación a Netlify...")
    archivo = comprimir_web(carpeta)
    try:
        _, deploy = pedir(
            f"{NETLIFY_API}/sites/{sitio['id']}/deploys",
            token,
            "POST",
            crudo=archivo.read_bytes(),
            tipo="application/zip",
        )
    finally:
        archivo.unlink(missing_ok=True)

    deploy_id = deploy["id"]
    esperar_deploy_netlify(token, deploy_id)

    _, sitio = pedir(f"{NETLIFY_API}/sites/{sitio['id']}", token)
    url = sitio.get("ssl_url") or sitio.get("url") or f"https://{nombre_sitio()}.netlify.app"
    print(f"Aplicación web: {url}")
    try:
        with urllib.request.urlopen(url, timeout=30) as respuesta:
            print(f"  Netlify: HTTP {respuesta.status}")
    except Exception:
        print("  Aviso: la aplicación web no respondió todavía.")
    return url.rstrip("/")


def guardar_urls(backend: str | None, web: str | None) -> None:
    datos = {}
    if ARCHIVO_URLS.exists():
        try:
            datos = json.loads(ARCHIVO_URLS.read_text(encoding="utf-8"))
        except json.JSONDecodeError:
            datos = {}
    if backend:
        datos["backend"] = backend
    if web:
        datos["web"] = web
    ARCHIVO_URLS.write_text(json.dumps(datos, indent=2) + "\n", encoding="utf-8")


def main() -> None:
    cargar_env()
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--solo-backend", action="store_true", help="Despliega solo Render.")
    parser.add_argument("--solo-web", action="store_true", help="Despliega solo Netlify.")
    parser.add_argument("--backend-url", help="URL del backend para --solo-web.")
    args = parser.parse_args()

    if args.solo_backend and args.solo_web:
        raise SystemExit("Use solo uno de --solo-backend o --solo-web.")

    backend = None
    web = None

    if not args.solo_web:
        backend = desplegar_backend()
        guardar_urls(backend=backend, web=None)

    if not args.solo_backend:
        if not backend:
            backend = (args.backend_url or os.getenv("BACKEND_URL", "")).strip()
        if not backend and ARCHIVO_URLS.exists():
            try:
                backend = json.loads(ARCHIVO_URLS.read_text(encoding="utf-8")).get("backend", "")
            except json.JSONDecodeError:
                backend = ""
        if not backend:
            raise SystemExit(
                "Falta la URL del backend. Use --backend-url o defina BACKEND_URL."
            )
        web = desplegar_web(backend)
        guardar_urls(backend=backend, web=web)

    print("\nDespliegue terminado.")
    if backend:
        print(f"Backend:      {backend}")
    if web:
        print(f"Aplicación:   {web}")


if __name__ == "__main__":
    main()
