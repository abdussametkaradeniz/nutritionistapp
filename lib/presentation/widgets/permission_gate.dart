import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth/auth_notifier.dart';

class PermissionGate extends ConsumerWidget {
  final String permissionName;
  final Widget child;
  final Widget? fallback;

  const PermissionGate({
    super.key,
    required this.permissionName,
    required this.child,
    this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(authNotifierProvider).maybeWhen(
          authenticated: (user) {
            if (user.hasPermission(permissionName)) {
              return child;
            }
            return fallback ?? const SizedBox.shrink();
          },
          orElse: () => fallback ?? const SizedBox.shrink(),
        );
  }
}
