import 'package:diet_app/domain/entities/permission.dart';

import '../base/base_entity.dart';
import '../entities/role.dart';

class User extends BaseEntity {
  final int id;
  final String email;
  final String username;
  final String? phoneNumber;
  final String? fullName;
  final DateTime? birthDate;
  final String? gender;
  final double? height;
  final double? weight;
  final String? address;
  final String? avatarUrl;
  final bool emailVerified;
  final int? dietitianId;
  final Role role;
  final List<dynamic> permissions;
  final bool twoFactorEnabled;
  final DateTime createdAt;
  final DateTime lastUpdateDate;
  final String? lastUpdatingUser;
  final String? recordStatus;
  final String? publicKey;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.phoneNumber,
    this.fullName,
    this.birthDate,
    this.gender,
    this.height,
    this.weight,
    this.address,
    this.avatarUrl,
    this.emailVerified = false,
    this.dietitianId,
    required this.role,
    this.permissions = const <Permission>[],
    this.twoFactorEnabled = false,
    required this.createdAt,
    required this.lastUpdateDate,
    this.lastUpdatingUser,
    this.recordStatus = 'A',
    this.publicKey,
  });

  @override
  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'email': email,
        'username': username,
        'phoneNumber': phoneNumber,
        'fullName': fullName,
        'birthDate': birthDate?.toIso8601String(),
        'gender': gender,
        'height': height,
        'weight': weight,
        'address': address,
        'avatarUrl': avatarUrl,
        'emailVerified': emailVerified,
        'dietitianId': dietitianId,
        'role': role.toJson(),
        'permissions': role.permissions.map((p) => p.name).toList(),
        'twoFactorEnabled': twoFactorEnabled,
        'createdAt': createdAt.toIso8601String(),
        'lastUpdateDate': lastUpdateDate.toIso8601String(),
        'lastUpdatingUser': lastUpdatingUser,
        'recordStatus': recordStatus,
        'publicKey': publicKey,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          email == other.email &&
          username == other.username;

  @override
  int get hashCode => id.hashCode ^ email.hashCode ^ username.hashCode;

  bool hasPermission(String permissionName) {
    if (permissions.any((permission) => permission.name == permissionName)) {
      return true;
    }
    return role.permissions
        .any((permission) => permission.name == permissionName);
  }
}
