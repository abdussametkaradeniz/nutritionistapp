import 'permission.dart';
import '../base/base_entity.dart';

enum UserRole { admin, dietitian, premiumUser, basicUser }

class Role extends BaseEntity {
  final int id;
  final String name;
  final List<dynamic> permissions;
  final DateTime lastUpdateDate;
  final String? lastUpdatingUser;
  final String? recordStatus;

  const Role({
    required this.id,
    required this.name,
    required this.permissions,
    required this.lastUpdateDate,
    this.lastUpdatingUser,
    this.recordStatus,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      permissions: json['permissions'],
      lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
      lastUpdatingUser: json['lastUpdatingUser'],
      recordStatus: json['recordStatus'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'permissions': permissions.map((p) => p.toJson()).toList(),
        'lastUpdateDate': lastUpdateDate.toIso8601String(),
        'lastUpdatingUser': lastUpdatingUser,
        'recordStatus': recordStatus,
      };
}
