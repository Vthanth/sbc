// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location.store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LocationStore on _LocationStore, Store {
  late final _$isLocationTrackingAtom = Atom(
    name: '_LocationStore.isLocationTracking',
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
    name: '_LocationStore.lastKnownLocation',
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

  late final _$startLocationTrackingAsyncAction = AsyncAction(
    '_LocationStore.startLocationTracking',
    context: context,
  );

  @override
  Future<void> startLocationTracking(BuildContext context) {
    return _$startLocationTrackingAsyncAction.run(
      () => super.startLocationTracking(context),
    );
  }

  late final _$_captureAndUploadLocationAsyncAction = AsyncAction(
    '_LocationStore._captureAndUploadLocation',
    context: context,
  );

  @override
  Future<void> _captureAndUploadLocation(BuildContext context) {
    return _$_captureAndUploadLocationAsyncAction.run(
      () => super._captureAndUploadLocation(context),
    );
  }

  late final _$captureLocationNowAsyncAction = AsyncAction(
    '_LocationStore.captureLocationNow',
    context: context,
  );

  @override
  Future<void> captureLocationNow(BuildContext context) {
    return _$captureLocationNowAsyncAction.run(
      () => super.captureLocationNow(context),
    );
  }

  late final _$_LocationStoreActionController = ActionController(
    name: '_LocationStore',
    context: context,
  );

  @override
  void stopLocationTracking() {
    final _$actionInfo = _$_LocationStoreActionController.startAction(
      name: '_LocationStore.stopLocationTracking',
    );
    try {
      return super.stopLocationTracking();
    } finally {
      _$_LocationStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLocationTracking: ${isLocationTracking},
lastKnownLocation: ${lastKnownLocation}
    ''';
  }
}
