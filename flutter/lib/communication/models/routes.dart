class RoutesResponse {
  late String message;
  late List<Route> routes;

  RoutesResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    routes = <Route>[];
    if (json['routes'] != null) {
      json['routes'].forEach((v) {
        routes.add(Route.fromJson(v));
      });
    }
  }
}

class Route {
  late int id;
  late String routeName;
  late String startLocationString;
  String? endLocationString;
  DateTime? startDate;
  DateTime? endDate;
  late String status;
  int? driverId;
  int? truckId;

  Route.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    routeName = json['route_name'];
    startLocationString = json['start_location_string'];
    endLocationString = json['end_location_string'];
    startDate =
        json['start_date'] != null ? DateTime.parse(json['start_date']) : null;
    endDate =
        json['end_date'] != null ? DateTime.parse(json['end_date']) : null;
    status = json['status'];
    driverId = json['driver_id'];
    truckId = json['truck_id'];
  }
}
