import 'package:app_models/models.dart';
import 'package:app_services/services.dart';
import 'package:sbccapp/core/shared_preference_keys.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceNetworkService _attendanceNetworkService;
  final InstantLocalPersistenceService _instantLocalPersistenceService;

  AttendanceRepositoryImpl(this._attendanceNetworkService, this._instantLocalPersistenceService);

  @override
  Future<Attendance?> addAttendance({required AttendanceCheckIn attendance}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return null;
    }
    return _attendanceNetworkService.addAttendance(bearerToken: bearerToken, attendance: attendance);
  }

  @override
  Future<void> deleteAttendance({required String attendanceId}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return;
    }
    await _attendanceNetworkService.deleteAttendance(bearerToken: bearerToken, attendanceId: attendanceId);
  }

  @override
  Future<List<Attendance>> getAttendance() async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return [];
    }
    return await _attendanceNetworkService.getAttendance(bearerToken: bearerToken);
  }

  @override
  Future<Attendance?> updateAttendance({required AttendanceCheckOut attendance}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return null;
    }
    return _attendanceNetworkService.updateAttendance(bearerToken: bearerToken, attendance: attendance);
  }

  @override
  Future<void> uploadLocationUpdate({required LocationUpdate locationUpdate}) async {
    final bearerToken = await _instantLocalPersistenceService.getString(SHARED_PREFERENCE_KEY_BEARER_TOKEN);
    if (bearerToken == null) {
      return;
    }
    await _attendanceNetworkService.uploadLocationUpdate(bearerToken: bearerToken, locationUpdate: locationUpdate);
  }
}
