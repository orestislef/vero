import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/trucks.dart';

class TruckStatistics extends StatefulWidget {
  const TruckStatistics({super.key});

  @override
  State<TruckStatistics> createState() => _TruckStatisticsState();
}

class _TruckStatisticsState extends State<TruckStatistics> {
  List<Truck>? _trucks;

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 5), (_) {
      Api().getAllTrucks().then((value) {
        TrucksResponse response =
            TrucksResponse.fromJson(jsonDecode(value.body));
        setState(() {
          _trucks = response.trucks;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return _trucks == null ? _buildLoading() : _buildColumn();
  }

  Widget _buildLoading() {
    return const Center(
      child: Column(
        children: [
          Text('Loading...'),
          SizedBox(height: 10),
          CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }

  Widget _buildColumn() {
    return _trucks!.isEmpty ? _buildEmpty() : _buildList();
  }

  Widget _buildEmpty() {
    return const Center(
      child: Text('No trucks found'),
    );
  }

  Widget _buildList() {
    return Scrollbar(
      child: ListView.builder(
        itemCount: _trucks!.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: const Icon(Icons.local_shipping),
            title: Text(
              _trucks![index].truckName,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              _trucks![index].licensePlate,
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Text(
              _trucks![index].status.name,
              style: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
