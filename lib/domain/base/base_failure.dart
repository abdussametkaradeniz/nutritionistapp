// Hata durumları için temel sınıf
abstract class Failure {
  final String message;
  final String? code;

  const Failure({
    required this.message,
    this.code,
  });

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

// Özel hata tipleri
class NetworkFailure extends Failure {
  const NetworkFailure({super.message = 'Network error occurred'});
}

class ServerFailure extends Failure {
  const ServerFailure({required super.message});
}

class CacheFailure extends Failure {
  const CacheFailure({super.message = 'Cache error occurred'});
}
