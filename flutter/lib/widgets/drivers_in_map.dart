import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/handlers/driver_handler.dart';
import 'package:vero/helpers/lat_lng_helper.dart';

import '../communication/models/drivers.dart';
import '../enums/driver_status.dart';

class DriversInMap extends StatefulWidget {
  const DriversInMap({super.key, this.isFullScreen = true});

  final bool isFullScreen;

  @override
  State<DriversInMap> createState() => _DriversInMapState();
}

class _DriversInMapState extends State<DriversInMap> {
  late MapController mapController;
  late List<Marker> markers;
  late List<Driver> drivers;

  @override
  void initState() {
    super.initState();

    mapController = MapController();
    markers = [];
    DriverHandler.startPeriodicDriverUpdate();
    // Timer.periodic(const Duration(seconds: 5), (_) {
    //   Api().getAllDrivers().then((value) {
    //     DriversResponse response = value;
    //
    //     for (var driver in response.drivers) {
    //       if (driver.currentLocationJson != null) {
    //         markers.add(Marker(
    //           width: 100.0,
    //           height: 50.0,
    //           point: LatLngHelper.jsonToLatLng(driver.currentLocationJson!),
    //           child: _buildMarker(driver),
    //         ));
    //       }
    //     }
    //     if (markers.isNotEmpty) {
    //       mapController.fitCamera(CameraFit.coordinates(
    //           padding: const EdgeInsets.all(20.0),
    //           coordinates: markers.map((e) => e.point).toList()));
    //     }
    //   });
    // });
  }

  @override
  void dispose() {
    DriverHandler.stopPeriodicDriverUpdate();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return widget.isFullScreen ? _buildScaffold() : _buildColumn();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(title: const Text('Drivers overview')),
      body: _buildColumn(),
    );
  }

  Widget _buildColumn() {
    return FlutterMap(
      mapController: mapController,
      options: const MapOptions(
        initialCenter: LatLng(40.0, 22.0),
        initialZoom: 15.0,
        maxZoom: 18.0,
        minZoom: 6.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          minNativeZoom: 6,
          maxNativeZoom: 18,
        ),
        StreamBuilder<DriversResponse>(
          stream: DriverHandler.getController(),
          initialData: DriverHandler.lastResponse,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              drivers = snapshot.data!.drivers;
              for (var driver in drivers) {
                if (driver.currentLocationJson != null) {
                  markers = [];
                  markers.add(Marker(
                    width: 100.0,
                    height: 50.0,
                    point: LatLngHelper.jsonToLatLng(driver.currentLocationJson!),
                    child: _buildMarker(driver),
                  ));
                }
              }
              if (markers.isNotEmpty) {
                mapController.fitCamera(CameraFit.coordinates(
                    padding: const EdgeInsets.all(20.0),
                    coordinates: markers.map((e) => e.point).toList()));
              }
            }
            return MarkerLayer(markers: markers);
          }
        ),
      ],
    );
  }

  Widget _buildMarker(Driver driver) {
    return Container(
      width: 100,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getColor(driver),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            driver.name,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(Driver driver) {
    switch (driver.status) {
      case DriverStatus.available:
        return Colors.green;
      case DriverStatus.offDuty:
        return Colors.red;
      case DriverStatus.onRoute:
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
