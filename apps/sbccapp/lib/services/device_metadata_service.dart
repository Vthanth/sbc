import 'dart:io';

import 'package:app_models/models.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceMetadataService {
  static final DeviceMetadataService _instance = DeviceMetadataService._internal();
  factory DeviceMetadataService() => _instance;
  DeviceMetadataService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final Battery _battery = Battery();

  /// Get comprehensive device metadata
  Future<DeviceMetadata> getDeviceMetadata() async {
    try {
      final batteryLevel = await _getBatteryLevel();
      final networkType = await _getNetworkType();
      final appVersion = await _getAppVersion();
      final deviceModel = await _getDeviceModel();
      final osVersion = await _getOsVersion();

      return DeviceMetadata(
        batteryLevel: batteryLevel,
        networkType: networkType,
        appVersion: appVersion,
        deviceModel: deviceModel,
        osVersion: osVersion,
      );
    } catch (e) {
      print('Error getting device metadata: $e');
      // Return default values if there's an error
      return DeviceMetadata(
        batteryLevel: 0,
        networkType: 'Unknown',
        appVersion: '1.0',
        deviceModel: 'Unknown',
        osVersion: 'Unknown',
      );
    }
  }

  /// Get battery level as percentage (0-100)
  Future<double> _getBatteryLevel() async {
    try {
      final batteryLevel = await _battery.batteryLevel;
      return batteryLevel.toDouble();
    } catch (e) {
      print('Error getting battery level: $e');
      return 0.0;
    }
  }

  /// Get network type as string
  Future<String> _getNetworkType() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      switch (connectivityResult.first) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobile';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        case ConnectivityResult.bluetooth:
          return 'Bluetooth';
        case ConnectivityResult.vpn:
          return 'VPN';
        case ConnectivityResult.other:
          return 'Other';
        case ConnectivityResult.none:
          return 'None';
      }
    } catch (e) {
      print('Error getting network type: $e');
      return 'Unknown';
    }
  }

  /// Get app version as string
  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      print('Error getting app version: $e');
      return '1.0';
    }
  }

  /// Get device model
  Future<String> _getDeviceModel() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return '${androidInfo.brand} ${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return '${iosInfo.name} ${iosInfo.model}';
      } else {
        return 'Unknown Device';
      }
    } catch (e) {
      print('Error getting device model: $e');
      return 'Unknown Device';
    }
  }

  /// Get OS version
  Future<String> _getOsVersion() async {
    try {
      if (Platform.isAndroid) {
        final androidInfo = await _deviceInfo.androidInfo;
        return 'Android ${androidInfo.version.release}';
      } else if (Platform.isIOS) {
        final iosInfo = await _deviceInfo.iosInfo;
        return 'iOS ${iosInfo.systemVersion}';
      } else {
        return 'Unknown OS';
      }
    } catch (e) {
      print('Error getting OS version: $e');
      return 'Unknown OS';
    }
  }

  /// Get network type as string for debugging
  Future<String> getNetworkTypeString() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      switch (connectivityResult.first) {
        case ConnectivityResult.wifi:
          return 'WiFi';
        case ConnectivityResult.mobile:
          return 'Mobile';
        case ConnectivityResult.ethernet:
          return 'Ethernet';
        case ConnectivityResult.bluetooth:
          return 'Bluetooth';
        case ConnectivityResult.vpn:
          return 'VPN';
        case ConnectivityResult.other:
          return 'Other';
        case ConnectivityResult.none:
          return 'None';
      }
    } catch (e) {
      return 'Unknown';
    }
  }
}
