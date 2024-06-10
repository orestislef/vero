import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/drivers.dart';
import 'package:vero/enums/driver_status.dart';
import 'package:vero/widgets/all_drivers.dart';

class EditDriver extends StatefulWidget {
  const EditDriver({super.key});

  @override
  State<EditDriver> createState() => _EditDriverState();
}

class _EditDriverState extends State<EditDriver> {
  Driver? _driver;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DriverStatus? _status;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    return _driver == null ? _buildSelectDriver() : _buildEditDriver();
  }

  Widget _buildSelectDriver() {
    return AllDrivers(onTap: (driver) {
      setState(() {
        _driver = driver;
      });
    });
  }

  Widget _buildEditDriver() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _driver = null;
              });
            },
            child: const Text('Select other Driver'),
          ),
        ),
        _buildEdit(),
      ],
    );
  }

  Widget _buildEdit() {
    _nameController.text = _driver!.name;
    _phoneController.text = _driver!.phone;
    _status ??= _driver!.status;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Name',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Phone',
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text('Status : ${_driver!.status.name}'),
        DropdownButtonFormField<DriverStatus>(
          value: _driver!.status,
          onChanged: (value) {
            setState(() {
              _status = value!;
            });
          },
          items: DriverStatus.values
              .map((status) => DropdownMenuItem<DriverStatus>(
                    value: status,
                    child: Text(status.name),
                  ))
              .toList(),
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
        .updateDriver(
            id: _driver!.id,
            name: _nameController.text,
            phone: _phoneController.text,
            status: _status!)
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
