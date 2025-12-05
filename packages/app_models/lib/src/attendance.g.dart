// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Attendance _$AttendanceFromJson(Map<String, dynamic> json) => Attendance(
  id: (json['id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  checkIn: json['check_in'] as String?,
  checkInLatitude: json['check_in_latitude'] as String,
  checkInLongitude: json['check_in_longitude'] as String,
  checkInLocationName: json['check_in_location_name'] as String,
  checkOut: json['check_out'] as String?,
  checkOutLatitude: json['check_out_latitude'] as String?,
  checkOutLongitude: json['check_out_longitude'] as String?,
  checkOutLocationName: json['check_out_location_name'] as String?,
  createdAt: json['created_at'] as String?,
  updatedAt: json['updated_at'] as String?,
);

Map<String, dynamic> _$AttendanceToJson(Attendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'check_in': instance.checkIn,
      'check_in_latitude': instance.checkInLatitude,
      'check_in_longitude': instance.checkInLongitude,
      'check_in_location_name': instance.checkInLocationName,
      'check_out': instance.checkOut,
      'check_out_latitude': instance.checkOutLatitude,
      'check_out_longitude': instance.checkOutLongitude,
      'check_out_location_name': instance.checkOutLocationName,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
