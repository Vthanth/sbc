import 'dart:convert';

import 'package:app_models/models.dart';
import 'package:app_network/app_network.dart';
import 'package:app_network/src/client/base_network_service.dart';
import 'package:app_services/services.dart';

class AttendanceNetworkServiceImpl extends BaseNetworkService implements AttendanceNetworkService {
  AttendanceNetworkServiceImpl(AppClient client, NetworkConfigBase config) : super(client, config.apiEndPoint);

  @override
  Future<Attendance?> addAttendance({required String bearerToken, required AttendanceCheckIn attendance}) async {
    final requestUrl = '${host}checkin';

    final parameters = {
      'check_in_latitude': attendance.checkInLatitude.toString(),
      'check_in_longitude': attendance.checkInLongitude.toString(),
      'check_in_location_name': attendance.checkInLocationName,
    };

    try {
      final response = await client.post(
        requestUrl,
        body: parameters,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        final attendance = Attendance.fromJson(body['data']);
        return attendance;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<void> deleteAttendance({required String bearerToken, required String attendanceId}) async {
    final requestUrl = '${host}attendances/$attendanceId';

    try {
      final response = await client.delete(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<List<Attendance>> getAttendance({required String bearerToken}) async {
    final requestUrl = '${host}attendances';

    try {
      final response = await client.get(requestUrl, headers: {"Authorization": "Bearer $bearerToken"});
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return (body as List).map((e) => Attendance.fromJson(e)).toList();
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<Attendance?> updateAttendance({required String bearerToken, required AttendanceCheckOut attendance}) async {
    final requestUrl = '${host}checkout';

    final parameters = {
      'check_out_latitude': attendance.checkOutLatitude.toString(),
      'check_out_longitude': attendance.checkOutLongitude.toString(),
      'check_out_location_name': attendance.checkOutLocationName,
    };

    try {
      final response = await client.put(
        requestUrl,
        body: parameters,
        encodeJson: false,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        final body = jsonDecode(response.body);
        return Attendance.fromJson(body['data']);
      } else {
        throw Exception(response.body);
      }
    } catch (e) {
      throw Exception("Network error while calling the network service");
    }
  }

  @override
  Future<void> uploadLocationUpdate({required String bearerToken, required LocationUpdate locationUpdate}) async {
    final requestUrl = '${host}locations';

    try {
      final response = await client.post(
        requestUrl,
        body: locationUpdate.toJson(),
        encodeJson: true,
        headers: {"Authorization": "Bearer $bearerToken"},
      );
      if (isSuccessful(response.statusCode)) {
        return;
      } else {
        throw Exception(response.body);
      }
    } catch (e, _) {
      throw Exception("Network error while uploading location update");
    }
  }
}
