import '../../domain/entities/permission.dart';

class PermissionModel extends Permission {
  PermissionModel({
    required super.id,
    required super.name,
    required super.description,
    required super.lastUpdateDate,
    super.lastUpdatingUser,
    super.recordStatus,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) =>
      PermissionModel(
        id: json['id'],
        name: json['name'],
        description: json['description'],
        lastUpdateDate: DateTime.parse(json['lastUpdateDate']),
        lastUpdatingUser: json['lastUpdatingUser'],
        recordStatus: json['recordStatus'],
      );
}
