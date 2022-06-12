import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:zapit_frontend_task/src/utils/ui_helpers.dart';

mixin NetworkAwareMixin<T extends StatefulWidget> on State<T> {
  bool isInternetAlertOn = false;
  late StreamSubscription connectivityStream;
  @override
  void initState() {
    super.initState();
    connectivityStream =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult event) {
      if (event == ConnectivityResult.none) {
        // show toast;
        context.showErrorSnackBar(message: 'No Internet Connection.');
        isInternetAlertOn = true;
      } else {
        if (isInternetAlertOn) {
          context.showSnackBar(
            message: 'Available Internet Connection',
            backgroundColor: Colors.green,
          );
          isInternetAlertOn = false;
        }
      }
    });
  }

  @override
  void dispose() {
    connectivityStream.cancel();
    super.dispose();
  }
}
