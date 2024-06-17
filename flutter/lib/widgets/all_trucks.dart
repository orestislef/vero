import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';

import '../communication/models/trucks.dart';

class AllTrucks extends StatefulWidget {
  const AllTrucks({super.key, this.onTap});

  final Function(Truck truck)? onTap;

  @override
  State<AllTrucks> createState() => _AllTrucksState();
}

class _AllTrucksState extends State<AllTrucks> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api().getAllTrucks(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
              SizedBox(height: 10),
              Text('Loading trucks...'),
            ],
          ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          var truckResponse = snapshot.data as TrucksResponse;
          return truckResponse.trucks.isEmpty
              ? const Center(child: Text('No trucks'))
              : Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: truckResponse.trucks.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getColor(truckResponse.trucks[index])),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                truckResponse.trucks[index].id.toString(),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            )),
                        trailing: widget.onTap != null
                            ? const Icon(Icons.chevron_right)
                            : null,
                        title: Text(truckResponse.trucks[index].truckName),
                        subtitle:
                            Text(truckResponse.trucks[index].licensePlate),
                        onTap: widget.onTap != null
                            ? () => widget.onTap!(truckResponse.trucks[index])
                            : null,
                      );
                    },
                  ),
                );
        } else {
          return const Center(child: Text('No data'));
        }
      },
    );
  }

  Color _getColor(Truck truck) {
    switch (truck.status) {
      case 'available':
        return Colors.green;
      case 'on_route':
        return Colors.red;
      case 'off_duty':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
