import 'package:dio/dio.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // API'den gelen hata mesajını çözümleme
    String errorMessage = 'Bir hata oluştu';
    if (err.response != null && err.response!.data != null) {
      final responseData = err.response!.data;
      if (responseData is Map<String, dynamic> &&
          responseData.containsKey('message')) {
        errorMessage = responseData['message'];
      }
    }

    // Hata türüne göre özel işlemler
    switch (err.type) {
      case DioExceptionType.badResponse:
        errorMessage = errorMessage;
        break;
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Bağlantı zaman aşımına uğradı';
        break;
      case DioExceptionType.cancel:
        errorMessage = 'İstek iptal edildi';
        break;
      case DioExceptionType.unknown:
        errorMessage = 'Bir ağ hatası oluştu';
        break;
      default:
        break;
    }

    // Orijinal hatayı değiştirip, standart formata çeviriyoruz
    final error = DioException(
      requestOptions: err.requestOptions,
      error: errorMessage,
      response: null,
      type: err.type,
    );

    handler.next(error);
  }
}
