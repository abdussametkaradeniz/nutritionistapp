import 'package:diet_app/data/models/permission_model.dart';

import '../../domain/entities/role.dart';

class RoleModel extends Role {
  RoleModel({
    required super.id,
    required super.name,
    required super.permissions,
    required super.lastUpdateDate,
    super.lastUpdatingUser,
    super.recordStatus,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) => RoleModel(
        id: json['id'],
        name: json['name'],
        permissions: (json['permissions'] as List)
            .map((p) => PermissionModel.fromJson(p))
            .toList(),
        lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
        lastUpdatingUser: json['lastUpdatingUser'],
        recordStatus: json['recordStatus'],
      );
}
