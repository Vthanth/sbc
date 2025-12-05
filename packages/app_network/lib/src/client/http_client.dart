/// Conditional import for browser client
/// https://github.com/dart-lang/http/pull/485
///https://gist.github.com/jakemac53/204d6adfe04eafa7e4d432fa77b3b4b1

// ignore_for_file: dangling_library_doc_comments

export 'http_client_default.dart' if (dart.library.html) 'http_client_browser.dart';
