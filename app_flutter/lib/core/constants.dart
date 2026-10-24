import 'package:flutter/foundation.dart';

class AppConstants {
  static const String _baseUrlDefinida = String.fromEnvironment('API_BASE_URL');

  static String get baseUrl {
    if (_baseUrlDefinida.isNotEmpty) {
      return _baseUrlDefinida;
    }
    if (kIsWeb) {
      return 'http://localhost:5000';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5000';
    }
    return 'http://localhost:5000';
  }

  static String get loginEndpoint => '$baseUrl/api/login';
  static String get productosEndpoint => '$baseUrl/api/productos';
  static String get buscarEndpoint => '$baseUrl/api/productos/buscar';

  static const Duration timeout = Duration(seconds: 10);
}
