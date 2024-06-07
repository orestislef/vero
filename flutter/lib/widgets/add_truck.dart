import 'dart:convert';

import 'package:flutter/material.dart';

import '../communication/api.dart';

class AddTruck extends StatefulWidget {
  const AddTruck({super.key});

  @override
  State<AddTruck> createState() => _AddTruckState();
}

class _AddTruckState extends State<AddTruck> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _truckNameController = TextEditingController();
  final TextEditingController _licencePlateController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _truckNameController,
              decoration: const InputDecoration(labelText: 'Truck Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Truck name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _licencePlateController,
              decoration: const InputDecoration(labelText: 'Licence Plate'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter licence plate';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator.adaptive()
                : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onClickedOnAddTruck();
                      }
                    },
                    child: const Text('Add Truck'),
                  ),
          ],
        ),
      ),
    );
  }

  void _onClickedOnAddTruck() {
    setState(() {
      _isLoading = true;
      Api()
          .addTruck(
              truckName: _truckNameController.text,
              licensePlate: _licencePlateController.text)
          .then((response) => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(jsonDecode(response.body)['message'])),
              ));
      setState(() {
        _isLoading = false;
      });
    });
  }
}
