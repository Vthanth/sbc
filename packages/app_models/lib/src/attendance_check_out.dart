import 'package:json_annotation/json_annotation.dart';

part 'attendance_check_out.g.dart';

@JsonSerializable()
class AttendanceCheckOut {
  @JsonKey(name: 'check_out')
  final DateTime checkOut;

  @JsonKey(name: 'check_out_latitude')
  final double checkOutLatitude;

  @JsonKey(name: 'check_out_longitude')
  final double checkOutLongitude;

  @JsonKey(name: 'check_out_location_name')
  final String checkOutLocationName;

  AttendanceCheckOut({
    required this.checkOut,
    required this.checkOutLatitude,
    required this.checkOutLongitude,
    required this.checkOutLocationName,
  });

  factory AttendanceCheckOut.fromJson(Map<String, dynamic> json) => _$AttendanceCheckOutFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceCheckOutToJson(this);
}
