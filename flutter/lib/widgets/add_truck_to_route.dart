import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/routes.dart' as rt;
import 'package:vero/communication/models/trucks.dart';

import 'all_routes.dart';
import 'all_trucks.dart';

class AddTruckToRoute extends StatefulWidget {
  const AddTruckToRoute({super.key});

  @override
  State<AddTruckToRoute> createState() => _AddTruckToRouteState();
}

class _AddTruckToRouteState extends State<AddTruckToRoute> {
  rt.Route? _route;
  Truck? _truck;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    if (_route == null) {
      return AllRoutes(onTap: (route) {
        setState(() {
          _route = route;
        });
      });
    } else if (_truck == null) {
      return AllTrucks(onTap: (truck) {
        setState(() {
          _truck = truck;
        });
      });
    } else {
      return _buildAddRouteToTruck();
    }
  }

  Widget _buildAddRouteToTruck() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
            onPressed: () {
              setState(() {
                _route = null;
              });
            },
            child: const Text('Select other Route')),
        const SizedBox(height: 10),
        ElevatedButton(
            onPressed: () {
              setState(() {
                _truck = null;
              });
            },
            child: const Text('Select other Truck')),
        Card(
          color: Colors.grey.shade300,
          elevation: 5,
          margin: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.route),
                title: Text(_route!.routeName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  setState(() {
                    _route = null;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_shipping),
                title: Text(_truck!.truckName),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  setState(() {
                    _truck = null;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _isLoading
            ? const CircularProgressIndicator.adaptive()
            : ElevatedButton(
                onPressed: _isLoading
                    ? null
                    : () {
                        onClickedOnAddTruckToRoute();
                      },
                child: const Text('Add Truck to Route')),
      ],
    );
  }

  void onClickedOnAddTruckToRoute() {
    setState(() {
      _isLoading = true;
    });
    Api()
        .addTruckToRoute(routeId: _route!.id, truckId: _truck!.id)
        .then((value) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(jsonDecode(value.body)['message']),
        ),
      );
    });
  }
}
