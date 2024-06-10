import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/routes.dart' as rt;
import 'package:vero/helpers/lat_lng_helper.dart';
import 'package:vero/widgets/all_routes.dart';

import 'choose_from_map.dart';

class EditRoute extends StatefulWidget {
  const EditRoute({super.key});

  @override
  State<EditRoute> createState() => _EditRouteState();
}

class _EditRouteState extends State<EditRoute> {
  @override
  void dispose() {
    super.dispose();
    _routeNameController.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _routeNameController = TextEditingController();
  rt.Route? _route;

  DateTime? _startDate;
  DateTime? _endDate;
  LatLng? _startLocation;
  LatLng? _endLocation;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _route == null ? _buildSelectRoute() : _buildEditRoute();
  }

  Widget _buildSelectRoute() {
    return AllRoutes(onTap: (route) {
      setState(() {
        _route = route;
      });
    });
  }

  Widget _buildEditRoute() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _route = null;
              });
            },
            child: const Text('Select other Route'),
          ),
        ),
        _buildEdit(),
      ],
    );
  }

  Widget _buildEdit() {
    if (_routeNameController.text.isEmpty) {
      _routeNameController.text = _route!.routeName;
    }
    _startDate ??= _route!.startDate;
    _endDate ??= _route!.endDate;

    _startLocation ??= LatLngHelper.jsonToLatLng(_route!.startLocationString);
    _endLocation ??= LatLngHelper.jsonToLatLng(_route!.endLocationString!);
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
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
                    const Text('Start location:'),
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
                    const Text('End location:'),
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
                        _onClickedOnEditRoute();
                      }
                    },
                    child: const Text('Update Route'),
                  ),
          ],
        ),
      ),
    );
  }

  void _onClickedOnDate({required bool isStart}) {
    showDatePicker(
            context: context,
            initialDate: isStart
                ? _route?.startDate ?? DateTime.now()
                : _route?.endDate ?? DateTime.now(),
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

  void _onClickedOnEditRoute() {
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
        .updateRoute(
          id: _route!.id,
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
}
