import 'package:app_models/models.dart';

abstract class AttendanceRepository {
  Future<List<Attendance>> getAttendance();
  Future<Attendance?> addAttendance({required AttendanceCheckIn attendance});
  Future<Attendance?> updateAttendance({required AttendanceCheckOut attendance});
  Future<void> deleteAttendance({required String attendanceId});
  Future<void> uploadLocationUpdate({required LocationUpdate locationUpdate});
}
