import 'environment.dart';

class AppConfig {
  static late final Environment environment;
  static late final String apiUrl;
  static late final bool enableLogging;

  static void initialize(Environment env) {
    environment = env;

    switch (env) {
      case Environment.dev:
        apiUrl = 'http://localhost:3000';
        enableLogging = true;
        break;
      case Environment.stage:
        apiUrl = 'https://stage-api.nutritionist.com';
        enableLogging = true;
        break;
      case Environment.prod:
        apiUrl = 'https://api.nutritionist.com';
        enableLogging = false;
        break;
    }
  }

  static bool get isDevelopment => environment == Environment.dev;
  static bool get isProduction => environment == Environment.prod;
  static bool get isStaging => environment == Environment.stage;
}
