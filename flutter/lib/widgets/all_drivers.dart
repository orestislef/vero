import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/drivers.dart';
import 'package:vero/widgets/driver_map_view.dart';

class AllDrivers extends StatefulWidget {
  const AllDrivers({super.key, this.onTap});

  final Function(Driver driver)? onTap;

  @override
  State<AllDrivers> createState() => _AllDriversState();
}

class _AllDriversState extends State<AllDrivers> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api().getAllDrivers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
              SizedBox(height: 10),
              Text('Loading drivers...'),
            ],
          ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          var driversResponse = snapshot.data as DriversResponse;
          return driversResponse.drivers.isEmpty
              ? const Center(child: Text('No drivers'))
              : Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: driversResponse.drivers.length,
                    itemBuilder: (context, index) {
                      bool hasLocation =
                          driversResponse.drivers[index].currentLocationJson !=
                                  null &&
                              driversResponse.drivers[index]
                                  .currentLocationJson!.isNotEmpty;
                      return ListTile(
                        leading: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    _getColor(driversResponse.drivers[index])),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                driversResponse.drivers[index].id.toString(),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            )),
                        trailing: widget.onTap != null
                            ? const Icon(Icons.chevron_right)
                            : hasLocation
                                ? IconButton(
                                    onPressed: () {
                                      _onClickedOnMap(
                                          driversResponse.drivers[index]);
                                    },
                                    icon: const Icon(Icons.map_outlined))
                                : null,
                        title: Text(driversResponse.drivers[index].name),
                        subtitle: Text(driversResponse.drivers[index].phone),
                        onTap: widget.onTap != null
                            ? () =>
                                widget.onTap!(driversResponse.drivers[index])
                            : null,
                      );
                    },
                  ),
                );
        } else {
          return const Center(child: Text('No data'));
        }
      },
    );
  }

  Color _getColor(Driver driver) {
    switch (driver.status) {
      case 'available':
        return Colors.green;
      case 'on_route':
        return Colors.red;
      case 'off_duty':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _onClickedOnMap(Driver driver) {
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: Text(driver.name),
              ),
              body: DriverMapView(
                drivers: [driver],
              ));
        });
  }
}
