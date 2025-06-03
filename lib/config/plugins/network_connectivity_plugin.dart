import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';

import '../config.dart';

class NetworkConnectivityPlugin {
  static bool checkedOnce = false;

  static Future<List<ConnectivityResult>> _getConnectivityInfos() {
    return Connectivity().checkConnectivity();
  }

  static Future<bool> isConnected() async {
    final connectivity = await _getConnectivityInfos();
    // if (connectivity.contains(ConnectivityResult.vpn)) return false;
    final googleIsReachable = await _checkInternetReachable();
    return (connectivity.contains(ConnectivityResult.mobile) ||
            connectivity.contains(ConnectivityResult.wifi) ||
            connectivity.contains(ConnectivityResult.other)) &&
        googleIsReachable;
  }

  static Future<bool> _checkInternetReachable() async {
    try {
      if (kIsWeb) {
        return true;
      }
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        logger.i('connected');
        return true;
      }
      return false;
    } on SocketException catch (_) {
      logger.e('not connected');
      return false;
    }
  }
}

class ConnectionStatusSingleton {
  //This creates the single instance by calling the `_internal` constructor specified below
  static final ConnectionStatusSingleton _singleton =
      ConnectionStatusSingleton._internal();
  ConnectionStatusSingleton._internal();

  //This is what's used to retrieve the instance through the app
  static ConnectionStatusSingleton getInstance() => _singleton;

  //This tracks the current connection status
  bool hasConnection = false;

  //This is how we'll allow subscribing to connection changes
  StreamController<bool> connectionChangeController =
      StreamController.broadcast();

  //flutter_connectivity
  final Connectivity _connectivity = Connectivity();

  //Hook into flutter_connectivity's Stream to listen for changes
  //And check the connection status out of the gate
  void initialize() {
    checkConnection();
    _connectivity.onConnectivityChanged.listen(
      (event) {
        _connectionChange(event.first);
      },
    );
  }

  Stream<bool> get connectionChange => connectionChangeController.stream;

  //A clean up method to close our StreamController
  //   Because this is meant to exist through the entire application life cycle this isn't
  //   really an issue
  void dispose() {
    connectionChangeController.close();
  }

  //flutter_connectivity's listener
  void _connectionChange(ConnectivityResult result) {
    checkConnection();
  }

  //The test to actually see if there is a connection
  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      if (kIsWeb) {
        return true;
      }
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }

  /// Used to trigger the redirection process in routes
  Future<bool> triggerConnectionEvent() async {
    try {
      if (kIsWeb) {
        return true;
      }
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    connectionChangeController.add(hasConnection);

    return hasConnection;
  }
}
