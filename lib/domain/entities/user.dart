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
  final List<Role> roles;
  final List<String> permissions;
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
    required this.roles,
    this.permissions = const [],
    this.twoFactorEnabled = false,
    required this.createdAt,
    required this.lastUpdateDate,
    this.lastUpdatingUser,
    this.recordStatus = 'A',
    this.publicKey,
  });

  @override
  Map<String, dynamic> toJson() => {
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
        'roles': roles.map((role) => role.toJson()).toList(),
        'permissions': permissions,
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
    if (permissions.contains(permissionName)) return true;
    return roles.any((role) => role.permissions
        .any((permission) => permission.name == permissionName));
  }
}
