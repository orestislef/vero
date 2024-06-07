import 'dart:convert';

import 'package:flutter/material.dart';

import '../communication/api.dart';

class AddDriver extends StatefulWidget {
  const AddDriver({super.key});

  @override
  State<AddDriver> createState() => _AddDriverState();
}

class _AddDriverState extends State<AddDriver> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

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
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
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
                        _onClickedOnAddDriver();
                      }
                    },
                    child: const Text('Add Driver'),
                  ),
          ],
        ),
      ),
    );
  }

  void _onClickedOnAddDriver() {
    setState(() {
      _isLoading = true;
    });
    Api()
        .addDriver(name: _nameController.text, phone: _phoneController.text)
        .then((response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(jsonDecode(response.body)['message'])),
      );
      setState(() {
        _isLoading = false;
      });
    });
  }
}
