import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dio_client.dart'; // dioProvider için bu import'u ekliyoruz

// Global provider for API client
final apiClientProvider = Provider<ApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiClient(dio);
});

class ApiClient {
  final Dio _dio;

  ApiClient(this._dio);

  // GET isteği
  Future<T> get<T>({
    required String path,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );

      // Parser fonksiyonu verilmişse, response'u parse et
      if (parser != null) {
        return parser(response.data);
      }

      return response.data as T;
    } on DioException {
      rethrow; // Error interceptor yakalar
    }
  }

  // POST isteği
  Future<T> post<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.post(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (parser != null) {
        return parser(response.data);
      }

      return response.data as T;
    } on DioException {
      rethrow;
    }
  }

  // PUT isteği
  Future<T> put<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.put(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (parser != null) {
        return parser(response.data);
      }

      return response.data as T;
    } on DioException {
      rethrow;
    }
  }

  // DELETE isteği
  Future<T> delete<T>({
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    T Function(dynamic)? parser,
  }) async {
    try {
      final response = await _dio.delete(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );

      if (parser != null) {
        return parser(response.data);
      }

      return response.data as T;
    } on DioException {
      rethrow;
    }
  }
}
