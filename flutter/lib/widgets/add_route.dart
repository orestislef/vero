import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vero/helpers/lat_lng_helper.dart';

import '../communication/api.dart';
import 'choose_from_map.dart';

class AddRoute extends StatefulWidget {
  const AddRoute({super.key});

  @override
  State<AddRoute> createState() => _AddRouteState();
}

class _AddRouteState extends State<AddRoute> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _routeNameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  LatLng? _startLocation;
  LatLng? _endLocation;
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
              controller: _routeNameController,
              decoration: const InputDecoration(labelText: 'Route Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Route name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(_startLocation == null
                        ? 'Start location'
                        : 'Selected(start):'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Stack(
                        children: [
                          ChooseFromMap(
                              initial: _startLocation,
                              isStart: true,
                              onSelected: (value) {
                                setState(() {
                                  _startLocation = value;
                                });
                              }),
                          const Center(
                            child: Icon(
                              Icons.location_searching_outlined,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(_endLocation == null
                        ? 'End location'
                        : 'Selected(end):'),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: Stack(
                        children: [
                          ChooseFromMap(
                              initial: _endLocation,
                              isStart: false,
                              onSelected: (value) {
                                setState(() {
                                  _endLocation = value;
                                });
                              }),
                          const Center(
                            child: Icon(
                              Icons.location_searching_outlined,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      _onClickedOnDate(isStart: true);
                    },
                    child: Text('Pick start date ' '${_startDate ?? ''}')),
                ElevatedButton(
                    onPressed: () {
                      _onClickedOnDate(isStart: false);
                    },
                    child: Text('Pick end date ' '${_endDate ?? ''}')),
              ],
            ),
            const SizedBox(height: 40),
            _isLoading
                ? const CircularProgressIndicator.adaptive()
                : ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _onClickedOnAddRoute();
                      }
                    },
                    child: const Text('Add Route'),
                  ),
          ],
        ),
      ),
    );
  }

  void _onClickedOnAddRoute() {
    if (_startLocation == null || _endLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end locations'),
        ),
      );
      return;
    }

    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select start and end dates'),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });
    Api()
        .addRoute(
          routeName: _routeNameController.text,
          startLocationString: LatLngHelper.latLngToJson(_startLocation!),
          endLocationString: LatLngHelper.latLngToJson(_endLocation!),
          startDate: _startDate!,
          endDate: _endDate!,
        )
        .then((response) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(jsonDecode(response.body)['message'])),
            ));
    setState(() {
      _isLoading = false;
    });
  }

  void _onClickedOnDate({required bool isStart}) {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)))
        .then((value) {
      if (value != null) {
        showTimePicker(context: context, initialTime: TimeOfDay.now())
            .then((time) {
          if (time != null) {
            setState(() {
              if (isStart) {
                _startDate = DateTime(
                    value.year, value.month, value.day, time.hour, time.minute);
              } else {
                _endDate = DateTime(
                    value.year, value.month, value.day, time.hour, time.minute);
              }
            });
          }
        });
      }
    });
  }
}
