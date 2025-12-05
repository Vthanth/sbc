// ignore_for_file: constant_identifier_names

import 'dart:core';

enum Platform { WIN, POSIX }

final _r1 = RegExp(r'"');
final _r2 = RegExp(r'%');
final _r3 = RegExp(r"\\");
final _r4 = RegExp(r"[\r\n]+");
final _r5 = RegExp(r"[^\x20-\x7E]|'");
final _r7 = RegExp(r"'");
final _r8 = RegExp(r"\n");
final _r9 = RegExp(r"\r");
final _r10 = RegExp(r"[[{}\]]");
const _urlencoded = "application/x-www-form-urlencoded";

String escapeStringWindows(String str) =>
    "\"${str.replaceAll(_r1, "\"\"").replaceAll(_r2, "\"%\"").replaceAll(_r3, "\\\\").replaceAllMapped(_r4, (match) => "\"^${match.group(0)}\"")}\"";

String escapeStringPosix(String str) {
  if (_r5.hasMatch(str)) {
    // Use ANSI-C quoting syntax.
    return "\$'${str.replaceAll(_r3, "\\\\").replaceAll(_r7, "\\'").replaceAll(_r8, "\\n").replaceAll(_r9, "\\r").replaceAllMapped(_r5, (Match match) {
      var x = match.group(0)!;
      assert(x.length == 1);
      final code = x.codeUnitAt(0);
      if (code < 256) {
        // Add leading zero when needed to not care about the next character.
        return code < 16 ? "\\x0${code.toRadixString(16)}" : "\\x${code.toRadixString(16)}";
      }
      final c = code.toRadixString(16);
      return "\\u${("0000$c").substring(c.length, c.length + 4)}";
    })}'";
  } else {
    // Use single quote syntax.
    return "'$str'";
  }
}

String toCurl({
  required String method,
  required Uri url,
  Map<String, String>? headers,
  Map<String, dynamic>? bodyFields,
  String? body,
  Platform platform = Platform.POSIX,
}) {
  var command = ["curl"];
  var ignoredHeaders = ["host", "method", "path", "scheme", "version"];
  final escapeString = platform == Platform.WIN ? escapeStringWindows : escapeStringPosix;
  var requestMethod = 'GET';
  var data = <String>[];
  final requestHeaders = headers;
  final requestBody = body;
  final contentType = requestHeaders?["content-type"];

  command.add(
    escapeString(
      "${url.origin}${url.path}${url.query.isEmpty ? '' : '?${url.query}'}",
    ).replaceAllMapped(_r10, (match) => "\\${match.group(0)}"),
  );
  command.add("\\\n");
  if (contentType != null && contentType.indexOf(_urlencoded) == 0) {
    ignoredHeaders.add("content-length");
    requestMethod = "POST";
    data.add("--data");
    if (bodyFields != null) {
      data.add(
        escapeString(
          bodyFields.keys
              .map((key) => "${Uri.encodeComponent(key)}=${Uri.encodeComponent(bodyFields[key]!)}")
              .join("&"),
        ),
      );
    }
  } else if (requestBody != null && requestBody.isNotEmpty) {
    ignoredHeaders.add("content-length");
    requestMethod = "POST";
    data.add("--data-binary");
    data.add(escapeString(requestBody));
  }

  if (method != requestMethod) {
    command
      ..add("-X")
      ..add(method);
    command.add("\\\n");
  }
  if (requestHeaders != null) {
    Map<String, String>.fromIterable(
      requestHeaders.keys.where((k) => !ignoredHeaders.contains(k)),
      value: (k) => requestHeaders[k]!,
    ).forEach((k, v) {
      command
        ..add("-H")
        ..add(escapeString("$k: $v"));
      command.add("\\\n");
    });
  }
  return (command
        ..addAll(data)
        ..add("--compressed")
        ..add("--insecure"))
      .join(" ");
}
