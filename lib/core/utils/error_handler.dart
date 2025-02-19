import 'package:dio/dio.dart';

class ErrorHandler {
  static String handleError(dynamic error) {
    if (error is DioException) {
      // Rate limit hatası için direkt response text'i kullan
      if (error.response?.statusCode == 429) {
        return error.response?.data.toString() ?? 'Çok fazla deneme yapıldı';
      }

      // Diğer API hataları için
      if (error.response?.data != null) {
        final data = error.response?.data;

        // Validation errors array
        if (data['errors'] != null) {
          final messages = (data['errors'] as List)
              .map((e) => e['message'].toString())
              .toList();
          return messages.join('\n');
        }
      }
    }

    // Genel hata durumları
    if (error.toString().contains('SocketException')) {
      return 'İnternet bağlantınızı kontrol edin';
    }

    if (error.toString().contains('TimeoutException')) {
      return 'Sunucu yanıt vermiyor, lütfen tekrar deneyin';
    }

    return 'Bir hata oluştu, lütfen tekrar deneyin';
  }
}
