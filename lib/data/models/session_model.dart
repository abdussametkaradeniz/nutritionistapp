import '../../domain/repositories/auth_repository.dart';

class SessionModel extends Session {
  SessionModel({
    required super.id,
    super.deviceId,
    super.deviceType,
    super.ipAddress,
    super.userAgent,
    required super.lastActivity,
    required super.isActive,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      deviceId: json['deviceId'] as String?,
      deviceType: json['deviceType'] as String?,
      ipAddress: json['ipAddress'] as String?,
      userAgent: json['userAgent'] as String?,
      lastActivity: DateTime.parse(json['lastActivity'] as String),
      isActive: json['isActive'] as bool,
    );
  }
}
