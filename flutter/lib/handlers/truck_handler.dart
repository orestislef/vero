import 'dart:async';

import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/trucks.dart';

class TruckHandler {
  static TrucksResponse? lastResponse;
  static Timer? timer;

  static final StreamController<TrucksResponse> streamController =
      StreamController<TrucksResponse>.broadcast();

  static Stream<TrucksResponse> getController() {
    return streamController.stream;
  }

  static forceGetAllTrucks() async {
    streamController.sink.add(await Api().getAllTrucks());
  }

  static startPeriodicTruckUpdate() async {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      streamController.sink.add(await Api().getAllTrucks());
    });
  }

  static stopPeriodicTruckUpdate() {
    streamController.close();
    if (timer != null) {
      timer!.cancel();
    }
  }
}
