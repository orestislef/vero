import 'dart:async';

import 'package:vero/communication/api.dart';
import 'package:vero/communication/models/drivers.dart';

class DriverHandler {
  static DriversResponse? lastResponse;
  static Timer? timer;

  static final StreamController<DriversResponse> streamController =
  StreamController<DriversResponse>.broadcast();

  static Stream<DriversResponse> getController() {
    return streamController.stream;
  }

  static forceGetAllDrivers() async {
    streamController.sink.add(await Api().getAllDrivers());
  }

  static startPeriodicDriverUpdate() async {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      streamController.sink.add(await Api().getAllDrivers());
    });
  }

  static stopPeriodicDriverUpdate() {
    streamController.close();
    if (timer != null) {
      timer!.cancel();
    }
  }
}
