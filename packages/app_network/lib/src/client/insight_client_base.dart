import 'dart:convert';

import 'package:app_network/app_network.dart';
import 'package:app_network/src/client/pretty_json.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

abstract class AppClientBase implements AppClient {
  AppClientBase({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  final _logger = Logger();

  @override
  String addQueryParamsToUrl(String originalUrl, Map<String, dynamic>? queryParams) {
    var oldUrl = Uri.parse(originalUrl);
    var oldQueryParams = oldUrl.queryParameters;
    var newQueryParams = {...oldQueryParams, if (queryParams != null && queryParams.isNotEmpty) ...queryParams};
    var newUrl = oldUrl.replace(queryParameters: newQueryParams);
    return newUrl.toString();
  }

  @override
  Future<http.Response> get(
    url, {
    Map<String, String>? headers,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
    List<String> fallbackUrls = const <String>[],
  }) async {
    http.Response? response;
    for (final fallbackUrl in [url] + fallbackUrls) {
      response = await _get(
        fallbackUrl,
        headers: headers,
        isContentLangsAdded: isContentLangsAdded,
        params: params,
        finalUrl: finalUrl,
      );
      if (isSuccessful(response.statusCode)) {
        return response;
      }
      _logger.w('Network request failed (${response.statusCode}): "$fallbackUrl"');
    }
    if (response == null) {
      throw Exception("Network request did not executed");
    }
    return response;
  }

  Future<http.Response> _get(
    String url, {
    Map<String, String>? headers,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
  }) async {
    var deviceLang = await getDeviceLang();
    var queryParams = <String, dynamic>{};

    // FLTR-7738 All static files that end in .json should not have any URL parameters
    if (!url.toLowerCase().endsWith('.json')) {
      if (params != null) {
        queryParams.addAll(params);
      }

      queryParams["device_lang"] = deviceLang;

      if (!isContentLangsAdded) {
        var contentLangs = await getContentLangs();
        queryParams.putIfAbsent('content_langs', () => contentLangs.join(","));
      }
    }

    final newUrl = queryParams.isEmpty ? url : addQueryParamsToUrl(url, queryParams);
    if (finalUrl != null) {
      /// Need to add this callback to when this method is called
      /// This class appending query parameter and prepare final url for call.
      /// This is mainly used for sending url when it will not execute the operation successfully
      /// To have more information about the request
      finalUrl(newUrl);
    }
    _logger.d("URL: $newUrl \nHeaders:\n${headers?.getPrettyJson()}");
    return _client.get(Uri.parse(newUrl), headers: headers);
  }

  @override
  Future<http.Response> post(
    url, {
    final Map<String, dynamic>? body,
    final Map<String, String>? headers,
    bool includeDeviceLang = true,
    bool isContentLangsAdded = false,
    bool encodeJson = false,
    RequestBodyCallback? finalBody,
  }) async {
    var deviceLang = await getDeviceLang();

    final bodyCopy = body ?? {};
    final headersCopy = headers ?? {};
    headersCopy["device_lang"] = deviceLang;
    if (includeDeviceLang) {
      bodyCopy["device_lang"] = deviceLang;
    }

    if (isContentLangsAdded) {
      var contentLangs = await getContentLangs();
      bodyCopy["content_langs"] = contentLangs.join(",");
    }

    Object newBody;
    if (encodeJson) {
      newBody = jsonEncode(bodyCopy);
      headersCopy['Content-Type'] = "application/json";
    } else {
      newBody = bodyCopy;
    }
    if (finalBody != null) {
      /// Need to add this callback to when this method is called
      /// This class appending body and prepare final body for call.
      /// This is mainly used for sending request body when it will not execute the operation successfully
      /// To have more information about the request
      finalBody(newBody is String ? newBody : const JsonEncoder().convert(newBody));
    }
    _logger.d("URL: $url \nHeaders:\n${headersCopy.getPrettyJson()} \nBody:\n${bodyCopy.getPrettyJson()}");
    return _client.post(Uri.parse(url), body: newBody, headers: headersCopy);
  }

  @override
  Future<http.Response> delete(
    url, {
    Map<String, String>? headers,
    bool includeDeviceLang = true,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
  }) async {
    var deviceLang = await getDeviceLang();
    var queryParams = <String, dynamic>{};
    if (params != null) {
      queryParams.addAll(params);
    }

    if (includeDeviceLang) {
      queryParams["device_lang"] = deviceLang;
    }

    if (isContentLangsAdded) {
      var contentLangs = await getContentLangs();
      queryParams.putIfAbsent('content_langs', () => contentLangs.join(","));
    }

    final newUrl = addQueryParamsToUrl(url, queryParams);
    if (finalUrl != null) {
      finalUrl(newUrl);
    }
    _logger.d("URL: $newUrl \n Headers:${headers?.getPrettyJson()}");
    return _client.delete(Uri.parse(newUrl), headers: headers);
  }

  ///
  ///This method name is temporary. In another PR, I will remove the get method above and replace it with this
  ///general purpose get method and rename it again to 'get'.
  @override
  Future<http.Response> getFull(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    RequestUrlCallback? finalUrl,
  }) async {
    var deviceLang = await getDeviceLang();
    var contentLangs = await getContentLangs();

    var newUrl = url;

    queryParams ??= {};

    newUrl = addQueryParamsToUrl(newUrl, queryParams);

    newUrl = addQueryParamsToUrl(newUrl, {
      "device_lang": deviceLang,
      if (!queryParams.containsKey("content_langs")) "content_langs": contentLangs.join(","),
    });
    if (finalUrl != null) {
      /// Need to add this callback to when this method is called
      /// This class appending query parameter and prepare final url for call.
      /// This is mainly used for sending url when it will not execute the operation successfully
      /// To have more information about the request
      finalUrl(newUrl);
    }
    _logger.d("URL: $newUrl \nHeaders:\n${headers?.getPrettyJson()}");
    return _client.get(Uri.parse(newUrl), headers: headers);
  }

  @override
  Future<http.Response> head(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    RequestUrlCallback? finalUrl,
  }) async {
    var deviceLang = await getDeviceLang();
    var contentLangs = await getContentLangs();

    var newUrl = url;

    queryParams ??= {};

    newUrl = addQueryParamsToUrl(newUrl, queryParams);

    newUrl = addQueryParamsToUrl(newUrl, {
      "device_lang": deviceLang,
      if (!queryParams.containsKey("content_langs")) "content_langs": contentLangs.join(","),
    });
    if (finalUrl != null) {
      /// Need to add this callback to when this method is called
      /// This class appending query parameter and prepare final url for call.
      /// This is mainly used for sending url when it will not execute the operation successfully
      /// To have more information about the request
      finalUrl(newUrl);
    }
    _logger.d("URL: $newUrl \nHeaders:\n${headers?.getPrettyJson()}");
    return _client.head(Uri.parse(newUrl), headers: headers);
  }

