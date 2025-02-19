import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final errorMessage = _handleError(err);

    // Orijinal hatayı değiştirip, standart formata çeviriyoruz
    final error = DioException(
      requestOptions: err.requestOptions,
      error: errorMessage,
      response: err.response,
      type: err.type,
    );

    return handler.next(error);
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'TimeoutException';

      case DioExceptionType.connectionError:
        return 'NetworkException';

      case DioExceptionType.badResponse:
        return _handleResponseError(error.response?.statusCode);

      default:
        return 'UnknownException';
    }
  }

  String _handleResponseError(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'BadRequestException';
      case 401:
        return 'UnauthorizedException';
      case 403:
        return 'ForbiddenException';
      case 404:
        return 'NotFoundException';
      case 500:
        return 'ServerException';
      default:
        return 'UnknownException';
    }
  }
}
