import 'package:json_annotation/json_annotation.dart';

part 'attendance_check_in.g.dart';

@JsonSerializable()
class AttendanceCheckIn {
  @JsonKey(name: 'check_in')
  final DateTime checkIn;

  @JsonKey(name: 'check_in_latitude')
  final double checkInLatitude;

  @JsonKey(name: 'check_in_longitude')
  final double checkInLongitude;

  @JsonKey(name: 'check_in_location_name')
  final String checkInLocationName;

  AttendanceCheckIn({
    required this.checkIn,
    required this.checkInLatitude,
    required this.checkInLongitude,
    required this.checkInLocationName,
  });

  factory AttendanceCheckIn.fromJson(Map<String, dynamic> json) => _$AttendanceCheckInFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceCheckInToJson(this);
}
