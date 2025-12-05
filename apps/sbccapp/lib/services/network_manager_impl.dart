import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:app_services/services.dart';

/// Network is wrapper on Connectivity.
/// This class will return the network which we are currently connected to.
/// ConnectionState enum is returned.
class NetworkManagerImpl extends NetworkManager {
  final StreamController<NetworkState> _networkState = StreamController.broadcast();

  NetworkManagerImpl() {
    checkNetwork();
    Connectivity().onConnectivityChanged.listen((result) {
      checkNetwork();
    });
  }

  void checkNetwork() async {
    var value = await getNetworkState();
    _networkState.add(value);
    isOnline = value != NetworkState.off;
  }

  @override
  Stream<NetworkState> getNetworkStateStream() {
    return _networkState.stream;
  }

  @override
  Future<NetworkState> getNetworkState() async {
    final connectivityResult = (await Connectivity().checkConnectivity()).first;
    switch (connectivityResult) {
      case ConnectivityResult.ethernet:
      case ConnectivityResult.wifi:
        return NetworkState.wifi;

      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.mobile:
        return NetworkState.mobile;

      case ConnectivityResult.none:
        return NetworkState.off;
      case ConnectivityResult.other:
        return NetworkState.other;
    }
  }
}
