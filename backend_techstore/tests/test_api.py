def test_health(client):
    respuesta = client.get("/health")
    assert respuesta.status_code == 200
    assert respuesta.get_json()["estado"] == "operativo"


def test_login_correcto(client):
    respuesta = client.post("/api/login", json={"username": "admin", "password": "admin123"})
    datos = respuesta.get_json()
    assert respuesta.status_code == 200
    assert datos["ok"] is True
    assert datos["usuario"]["username"] == "admin"
    assert "password" not in datos["usuario"]


def test_login_incorrecto(client):
    respuesta = client.post("/api/login", json={"username": "admin", "password": "incorrecta"})
    assert respuesta.status_code == 401
    assert respuesta.get_json()["ok"] is False


def test_login_incompleto(client):
    respuesta = client.post("/api/login", json={"username": "admin"})
    assert respuesta.status_code == 400
    assert respuesta.get_json()["mensaje"] == "Datos incompletos"


def test_listar_productos(client):
    respuesta = client.get("/api/productos")
    datos = respuesta.get_json()
    assert respuesta.status_code == 200
    assert len(datos) == 8
    assert datos[0]["codigo"] == "PROD-005"


def test_buscar_por_nombre(client):
    respuesta = client.get("/api/productos/buscar?q=laptop")
    datos = respuesta.get_json()
    assert respuesta.status_code == 200
    assert len(datos) == 1
    assert datos[0]["nombre"] == "Laptop HP Pavilion 15"


def test_buscar_sin_resultados(client):
    respuesta = client.get("/api/productos/buscar?q=xyz123")
    assert respuesta.status_code == 200
    assert respuesta.get_json() == []


def test_buscar_por_categoria(client):
    respuesta = client.get("/api/productos/buscar?q=Periféricos")
    assert respuesta.status_code == 200
    assert len(respuesta.get_json()) == 2


def test_crear_producto(client):
    respuesta = client.post(
        "/api/productos",
        json={
            "codigo": "PROD-100",
            "nombre": "Webcam Logitech",
            "categoria": "Periféricos",
            "precio": 249.5,
            "stock": 4,
            "descripcion": "Full HD",
        },
    )
    datos = respuesta.get_json()
    assert respuesta.status_code == 201
    assert datos["ok"] is True
    assert datos["id"] > 0


def test_crear_producto_codigo_duplicado(client):
    respuesta = client.post(
        "/api/productos",
        json={"codigo": "PROD-001", "nombre": "Duplicado", "categoria": "Pruebas", "precio": 10},
    )
    assert respuesta.status_code == 409


def test_crear_producto_sin_campos(client):
    respuesta = client.post("/api/productos", json={"codigo": "PROD-101"})
    assert respuesta.status_code == 400


def test_actualizar_producto(client, producto_creado):
    respuesta = client.put(
        f"/api/productos/{producto_creado}",
        json={"nombre": "Producto editado", "categoria": "Pruebas", "precio": 120, "stock": 9},
    )
    assert respuesta.status_code == 200

    consulta = client.get(f"/api/productos/{producto_creado}")
    assert consulta.get_json()["nombre"] == "Producto editado"
    assert consulta.get_json()["stock"] == 9


def test_actualizar_producto_inexistente(client):
    respuesta = client.put(
        "/api/productos/9999",
        json={"nombre": "Sin producto", "categoria": "Pruebas", "precio": 1},
    )
    assert respuesta.status_code == 404


def test_eliminar_producto(client, producto_creado):
    respuesta = client.delete(f"/api/productos/{producto_creado}")
    assert respuesta.status_code == 200
    consulta = client.get(f"/api/productos/{producto_creado}")
    assert consulta.status_code == 404


def test_eliminar_producto_inexistente(client):
    respuesta = client.delete("/api/productos/9999")
    assert respuesta.status_code == 404
