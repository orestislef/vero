//'available', 'on_route', 'off_duty'

enum TruckStatus { available, onRoute, offDuty }

extension TruckStatusExtension on TruckStatus {
  static TruckStatus fromString(String value) {
    switch (value) {
      case 'available':
        return TruckStatus.available;
      case 'on_route':
        return TruckStatus.onRoute;
      case 'off_duty':
        return TruckStatus.offDuty;
      default:
        return TruckStatus.available;
    }
  }

  static String enumToString(TruckStatus value) {
    switch (value) {
      case TruckStatus.available:
        return 'available';
      case TruckStatus.onRoute:
        return 'on_route';
      case TruckStatus.offDuty:
        return 'off_duty';
      default:
        return 'unknown';
    }
  }
}
