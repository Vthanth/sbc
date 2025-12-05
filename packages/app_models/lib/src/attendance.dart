import 'package:json_annotation/json_annotation.dart';

part 'attendance.g.dart';

@JsonSerializable()
class Attendance {
  final int id;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'check_in')
  final String? checkIn;
  @JsonKey(name: 'check_in_latitude')
  final String checkInLatitude;
  @JsonKey(name: 'check_in_longitude')
  final String checkInLongitude;
  @JsonKey(name: 'check_in_location_name')
  final String checkInLocationName;
  @JsonKey(name: 'check_out')
  final String? checkOut;
  @JsonKey(name: 'check_out_latitude')
  final String? checkOutLatitude;
  @JsonKey(name: 'check_out_longitude')
  final String? checkOutLongitude;
  @JsonKey(name: 'check_out_location_name')
  final String? checkOutLocationName;
  @JsonKey(name: 'created_at')
  final String? createdAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  Attendance({
    required this.id,
    required this.userId,
    required this.checkIn,
    required this.checkInLatitude,
    required this.checkInLongitude,
    required this.checkInLocationName,
    this.checkOut,
    this.checkOutLatitude,
    this.checkOutLongitude,
    this.checkOutLocationName,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Attendance.fromJson(Map<String, dynamic> json) => _$AttendanceFromJson(json);
  Map<String, dynamic> toJson() => _$AttendanceToJson(this);

  bool get isCheckedOut => checkOut != null;

  Duration? get workingHours {
    if (checkOut == null || checkIn == null) return null;
    final checkInDate = DateTime.parse(checkIn!);
    final checkOutDate = DateTime.parse(checkOut!);
    return checkOutDate.difference(checkInDate);
  }

  String get formattedWorkingHours {
    if (workingHours == null) return 'Not checked out';
    final hours = workingHours!.inHours;
    final minutes = workingHours!.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}
