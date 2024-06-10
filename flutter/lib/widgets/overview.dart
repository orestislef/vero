import 'package:flutter/material.dart';
import 'package:vero/widgets/drivers_in_map.dart';
import 'package:vero/widgets/truck_statistics.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisExtent: 300.0,
              crossAxisCount: 2,
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 10.0),
          itemCount: 4,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.blueGrey,
              elevation: 10.0,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                child: _buildOverviewCard(index),
              ),
            );
          }),
    );
  }

  Widget _buildOverviewCard(int index) {
    switch (index) {
      case 0:
        return Stack(children: [
          const DriversInMap(isFullScreen: false),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: IconButton.filledTonal(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        const DriversInMap(isFullScreen: true),
                  ),
                );
              },
              icon: const Icon(Icons.fullscreen_exit),
            ),
          )
        ]);
      case 1:
        return const TruckStatistics();
      case 2:
        return const Text('here to put calendar for routes');
      case 3:
        return const Text('here to put routes upcoming');
      default:
        return const SizedBox();
    }
  }
}
