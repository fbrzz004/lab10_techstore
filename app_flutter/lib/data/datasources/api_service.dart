import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../core/constants.dart';
import '../../core/errors.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String url) async {
    final respuesta = await _ejecutar(() => _client.get(Uri.parse(url)));
    return _procesar(respuesta);
  }

  Future<dynamic> post(String url, Map<String, dynamic> cuerpo) async {
    final respuesta = await _ejecutar(
      () => _client.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cuerpo),
      ),
    );
    return _procesar(respuesta);
  }

  Future<dynamic> put(String url, Map<String, dynamic> cuerpo) async {
    final respuesta = await _ejecutar(
      () => _client.put(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(cuerpo),
      ),
    );
    return _procesar(respuesta);
  }

  Future<dynamic> delete(String url) async {
    final respuesta = await _ejecutar(() => _client.delete(Uri.parse(url)));
    return _procesar(respuesta);
  }

  Future<http.Response> _ejecutar(
    Future<http.Response> Function() accion,
  ) async {
    try {
      return await accion().timeout(AppConstants.timeout);
    } on TimeoutException {
      throw const ApiException(
        'El servidor no respondió. Verifique la conexión.',
      );
    } on http.ClientException {
      throw const ApiException('No se pudo conectar con el servidor.');
    }
  }

  dynamic _procesar(http.Response respuesta) {
    dynamic cuerpo;
    if (respuesta.body.isNotEmpty) {
      try {
        cuerpo = jsonDecode(utf8.decode(respuesta.bodyBytes));
      } catch (_) {
        cuerpo = null;
      }
    }

    if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
      return cuerpo;
    }

    if (cuerpo is Map && cuerpo['mensaje'] is String) {
      throw ApiException(cuerpo['mensaje'] as String);
    }
    throw ApiException('Error del servidor (${respuesta.statusCode}).');
  }
}
