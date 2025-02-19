import 'package:diet_app/data/repositories/auth_repository_impl.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_failure.dart';
import '../../base/base_usecase.dart';
import '../../repositories/auth_repository.dart';

final enable2FAUseCaseProvider = Provider<Enable2FAUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return Enable2FAUseCase(repository);
});

class Enable2FAUseCase implements UseCase<Either<Failure, String>, void> {
  final AuthRepository _repository;

  Enable2FAUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call([void params]) {
    return _repository.enable2FA();
  }
}
