from flask import Blueprint, jsonify

from models.database import get_db

main_bp = Blueprint("main", __name__)


@main_bp.get("/")
def inicio():
    return jsonify(
        {
            "ok": True,
            "servicio": "techstore-api",
            "version": "1.0.0",
            "endpoints": [
                "POST /api/login",
                "GET /api/productos",
                "GET /api/productos/buscar?q=",
                "GET /api/productos/<id>",
                "POST /api/productos",
                "PUT /api/productos/<id>",
                "DELETE /api/productos/<id>",
            ],
        }
    ), 200


@main_bp.get("/health")
def health():
    conexion = get_db()
    conexion.execute("SELECT 1").fetchone()
    conexion.close()
    return jsonify({"ok": True, "estado": "operativo"}), 200
