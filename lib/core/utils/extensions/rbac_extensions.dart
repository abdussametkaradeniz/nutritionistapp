import '../../../domain/entities/user.dart';

extension RBACExtensions on User {
  bool hasRole(String roleName) {
    return roles.any((role) => role.name == roleName);
  }

  bool hasAnyRole(List<String> roleNames) {
    return roleNames.any(hasRole);
  }

  bool hasPermission(String permissionName) {
    return permissions.contains(permissionName) ||
        roles.any(
            (role) => role.permissions.any((p) => p.name == permissionName));
  }

  bool hasAnyPermission(List<String> permissionNames) {
    return permissionNames.any(hasPermission);
  }

  bool hasAllPermissions(List<String> permissionNames) {
    return permissionNames.every(hasPermission);
  }
}
