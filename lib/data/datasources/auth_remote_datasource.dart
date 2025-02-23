import 'package:diet_app/core/storage/secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../domain/repositories/auth_repository.dart'; // Session için
import '../models/session_model.dart';
import 'package:dio/dio.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final secureStorage = ref.watch(secureStorageProvider);
  return AuthRemoteDataSource(apiClient, secureStorage);
});

class AuthRemoteDataSource {
  final ApiClient _apiClient;
  final SecureStorage _secureStorage;

  AuthRemoteDataSource(this._apiClient, this._secureStorage);

  Future<Map<String, dynamic>> signIn(String email, String password) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      path: ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (response['sessionId'] != null) {
      final sessionId = response['sessionId']['id'];
      await _secureStorage.setSessionId(sessionId);
    }

    if (response['accessToken'] != null) {
      await _secureStorage.setToken(response['accessToken']);
    }

    if (response['refreshToken'] != null) {
      await _secureStorage.setRefreshToken(response['refreshToken']);
    }

    return response['user'];
  }

  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    required String username,
    required String firstName,
    required String lastName,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      path: ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        'username': username,
        'firstName': firstName,
        'lastName': lastName,
      },
    );
    return response;
  }

  Future<void> signOut({required String sessionId}) async {
    await _apiClient.post(
      path: ApiEndpoints.logout,
      options: Options(
        headers: {
          'x-session-id': sessionId,
        },
      ),
    );
  }

  Future<String> refreshToken(String refreshToken) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      path: ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );
    return response['accessToken'];
  }

  Future<void> sendEmailVerification() async {
    await _apiClient.post(
      path: ApiEndpoints.sendEmailVerification,
    );
  }

  Future<void> verifyEmail(String token) async {
    await _apiClient.post(
      path: ApiEndpoints.verifyEmail,
      data: {'token': token},
    );
  }

  Future<String> enable2FA() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      path: ApiEndpoints.enable2FA,
    );
    return response['qrCode'];
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    await _apiClient.post(
      path: ApiEndpoints.changePassword,
      data: {
        'oldPassword': oldPassword,
        'newPassword': newPassword,
      },
    );
  }

  Future<void> deleteAvatar() async {
    await _apiClient.delete(path: ApiEndpoints.updateAvatar);
  }

  Future<void> disable2FA(String code) async {
    await _apiClient.post(
      path: ApiEndpoints.disable2FA,
      data: {'code': code},
    );
  }

  Future<List<String>> generateBackupCodes() async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      path: ApiEndpoints.generateBackupCodes,
    );
    return List<String>.from(response['codes']);
  }

  Future<List<Session>> getActiveSessions() async {
    final response = await _apiClient.get<List<dynamic>>(
      path: ApiEndpoints.sessions,
    );
    return response.map((json) => SessionModel.fromJson(json)).toList();
  }

  Stream<Map<String, dynamic>?> get onAuthStateChanged =>
      const Stream.empty(); // Firebase gibi real-time auth için

  Future<void> resetPassword(String token, String newPassword) async {
    await _apiClient.post(
      path: ApiEndpoints.resetPassword,
      data: {
        'token': token,
        'newPassword': newPassword,
      },
    );
  }

  Future<void> revokeToken(String refreshToken) async {
    await _apiClient.post(
      path: ApiEndpoints.revokeToken,
      data: {'refreshToken': refreshToken},
    );
  }

  Future<void> terminateAllSessions() async {
    await _apiClient.post(path: ApiEndpoints.terminateAllSessions);
  }

  Future<void> terminateSession(String sessionId) async {
    await _apiClient.post(
      path: ApiEndpoints.terminateSession,
      data: {'sessionId': sessionId},
    );
  }

  Future<void> updateAvatar(String avatarUrl) async {
    await _apiClient.put(
      path: ApiEndpoints.updateAvatar,
      data: {'avatarUrl': avatarUrl},
    );
  }

  Future<Map<String, dynamic>> updateProfile({
    String? fullName,
    String? phoneNumber,
    DateTime? birthDate,
    String? gender,
    double? height,
    double? weight,
    String? address,
  }) async {
    final response = await _apiClient.put<Map<String, dynamic>>(
      path: ApiEndpoints.updateProfile,
      data: {
        if (fullName != null) 'fullName': fullName,
        if (phoneNumber != null) 'phoneNumber': phoneNumber,
        if (birthDate != null) 'birthDate': birthDate.toIso8601String(),
        if (gender != null) 'gender': gender,
        if (height != null) 'height': height,
        if (weight != null) 'weight': weight,
        if (address != null) 'address': address,
      },
    );
    return response;
  }

  Future<void> verify2FA(String code) async {
    await _apiClient.post(
      path: ApiEndpoints.verify2FA,
      data: {'code': code},
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _apiClient.post(
      path: ApiEndpoints.sendPasswordResetEmail,
      data: {'email': email},
    );
  }

  Future<void> ping() async {
    await _apiClient.get(path: ApiEndpoints.ping);
  }

  // Diğer API çağrıları...
}
