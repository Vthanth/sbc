import 'dart:convert';

import 'package:http/browser_client.dart';
import 'package:http/http.dart';

extension ClientCredentialsExtension on Client {
  void includeCredentials(bool includeCredentials) {
    (this as BrowserClient?)?.withCredentials = includeCredentials;
  }
}

Future<Response> postRequest(
  Client client,
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  bool shouldUseBrowserClientWithCredentials = false,
}) async {
  Client httpClient = shouldUseBrowserClientWithCredentials ? (BrowserClient()..includeCredentials(true)) : client;
  try {
    return await httpClient.post(url, body: body, headers: headers, encoding: encoding);
  } catch (_) {
    rethrow;
  } finally {
    if (shouldUseBrowserClientWithCredentials) {
      httpClient.close();
    }
  }
}
