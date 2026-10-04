import 'package:flutter/foundation.dart';

abstract final class AppConfig {
  static String get apiBaseUrl {
    const configuredUrl = String.fromEnvironment('API_BASE_URL');
    if (configuredUrl.isNotEmpty) return configuredUrl;
    return kIsWeb ? 'http://localhost:4000/api' : 'http://10.0.2.2:4000/api';
  }
}
