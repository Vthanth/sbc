// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_page.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AttendancePageStore on _AttendancePageStore, Store {
  late final _$attendancesAtom = Atom(
    name: '_AttendancePageStore.attendances',
    context: context,
  );

  @override
  Result<List<Attendance>> get attendances {
    _$attendancesAtom.reportRead();
    return super.attendances;
  }

  @override
  set attendances(Result<List<Attendance>> value) {
    _$attendancesAtom.reportWrite(value, super.attendances, () {
      super.attendances = value;
    });
  }

  late final _$todayAttendanceAtom = Atom(
    name: '_AttendancePageStore.todayAttendance',
    context: context,
  );

  @override
  Attendance? get todayAttendance {
    _$todayAttendanceAtom.reportRead();
    return super.todayAttendance;
  }

  @override
  set todayAttendance(Attendance? value) {
    _$todayAttendanceAtom.reportWrite(value, super.todayAttendance, () {
      super.todayAttendance = value;
    });
  }

  late final _$deletingAttendanceIdAtom = Atom(
    name: '_AttendancePageStore.deletingAttendanceId',
    context: context,
  );

  @override
  String? get deletingAttendanceId {
    _$deletingAttendanceIdAtom.reportRead();
    return super.deletingAttendanceId;
  }

  @override
  set deletingAttendanceId(String? value) {
    _$deletingAttendanceIdAtom.reportWrite(
      value,
      super.deletingAttendanceId,
      () {
        super.deletingAttendanceId = value;
      },
    );
  }

  late final _$isCheckingInLoadingAtom = Atom(
    name: '_AttendancePageStore.isCheckingInLoading',
    context: context,
  );

  @override
  bool get isCheckingInLoading {
    _$isCheckingInLoadingAtom.reportRead();
    return super.isCheckingInLoading;
  }

  @override
  set isCheckingInLoading(bool value) {
    _$isCheckingInLoadingAtom.reportWrite(value, super.isCheckingInLoading, () {
      super.isCheckingInLoading = value;
    });
  }

  late final _$isLocationTrackingAtom = Atom(
    name: '_AttendancePageStore.isLocationTracking',
    context: context,
  );

  @override
  bool get isLocationTracking {
    _$isLocationTrackingAtom.reportRead();
    return super.isLocationTracking;
  }

  @override
  set isLocationTracking(bool value) {
    _$isLocationTrackingAtom.reportWrite(value, super.isLocationTracking, () {
      super.isLocationTracking = value;
    });
  }

  late final _$lastKnownLocationAtom = Atom(
    name: '_AttendancePageStore.lastKnownLocation',
    context: context,
  );

  @override
  LocationDetails? get lastKnownLocation {
    _$lastKnownLocationAtom.reportRead();
    return super.lastKnownLocation;
  }

  @override
  set lastKnownLocation(LocationDetails? value) {
    _$lastKnownLocationAtom.reportWrite(value, super.lastKnownLocation, () {
      super.lastKnownLocation = value;
    });
  }

  late final _$loadAttendancesAsyncAction = AsyncAction(
    '_AttendancePageStore.loadAttendances',
    context: context,
  );

  @override
  Future<void> loadAttendances() {
    return _$loadAttendancesAsyncAction.run(() => super.loadAttendances());
  }

  late final _$refreshAttendancesAsyncAction = AsyncAction(
    '_AttendancePageStore.refreshAttendances',
    context: context,
  );

  @override
  Future<void> refreshAttendances() {
    return _$refreshAttendancesAsyncAction.run(
      () => super.refreshAttendances(),
    );
  }

  late final _$checkInAsyncAction = AsyncAction(
    '_AttendancePageStore.checkIn',
    context: context,
  );

  @override
  Future<void> checkIn({required BuildContext context}) {
    return _$checkInAsyncAction.run(() => super.checkIn(context: context));
  }

  late final _$checkOutAsyncAction = AsyncAction(
    '_AttendancePageStore.checkOut',
    context: context,
  );

  @override
  Future<void> checkOut({required BuildContext context}) {
    return _$checkOutAsyncAction.run(() => super.checkOut(context: context));
  }

  late final _$_startLocationTrackingAsyncAction = AsyncAction(
    '_AttendancePageStore._startLocationTracking',
    context: context,
  );

  @override
  Future<void> _startLocationTracking(BuildContext context) {
    return _$_startLocationTrackingAsyncAction.run(
      () => super._startLocationTracking(context),
    );
  }

  late final _$deleteAttendanceAsyncAction = AsyncAction(
    '_AttendancePageStore.deleteAttendance',
    context: context,
  );

  @override
  Future<void> deleteAttendance(String attendanceId) {
    return _$deleteAttendanceAsyncAction.run(
      () => super.deleteAttendance(attendanceId),
    );
  }

  late final _$captureLocationNowAsyncAction = AsyncAction(
    '_AttendancePageStore.captureLocationNow',
    context: context,
  );

  @override
  Future<void> captureLocationNow(BuildContext context) {
    return _$captureLocationNowAsyncAction.run(
      () => super.captureLocationNow(context),
    );
  }

  @override
  String toString() {
    return '''
attendances: ${attendances},
todayAttendance: ${todayAttendance},
deletingAttendanceId: ${deletingAttendanceId},
isCheckingInLoading: ${isCheckingInLoading},
isLocationTracking: ${isLocationTracking},
lastKnownLocation: ${lastKnownLocation}
    ''';
  }
}
