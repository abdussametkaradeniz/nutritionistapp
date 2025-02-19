import 'package:diet_app/core/network/interceptors/auth_interceptor.dart';
import 'package:diet_app/core/network/interceptors/error_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';
import '../constants/app_constants.dart';
import '../storage/secure_storage.dart';

// Global provider for Dio client
final dioProvider = Provider<Dio>((ref) => DioClient.getInstance());

class DioClient {
  static Dio? _instance;

  // Singleton pattern kullanıyoruz çünkü:
  // 1. Tek bir HTTP client instance'ı yeterli
  // 2. Memory optimization
  // 3. Interceptor'ları tek noktadan yönetmek için
  static Dio getInstance() {
    _instance ??= _createDioInstance();
    return _instance!;
  }

  static Dio _createDioInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiUrl,
        connectTimeout:
            const Duration(milliseconds: AppConstants.connectionTimeout),
        receiveTimeout:
            const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    final storage = SecureStorage();

    // Debug modda detaylı logging ekleyelim
    if (AppConfig.isDevelopment) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          error: true,
        ),
      );
    }

    dio.interceptors.addAll([
      ErrorInterceptor(),
      AuthInterceptor(dio, storage),
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    ]);

    return dio;
  }
}
