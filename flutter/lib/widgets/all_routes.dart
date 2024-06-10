import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vero/communication/api.dart';

import '../communication/models/routes.dart' as rt;

class AllRoutes extends StatefulWidget {
  const AllRoutes({super.key, this.onTap});

  final Function(rt.Route route)? onTap;

  @override
  State<AllRoutes> createState() => _AllRoutesState();
}

class _AllRoutesState extends State<AllRoutes> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Api().getAllRoutes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator.adaptive(),
              SizedBox(height: 10),
              Text('Loading Routes...'),
            ],
          ));
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        } else if (snapshot.hasData) {
          var routeResponse =
              rt.RoutesResponse.fromJson(jsonDecode(snapshot.data!.body));
          return routeResponse.routes.isEmpty
              ? const Center(child: Text('No routes'))
              : Scrollbar(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: routeResponse.routes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _getColor(routeResponse.routes[index])),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                routeResponse.routes[index].id.toString(),
                                style: const TextStyle(
                                  fontSize: 20.0,
                                ),
                              ),
                            )),
                        trailing: widget.onTap != null
                            ? const Icon(Icons.chevron_right)
                            : null,
                        title: Text(routeResponse.routes[index].routeName),
                        subtitle: Text('${routeResponse
                                    .routes[index].startLocationString} - ${routeResponse.routes[index].endLocationString}' ??
                            ''),
                        onTap: widget.onTap != null
                            ? () => widget.onTap!(routeResponse.routes[index])
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

  Color _getColor(rt.Route route) {
    switch (route.status) {
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
