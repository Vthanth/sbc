import 'dart:async';

enum NetworkState { mobile, wifi, off, other }

abstract class NetworkManager {
  Future<NetworkState> getNetworkState();

  Stream<NetworkState> getNetworkStateStream();

  bool? isOnline;
}
