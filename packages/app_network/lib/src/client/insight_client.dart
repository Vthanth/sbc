import 'package:http/http.dart' as http;

typedef RequestUrlCallback = void Function(String);
typedef RequestBodyCallback = void Function(String);

abstract class AppClient {
  Future<String> getDeviceLang();
  Future<List<String>> getContentLangs();
  Future<String> getContentFilters();
  String addQueryParamsToUrl(String originalUrl, Map<String, dynamic>? queryParams);

  Future<http.Response> get(
    String url, {
    Map<String, String>? headers,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
    List<String> fallbackUrls = const <String>[],
  });

  Future<http.Response> post(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool includeDeviceLang = true,
    bool isContentLangsAdded = false,
    bool encodeJson = false,
    RequestBodyCallback? finalBody,
  });

  Future<http.Response> delete(
    String url, {
    Map<String, String>? headers,
    bool includeDeviceLang = true,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
  });

  Future<http.Response> getFull(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    RequestUrlCallback? finalUrl,
  });

  Future<http.Response> head(
    String url, {
    Map<String, dynamic>? queryParams,
    Map<String, String>? headers,
    RequestUrlCallback? finalUrl,
  });

  Future<http.Response> headerRequest(
    String url, {
    Map<String, String>? headers,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
  });

  Future<http.Response> put(
    String url, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool includeDeviceLang = true,
    bool isContentLangsAdded = false,
    bool encodeJson = false,
    RequestBodyCallback? finalBody,
  });

  Future<http.Response> patch(
    String url, {
    Map<String, String>? headers,
    bool includeDeviceLang = true,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
  });

  Future<http.Response> multipart(
    String url,
    String imagePath, {
    String imageParamKey = "pictures",
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    RequestBodyCallback? finalBody,
  });
  Future<http.Response> multipartMultiple(
      String url, {
        Map<String, String>? files,
        Map<String, String>? body,
        Map<String, String>? headers,
      });
}
