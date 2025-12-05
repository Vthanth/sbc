// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_check_in.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceCheckIn _$AttendanceCheckInFromJson(Map<String, dynamic> json) =>
    AttendanceCheckIn(
      checkIn: DateTime.parse(json['check_in'] as String),
      checkInLatitude: (json['check_in_latitude'] as num).toDouble(),
      checkInLongitude: (json['check_in_longitude'] as num).toDouble(),
      checkInLocationName: json['check_in_location_name'] as String,
    );

Map<String, dynamic> _$AttendanceCheckInToJson(AttendanceCheckIn instance) =>
    <String, dynamic>{
      'check_in': instance.checkIn.toIso8601String(),
      'check_in_latitude': instance.checkInLatitude,
      'check_in_longitude': instance.checkInLongitude,
      'check_in_location_name': instance.checkInLocationName,
    };
