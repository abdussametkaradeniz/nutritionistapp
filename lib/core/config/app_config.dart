import 'package:diet_app/core/constants/app_constants.dart';

import 'environment.dart';

class AppConfig {
  static late final Environment environment;
  static late final String apiUrl;
  static late final bool enableLogging;

  static void initialize(Environment env) {
    environment = env;

    switch (env) {
      case Environment.dev:
        apiUrl = AppConstants.devUrl;
        enableLogging = true;
        break;
      case Environment.stage:
        apiUrl = AppConstants.stageUrl;
        enableLogging = true;
        break;
      case Environment.prod:
        apiUrl = AppConstants.prodUrl;
        enableLogging = false;
        break;
    }
  }

  static bool get isDevelopment => environment == Environment.dev;
  static bool get isProduction => environment == Environment.prod;
  static bool get isStaging => environment == Environment.stage;
}
