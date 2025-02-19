class ApiEndpoints {
  static const String baseUrl =
      'https://localhost:3000'; // API base URL'inizi buraya yazın

  // Auth endpoints
  static const String login = '/api/login';
  static const String register = '/api/register';
  static const String logout = '/api/logout';
  static const String refreshToken = '/api/refresh-token';
  static const String sendEmailVerification = '/api/send-verification';
  static const String verifyEmail = '/api/verify-email';
  static const String enable2FA = '/api/2fa/enable';
  static const String verify2FA = '/api/2fa/verify';
  static const String disable2FA = '/api/2fa/disable';
  static const String generateBackupCodes = '/api/2fa/backup-codes';
  static const String changePassword = '/api/change-password';
  static const String resetPassword = '/api/reset-password';
  static const String revokeToken = '/api/revoke-token';
  static const String terminateSession = '/api/sessions/terminate';
  static const String terminateAllSessions = '/api/sessions/terminate-all';
  static const String sendPasswordResetEmail = '/api/forgot-password';

  // User endpoints
  static const String profile = '/api/user/profile';
  static const String updateProfile = '/api/user/profile/update';
  static const String updateAvatar = '/api/user/profile/avatar';
  static const String sessions = '/api/user/sessions';

  // New endpoint
  static const String ping = '/api/ping';
}
