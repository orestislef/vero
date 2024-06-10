import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:vero/helpers/location_helper.dart';

class ChooseFromMap extends StatelessWidget {
  const ChooseFromMap({
    super.key,
    required this.isStart,
    required this.onSelected,
    this.initial,
  });

  final Function(LatLng) onSelected;
  final bool isStart;
  final LatLng? initial;

  @override
  Widget build(BuildContext context) {
    MapController mapController = MapController();
    return FutureBuilder<LocationData>(
      future: LocationHelper().getLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
        return Stack(
          children: [
            FlutterMap(
              mapController: mapController,
              options: MapOptions(
                initialCenter: initial ??
                    LatLng(snapshot.data!.latitude ?? 0.0,
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
            ),
            Positioned(
              bottom: MediaQuery.of(context).padding.bottom,
              left: 10.0,
              right: 10.0,
              child: ElevatedButton(
                onPressed: () {
                  onSelected(mapController.camera.center);
                },
                child: const Text('Choose Location'),
              ),
            ),
          ],
        );
      },
    );
  }
}
