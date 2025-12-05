// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delivery_challan_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeliveryChallanData _$DeliveryChallanDataFromJson(Map<String, dynamic> json) =>
    DeliveryChallanData(
      challanNo: json['challan_no'] as String?,
      vehicleNo: json['vehical_no'] as String?,
      deliveredBy: json['delivered_by'] as String?,
      log: json['log'] as String?,
      startDateTime:
          json['start_date_time'] == null
              ? null
              : DateTime.parse(json['start_date_time'] as String),
      startLocationLat: (json['start_location_lat'] as num?)?.toDouble(),
      startLocationLong: (json['start_location_long'] as num?)?.toDouble(),
      startLocationName: json['start_location_name'] as String?,
      endDateTime:
          json['end_date_time'] == null
              ? null
              : DateTime.parse(json['end_date_time'] as String),
      endLocationLat: (json['end_location_lat'] as num?)?.toDouble(),
      endLocationLong: (json['end_location_long'] as num?)?.toDouble(),
      endLocationName: json['end_location_name'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$DeliveryChallanDataToJson(
  DeliveryChallanData instance,
) => <String, dynamic>{
  if (instance.challanNo case final value?) 'challan_no': value,
  if (instance.vehicleNo case final value?) 'vehical_no': value,
  if (instance.deliveredBy case final value?) 'delivered_by': value,
  if (instance.log case final value?) 'log': value,
  if (instance.startDateTime?.toIso8601String() case final value?)
    'start_date_time': value,
  if (instance.startLocationLat case final value?) 'start_location_lat': value,
  if (instance.startLocationLong case final value?)
    'start_location_long': value,
  if (instance.startLocationName case final value?)
    'start_location_name': value,
  if (instance.endDateTime?.toIso8601String() case final value?)
    'end_date_time': value,
  if (instance.endLocationLat case final value?) 'end_location_lat': value,
  if (instance.endLocationLong case final value?) 'end_location_long': value,
  if (instance.endLocationName case final value?) 'end_location_name': value,
  if (instance.items case final value?) 'items': value,
};
