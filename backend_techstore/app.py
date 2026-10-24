import os

from flask import Flask, jsonify
from flask_cors import CORS

from config import Config
from controllers.auth_controller import auth_bp
from controllers.main_controller import main_bp
from controllers.producto_controller import producto_bp
from models.database import init_db
from views.presenters import error_json


def create_app(config_object=Config):
    app = Flask(__name__)
    app.config.from_object(config_object)
    app.json.ensure_ascii = False

    CORS(app, resources={r"/*": {"origins": app.config["CORS_ORIGINS"]}})

    app.register_blueprint(main_bp)
    app.register_blueprint(auth_bp)
    app.register_blueprint(producto_bp)

    @app.errorhandler(404)
    def no_encontrado(_error):
        return jsonify(error_json("Ruta no encontrada")), 404

    @app.errorhandler(500)
    def error_interno(_error):
        return jsonify(error_json("Error interno del servidor")), 500

    with app.app_context():
        init_db()

    return app


app = create_app()

if __name__ == "__main__":
    app.run(
        host="0.0.0.0",
        port=int(os.getenv("PORT", "5000")),
        debug=os.getenv("FLASK_DEBUG", "0") == "1",
    )
