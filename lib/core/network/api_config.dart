abstract final class ApiConfig {
  static const String _defaultBaseUrl = 'http://3.6.89.168/api';

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

  static const String _defaultVideoCallBaseUrl = 'https://meet.jit.si';

  static const String videoCallBaseUrl = String.fromEnvironment(
    'VIDEO_CALL_BASE_URL',
    defaultValue: _defaultVideoCallBaseUrl,
  );

  static String get normalizedVideoCallBaseUrl {
    if (videoCallBaseUrl.endsWith('/')) {
      return videoCallBaseUrl.substring(0, videoCallBaseUrl.length - 1);
    }

    return videoCallBaseUrl;
  }
}
