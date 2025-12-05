import 'dart:convert';

import 'package:app_network/app_network.dart';
import 'package:get_it/get_it.dart';

class QRCodeService {
  final AppClient _client = GetIt.instance<AppClient>();

  /// Fetches data from a QR code URL with the specified User-Agent header
  ///
  /// [url] - The URL extracted from the QR code
  /// Returns a Map containing the JSON response data
  Future<Map<String, dynamic>> fetchQRCodeData(String url) async {
    try {
      // Set the required User-Agent header
      final headers = {'User-Agent': 'sbccIndia/1.0'};

      // Make the GET request
      final response = await _client.get(
        url,
        headers: headers,
        isContentLangsAdded: true, // Don't add content_langs parameter for external URLs
      );

      // Check if the request was successful
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Parse the JSON response
        final jsonData = json.decode(response.body);
        return jsonData as Map<String, dynamic>;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Failed to fetch QR code data: $e');
    }
  }

  /// Validates if the URL is a valid SBCC ERP URL
  bool isValidSBCCUrl(String url) {
    return url.startsWith('https://erp.sbccindia.com/');
  }

  /// Extracts order ID from the URL
  String? extractOrderId(String url) {
    final uri = Uri.parse(url);
    final pathSegments = uri.pathSegments;

    if (pathSegments.length >= 3 && pathSegments[0] == 'order' && pathSegments[1] == 'details') {
      return pathSegments[2];
    }

    return null;
  }
}
