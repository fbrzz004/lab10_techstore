import sys
import tempfile
from pathlib import Path

import pytest

RAIZ = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(RAIZ))

from app import create_app  # noqa: E402
from config import Config  # noqa: E402


@pytest.fixture()
def app():
    with tempfile.TemporaryDirectory() as directorio:
        class ConfigPrueba(Config):
            TESTING = True
            DATABASE_PATH = str(Path(directorio) / "prueba.db")

        aplicacion = create_app(ConfigPrueba)
        yield aplicacion


@pytest.fixture()
def client(app):
    return app.test_client()


@pytest.fixture()
def producto_creado(client):
    respuesta = client.post(
        "/api/productos",
        json={
            "codigo": "PROD-TEST",
            "nombre": "Producto de prueba",
            "categoria": "Pruebas",
            "precio": 99.9,
            "stock": 3,
            "descripcion": "Producto temporal",
        },
    )
    return respuesta.get_json()["id"]