  @override
  Future<http.Response> headerRequest(
    url, {
    Map<String, String>? headers,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
  }) async {
    var deviceLang = await getDeviceLang();
    var queryParams = <String, dynamic>{};
    if (params != null) {
      queryParams.addAll(params);
    }
    queryParams["device_lang"] = deviceLang;
    if (!isContentLangsAdded) {
      var contentLangs = await getContentLangs();
      queryParams.putIfAbsent('content_langs', () => contentLangs.join(","));
    }

    final newUrl = addQueryParamsToUrl(url, queryParams);
    if (finalUrl != null) {
      /// Need to add this callback to when this method is called
      /// This class appending query parameter and prepare final url for call.
      /// This is mainly used for sending url when it will not execute the operation successfully
      /// To have more information about the request
      finalUrl(newUrl);
    }

    _logger.d("URL: $newUrl \nHeaders:\n${headers?.getPrettyJson()}");
    return _client.head(Uri.parse(newUrl), headers: headers);
  }

  @override
  Future<http.Response> put(
    url, {
    final Map<String, dynamic>? body,
    final Map<String, String>? headers,
    bool includeDeviceLang = true,
    bool isContentLangsAdded = false,
    bool encodeJson = false,
    RequestBodyCallback? finalBody,
  }) async {
    final bodyCopy = body ?? {};
    final headersCopy = headers ?? {};
    var deviceLang = await getDeviceLang();
    if (includeDeviceLang) {
      bodyCopy["device_lang"] = deviceLang;
    }

    if (!isContentLangsAdded) {
      var contentLangs = await getContentLangs();
      bodyCopy["content_langs"] = contentLangs.join(",");
    }
    Object newBody;
    if (encodeJson) {
      newBody = jsonEncode(bodyCopy);
      headersCopy['Content-Type'] = "application/json";
    } else {
      newBody = bodyCopy;
    }
    if (finalBody != null) {
      /// Need to add this callback to when this method is called
      /// This class appending body and prepare final body for call.
      /// This is mainly used for sending request body when it will not execute the operation successfully
      /// To have more information about the request
      finalBody(newBody is String ? newBody : const JsonEncoder().convert(newBody));
    }
    _logger.d("URL: $url \nHeaders:\n${headersCopy.getPrettyJson()} \nBody:\n${headersCopy.getPrettyJson()}");
    return _client.put(Uri.parse(url), body: newBody, headers: headersCopy);
  }

  @override
  Future<http.Response> multipartMultiple(
      String url, {
        Map<String, String>? files, // Key: param name, Value: file path
        Map<String, String>? body,
        Map<String, String>? headers,
      }) async {
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

    if (headers != null) request.headers.addAll(headers);
    if (body != null) request.fields.addAll(body);

    if (files != null) {
      for (var entry in files.entries) {
        request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value));
      }
    }

    final streamedResponse = await request.send();
    return await http.Response.fromStream(streamedResponse);
  }

  @override
  Future<http.Response> multipart(
    String url,
    String imagePath, {
    String imageParamKey = "pictures",
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    RequestBodyCallback? finalBody,
  }) async {
    var deviceLang = await getDeviceLang();

    final headersCopy = headers ?? {};
    headersCopy["device_lang"] = deviceLang;

    _logger.d("URL: $url \nHeaders:\n${headersCopy.getPrettyJson()} \nBody:\n$body");
    http.MultipartRequest request = http.MultipartRequest('POST', Uri.parse(url));

    request.headers.addAll(headersCopy);
    body?.forEach((key, value) {
      request.fields[key] = value;
    });

    request.files.add(await http.MultipartFile.fromPath(imageParamKey, imagePath));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return response;
  }

  bool isSuccessful(int responseCode) => responseCode ~/ 100 == 2;
}
