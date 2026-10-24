from models.database import get_db

CAMPOS_ACTUALIZABLES = ("nombre", "categoria", "precio", "stock", "descripcion")


class Producto:
    @staticmethod
    def listar():
        conexion = get_db()
        filas = conexion.execute("SELECT * FROM producto ORDER BY nombre").fetchall()
        conexion.close()
        return [dict(fila) for fila in filas]

    @staticmethod
    def buscar(termino):
        conexion = get_db()
        patron = f"%{termino}%"
        filas = conexion.execute(
            """
            SELECT * FROM producto
            WHERE codigo LIKE ? OR nombre LIKE ? OR categoria LIKE ?
            ORDER BY nombre
            """,
            (patron, patron, patron),
        ).fetchall()
        conexion.close()
        return [dict(fila) for fila in filas]

    @staticmethod
    def obtener(producto_id):
        conexion = get_db()
        fila = conexion.execute("SELECT * FROM producto WHERE id = ?", (producto_id,)).fetchone()
        conexion.close()
        return dict(fila) if fila else None

    @staticmethod
    def crear(datos):
        conexion = get_db()
        cursor = conexion.execute(
            """
            INSERT INTO producto (codigo, nombre, categoria, precio, stock, descripcion)
            VALUES (?, ?, ?, ?, ?, ?)
            """,
            (
                datos["codigo"],
                datos["nombre"],
                datos["categoria"],
                datos["precio"],
                datos.get("stock", 0),
                datos.get("descripcion", ""),
            ),
        )
        conexion.commit()
        nuevo_id = cursor.lastrowid
        conexion.close()
        return nuevo_id

    @staticmethod
    def actualizar(producto_id, datos):
        conexion = get_db()
        cursor = conexion.execute(
            """
            UPDATE producto
            SET nombre = ?, categoria = ?, precio = ?, stock = ?, descripcion = ?
            WHERE id = ?
            """,
            (
                datos["nombre"],
                datos["categoria"],
                datos["precio"],
                datos.get("stock", 0),
                datos.get("descripcion", ""),
                producto_id,
            ),
        )
        conexion.commit()
        filas = cursor.rowcount
        conexion.close()
        return filas > 0

    @staticmethod
    def eliminar(producto_id):
        conexion = get_db()
        cursor = conexion.execute("DELETE FROM producto WHERE id = ?", (producto_id,))
        conexion.commit()
        filas = cursor.rowcount
        conexion.close()
        return filas > 0
