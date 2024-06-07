import 'package:flutter/material.dart';
import 'package:vero/widgets/add_driver.dart';

import 'all_drivers.dart';
import 'edit_driver.dart';

class DriverOverview extends StatefulWidget {
  const DriverOverview({super.key});

  @override
  State<DriverOverview> createState() => _DriverOverviewState();
}

class _DriverOverviewState extends State<DriverOverview> {
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
              title: const Text('View All Drivers'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 0;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add Driver'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Driver'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                setState(() {
                  _currentIndex = 2;
                });
              },
            ),
          ],
        );
      case 0:
        return const AllDrivers();
      case 1:
        return const AddDriver();
      case 2:
        return const EditDriver();
      default:
        return const Placeholder();
    }
  }
}
