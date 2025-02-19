// Tüm repository'ler için temel sınıf
abstract class BaseRepository {
  // Ortak repository metodları buraya eklenebilir
  Future<bool> isConnected();
  Future<void> clearCache();
}
