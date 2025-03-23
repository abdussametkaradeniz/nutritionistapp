import '../base/base_entity.dart';

class Permission extends BaseEntity {
  final String id;
  final String name;
  final String description;
  final DateTime lastUpdateDate;
  final String? lastUpdatingUser;
  final String? recordStatus;

  const Permission({
    required this.id,
    required this.name,
    required this.description,
    required this.lastUpdateDate,
    this.lastUpdatingUser,
    this.recordStatus,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      lastUpdatingUser: json['lastUpdatingUser'],
      recordStatus: json['recordStatus'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'lastUpdateDate': lastUpdateDate.toIso8601String(),
        'lastUpdatingUser': lastUpdatingUser,
        'recordStatus': recordStatus,
      };
}
