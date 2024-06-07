import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/drivers.dart';
import 'package:vero/communication/models/trucks.dart';
import 'package:vero/widgets/all_drivers.dart';
import 'package:vero/widgets/all_trucks.dart';

class AddTruckToDriver extends StatefulWidget {
  const AddTruckToDriver({super.key});

  @override
  State<AddTruckToDriver> createState() => _AddTruckToDriverState();
}

class _AddTruckToDriverState extends State<AddTruckToDriver> {
  Truck? _truck;
  Driver? _driver;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_truck == null) {
      return AllTrucks(onTap: (truck) {
        setState(() {
          _truck = truck;
        });
      });
    } else if (_driver == null) {
      return AllDrivers(onTap: (driver) {
        setState(() {
          _driver = driver;
        });
      });
    } else {
      return _buildAddTruckToDriver();
    }
  }

  Widget _buildAddTruckToDriver() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                _truck = null;
              });
            },
            child: const Text('Select other Truck')),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _driver = null;
              });
            },
            child: const Text('Select other Driver')),
        Card(
          color: Colors.grey.shade300,
          elevation: 5,
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text(_truck!.truckName),
                subtitle: Text(_truck!.licensePlate),
              ),
              const SizedBox(width: 10),
              const ListTile(
                leading: Icon(Icons.input_rounded),
                title: Text('Will assign to'),
              ),
              const SizedBox(width: 10),
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(_driver!.name),
                subtitle: Text(_driver!.phone),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _isLoading
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                onPressed: () {
                  _onPressedAddTruckToDriver();
                },
                child: const Text('Assign Truck to Driver')),
      ],
    );
  }

  void _onPressedAddTruckToDriver() {
    Api()
        .assignTruckToDriver(truckId: _truck!.id, driverId: _driver!.id)
        .then((response) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonDecode(response.body)['message'])),
      );
    });
  }
}
