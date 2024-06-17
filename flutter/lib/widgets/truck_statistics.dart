import 'package:flutter/material.dart';
import 'package:vero/communication/models/trucks.dart';
import 'package:vero/handlers/truck_handler.dart';

class TruckStatistics extends StatefulWidget {
  const TruckStatistics({super.key});

  @override
  State<TruckStatistics> createState() => _TruckStatisticsState();
}

class _TruckStatisticsState extends State<TruckStatistics> {
  @override
  void initState() {
    TruckHandler.startPeriodicTruckUpdate();
    super.initState();
  }

  @override
  void dispose() {
    TruckHandler.stopPeriodicTruckUpdate();
    super.dispose();
  }

  List<Truck>? _trucks;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        initialData: TruckHandler.lastResponse,
        stream: TruckHandler.getController(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _trucks = snapshot.data!.trucks;
            return _buildColumn();
          } else {
            return _buildLoading();
          }
        });
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
