class AppConstants {
  // API Endpoints
  static const String devUrl = 'http://localhost:3000';
  static const String stageUrl = 'https://stage-api.nutritionist.com';
  static const String prodUrl = 'https://api.nutritionist.com';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';

  // Timeouts
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Cache Duration
  static const int cacheDuration = 7; // days
}
