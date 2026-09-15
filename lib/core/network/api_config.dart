abstract final class ApiConfig {
  static const String _defaultBaseUrl = 'http://192.168.29.50:8000/api';

  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: _defaultBaseUrl,
  );

  static String get normalizedBaseUrl {
    if (baseUrl.endsWith('/')) {
      return baseUrl.substring(0, baseUrl.length - 1);
    }

    return baseUrl;
  }
}
