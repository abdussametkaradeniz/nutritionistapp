import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final cacheManagerProvider = Provider<CacheManager>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return CacheManager(prefs);
});

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

class CacheManager {
  final SharedPreferences _prefs;

  // Cache için varsayılan süre (24 saat)
  static const int defaultCacheDuration = 24 * 60 * 60;

  CacheManager(this._prefs);

  Future<void> init() async {
    // _prefs is already initialized when the CacheManager is created
  }

  Future<void> setData(String key, dynamic data, {int? duration}) async {
    // Cache data formatı:
    // {
    //   "data": actual_data,
    //   "timestamp": cache_time,
    //   "duration": cache_duration
    // }

    final cacheData = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'duration': duration ?? defaultCacheDuration,
    };

    await _prefs.setString(key, jsonEncode(cacheData));
  }

  Future<T?> getData<T>(String key) async {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return null;

    final cacheData = jsonDecode(jsonString);
    final timestamp = cacheData['timestamp'] as int;
    final duration = cacheData['duration'] as int;

    // Cache süresi dolmuş mu kontrol et
    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    if (age > duration * 1000) {
      // Cache süresi dolmuşsa veriyi sil
      await _prefs.remove(key);
      return null;
    }

    return cacheData['data'] as T;
  }

  Future<void> removeData(String key) async {
    await _prefs.remove(key);
  }

  Future<void> clearCache() async {
    await _prefs.clear();
  }

  bool hasValidCache(String key) {
    final jsonString = _prefs.getString(key);
    if (jsonString == null) return false;

    final cacheData = jsonDecode(jsonString);
    final timestamp = cacheData['timestamp'] as int;
    final duration = cacheData['duration'] as int;

    final age = DateTime.now().millisecondsSinceEpoch - timestamp;
    return age <= duration * 1000;
  }

  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }

  Future<String?> read(String key) async {
    return _prefs.getString(key);
  }

  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
}
