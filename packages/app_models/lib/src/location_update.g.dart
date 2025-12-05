// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_update.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationUpdate _$LocationUpdateFromJson(Map<String, dynamic> json) =>
    LocationUpdate(
      userId: json['user_id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      locationTimestamp: json['location_timestamp'] as String,
      additionalData:
          json['additional_data'] == null
              ? null
              : DeviceMetadata.fromJson(
                json['additional_data'] as Map<String, dynamic>,
              ),
    );

Map<String, dynamic> _$LocationUpdateToJson(LocationUpdate instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'location_timestamp': instance.locationTimestamp,
      'additional_data': instance.additionalData,
    };

DeviceMetadata _$DeviceMetadataFromJson(Map<String, dynamic> json) =>
    DeviceMetadata(
      batteryLevel: (json['battery_level'] as num?)?.toDouble(),
      networkType: json['network_type'] as String?,
      appVersion: json['app_version'] as String?,
      deviceModel: json['device_model'] as String?,
      osVersion: json['os_version'] as String?,
    );

Map<String, dynamic> _$DeviceMetadataToJson(DeviceMetadata instance) =>
    <String, dynamic>{
      'battery_level': instance.batteryLevel,
      'network_type': instance.networkType,
      'app_version': instance.appVersion,
      'device_model': instance.deviceModel,
      'os_version': instance.osVersion,
    };
