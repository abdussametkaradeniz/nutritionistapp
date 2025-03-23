import '../../../domain/entities/user.dart';

extension RBACExtensions on User {
  bool hasRole(String roleName) {
    return role.name == roleName;
  }

  bool hasAnyRole(List<String> roleNames) {
    return roleNames.any(hasRole);
  }

  bool hasPermission(String permissionName) {
    return permissions.contains(permissionName) ||
        role.permissions.any((p) => p.name == permissionName);
  }

  bool hasAnyPermission(List<String> permissionNames) {
    return permissionNames.any(hasPermission);
  }

  bool hasAllPermissions(List<String> permissionNames) {
    return permissionNames.every(hasPermission);
  }
}
