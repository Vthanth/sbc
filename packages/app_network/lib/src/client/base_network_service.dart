import 'package:app_network/src/client/insight_client.dart';

const eTagWriteHeaderKey = "if-none-match";
const eTagReadHeaderKey = "etag";
const lastModifiedNewKey = "last-modified";
const cacheControlKey = "cache-control";

/// This provides the base network service api for communicating with the network;
abstract class BaseNetworkService {
  final AppClient client;
  final String host;
  final String? newHost;
  final String? legacyHost;

  BaseNetworkService(this.client, this.host, {this.newHost, this.legacyHost});

  bool isSuccessful(int responseCode) => responseCode ~/ 100 == 2;

  bool isSuccess(dynamic jsonObj) {
    if (jsonObj["status"] != null) {
      final respStatus = jsonObj["status"] as String;
      return respStatus.toLowerCase() == "success";
    }
    return false;
  }
}
