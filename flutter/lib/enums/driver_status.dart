//available', 'on_route', 'off_duty'

enum DriverStatus { available, onRoute, offDuty }

extension DriverStatusExtension on DriverStatus {
  static DriverStatus fromString(String value) {
    switch (value) {
      case 'available':
        return DriverStatus.available;
      case 'on_route':
        return DriverStatus.onRoute;
      case 'off_duty':
        return DriverStatus.offDuty;
      default:
        return DriverStatus.available;
    }
  }

  static String enumToString(DriverStatus value) {
    switch (value) {
      case DriverStatus.available:
        return 'available';
      case DriverStatus.onRoute:
        return 'on_route';
      case DriverStatus.offDuty:
        return 'off_duty';
      default:
        return 'unknown';
    }
  }
}
