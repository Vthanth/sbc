import 'dart:async'; // Added for Timer

import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:sbccapp/core/service_locator.dart';
import 'package:sbccapp/helper/geolocator_helper.dart';
import 'package:sbccapp/services/location_tracking_manager.dart';
import 'package:sbccapp/utils.dart';
import 'package:sbccapp/utils/mobx_provider.dart';

part 'attendance_page.store.g.dart';

class AttendancePageStore = _AttendancePageStore with _$AttendancePageStore;

abstract class _AttendancePageStore with Store, Disposable {
  final _attendanceRepository = locator<AttendanceRepository>();
  final _locationTrackingManager = locator<LocationTrackingManager>();

  @observable
  Result<List<Attendance>> attendances = Result.none();

  @observable
  Attendance? todayAttendance;

  List<Attendance> _attendancesPrivate = [];

  @observable
  String? deletingAttendanceId;

  @observable
  bool isCheckingInLoading = false;

  @observable
  bool isLocationTracking = false;

  @observable
  LocationDetails? lastKnownLocation;

  @action
  Future<void> loadAttendances() async {
    attendances = Result.loading();
    try {
      final attendanceList = await _attendanceRepository.getAttendance();
      _attendancesPrivate = attendanceList.reversed.toList();
      attendances = Result(_attendancesPrivate);

      todayAttendance = _attendancesPrivate.firstWhereOrNull((attendance) {
        if (attendance.checkIn == null) return false;
        final checkInDate = Utils.dateFromString(attendance.checkIn!);
        return checkInDate.day == DateTime.now().day &&
            checkInDate.month == DateTime.now().month &&
            checkInDate.year == DateTime.now().year;
      });

      // Sync location tracking state with the manager
      isLocationTracking = _locationTrackingManager.isTracking;
      lastKnownLocation = _locationTrackingManager.locationStore.lastKnownLocation;
    } catch (e) {
      attendances = Result.error(error: e);
    } finally {}
  }

  @action
  Future<void> refreshAttendances() async {
    await loadAttendances();
  }

  @action
  Future<void> checkIn({required BuildContext context}) async {
    isCheckingInLoading = true;
    try {
      final position = await GeolocatorHelper.getCurrentPosition(context);
      if (position == null) {
        return;
      }

      final attendance = AttendanceCheckIn(
        checkIn: DateTime.now(),
        checkInLatitude: position.latitude,
        checkInLongitude: position.longitude,
        checkInLocationName: position.address,
      );
      final newlyAddedAttendance = await _attendanceRepository.addAttendance(attendance: attendance);
      if (newlyAddedAttendance != null) {
        //_attendancesPrivate.removeWhere((attendance) => attendance.id.toString() == newlyAddedAttendance.id.toString());
        _attendancesPrivate.insert(0, newlyAddedAttendance);
      }
      todayAttendance = newlyAddedAttendance;

      attendances = Result(_attendancesPrivate);

      // Start location tracking after successful check-in
      await _startLocationTracking(context);
    } catch (e) {
      // Handle error
    } finally {
      isCheckingInLoading = false;
    }
  }

  @action
  Future<void> checkOut({required BuildContext context}) async {
    isCheckingInLoading = true;
    try {
      final position = await GeolocatorHelper.getCurrentPosition(context);
      if (position == null) {
        return;
      }

      final attendance = AttendanceCheckOut(
        checkOut: DateTime.now(),
        checkOutLatitude: position.latitude,
        checkOutLongitude: position.longitude,
        checkOutLocationName: position.address,
      );
      final newlyAddedAttendance = await _attendanceRepository.updateAttendance(attendance: attendance);
      if (newlyAddedAttendance != null) {
        _attendancesPrivate.removeWhere((attendance) => attendance.id.toString() == newlyAddedAttendance.id.toString());
        _attendancesPrivate.insert(0, newlyAddedAttendance);
      }
      attendances = Result(_attendancesPrivate);
      todayAttendance = newlyAddedAttendance;

      // Stop location tracking after successful check-out
      _locationTrackingManager.stopLocationTracking();
      isLocationTracking = false;
    } catch (e) {
      // Handle error
    } finally {
      isCheckingInLoading = false;
    }
  }

  @action
  Future<void> _startLocationTracking(BuildContext context) async {
    try {
      await _locationTrackingManager.startLocationTracking(context);
      isLocationTracking = _locationTrackingManager.isTracking;
      lastKnownLocation = _locationTrackingManager.locationStore.lastKnownLocation;

      // Set up periodic check for location updates
      Timer.periodic(const Duration(seconds: 5), (timer) {
        if (!isLocationTracking) {
          timer.cancel();
          return;
        }
        lastKnownLocation = _locationTrackingManager.locationStore.lastKnownLocation;
        isLocationTracking = _locationTrackingManager.isTracking;
      });
    } catch (e) {
      print('Error starting location tracking: $e');
    }
  }

  @action
  Future<void> deleteAttendance(String attendanceId) async {
    deletingAttendanceId = attendanceId;
    try {
      await _attendanceRepository.deleteAttendance(attendanceId: attendanceId);
      _attendancesPrivate.removeWhere((attendance) => attendance.id.toString() == attendanceId);
      attendances = Result.loading();
      attendances = Result(_attendancesPrivate);
    } catch (e) {
      // Handle error
    } finally {
      deletingAttendanceId = null;
    }
  }

  @action
  Future<void> captureLocationNow(BuildContext context) async {
    try {
      await _locationTrackingManager.locationStore.captureLocationNow(context);
    } catch (e) {
      print('Error capturing location: $e');
    }
  }

  List<Attendance> get recentAttendances {
    return attendances.maybeWhen(
      (list) => list.take(7).toList(), // Get last 7 days
      orElse: () => [],
    );
  }
}
