import 'package:vero/enums/driver_status.dart';

class DriversResponse {
  late String message;
  late List<Driver> drivers;

  DriversResponse({required this.message, required this.drivers});

  factory DriversResponse.fromJson(Map<String, dynamic> json) {
    List<Driver> drivers = [];
    if (json['drivers'] != null) {
      json['drivers'].forEach((driver) {
        drivers.add(Driver.fromJson(driver));
      });
    }
    return DriversResponse(
      message: json['message'],
      drivers: drivers,
    );
  }
}

class Driver {
  late int id;
  late String name;
  late String phone;
  String? lastLocationDate;
  String? currentLocationString;
  String? currentLocationJson;
  late DriverStatus status;
  int? truckId;

  Driver({required this.id,
    required this.name,
    required this.phone,
    this.lastLocationDate,
    this.currentLocationString,
    this.currentLocationJson,
    required this.status,
    this.truckId});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        id: json['id'],
        name: json['name'],
        phone: json['phone'],
        lastLocationDate: json['last_location_date'],
        currentLocationString: json['current_location_string'],
        currentLocationJson: json['current_location_json'],
        status: DriverStatusExtension.fromString(json['status']),
        truckId: json['truck_id']);
  }
}
