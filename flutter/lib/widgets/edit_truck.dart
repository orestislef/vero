import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/trucks.dart';
import 'package:vero/widgets/all_trucks.dart';

class EditTruck extends StatefulWidget {
  const EditTruck({super.key});

  @override
  State<EditTruck> createState() => _EditTruckState();
}

class _EditTruckState extends State<EditTruck> {
  Truck? _truck;

  final TextEditingController _truckNameController = TextEditingController();
  final TextEditingController _truckLicencePlateController = TextEditingController();
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return _truck == null ? _buildSelectTruck() : _buildEditTruck();
  }

  Widget _buildSelectTruck() {
    return AllTrucks(onTap: (truck) {
      setState(() {
        _truck = truck;
      });
    });
  }

  Widget _buildEditTruck() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _truck = null;
              });
            },
            child: const Text('Select other Truck'),
          ),
        ),
        _buildEdit(),
      ],
    );
  }

  Widget _buildEdit() {
    _truckNameController.text = _truck!.truckName;
    _truckLicencePlateController.text = _truck!.licensePlate;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _truckNameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Truck Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _truckLicencePlateController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Truck Licence Plate',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: _isSaving
              ? const CircularProgressIndicator.adaptive()
              : ElevatedButton(
            onPressed: () {
              _onClickedSave();
            },
            child: const Text('Save'),
          ),
        ),
      ],
    );
  }

  void _onClickedSave() {
    setState(() {
      _isSaving = true;
    });
    Api()
        .updateTruck(
        id: _truck!.id,
        truckName: _truckNameController.text,
        licencePlate: _truckLicencePlateController.text)
        .then((response) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonDecode(response.body)['message'])),
      );
    });
  }
}
