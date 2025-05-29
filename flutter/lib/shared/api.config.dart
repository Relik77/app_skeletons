class ApiConfig {
  static const String apiURl = String.fromEnvironment("API_URL");

  static String? _urlScheme;
  static String get urlScheme {
    return _urlScheme ??= apiURl.startsWith("https") ? "https" : "http";
  }

  static int? _port;
  static int? get port {
    if (_port != null) return _port;
    final domain = apiURl.replaceFirst("$urlScheme://", "");
    return _port ??= domain.contains(":") ? int.tryParse(domain.split(":").last) : null;
  }

  static String? _baseUrl;
  static String get baseUrl {
    return _baseUrl ??= apiURl.replaceFirst("$urlScheme://", "").split(":").first;
  }

  // Log API
  static const String log = "/api/log";

  // Auth API
  static const String login = "/api/auth/sign-in";
  static const String refreshToken = "/api/auth/token";
  static const String getProfile = "/api/auth/user";
  static const String logout = "/api/auth/sign-out";
  static const String updateProfile = "/api/auth/user";


  static const String sampleApiWithPathParams = "/api/test/{id}";
}
