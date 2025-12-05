import 'package:app_network/app_network.dart';
import 'package:app_network/src/client/insight_client_base.dart';
import 'package:http/http.dart';

class DefaultAppClient extends AppClientBase {
  DefaultAppClient({super.client});

  @override
  Future<String> getContentFilters() async {
    return "";
  }

  @override
  Future<List<String>> getContentLangs() async {
    return [];
  }

  @override
  Future<String> getDeviceLang() async {
    return "";
  }

  @override
  Future<Response> patch(
    String url, {
    Map<String, String>? headers,
    bool includeDeviceLang = true,
    bool isContentLangsAdded = false,
    Map<String, dynamic>? params,
    RequestUrlCallback? finalUrl,
  }) {
    throw UnimplementedError();
  }
}
