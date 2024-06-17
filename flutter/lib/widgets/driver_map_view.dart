import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:vero/communication/models/drivers.dart';

class DriverMapView extends StatelessWidget {
  const DriverMapView({super.key, required this.drivers});

  final List<Driver> drivers;

  @override
  Widget build(BuildContext context) {
    List<LatLng> points = [];

    for (var i = 0; i < drivers.length; i++) {
      points.add(LatLng(
          jsonDecode(drivers[i].currentLocationJson!)['latitude'] as double,
          jsonDecode(drivers[i].currentLocationJson!)['longitude'] as double));
    }
    return FlutterMap(
      mapController: MapController(),
      options: MapOptions(
        initialCameraFit: CameraFit.coordinates(
          coordinates: points,
          padding: const EdgeInsets.all(20.0),
        ),
        initialZoom: 15.0,
        maxZoom: 18.0,
        minZoom: 8.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          minNativeZoom: 6,
          maxNativeZoom: 18,
        ),
        MarkerLayer(
          markers: [
            for (var i = 0; i < drivers.length; i++)
              Marker(
                  alignment: Alignment.center,
                  height: 60,
                  width: 60,
                  point: LatLng(
                      jsonDecode(drivers[i].currentLocationJson!)['latitude']
                          as double,
                      jsonDecode(drivers[i].currentLocationJson!)['longitude']
                          as double),
                  child: IconButton.filledTonal(
                    icon: const Icon(
                      Icons.person,
                      size: 40,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      debugPrint(drivers[i].currentLocationJson!);
                      //TODO show truck&route&driver info in alert dialog
                    },
                  ))
          ],
        ),
        // CurrentLocationLayer(),
      ],
    );
  }
}
