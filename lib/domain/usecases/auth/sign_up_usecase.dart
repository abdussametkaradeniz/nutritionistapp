import 'package:diet_app/data/repositories/auth_repository_impl.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../base/base_failure.dart';
import '../../base/base_usecase.dart';
import '../../entities/user.dart';
import '../../repositories/auth_repository.dart';
import 'package:dio/dio.dart';

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repository);
});

class SignUpParams {
  final String email;
  final String password;
  final String username;
  final String firstName;
  final String lastName;

  const SignUpParams({
    required this.email,
    required this.password,
    required this.username,
    required this.firstName,
    required this.lastName,
  });
}

class SignUpUseCase implements UseCase<Either<Failure, User>, SignUpParams> {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  @override
  Future<Either<Failure, User>> call(SignUpParams params) async {
    try {
      final result = await _repository.signUp(
        email: params.email,
        password: params.password,
        username: params.username,
        firstName: params.firstName,
        lastName: params.lastName,
      );
      return result;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.data?['errors'] != null) {
          final errors = e.response!.data['errors'] as List;
          final messages = errors.map((e) => e['message']).join('\n');
          return Left(ServerFailure(message: messages));
        }
        return Left(ServerFailure(
            message: e.response?.data?.toString() ?? 'Bir hata oluştu'));
      }
      return const Left(ServerFailure(message: 'Bir hata oluştu'));
    }
  }
}
