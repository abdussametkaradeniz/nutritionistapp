import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/cache_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  final cacheManager = ref.watch(cacheManagerProvider);
  return AuthLocalDataSource(secureStorage, cacheManager);
});

class AuthLocalDataSource {
  final SecureStorage _secureStorage;
  final CacheManager _cacheManager;

  AuthLocalDataSource(this._secureStorage, this._cacheManager);

  Future<void> cacheUser(Map<String, dynamic> user) async {
    await _cacheManager.write('user', jsonEncode(user));
  }

  Future<Map<String, dynamic>?> getUser() async {
    final userStr = await _cacheManager.read('user');
    if (userStr != null) {
      return jsonDecode(userStr) as Map<String, dynamic>;
    }
    return null;
  }

  Future<void> clearUser() async {
    await _cacheManager.remove('user');
    await _secureStorage.clearTokens();
    await _secureStorage.clearSessionId();
  }

  Future<void> saveToken(String token) async {
    await _secureStorage.setToken(token);
  }

  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.setRefreshToken(token);
  }

  Future<String?> getToken() async {
    return await _secureStorage.getToken();
  }

  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

  Future<void> clearTokens() async {
    await _secureStorage.clearTokens();
  }

  Future<String?> getSessionId() async {
    return await _secureStorage.getSessionId();
  }

  Future<void> saveSessionId(String sessionId) async {
    await _secureStorage.setSessionId(sessionId);
  }

  Future<void> clearSessionId() async {
    await _secureStorage.clearSessionId();
  }

  Future<Map<String, dynamic>?> getCachedUser() async {
    final userStr = await _cacheManager.read('user');
    if (userStr != null) {
      return jsonDecode(userStr) as Map<String, dynamic>;
    }
    return null;
  }
}
