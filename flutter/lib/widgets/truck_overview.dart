import 'package:flutter/material.dart';

import 'add_truck.dart';
import 'add_truck_to_driver.dart';
import 'all_trucks.dart';
import 'edit_truck.dart';

class TruckOverview extends StatefulWidget {
  const TruckOverview({super.key});

  @override
  State<TruckOverview> createState() => _TruckOverviewState();
}

class _TruckOverviewState extends State<TruckOverview> {
  int _currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _currentIndex == -1
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _currentIndex = -1;
                    });
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.adaptive.arrow_back_rounded),
                      const SizedBox(width: 10),
                      const Text('Back'),
                    ],
                  ),
                ),
              ),
        _buildBody(),
      ],
    );
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case -1:
        return ListView(
          shrinkWrap: true,
          children: [
            ListTile(
              leading: const Icon(Icons.view_agenda),
              title: const Text('View all Trucks'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Truck'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Truck'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Assign Truck to driver'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 3;
                });
              },
            ),
          ],
        );
      case 0:
        return const AllTrucks();
      case 1:
        return const AddTruck();
      case 2:
        return const EditTruck();
      case 3:
        return const AddTruckToDriver();
      default:
        return const Placeholder();
    }
  }
}
