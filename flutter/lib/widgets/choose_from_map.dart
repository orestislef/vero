import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:vero/helpers/location_helper.dart';

class ChooseFromMap extends StatelessWidget {
  const ChooseFromMap(
      {super.key, required this.isStart, required this.onSelected});

  final Function(LatLng) onSelected;
  final bool isStart;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LocationData>(
      future: LocationHelper().getLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return FlutterMap(
          mapController: MapController(),
          options: MapOptions(
            initialCenter: LatLng(snapshot.data!.latitude ?? 0.0,
                snapshot.data!.longitude ?? 0.0),
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
          ],
        );
      },
    );
  }
}
