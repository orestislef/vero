enum UserStatus { admin, driver }

extension UserStatusExtension on UserStatus {
  static UserStatus fromString(String value) {
    switch (value) {
      case 'admin':
        return UserStatus.admin;
      case 'driver':
        return UserStatus.driver;
      default:
        return UserStatus.driver;
    }
  }

  static String enumToString(UserStatus value) {
    switch (value) {
      case UserStatus.admin:
        return 'admin';
      case UserStatus.driver:
        return 'driver';
      default:
        return 'unknown';
    }
  }
}
