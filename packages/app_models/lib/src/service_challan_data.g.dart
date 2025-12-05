// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service_challan_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServiceChallanData _$ServiceChallanDataFromJson(Map<String, dynamic> json) =>
    ServiceChallanData(
      serviceType: json['service_type'] as String?,
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
      contactPersonName: json['contact_person_name'] as String?,
      paymentType: json['payment_type'] as String?,
      paymentStatus: json['payment_status'] as String?,
      paymentMode: json['payment'] as String?,
      unitModelNumber: json['unit_model_number'] as String?,
      unitSrNo: json['unit_sr_no'] as String?,
      serviceDescription: json['service_description'] as String?,
      refrigerant: json['refrigerant'] as String?,
      voltage: (json['voltage'] as num?)?.toDouble(),
      ampR: (json['amp_r'] as num?)?.toDouble(),
      ampY: (json['amp_y'] as num?)?.toDouble(),
      ampB: (json['amp_b'] as num?)?.toDouble(),
      standingPressure: (json['standing_pressure'] as num?)?.toDouble(),
      suctionPressure: (json['suction_pressure'] as num?)?.toDouble(),
      dischargePressure: (json['discharge_pressure'] as num?)?.toDouble(),
      suctionTemp: (json['suction_temp'] as num?)?.toDouble(),
      dischargeTemp: (json['dischage_temp'] as num?)?.toDouble(),
      exvOpening: (json['exv_opening'] as num?)?.toDouble(),
      chilledWaterIn: (json['chilled_water_in'] as num?)?.toDouble(),
      chilledWaterOut: (json['chilled_water_out'] as num?)?.toDouble(),
      conWaterIn: (json['con_water_in'] as num?)?.toDouble(),
      conWaterOut: (json['con_water_out'] as num?)?.toDouble(),
      waterTankTemp: (json['water_tank_temp'] as num?)?.toDouble(),
      cabinetTemp: (json['cabinet_temp'] as num?)?.toDouble(),
      roomTemp: (json['room_temp'] as num?)?.toDouble(),
      roomSupplyAirTemp: (json['room_supply_air_temp'] as num?)?.toDouble(),
      roomReturnAirTemp: (json['room_return_air_temp'] as num?)?.toDouble(),
      lpSetting: (json['lp_setting'] as num?)?.toDouble(),
      hpSetting: (json['hp_setting'] as num?)?.toDouble(),
      aft: (json['aft'] as num?)?.toDouble(),
      thermostatSetting: (json['thermostat_setting'] as num?)?.toDouble(),
      log: json['log'] as String?,
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => Item.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$ServiceChallanDataToJson(
  ServiceChallanData instance,
) => <String, dynamic>{
  if (instance.serviceType case final value?) 'service_type': value,
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
  if (instance.contactPersonName case final value?)
    'contact_person_name': value,
  if (instance.paymentType case final value?) 'payment_type': value,
  if (instance.paymentStatus case final value?) 'payment_status': value,
  if (instance.paymentMode case final value?) 'payment': value,
  if (instance.unitModelNumber case final value?) 'unit_model_number': value,
  if (instance.unitSrNo case final value?) 'unit_sr_no': value,
  if (instance.serviceDescription case final value?)
    'service_description': value,
  if (instance.refrigerant case final value?) 'refrigerant': value,
  if (instance.voltage case final value?) 'voltage': value,
  if (instance.ampR case final value?) 'amp_r': value,
  if (instance.ampY case final value?) 'amp_y': value,
  if (instance.ampB case final value?) 'amp_b': value,
  if (instance.standingPressure case final value?) 'standing_pressure': value,
  if (instance.suctionPressure case final value?) 'suction_pressure': value,
  if (instance.dischargePressure case final value?) 'discharge_pressure': value,
  if (instance.suctionTemp case final value?) 'suction_temp': value,
  if (instance.dischargeTemp case final value?) 'dischage_temp': value,
  if (instance.exvOpening case final value?) 'exv_opening': value,
  if (instance.chilledWaterIn case final value?) 'chilled_water_in': value,
  if (instance.chilledWaterOut case final value?) 'chilled_water_out': value,
  if (instance.conWaterIn case final value?) 'con_water_in': value,
  if (instance.conWaterOut case final value?) 'con_water_out': value,
  if (instance.waterTankTemp case final value?) 'water_tank_temp': value,
  if (instance.cabinetTemp case final value?) 'cabinet_temp': value,
  if (instance.roomTemp case final value?) 'room_temp': value,
  if (instance.roomSupplyAirTemp case final value?)
    'room_supply_air_temp': value,
  if (instance.roomReturnAirTemp case final value?)
    'room_return_air_temp': value,
  if (instance.lpSetting case final value?) 'lp_setting': value,
  if (instance.hpSetting case final value?) 'hp_setting': value,
  if (instance.aft case final value?) 'aft': value,
  if (instance.thermostatSetting case final value?) 'thermostat_setting': value,
  if (instance.log case final value?) 'log': value,
  if (instance.items case final value?) 'items': value,
};
