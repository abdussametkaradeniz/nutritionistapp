import 'package:diet_app/domain/entities/role.dart';

import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.username,
    super.fullName,
    super.phoneNumber,
    super.gender,
    super.height,
    super.weight,
    super.address,
    super.avatarUrl,
    super.emailVerified,
    super.dietitianId,
    required super.role,
    super.twoFactorEnabled,
    required super.createdAt,
    required super.lastUpdateDate,
    super.recordStatus,
    this.profile,
    this.preferences,
  });

  final Profile? profile;
  final Preferences? preferences;

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      fullName: json['fullName'],
      phoneNumber: json['phoneNumber'],
      gender: json['gender'],
      height: json['height']?.toDouble(),
      weight: json['weight']?.toDouble(),
      address: json['address'],
      avatarUrl: json['avatarUrl'],
      emailVerified: json['emailVerified'] ?? false,
      dietitianId: json['dietitianId'],
      role: json['role'] != null
          ? Role.fromJson(json['role'])
          : Role(
              id: 0, name: '', permissions: [], lastUpdateDate: DateTime.now()),
      twoFactorEnabled: json['twoFactorEnabled'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      lastUpdateDate: json['lastUpdateDate'] != null
          ? DateTime.parse(json['lastUpdateDate'])
          : DateTime.now(),
      recordStatus: json['recordStatus'],
      profile:
          json['profile'] != null ? Profile.fromJson(json['profile']) : null,
      preferences: json['preferences'] != null
          ? Preferences.fromJson(json['preferences'])
          : null,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'role': role.toJson(), // Burada null kontrolü yapıldı
        if (profile != null) 'profile': profile!.toJson(),
        if (preferences != null) 'preferences': preferences!.toJson(),
      };
}

class Profile {
  final String? firstName;
  final String? secondName;
  final String? lastName;
  final int? age;
  final double? weight;
  final String? photoUrl;

  Profile({
    this.firstName,
    this.secondName,
    this.lastName,
    this.age,
    this.weight,
    this.photoUrl,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        firstName: json['firstName'],
        secondName: json['secondName'],
        lastName: json['lastName'],
        age: json['age'],
        weight: json['weight']?.toDouble(),
        photoUrl: json['photoUrl'],
      );

  Map<String, dynamic> toJson() => {
        if (firstName != null) 'firstName': firstName,
        if (secondName != null) 'secondName': secondName,
        if (lastName != null) 'lastName': lastName,
        if (age != null) 'age': age,
        if (weight != null) 'weight': weight,
        if (photoUrl != null) 'photoUrl': photoUrl,
      };
}

class Preferences {
  final String? language;
  final String? timezone;
  final String? theme;
  final bool? emailNotifications;
  final bool? pushNotifications;
  final bool? smsNotifications;

  Preferences({
    this.language,
    this.timezone,
    this.theme,
    this.emailNotifications,
    this.pushNotifications,
    this.smsNotifications,
  });

  factory Preferences.fromJson(Map<String, dynamic> json) => Preferences(
        language: json['language'],
        timezone: json['timezone'],
        theme: json['theme'],
        emailNotifications: json['emailNotifications'],
        pushNotifications: json['pushNotifications'],
        smsNotifications: json['smsNotifications'],
      );

  Map<String, dynamic> toJson() => {
        if (language != null) 'language': language,
        if (timezone != null) 'timezone': timezone,
        if (theme != null) 'theme': theme,
        if (emailNotifications != null)
          'emailNotifications': emailNotifications,
        if (pushNotifications != null) 'pushNotifications': pushNotifications,
        if (smsNotifications != null) 'smsNotifications': smsNotifications,
      };
}
