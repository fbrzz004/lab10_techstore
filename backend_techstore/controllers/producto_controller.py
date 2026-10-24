import sqlite3

from flask import Blueprint, jsonify, request

from models.producto import Producto
from views.presenters import error_json, exito_json, producto_json, productos_json

producto_bp = Blueprint("producto", __name__, url_prefix="/api/productos")

CAMPOS_OBLIGATORIOS = ("codigo", "nombre", "categoria", "precio")


def _validar(datos, requiere_codigo=True):
    if not datos:
        return "Datos incompletos"

    campos = CAMPOS_OBLIGATORIOS if requiere_codigo else CAMPOS_OBLIGATORIOS[1:]
    for campo in campos:
        if campo not in datos or str(datos[campo]).strip() == "":
            return f"El campo {campo} es obligatorio"

    try:
        datos["precio"] = float(datos["precio"])
    except (TypeError, ValueError):
        return "El precio debe ser un número"

    if datos["precio"] < 0:
        return "El precio no puede ser negativo"

    try:
        datos["stock"] = int(datos.get("stock", 0) or 0)
    except (TypeError, ValueError):
        return "El stock debe ser un número entero"

    if datos["stock"] < 0:
        return "El stock no puede ser negativo"

    return None


@producto_bp.get("")
def listar():
    return jsonify(productos_json(Producto.listar())), 200


@producto_bp.get("/buscar")
def buscar():
    termino = request.args.get("q", "").strip()
    if not termino:
        return jsonify([]), 200
    return jsonify(productos_json(Producto.buscar(termino))), 200


@producto_bp.get("/<int:producto_id>")
def obtener(producto_id):
    producto = Producto.obtener(producto_id)
    if producto is None:
        return jsonify(error_json("Producto no encontrado")), 404
    return jsonify(producto_json(producto)), 200


@producto_bp.post("")
def crear():
    datos = request.get_json(silent=True)
    error = _validar(datos, requiere_codigo=True)
    if error:
        return jsonify(error_json(error)), 400

    try:
        nuevo_id = Producto.crear(datos)
    except sqlite3.IntegrityError:
        return jsonify(error_json("El código ya existe")), 409

    return jsonify(exito_json("Producto registrado", id=nuevo_id)), 201


@producto_bp.put("/<int:producto_id>")
def actualizar(producto_id):
    if Producto.obtener(producto_id) is None:
        return jsonify(error_json("Producto no encontrado")), 404

    datos = request.get_json(silent=True)
    error = _validar(datos, requiere_codigo=False)
    if error:
        return jsonify(error_json(error)), 400

    Producto.actualizar(producto_id, datos)
    return jsonify(exito_json("Producto actualizado")), 200


@producto_bp.delete("/<int:producto_id>")
def eliminar(producto_id):
    if not Producto.eliminar(producto_id):
        return jsonify(error_json("Producto no encontrado")), 404
    return jsonify(exito_json("Producto eliminado")), 200
