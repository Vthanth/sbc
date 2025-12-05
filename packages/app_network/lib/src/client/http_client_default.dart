import 'dart:convert';

import 'package:http/http.dart';

extension ClientCredentialsExtension on Client {
  void includeCredentials(bool includeCredentials) {
    //'Cannot set credentials on a dart:io client.'
    // Do nothing
  }
}

Future<Response> postRequest(
  Client client,
  Uri url, {
  Map<String, String>? headers,
  Object? body,
  Encoding? encoding,
  bool shouldUseBrowserClientWithCredentials = false,
}) =>
    client.post(
      url,
      body: body,
      headers: headers,
      encoding: encoding,
    );
