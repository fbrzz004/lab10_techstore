from flask import Blueprint, jsonify, request

from models.usuario import Usuario
from views.presenters import error_json, exito_json, usuario_json

auth_bp = Blueprint("auth", __name__, url_prefix="/api")


@auth_bp.post("/login")
def login():
    datos = request.get_json(silent=True)
    if not datos:
        return jsonify(error_json("Datos incompletos")), 400

    username = str(datos.get("username", "")).strip()
    password = str(datos.get("password", ""))
    if not username or not password:
        return jsonify(error_json("Datos incompletos")), 400

    usuario = Usuario.autenticar(username, password)
    if usuario is None:
        return jsonify(error_json("Credenciales incorrectas")), 401

    return jsonify(exito_json("Acceso exitoso", usuario=usuario_json(usuario))), 200
