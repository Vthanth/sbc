import 'dart:async';

class LogoutStreamListener {
  static final LogoutStreamListener singleton = LogoutStreamListener._internal();

  factory LogoutStreamListener() {
    return singleton;
  }

  LogoutStreamListener._internal();

  final StreamController<bool> listenLogoutButtonEvent = StreamController.broadcast();
}
