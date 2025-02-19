import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  // Theme extensions
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => theme.textTheme;
  ColorScheme get colorScheme => theme.colorScheme;

  // Size extensions
  double get height => MediaQuery.of(this).size.height;
  double get width => MediaQuery.of(this).size.width;

  // Padding values
  EdgeInsets get paddingLow => const EdgeInsets.all(8);
  EdgeInsets get paddingNormal => const EdgeInsets.all(16);
  EdgeInsets get paddingMedium => const EdgeInsets.all(24);
  EdgeInsets get paddingHigh => const EdgeInsets.all(32);

  // Responsive padding
  EdgeInsets get horizontalPaddingLow =>
      EdgeInsets.symmetric(horizontal: width * 0.02);
  EdgeInsets get horizontalPaddingNormal =>
      EdgeInsets.symmetric(horizontal: width * 0.05);
  EdgeInsets get horizontalPaddingHigh =>
      EdgeInsets.symmetric(horizontal: width * 0.1);

  // Navigation shortcuts
  void pop<T>([T? result]) => Navigator.pop(this, result);
  Future<T?> push<T>(Widget widget) => Navigator.push<T>(
        this,
        MaterialPageRoute(builder: (context) => widget),
      );

  // Show dialog/bottom sheet shortcuts
  Future<T?> showBottomSheet<T>(Widget child) => showModalBottomSheet<T>(
        context: this,
        builder: (context) => child,
      );

  // Snackbar shortcuts
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
