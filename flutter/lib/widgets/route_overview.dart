import 'package:flutter/material.dart';

import 'add_route.dart';
import 'add_truck_to_route.dart';
import 'all_routes.dart';
import 'edit_route.dart';

class RouteOverview extends StatefulWidget {
  const RouteOverview({super.key});

  @override
  State<RouteOverview> createState() => _RouteOverviewState();
}

class _RouteOverviewState extends State<RouteOverview> {
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
              title: const Text('View all Routes'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Route'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Route'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_shipping),
              title: const Text('Assign truck to Route'),
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
        return const AllRoutes();
      case 1:
        return const AddRoute();
      case 2:
        return const EditRoute();
      case 3:
        return const AddTruckToRoute();
      default:
        return const Placeholder();
    }
  }
}
