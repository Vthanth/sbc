// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_check_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceCheckOut _$AttendanceCheckOutFromJson(Map<String, dynamic> json) =>
    AttendanceCheckOut(
      checkOut: DateTime.parse(json['check_out'] as String),
      checkOutLatitude: (json['check_out_latitude'] as num).toDouble(),
      checkOutLongitude: (json['check_out_longitude'] as num).toDouble(),
      checkOutLocationName: json['check_out_location_name'] as String,
    );

Map<String, dynamic> _$AttendanceCheckOutToJson(AttendanceCheckOut instance) =>
    <String, dynamic>{
      'check_out': instance.checkOut.toIso8601String(),
      'check_out_latitude': instance.checkOutLatitude,
      'check_out_longitude': instance.checkOutLongitude,
      'check_out_location_name': instance.checkOutLocationName,
    };
