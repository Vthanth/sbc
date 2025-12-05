import 'dart:async';

import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/helper/geolocator_helper.dart';
import 'package:sbccapp/services/device_metadata_service.dart';
import 'package:sbccapp/stores/user.store.dart';
import 'package:sbccapp/utils/mobx_provider.dart';

part 'location.store.g.dart';

class LocationStore = _LocationStore with _$LocationStore;

abstract class _LocationStore with Store, Disposable {
  final _userStore = locator<UserStore>();
  final _attendanceRepository = locator<AttendanceRepository>();
  final _deviceMetadataService = locator<DeviceMetadataService>();

  Timer? _locationTimer;
  bool _isTracking = false;

  @observable
  bool isLocationTracking = false;

  @observable
  LocationDetails? lastKnownLocation;

  @override
  void dispose() {
    stopLocationTracking();
  }

  @action
  Future<void> startLocationTracking(BuildContext context) async {
    if (_isTracking) return;

    _isTracking = true;
    isLocationTracking = true;

    // Get initial location
    await _captureAndUploadLocation(context);

    // Start timer for 30-minute intervals
    _locationTimer = Timer.periodic(const Duration(minutes: 30), (timer) async {
      if (_isTracking) {
        await _captureAndUploadLocation(context);
      } else {
        timer.cancel();
      }
    });
  }

  @action
  void stopLocationTracking() {
    _isTracking = false;
    isLocationTracking = false;
    _locationTimer?.cancel();
    _locationTimer = null;
  }

  @action
  Future<void> _captureAndUploadLocation(BuildContext context) async {
    try {
      final position = await GeolocatorHelper.getCurrentPosition(context);
      if (position == null) {
        print('Failed to get location for tracking');
        return;
      }

      lastKnownLocation = position;

      final userId = _userStore.currentUser?.id;
      if (userId == null) {
        print('User ID not available for location update');
        return;
      }

      // Get device metadata
      final deviceMetadata = await _deviceMetadataService.getDeviceMetadata();
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final dateTimeFormatted = dateFormat.format(DateTime.now());
      final locationUpdate = LocationUpdate(
        userId: userId.toString(),
        latitude: position.latitude,
        longitude: position.longitude,
        address: position.address,
        locationTimestamp: dateTimeFormatted,
        additionalData: deviceMetadata,
      );

      print('Location update: ${locationUpdate.toJson()}');

      await _attendanceRepository.uploadLocationUpdate(locationUpdate: locationUpdate);
      print('Location update uploaded successfully: ${position.latitude}, ${position.longitude}');
      print(
        'Device metadata: Battery: ${deviceMetadata.batteryLevel}%, Network: ${deviceMetadata.networkType}, Device: ${deviceMetadata.deviceModel}',
      );
    } catch (e) {
      print('Error capturing and uploading location: $e');
    }
  }

  @action
  Future<void> captureLocationNow(BuildContext context) async {
    await _captureAndUploadLocation(context);
  }
}
