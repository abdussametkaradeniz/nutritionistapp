import 'package:diet_app/core/storage/secure_storage.dart';
import 'package:diet_app/data/datasources/auth_local_datasource.dart';
import 'package:diet_app/data/models/user_model.dart';
import 'package:diet_app/data/repositories/auth_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/usecases/auth/sign_in_usecase.dart';
import '../../../domain/usecases/auth/sign_up_usecase.dart';
import '../../../domain/usecases/auth/enable_2fa_usecase.dart';
import '../../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';
import '../../../domain/base/base_failure.dart';
import 'package:dio/dio.dart';

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  final signInUseCase = ref.watch(signInUseCaseProvider);
  final signUpUseCase = ref.watch(signUpUseCaseProvider);
  final enable2FAUseCase = ref.watch(enable2FAUseCaseProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthNotifier(
    repository: repository,
    signInUseCase: signInUseCase,
    signUpUseCase: signUpUseCase,
    enable2FAUseCase: enable2FAUseCase,
    secureStorage: secureStorage,
    authLocalDataSource: authLocalDataSource,
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final Enable2FAUseCase _enable2FAUseCase;
  final SecureStorage _secureStorage;
  final AuthLocalDataSource _authLocalDataSource;
  AuthNotifier({
    required AuthRepository repository,
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required Enable2FAUseCase enable2FAUseCase,
    required SecureStorage secureStorage,
    required AuthLocalDataSource authLocalDataSource,
  })  : _authRepository = repository,
        _signInUseCase = signInUseCase,
        _signUpUseCase = signUpUseCase,
        _enable2FAUseCase = enable2FAUseCase,
        _secureStorage = secureStorage,
        _authLocalDataSource = authLocalDataSource,
        super(const AuthState.initial()) {
    checkAuthStatus();
  }

  Future<void> checkAuthStatus() async {
    try {
      // YENİ KULLANIM
      final userJson = await _authLocalDataSource.getUser();
      final user = userJson != null ? UserModel.fromJson(userJson) : null;

      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
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
    required String firstName,
    required String lastName,
  }) async {
    state = const AuthState.loading();

    try {
      final result = await _signUpUseCase(
        SignUpParams(
          email: email,
          password: password,
          username: username,
          firstName: firstName,
          lastName: lastName,
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

      final result = await _authRepository.signOut(sessionId: sessionId ?? '');

      result.fold(
        (failure) {
          state = AuthState.error(failure);
        },
        (_) {
          _secureStorage.clearTokens();
          _secureStorage.clearSessionId();
          state = const AuthState.unauthenticated();
        },
      );
    } catch (e) {
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
        final userJson = await _authLocalDataSource.getUser();
        final user = userJson != null ? UserModel.fromJson(userJson) : null;

        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }
}
