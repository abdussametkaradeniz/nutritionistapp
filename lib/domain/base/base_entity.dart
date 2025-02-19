// Tüm entity'ler için temel sınıf
abstract class BaseEntity {
  const BaseEntity(); // Constant constructor ekle

  // Entity'lerin eşitlik kontrolü için
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseEntity && runtimeType == other.runtimeType;

  @override
  int get hashCode => 0;

  // Entity'yi Map'e çevirmek için
  Map<String, dynamic> toJson();
}
