import 'dart:convert';

extension JsonToPrettyJson on Map<String, dynamic> {
  String? getPrettyJson({String indent = "   "}) {
    if (isNotEmpty) {
      var encoder = JsonEncoder.withIndent(indent);
      return encoder.convert(this);
    }
    return null;
  }

  Map<String, String> convertToStringMap() {
    final stringMap = <String, String>{};
    forEach((key, value) {
      stringMap[key] = value.toString();
    });
    return stringMap;
  }
}

extension JsonArrayToPrettyJson on List<dynamic> {
  String? getPrettyJson() {
    if (isNotEmpty) {
      var encoder = const JsonEncoder.withIndent("   ");
      return encoder.convert(this);
    }
    return null;
  }
}
