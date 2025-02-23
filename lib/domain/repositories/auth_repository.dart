import 'package:fpdart/fpdart.dart';
import '../base/base_repository.dart';
import '../base/base_failure.dart';
import '../entities/user.dart';

abstract class AuthRepository extends BaseRepository {
  // Temel auth işlemleri
  Future<Either<Failure, User>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> signUp({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  });

  Future<Either<Failure, void>> signOut({required String sessionId});

  // Email doğrulama işlemleri
  Future<Either<Failure, void>> sendEmailVerification();
  Future<Either<Failure, void>> verifyEmail(String token);

  // Şifre sıfırlama işlemleri
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);
  Future<Either<Failure, void>> resetPassword({
    required String token,
    required String newPassword,
  });
  Future<Either<Failure, void>> changePassword({
    required String oldPassword,
    required String newPassword,
  });

  // 2FA işlemleri
  Future<Either<Failure, String>> enable2FA();
  Future<Either<Failure, void>> verify2FA(String code);
  Future<Either<Failure, void>> disable2FA(String code);
  Future<Either<Failure, List<String>>> generateBackupCodes();

  // Oturum yönetimi
  Future<Either<Failure, String>> refreshToken(String refreshToken);
  Future<Either<Failure, void>> revokeToken(String refreshToken);
  Future<Either<Failure, List<Session>>> getActiveSessions();
  Future<Either<Failure, void>> terminateSession(String sessionId);
  Future<Either<Failure, void>> terminateAllSessions();

  // Profil yönetimi
  Future<Either<Failure, User>> updateProfile({
    String? fullName,
    String? phoneNumber,
    DateTime? birthDate,
    String? gender,
    double? height,
    double? weight,
    String? address,
  });

  Future<Either<Failure, void>> updateAvatar(String avatarUrl);
  Future<Either<Failure, void>> deleteAvatar();

  // Kullanıcı durumu
  Stream<User?> get onAuthStateChanged;
}

// Session bilgisi için data class
class Session {
  final String id;
  final String? deviceId;
  final String? deviceType;
  final String? ipAddress;
  final String? userAgent;
  final DateTime lastActivity;
  final bool isActive;

  Session({
    required this.id,
    this.deviceId,
    this.deviceType,
    this.ipAddress,
    this.userAgent,
    required this.lastActivity,
    required this.isActive,
  });
}
