import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';

class AuthInterceptor extends Interceptor {
  final SecureStorage _secureStorage;
  final Dio _dio;
  bool _isRefreshing = false;

  AuthInterceptor(this._dio, this._secureStorage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Her istekte token'ı header'a ekle
    final token = await _secureStorage.getToken();
    final sessionId = await _secureStorage.getSessionId();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    if (sessionId != null) {
      options.headers['x-session-id'] = sessionId;
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Token expired durumunu yakala
    if (err.response?.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final newToken = await _refreshToken();
        if (newToken != null) {
          // Başarısız olan isteği yeni token ile tekrarla
          final response = await _retryRequest(err.requestOptions, newToken);
          return handler.resolve(response);
        }
      } catch (e) {
        // Token yenileme başarısız, kullanıcıyı logout yap
        await _handleLogout();
      } finally {
        _isRefreshing = false;
      }
    }
    return handler.next(err);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();
      if (refreshToken == null) return null;

      final response = await _dio.post(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );

      final newToken = response.data['access_token'];
      await _secureStorage.setToken(newToken);
      return newToken;
    } catch (e) {
      return null;
    }
  }

  Future<Response<dynamic>> _retryRequest(
    RequestOptions requestOptions,
    String newToken,
  ) async {
    final options = Options(
      method: requestOptions.method,
      headers: {
        ...requestOptions.headers,
        'Authorization': 'Bearer $newToken',
      },
    );

    return _dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }

  Future<void> _handleLogout() async {
    await _secureStorage.clearTokens();
    // TODO: Navigate to login screen
  }
}
