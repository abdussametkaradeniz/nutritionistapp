import 'package:diet_app/data/models/role_model.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.fullName,
    super.phoneNumber,
    super.birthDate,
    super.gender,
    super.height,
    super.weight,
    super.address,
    super.avatarUrl,
    super.emailVerified,
    super.dietitianId,
    required super.roles,
    required super.permissions,
    super.twoFactorEnabled,
    required super.createdAt,
    required super.lastUpdateDate,
    super.recordStatus,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      birthDate:
          json['birthDate'] != null ? DateTime.parse(json['birthDate']) : null,
      gender: json['gender'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      address: json['address'],
      avatarUrl: json['avatarUrl'],
      emailVerified: json['emailVerified'] ?? false,
      dietitianId: json['dietitianId'],
      roles: (json['roles'] as List?)
              ?.map((r) => RoleModel(
                    id: r['id'],
                    name: r['name'],
                    permissions: r['permissions'],
                    lastUpdateDate: DateTime.now(),
                  ))
              .toList() ??
          [],
      permissions: (json['permissions'] as List?)?.cast<String>() ?? [],
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastUpdateDate: json['lastUpdateDate'] != null
          ? DateTime.parse(json['lastUpdateDate'])
          : DateTime.now(),
      recordStatus: json['recordStatus'],
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        // Ek model-spesifik alanlar buraya eklenebilir
      };
}
