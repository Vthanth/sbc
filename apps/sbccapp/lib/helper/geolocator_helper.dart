import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class LocationDetails {
  final String address;
  final double latitude;
  final double longitude;

  LocationDetails({required this.address, required this.latitude, required this.longitude});
}

class GeolocatorHelper {
  static Future<bool> _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permissions are permanently denied, we cannot request permissions.')),
      );
      return false;
    }
    return true;
  }

  static Future<LocationDetails?> getCurrentPosition(BuildContext context) async {
    String? _currentAddress;
    Position? _currentPosition;

    try {
      final hasPermission = await _handleLocationPermission(context);

      if (!hasPermission) return null;

      final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      _currentPosition = position;
      _currentAddress = await _getAddressFromLatLng(_currentPosition);

      return LocationDetails(
        address: _currentAddress ?? '',
        latitude: _currentPosition.latitude,
        longitude: _currentPosition.longitude,
      );
    } catch (e) {
      return null;
    }
  }

  static Future<String?> _getAddressFromLatLng(Position position) async {
    try {
      final placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
      if (placeMarks.isEmpty) {
        return null;
      }
      final placemark = placeMarks[0];
      return '${placemark.street}, ${placemark.subLocality}, ${placemark.subAdministrativeArea}, ${placemark.postalCode}, ${placemark.country}';
    } catch (e) {
      return null;
    }
  }

  static Future<Position?> _getCurrentPositionOld({required BuildContext context}) async {
    bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationServiceEnabled) {
      DialogHelper.show(context, 'Location Service is not enabled', 'Please enable location service to use this app');
      return null;
    }
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      DialogHelper.show(context, 'Location Permission is denied', 'Please enable location permission to use this app');
      await Geolocator.requestPermission();
      return null;
    }
    if (permission == LocationPermission.deniedForever) {
      DialogHelper.show(
        context,
        'Location Permission is denied forever',
        'Please enable location permission to use this app',
      );
      return null;
    }
    return Geolocator.getCurrentPosition();
  }
}

class DialogHelper {
  static void show(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: const Text("okay"),
              ),
            ],
          ),
    );
  }
}
