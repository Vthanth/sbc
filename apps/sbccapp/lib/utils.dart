import 'package:app_services/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sbccapp/core/service_locator.dart';

class Utils {
  static final Utils instance = Utils();

  static bool isMobileLayout(BuildContext context) {
    // Determine if we should use mobile layout or not. The number 600 here is a common breakpoint for a typical 7-inch tablet.
    // Reference URL: https://iirokrankka.com/2018/01/28/implementing-adaptive-master-detail-layouts/
    return MediaQuery.of(context).size.shortestSide < 600;
  }

  static bool isSmallTabLayout(BuildContext context) {
    // Determine if we should use mobile layout or not. The number 700 here is a common breakpoint for a typical 7-inch tablet.
    // Reference URL: https://iirokrankka.com/2018/01/28/implementing-adaptive-master-detail-layouts/
    return MediaQuery.of(context).size.shortestSide < 700;
  }

  static bool isLandscape(BuildContext context) {
    return MediaQuery.of(context).orientation == Orientation.landscape;
  }

  static EdgeInsets dialogInsetPadding(BuildContext context) {
    if (isMobileLayout(context)) {
      return const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0); // default padding in dialog.dart
    } else {
      final horizontal = (MediaQuery.of(context).size.width - 325) / 2;
      return EdgeInsets.symmetric(horizontal: horizontal, vertical: 24.0);
    }
  }

  String formatCountWithCommaSeparatorOnly(int number) {
    final formatter = NumberFormat('#,###');
    return formatter.format(number);
  }

  Future<bool> isConnectedToNetwork() async {
    var networkStatus = await locator<NetworkManager>().getNetworkState();
    return networkStatus != NetworkState.off;
  }

  /// It will use to get the height of widget.
  /// height of widget will be different base on device size.
  static double getResponsiveHeightOfWidget(int height, double screenWidth) {
    return screenWidth * height / 375.0;
  }

  /// It will use to get the Pixel based on screen size.
  static double getHorizontalPixel(Size size, double value) {
    return (value * size.width) / 375;
  }

  /// It will use to get the Pixel based on tablet screen size.
  static double getTabletHorizontalPixel(Size size, double value) {
    return (value * size.width) / 768;
  }

  static TextScaler maxTextScaler(BuildContext context, {double defaultMaxTextScaleFactor = 1.1}) {
    final textScaler = MediaQuery.of(context).textScaler;
    return textScaler.clamp(minScaleFactor: 1.0, maxScaleFactor: defaultMaxTextScaleFactor);
  }

  /// Converts UTC DateTime string to local time format (HH:mm)
  /// Returns time in 24-hour format
  static String formatTimeToLocal(String utcTimeString) {
    try {
      final utcTime = DateTime.parse(utcTimeString);
      final localTime = utcTime.toLocal();
      return DateFormat('HH:mm').format(localTime);
    } catch (e) {
      return 'Error';
    }
  }

  /// Converts UTC DateTime string to local date and time format (MMM dd, yyyy HH:mm)
  /// Returns both date and time in local format
  static String formatDateTimeToLocal(String utcTimeString) {
    try {
      final utcTime = DateTime.parse(utcTimeString);
      final localTime = utcTime.toLocal();
      return DateFormat('MMM dd, yyyy HH:mm').format(localTime);
    } catch (e) {
      return 'Error';
    }
  }

  /// Converts UTC DateTime string to local date and time format with AM/PM (MMM dd, yyyy hh:mm a)
  /// Returns both date and time in local format with AM/PM
  static String formatDateTimeToLocalWithAmPm(String utcTimeString) {
    try {
      final utcTime = DateTime.parse(utcTimeString);
      final localTime = utcTime.toLocal();
      return DateFormat('MMM dd, yyyy hh:mm a').format(localTime);
    } catch (e) {
      return 'Error';
    }
  }

  /// Converts UTC DateTime string to local date format only (MMM dd, yyyy)
  /// Returns only the date in local format
  /// //2025-06-16T10:26:44.000000Z
  static DateTime dateFromString(String utcTimeString) {
    if (utcTimeString.contains("T")) {
      final utcTime = DateFormat("yyyy-MM-ddTHH:mm:ss").parse(utcTimeString, true);
      return utcTime.toLocal();
    } else {
      final utcTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(utcTimeString, true);
      return utcTime.toLocal();
    }
  }

  /// Overloaded methods for DateTime objects (for backward compatibility)
  static String formatTimeToLocalFromDateTime(DateTime utcTime) {
    try {
      final localTime = utcTime.toLocal();
      return DateFormat('HH:mm').format(localTime);
    } catch (e) {
      return 'Error';
    }
  }

  static String formatTimeToLocalWithAmPmFromDateTime(DateTime utcTime) {
    try {
      final localTime = utcTime.toLocal();
      return DateFormat('hh:mm a').format(localTime);
    } catch (e) {
      return 'Error';
    }
  }

  static String formatDateTimeToLocalFromDateTime(DateTime utcTime) {
    try {
      final localTime = utcTime.toLocal();
      return DateFormat('MMM dd, yyyy HH:mm').format(localTime);
    } catch (e) {
      return 'Error';
    }
  }

  static String formatDateTimeToLocalWithAmPmFromDateTime(DateTime utcTime) {
    try {
      final localTime = utcTime.toLocal();
      return DateFormat('MMM dd, yyyy hh:mm a').format(localTime);
    } catch (e) {
      return 'Error';
    }
  }

  static String formatDateToLocalFromDateTime(DateTime utcTime) {
    try {
      final localTime = utcTime.toLocal();
      return DateFormat('MMM dd, yyyy').format(localTime);
    } catch (e) {
      return 'Error';
    }
  }
}
