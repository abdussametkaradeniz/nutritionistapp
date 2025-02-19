import 'permission.dart';
import '../base/base_entity.dart';

enum UserRole { admin, dietitian, premiumUser, basicUser }

class Role extends BaseEntity {
  final String id;
  final String name;
  final List<Permission> permissions;
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
