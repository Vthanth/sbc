import 'package:json_annotation/json_annotation.dart';

part 'location_update.g.dart';

@JsonSerializable()
class LocationUpdate {
  @JsonKey(name: 'user_id')
  final String userId;

  @JsonKey(name: 'latitude')
  final double latitude;

  @JsonKey(name: 'longitude')
  final double longitude;

  @JsonKey(name: 'address')
  final String address;

  @JsonKey(name: 'location_timestamp')
  final String locationTimestamp;

  @JsonKey(name: 'additional_data')
  final DeviceMetadata? additionalData;

  LocationUpdate({
    required this.userId,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.locationTimestamp,
    this.additionalData,
  });

  factory LocationUpdate.fromJson(Map<String, dynamic> json) => _$LocationUpdateFromJson(json);
  Map<String, dynamic> toJson() => _$LocationUpdateToJson(this);
}

@JsonSerializable()
class DeviceMetadata {
  @JsonKey(name: 'battery_level')
  final double? batteryLevel;

  @JsonKey(name: 'network_type')
  final String? networkType;

  @JsonKey(name: 'app_version')
  final String? appVersion;

  @JsonKey(name: 'device_model')
  final String? deviceModel;

  @JsonKey(name: 'os_version')
  final String? osVersion;

  DeviceMetadata({this.batteryLevel, this.networkType, this.appVersion, this.deviceModel, this.osVersion});

  factory DeviceMetadata.fromJson(Map<String, dynamic> json) => _$DeviceMetadataFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceMetadataToJson(this);
}
