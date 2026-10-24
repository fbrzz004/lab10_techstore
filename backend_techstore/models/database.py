import sqlite3
from pathlib import Path

from flask import current_app
from werkzeug.security import generate_password_hash

PRODUCTOS_INICIALES = [
    ("PROD-001", "Laptop HP Pavilion 15", "Laptops", 2899.90, 10, "Procesador Intel i5 12va generación"),
    ("PROD-002", "Mouse Logitech MX Master", "Periféricos", 189.90, 25, "Mouse inalámbrico ergonómico"),
    ("PROD-003", "Teclado Mecánico Redragon", "Periféricos", 249.90, 15, "Switches rojos, retroiluminado RGB"),
    ("PROD-004", "Monitor Dell 24 FHD", "Monitores", 799.90, 8, "Pantalla IPS 1920x1080 75Hz"),
    ("PROD-005", "Auriculares Sony WH-1000XM5", "Audio", 1299.90, 12, "Cancelación de ruido activa"),
    ("PROD-006", "Smartphone Samsung Galaxy A54", "Smartphones", 1199.90, 20, "6.4 pulgadas, 128GB, 5G"),
    ("PROD-007", "Tablet iPad Air 5ta Gen", "Tablets", 2999.90, 5, "10.9 pulgadas, M1 chip, WiFi"),
    ("PROD-008", "SSD Kingston 1TB", "Almacenamiento", 299.90, 30, "SATA III, lectura 550 MB/s"),
]


def get_db():
    ruta = Path(current_app.config["DATABASE_PATH"])
    ruta.parent.mkdir(parents=True, exist_ok=True)
    conexion = sqlite3.connect(ruta)
    conexion.row_factory = sqlite3.Row
    conexion.execute("PRAGMA foreign_keys = ON")
    return conexion


def init_db():
    conexion = get_db()
    cursor = conexion.cursor()
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS usuario (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            username TEXT NOT NULL UNIQUE,
            password TEXT NOT NULL,
            nombre TEXT,
            activo INTEGER DEFAULT 1
        )
        """
    )
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS producto (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            codigo TEXT NOT NULL UNIQUE,
            nombre TEXT NOT NULL,
            categoria TEXT NOT NULL,
            precio REAL NOT NULL,
            stock INTEGER DEFAULT 0,
            descripcion TEXT
        )
        """
    )

    cursor.execute("SELECT COUNT(*) FROM usuario")
    if cursor.fetchone()[0] == 0:
        usuarios = [
            ("admin", "admin123", "Administrador TechStore"),
            ("vendedor1", "pass123", "Juan Pérez"),
        ]
        cursor.executemany(
            "INSERT INTO usuario (username, password, nombre) VALUES (?, ?, ?)",
            [(u, generate_password_hash(p), n) for u, p, n in usuarios],
        )

    cursor.execute("SELECT COUNT(*) FROM producto")
    if cursor.fetchone()[0] == 0:
        cursor.executemany(
            """
            INSERT INTO producto (codigo, nombre, categoria, precio, stock, descripcion)
            VALUES (?, ?, ?, ?, ?, ?)
            """,
            PRODUCTOS_INICIALES,
        )

    conexion.commit()
    conexion.close()
