import 'dart:convert';

import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class LocationHelper {
  LocationHelper._();

  factory LocationHelper() {
    return instance;
  }

  static final LocationHelper instance = LocationHelper._();
  final Location _location = Location();

  Future initializeService() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  LatLng? lastKnownLocation;
  LocationData? lastKnownLocationData;

  Future<LocationData> getLocation() async {
    return await Location().getLocation();
  }

  Future<LatLng> getLocationLatLng() async {
    final location = await Location().getLocation();
    LatLng latLng = LatLng(location.latitude!, location.longitude!);
    lastKnownLocation = latLng;
    lastKnownLocationData = location;
    return latLng;
  }

  Stream<LocationData> get locationStream => _location.onLocationChanged;

  String locationToJsonString(LocationData location) {
    return jsonEncode({
      'latitude': location.latitude,
      'longitude': location.longitude,
      'altitude': location.altitude,
      'accuracy': location.accuracy,
      'speed': location.speed,
      'heading': location.heading,
      'time': location.time,
      'is_mock': location.isMock,
      'vertical_accuracy': location.verticalAccuracy,
      'heading_accuracy': location.headingAccuracy,
      'elapsed_realtime_nanos': location.elapsedRealtimeNanos,
      'elapsed_realtime_uncertainty_nanos':
      location.elapsedRealtimeUncertaintyNanos,
      'satellite_number': location.satelliteNumber,
      'provider': location.provider,
    }).toString();
  }
}
