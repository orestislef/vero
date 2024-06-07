class TrucksResponse {
  late String message;
  late List<Truck> trucks;

  TrucksResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    trucks = <Truck>[];
    if (json['trucks'] != null) {
      json['trucks'].forEach((v) {
        trucks.add(Truck.fromJson(v));
      });
    }
  }
}

class Truck {
  late int id;
  late String truckName;
  late String licensePlate;
  late String status;

  Truck.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    truckName = json['truck_name'];
    licensePlate = json['license_plate'];
    status = json['status'];
  }
}
