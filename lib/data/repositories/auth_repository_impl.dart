import 'package:diet_app/data/datasources/auth_local_datasource.dart';
import 'package:diet_app/data/datasources/auth_remote_datasource.dart';
import 'package:diet_app/data/models/user_model.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/base/base_failure.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import 'package:dio/dio.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.watch(authRemoteDataSourceProvider);
  final localDataSource = ref.watch(authLocalDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource, localDataSource);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final userJson = await _remoteDataSource.signIn(email, password);
      final user = UserModel.fromJson(userJson);

      // Cache user data
      await _localDataSource.cacheUser(userJson);

      return right(user);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
    required String phoneNumber,
    required DateTime birthDate,
    required Map<String, dynamic> profile,
  }) async {
    try {
      final response = await _remoteDataSource.signUp(
        email: email,
        password: password,
        username: username,
        phoneNumber: phoneNumber,
        birthDate: birthDate,
        profile: profile,
      );

      if (response['isError'] == false && response['result'] != null) {
        final userData = response['result']['user'] as Map<String, dynamic>;
        final user = UserModel.fromJson(userData);
        await _localDataSource.cacheUser(userData);
        return right(user);
      }

      return left(const ServerFailure(message: 'Kullanıcı kaydı başarısız'));
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400 && e.response?.data is Map) {
          final data = e.response?.data as Map;
          if (data['errors'] != null) {
            final errors = (data['errors'] as List)
                .map((e) => e['message'].toString())
                .join('\n');
            return left(ServerFailure(message: errors));
          }
        }

        return left(ServerFailure(
          message: e.response?.data?.toString() ??
              'Sunucu bağlantısında hata oluştu',
        ));
      }
      return left(const ServerFailure(message: 'Beklenmeyen bir hata oluştu'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut({required String sessionId}) async {
    try {
      final sessionId = await _localDataSource.getSessionId();
      if (sessionId != null) {
        await _remoteDataSource.signOut(sessionId: sessionId);
      }
      await _localDataSource.clearUser();
      await _localDataSource.clearTokens();
      await _localDataSource.clearSessionId();
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.changePassword(oldPassword, newPassword);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAvatar() async {
    try {
      await _remoteDataSource.deleteAvatar();
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> disable2FA(String code) async {
    try {
      await _remoteDataSource.disable2FA(code);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> enable2FA() async {
    try {
      final qrCode = await _remoteDataSource.enable2FA();
      return right(qrCode);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<String>>> generateBackupCodes() async {
    try {
      final codes = await _remoteDataSource.generateBackupCodes();
      return right(codes);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Session>>> getActiveSessions() async {
    try {
      final sessions = await _remoteDataSource.getActiveSessions();
      return right(sessions);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Stream<User?> get onAuthStateChanged =>
      _remoteDataSource.onAuthStateChanged.map(
          (userJson) => userJson == null ? null : UserModel.fromJson(userJson));

  @override
  Future<Either<Failure, String>> refreshToken(String refreshToken) async {
    try {
      final newToken = await _remoteDataSource.refreshToken(refreshToken);
      await _localDataSource.saveToken(newToken);
      return right(newToken);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  }) async {
    try {
      await _remoteDataSource.resetPassword(token, newPassword);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> revokeToken(String refreshToken) async {
    try {
      await _remoteDataSource.revokeToken(refreshToken);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await _remoteDataSource.sendEmailVerification();
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateAllSessions() async {
    try {
      await _remoteDataSource.terminateAllSessions();
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> terminateSession(String sessionId) async {
    try {
      await _remoteDataSource.terminateSession(sessionId);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateAvatar(String avatarUrl) async {
    try {
      await _remoteDataSource.updateAvatar(avatarUrl);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? phoneNumber,
    DateTime? birthDate,
    String? gender,
    double? height,
    double? weight,
    String? address,
  }) async {
    try {
      final userJson = await _remoteDataSource.updateProfile(
        fullName: fullName,
        phoneNumber: phoneNumber,
        birthDate: birthDate,
        gender: gender,
        height: height,
        weight: weight,
        address: address,
      );
      return right(UserModel.fromJson(userJson));
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verify2FA(String code) async {
    try {
      await _remoteDataSource.verify2FA(code);
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<void> clearCache() async {
    await _localDataSource.clearUser();
    await _localDataSource.clearTokens();
  }

  @override
  Future<Either<Failure, void>> verifyEmail(String token) async {
    try {
      await _remoteDataSource.sendEmailVerification();
      return right(null);
    } catch (e) {
      return left(ServerFailure(message: e.toString()));
    }
  }
}
