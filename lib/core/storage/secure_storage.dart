import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage() : _storage = const FlutterSecureStorage();

  Future<String?> getToken() async {
    return _storage.read(key: 'access_token');
  }

  Future<String?> getRefreshToken() async {
    return _storage.read(key: 'refresh_token');
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'access_token', value: token);
  }

  Future<void> setRefreshToken(String token) async {
    await _storage.write(key: 'refresh_token', value: token);
  }

  Future<void> clearTokens() async {
    await _storage.deleteAll();
  }

  Future<String?> getSessionId() async {
    return _storage.read(key: 'session_id');
  }

  Future<void> setSessionId(String sessionId) async {
    await _storage.write(key: 'session_id', value: sessionId);
  }

  Future<void> clearSessionId() async {
    await _storage.delete(key: 'session_id');
  }
}
