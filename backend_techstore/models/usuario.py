from werkzeug.security import check_password_hash

from models.database import get_db


class Usuario:
    @staticmethod
    def autenticar(username, password):
        conexion = get_db()
        fila = conexion.execute(
            """
            SELECT id, username, password, nombre
            FROM usuario
            WHERE username = ? AND activo = 1
            """,
            (username,),
        ).fetchone()
        conexion.close()

        if fila is None:
            return None
        if not check_password_hash(fila["password"], password):
            return None
        return {"id": fila["id"], "username": fila["username"], "nombre": fila["nombre"]}
