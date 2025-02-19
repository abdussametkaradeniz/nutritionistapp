// Tüm use case'ler için temel sınıf
abstract class UseCase<Type, Params> {
  Future<Type> call(Params params);
}

// Parametre gerektirmeyen use case'ler için
abstract class NoParamsUseCase<Type> {
  Future<Type> call();
}
