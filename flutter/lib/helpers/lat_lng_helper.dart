import 'dart:convert';

import 'package:latlong2/latlong.dart';

class LatLngHelper {
  // Converts a LatLng object to a JSON string
  static String latLngToJson(LatLng latLng) {
    Map<String, double> latLngMap = {
      'latitude': latLng.latitude,
      'longitude': latLng.longitude,
    };
    return jsonEncode(latLngMap);
  }

  // Converts a JSON string to a LatLng object
  static LatLng jsonToLatLng(String jsonString) {
    Map<String, dynamic> latLngMap = jsonDecode(jsonString);
    return LatLng(latLngMap['latitude'], latLngMap['longitude']);
  }

  // Converts a list of LatLng objects to a JSON string
  static String latLngListToJson(List<LatLng> latLngList) {
    List<Map<String, double>> latLngMapList = latLngList.map((latLng) {
      return {
        'latitude': latLng.latitude,
        'longitude': latLng.longitude,
      };
    }).toList();
    return jsonEncode(latLngMapList);
  }

  // Converts a JSON string to a list of LatLng objects
  static List<LatLng> jsonToLatLngList(String jsonString) {
    List<dynamic> latLngMapList = jsonDecode(jsonString);
    return latLngMapList.map((latLngMap) {
      return LatLng(latLngMap['latitude'], latLngMap['longitude']);
    }).toList();
  }
}
