import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import '../config/app_config.dart';

final loggerProvider = Provider<AppLogger>((ref) => AppLogger());

class AppLogger {
  late final Logger _logger;

  AppLogger() {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2, // Kaç method geriye gidileceği
        errorMethodCount: 8, // Hata durumunda kaç method geriye gidileceği
        lineLength: 120, // Maksimum satır uzunluğu
        colors: true, // Renkli output
        printEmojis: true, // Emoji kullanımı
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: AppConfig.isDevelopment ? Level.trace : Level.error,
    );
  }

  // Farklı log seviyeleri için metodlar
  void debug(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    if (AppConfig.isDevelopment) {
      _logger.d(message, error: error, stackTrace: stackTrace);
    }
  }

  void info(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.i(message, error: error, stackTrace: stackTrace);
  }

  void warning(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.w(message, error: error, stackTrace: stackTrace);
  }

  void error(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }

  void fatal(dynamic message, [dynamic error, StackTrace? stackTrace]) {
    _logger.f(message, error: error, stackTrace: stackTrace);
  }
}
