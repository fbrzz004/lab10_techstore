import os
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent


class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", "techstore_secret_2026")
    DATABASE_PATH = os.getenv("DATABASE_PATH", str(BASE_DIR / "database.db"))
    CORS_ORIGINS = os.getenv("CORS_ORIGINS", "*")
    JSON_SORT_KEYS = False
