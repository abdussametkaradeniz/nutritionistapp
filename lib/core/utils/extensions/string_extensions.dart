extension StringExtensions on String {
  // Capitalization
  String get capitalize =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1)}' : '';
  String get capitalizeFirst =>
      split(' ').map((str) => str.capitalize).join(' ');

  // Validation
  bool get isValidEmail => RegExp(
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
      ).hasMatch(this);

  bool get isValidPhone => RegExp(
        r'^\+?[0-9]{10,}$',
      ).hasMatch(this);

  // Formatting
  String get hideEmail {
    if (!isValidEmail) return this;
    final parts = split('@');
    return '${parts[0][0]}****@${parts[1]}';
  }

  String get hidePhone {
    if (length < 4) return this;
    return '****${substring(length - 4)}';
  }

  // Parsing
  int? get toIntOrNull => int.tryParse(this);
  double? get toDoubleOrNull => double.tryParse(this);

  // Path operations
  String get getFileExtension => split('.').last;
  String get getFileName => split('/').last;
}
