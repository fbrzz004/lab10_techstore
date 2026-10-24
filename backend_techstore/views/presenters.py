def usuario_json(usuario):
    return {
        "id": usuario["id"],
        "username": usuario["username"],
        "nombre": usuario["nombre"],
    }


def producto_json(producto):
    return {
        "id": producto["id"],
        "codigo": producto["codigo"],
        "nombre": producto["nombre"],
        "categoria": producto["categoria"],
        "precio": producto["precio"],
        "stock": producto["stock"],
        "descripcion": producto["descripcion"] or "",
    }


def productos_json(productos):
    return [producto_json(producto) for producto in productos]


def exito_json(mensaje, **datos):
    respuesta = {"ok": True, "mensaje": mensaje}
    respuesta.update(datos)
    return respuesta


def error_json(mensaje):
    return {"ok": False, "mensaje": mensaje}
