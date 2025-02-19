import 'package:diet_app/core/storage/secure_storage.dart';
import 'package:diet_app/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/auth/sign_in_usecase.dart';
import '../../../domain/usecases/auth/sign_up_usecase.dart';
import '../../../domain/usecases/auth/enable_2fa_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';
import '../../../core/utils/error_handler.dart';
import '../../../domain/base/base_failure.dart';
import 'package:dio/dio.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final signInUseCase = ref.watch(signInUseCaseProvider);
  final signUpUseCase = ref.watch(signUpUseCaseProvider);
  final enable2FAUseCase = ref.watch(enable2FAUseCaseProvider);
  final secureStorage = ref.watch(secureStorageProvider);

  return AuthNotifier(
    repository: repository,
    signInUseCase: signInUseCase,
    signUpUseCase: signUpUseCase,
    enable2FAUseCase: enable2FAUseCase,
    secureStorage: secureStorage,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final Enable2FAUseCase _enable2FAUseCase;
  final SecureStorage _secureStorage;

  AuthNotifier({
    required AuthRepository repository,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required Enable2FAUseCase enable2FAUseCase,
    required SecureStorage secureStorage,
  })  : _authRepository = repository,
        _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _enable2FAUseCase = enable2FAUseCase,
        _secureStorage = secureStorage,
        super(const AuthState.initial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      final userResult = await _authRepository.getCurrentUser();

      userResult.fold(
        (failure) => state = const AuthState.unauthenticated(),
        (user) {
          if (user != null) {
            state = AuthState.authenticated(user);
          } else {
            state = const AuthState.unauthenticated();
          }
        },
      );
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  Future<void> signIn(String email, String password) async {
    state = const AuthState.loading();

    final result = await _signInUseCase(
      SignInParams(email: email, password: password),
    );

    state = result.fold(
      (failure) => AuthState.error(failure),
      (user) => AuthState.authenticated(user),
    );
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    state = const AuthState.loading();

    try {
      final result = await _signUpUseCase(
        SignUpParams(
          email: email,
          password: password,
          username: username,
          fullName: fullName,
        ),
      );

      state = result.fold(
        (failure) => AuthState.error(failure),
        (user) => AuthState.authenticated(user),
      );
    } catch (e) {
      if (e is DioException) {
        // Validation hataları için
        if (e.response?.data?['errors'] != null) {
          final errors = e.response!.data['errors'] as List;
          final messages = errors.map((e) => e['message']).join('\n');
          state = AuthState.error(ServerFailure(message: messages));
          return;
        }

        // Diğer API hataları için
        state = const AuthState.error(
          ServerFailure(message: 'Bir hata oluştu, lütfen tekrar deneyin'),
        );
      } else {
        state = const AuthState.error(
          ServerFailure(message: 'Bir hata oluştu, lütfen tekrar deneyin'),
        );
      }
    }
  }

  Future<void> signOut() async {
    try {
      final sessionId = await _secureStorage.getSessionId();
      print('Session ID: $sessionId'); // Debug için

      final result = await _authRepository.signOut(sessionId: sessionId ?? '');

      result.fold(
        (failure) {
          print('Logout Error: ${failure.message}'); // Debug için
          state = AuthState.error(failure);
        },
        (_) {
          print('Logout Success'); // Debug için
          _secureStorage.clearTokens();
          _secureStorage.clearSessionId();
          state = const AuthState.unauthenticated();
        },
      );
    } catch (e) {
      print('Logout Exception: $e'); // Debug için
      state = AuthState.error(ServerFailure(message: e.toString()));
    }
  }

  Future<String?> enable2FA() async {
    final result = await _enable2FAUseCase();
    return result.fold(
      (failure) {
        state = AuthState.error(failure);
        return null;
      },
      (qrCode) => qrCode,
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    state = const AuthState.loading();

    final result = await _authRepository.sendPasswordResetEmail(email);

    state = result.fold(
      (failure) => AuthState.error(failure),
      (_) => const AuthState.initial(),
    );
  }

  Future<void> checkAuth() async {
    try {
      final token = await _secureStorage.getToken();
      final sessionId = await _secureStorage.getSessionId();

      if (token != null && sessionId != null) {
        // Token ve session varsa kullanıcı bilgisini al
        final user = await _authRepository.getCurrentUser();
        user.fold(
          (failure) => state = const AuthState.unauthenticated(),
          (user) => user != null
              ? state = AuthState.authenticated(user)
              : state = const AuthState.unauthenticated(),
        );
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }
}
