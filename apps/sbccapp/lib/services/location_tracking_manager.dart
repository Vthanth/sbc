import 'dart:async';

import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/stores/location.store.dart';
import 'package:sbccapp/utils/app_lifecycle_observer.dart';

// Shared preference key for location tracking persistence
const String SHARED_PREFERENCE_KEY_WAS_CHECKED_IN = 'was_checked_in';

class LocationTrackingManager {
  static final LocationTrackingManager _instance = LocationTrackingManager._internal();
  factory LocationTrackingManager() => _instance;
  LocationTrackingManager._internal();

  final LocationStore _locationStore = locator<LocationStore>();
  final AppLifecycleObserver _appLifecycleObserver = locator<AppLifecycleObserver>();
  final InstantLocalPersistenceService _persistenceService = locator<InstantLocalPersistenceService>();

  bool _isTracking = false;
  StreamSubscription<AppLifecycleStateWithLastTimeBackgrounded>? _lifecycleSubscription;

  /// Initialize the location tracking manager
  void initialize() {
    // Listen to app lifecycle changes
    _lifecycleSubscription = _appLifecycleObserver.onLifecycleChanged.listen((lifecycleData) {
      _handleAppLifecycleChange(lifecycleData.state);
    });
  }

  /// Resume tracking with context (called when app has context)
  Future<void> resumeTrackingIfNeeded(BuildContext context) async {
    try {
      final wasCheckedIn = await _persistenceService.getBool(SHARED_PREFERENCE_KEY_WAS_CHECKED_IN, false);
      if (wasCheckedIn == true && !_isTracking) {
        print('Resuming location tracking from previous session...');
        await startLocationTracking(context);
      }
    } catch (e) {
      print('Error resuming location tracking: $e');
    }
  }

  /// Start location tracking (called when user checks in)
  Future<void> startLocationTracking(BuildContext context) async {
    if (_isTracking) return;

    _isTracking = true;

    try {
      await _locationStore.startLocationTracking(context);
      // Persist the check-in state
      await _persistenceService.setBool(SHARED_PREFERENCE_KEY_WAS_CHECKED_IN, true);
      print('Location tracking started successfully');
    } catch (e) {
      print('Error starting location tracking: $e');
      _isTracking = false;
    }
  }

  /// Stop location tracking (called when user checks out)
  void stopLocationTracking() async {
    if (!_isTracking) return;

    _isTracking = false;

    try {
      _locationStore.stopLocationTracking();
      // Clear the persisted check-in state
      await _persistenceService.setBool(SHARED_PREFERENCE_KEY_WAS_CHECKED_IN, false);
      print('Location tracking stopped successfully');
    } catch (e) {
      print('Error stopping location tracking: $e');
    }
  }

  /// Handle app lifecycle changes
  void _handleAppLifecycleChange(AppLifecycleState state) {
    if (!_isTracking) return;

    switch (state) {
      case AppLifecycleState.resumed:
        // App came to foreground - ensure tracking is active
        print('App resumed - location tracking should be active');
        break;
      case AppLifecycleState.paused:
        // App went to background - tracking should continue
        print('App paused - location tracking continues in background');
        break;
      case AppLifecycleState.inactive:
        // App is inactive - tracking should continue
        print('App inactive - location tracking continues');
        break;
      case AppLifecycleState.hidden:
        // App is hidden - tracking should continue
        print('App hidden - location tracking continues');
        break;
      case AppLifecycleState.detached:
        // App is detached - stop tracking
        print('App detached - stopping location tracking');
        stopLocationTracking();
        break;
    }
  }

  /// Check if location tracking is currently active
  bool get isTracking => _isTracking;

  /// Get the current location store
  LocationStore get locationStore => _locationStore;

  /// Dispose the manager
  void dispose() {
    _lifecycleSubscription?.cancel();
    if (_isTracking) {
      stopLocationTracking();
    }
  }
}
