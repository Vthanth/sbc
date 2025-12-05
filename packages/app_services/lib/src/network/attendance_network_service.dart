import 'package:app_models/models.dart';

abstract class AttendanceNetworkService {
  Future<Attendance?> addAttendance({required String bearerToken, required AttendanceCheckIn attendance});
  Future<Attendance?> updateAttendance({required String bearerToken, required AttendanceCheckOut attendance});
  Future<void> deleteAttendance({required String bearerToken, required String attendanceId});
  Future<List<Attendance>> getAttendance({required String bearerToken});
  Future<void> uploadLocationUpdate({required String bearerToken, required LocationUpdate locationUpdate});
}
