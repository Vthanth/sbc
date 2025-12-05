import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  final PublishSubject<AppLifecycleState> _lifecycleRefreshObserverController = PublishSubject();
  final PublishSubject<AppLifecycleStateWithLastTimeBackgrounded> _appLifeCycleStateWithLastTimeBackgrounded =
      PublishSubject();

  var _lastTimeBackgrounded = 0;
  final _maxBackgroundDurationForRefreshInMilliseconds =
      kDebugMode
          ? 30 * Duration.millisecondsPerSecond
          : 1 * Duration.millisecondsPerHour; // 30sec in debug, 1h in release

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _appLifeCycleStateWithLastTimeBackgrounded.add(
      AppLifecycleStateWithLastTimeBackgrounded(state, _lastTimeBackgrounded),
    );
    switch (state) {
      case AppLifecycleState.resumed:
        if (_lastTimeBackgrounded != 0 &&
            (DateTime.now().millisecondsSinceEpoch - _lastTimeBackgrounded) >
                _maxBackgroundDurationForRefreshInMilliseconds) {
          _lifecycleRefreshObserverController.add(state);
        }
        _lastTimeBackgrounded = 0;
        break;
      case AppLifecycleState.paused:
        _lastTimeBackgrounded = DateTime.now().millisecondsSinceEpoch;
        break;
      case AppLifecycleState.hidden:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        break;
    }
  }

  Stream<AppLifecycleState> get onLifecycleRefreshChanged => _lifecycleRefreshObserverController.stream;
  Stream<AppLifecycleStateWithLastTimeBackgrounded> get onLifecycleChanged =>
      _appLifeCycleStateWithLastTimeBackgrounded.stream;

  void dispose() {
    _lifecycleRefreshObserverController.close();
    _appLifeCycleStateWithLastTimeBackgrounded.close();
  }
}

class AppLifecycleStateWithLastTimeBackgrounded {
  AppLifecycleStateWithLastTimeBackgrounded(this.state, this.lastTimeBackgrounded);

  final AppLifecycleState state;
  final int lastTimeBackgrounded;
}
