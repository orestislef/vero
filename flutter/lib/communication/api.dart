import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:vero/helpers/location_helper.dart';

class Api {
  Api._();

  factory Api() {
    return _instance;
  }

  static final Api _instance = Api._();

  String? _token;


  String? get token => _token;

  Future<http.Response> updateDriver({
    required int id,
    required String name,
    required String phone,
  }) async {
    await LocationHelper().initializeService();
    LocationData location = await LocationHelper().getLocation();
    String locationString = '';
    if (!kIsWeb && await GeocodingPlatform.instance!.isPresent()) {
      List<Placemark>? placemarks = await GeocodingPlatform.instance
          ?.placemarkFromCoordinates(location.latitude!, location.longitude!);
      if (placemarks != null && placemarks.isNotEmpty) {
        locationString = placemarks[0].toString();
      }
    }

    final response = await http.put(
      Uri.parse(
          'http://192.168.24.21:8080/vero/index.php?action=update_driver'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'name': name,
        'phone': phone,
        'last_location_date': DateTime.now().toIso8601String(),
        'current_location_json':
            LocationHelper().locationToJsonString(location),
        'current_location_string': locationString
      }),
    );

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> addDriver(
      {required String name, required String phone}) async {
    final response = await http.post(
      Uri.parse('http://192.168.24.21:8080/vero/index.php?action=add_driver'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'phone': phone,
      }),
    );

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> addTruck(
      {required String truckName, required String licensePlate}) async {
    final response = await http.post(
      Uri.parse('http://192.168.24.21:8080/vero/index.php?action=add_truck'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'truck_name': truckName,
        'license_plate': licensePlate,
      }),
    );

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> getAllDrivers() async {
    final response = await http.get(
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      Uri.parse(
          'http://192.168.24.21:8080/vero/index.php?action=get_all_drivers'),
    );

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> getAllTrucks() async {
    final response = await http.get(
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      Uri.parse(
          'http://192.168.24.21:8080/vero/index.php?action=get_all_trucks'),
    );

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> updateTruck({
    required int id,
    required String truckName,
    required String licencePlate,
  }) async {
    final response = await http.put(
      Uri.parse('http://192.168.24.21:8080/vero/index.php?action=update_truck'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'id': id.toString(),
        'truck_name': truckName,
        'license_plate': licencePlate,
      }),
    );
    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> assignTruckToDriver(
      {required int driverId, required int truckId}) async {
    final response = await http.put(
      Uri.parse(
          'http://192.168.24.21:8080/vero/index.php?action=assign_truck_to_driver'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'driver_id': driverId.toString(),
        'truck_id': truckId.toString(),
      }),
    );

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> getAllRoutes() async {
    final response = await http.get(
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      Uri.parse(
          'http://192.168.24.21:8080/vero/index.php?action=get_all_routes'),
    );

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> addRoute({
    required String routeName,
    required String startLocationString,
    required String endLocationString,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final response = await http.post(
      Uri.parse('http://192.168.24.21:8080/vero/index.php?action=add_route'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'route_name': routeName,
        'start_location_string': startLocationString,
        'end_location_string': endLocationString,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
      }),
    );

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> register(
      {required String username, required String password}) async {
    final response = await http.post(
      Uri.parse('http://192.168.24.21:8080/vero/index.php?action=register'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      if (token != null) {
        _token = token;
      }
      debugPrint('Token: $token');
    }

    debugPrint(response.body.toString());
    return response;
  }

  Future<http.Response> login(
      {required String username, required String password}) async {
    final response = await http.post(
      Uri.parse('http://192.168.24.21:8080/vero/index.php?action=login'),
      headers: <String, String>{
        'Authorization': 'Bearer $_token',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['token'];
      if (token != null) {
        _token = token;
      }
      debugPrint('Token: $token');
    }

    debugPrint(response.body.toString());
    return response;
  }
}
