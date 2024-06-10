enum UserStatus { admin, driver, mod, unknown }

extension UserStatusExtension on UserStatus {
  static UserStatus fromString(String value) {
    switch (value) {
      case 'admin':
        return UserStatus.admin;
      case 'driver':
        return UserStatus.driver;
      case 'mod':
        return UserStatus.mod;
      default:
        return UserStatus.unknown;
    }
  }

  static String enumToString(UserStatus value) {
    switch (value) {
      case UserStatus.admin:
        return 'admin';
      case UserStatus.driver:
        return 'driver';
      case UserStatus.mod:
        return 'mod';
      default:
        return 'unknown';
    }
  }
}
