// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Service _$ServiceFromJson(Map<String, dynamic> json) => Service(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String,
  ticketId: (json['ticket_id'] as num).toInt(),
  userId: (json['user_id'] as num).toInt(),
  serviceType: json['service_type'] as String,
  startDateTime:
      json['start_date_time'] == null
          ? null
          : DateTime.parse(json['start_date_time'] as String),
  startLocationLat: json['start_location_lat'] as String?,
  startLocationLong: json['start_location_long'] as String?,
  startLocationName: json['start_location_name'] as String?,
  endDateTime:
      json['end_date_time'] == null
          ? null
          : DateTime.parse(json['end_date_time'] as String),
  endLocationLat: json['end_location_lat'] as String?,
  endLocationLong: json['end_location_long'] as String?,
  endLocationName: json['end_location_name'] as String?,
  contactPersonName: json['contact_person_name'] as String?,
  paymentType: json['payment_type'] as String?,
  log: json['log'] as String?,
  unitModelNumber: json['unit_model_number'] as String?,
  unitSrNo: json['unit_sr_no'] as String?,
  paymentStatus: json['payment_status'] as String?,
  serviceDescription: json['service_description'] as String?,
  refrigerant: json['refrigerant'] as String?,
  voltage: json['voltage'] as String?,
  ampR: json['amp_r'] as String?,
  ampY: json['amp_y'] as String?,
  ampB: json['amp_b'] as String?,
  standingPressure: json['standing_pressure'] as String?,
  suctionPressure: json['suction_pressure'] as String?,
  dischargePressure: json['discharge_pressure'] as String?,
  suctionTemp: json['suction_temp'] as String?,
  dischargeTemp: json['discharge_temp'] as String?,
  exvOpening: json['exv_opening'] as String?,
  chilledWaterIn: json['chilled_water_in'] as String?,
  chilledWaterOut: json['chilled_water_out'] as String?,
  conWaterIn: json['con_water_in'] as String?,
  conWaterOut: json['con_water_out'] as String?,
  waterTankTemp: json['water_tank_temp'] as String?,
  cabinetTemp: json['cabinet_temp'] as String?,
  roomTemp: json['room_temp'] as String?,
  roomSupplyAirTemp: json['room_supply_air_temp'] as String?,
  roomReturnAirTemp: json['room_return_air_temp'] as String?,
  lpSetting: json['lp_setting'] as String?,
  hpSetting: json['hp_setting'] as String?,
  aft: json['aft'] as String?,
  thermostatSetting: json['thermostat_setting'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
  serviceItems: json['service_items'] as List<dynamic>?,
  user:
      json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ServiceToJson(Service instance) => <String, dynamic>{
  'id': instance.id,
  'uuid': instance.uuid,
  'ticket_id': instance.ticketId,
  'user_id': instance.userId,
  'service_type': instance.serviceType,
  'start_date_time': instance.startDateTime?.toIso8601String(),
  'start_location_lat': instance.startLocationLat,
  'start_location_long': instance.startLocationLong,
  'start_location_name': instance.startLocationName,
  'end_date_time': instance.endDateTime?.toIso8601String(),
  'end_location_lat': instance.endLocationLat,
  'end_location_long': instance.endLocationLong,
  'end_location_name': instance.endLocationName,
  'contact_person_name': instance.contactPersonName,
  'payment_type': instance.paymentType,
  'log': instance.log,
  'unit_model_number': instance.unitModelNumber,
  'unit_sr_no': instance.unitSrNo,
  'payment_status': instance.paymentStatus,
  'service_description': instance.serviceDescription,
  'refrigerant': instance.refrigerant,
  'voltage': instance.voltage,
  'amp_r': instance.ampR,
  'amp_y': instance.ampY,
  'amp_b': instance.ampB,
  'standing_pressure': instance.standingPressure,
  'suction_pressure': instance.suctionPressure,
  'discharge_pressure': instance.dischargePressure,
  'suction_temp': instance.suctionTemp,
  'discharge_temp': instance.dischargeTemp,
  'exv_opening': instance.exvOpening,
  'chilled_water_in': instance.chilledWaterIn,
  'chilled_water_out': instance.chilledWaterOut,
  'con_water_in': instance.conWaterIn,
  'con_water_out': instance.conWaterOut,
  'water_tank_temp': instance.waterTankTemp,
  'cabinet_temp': instance.cabinetTemp,
  'room_temp': instance.roomTemp,
  'room_supply_air_temp': instance.roomSupplyAirTemp,
  'room_return_air_temp': instance.roomReturnAirTemp,
  'lp_setting': instance.lpSetting,
  'hp_setting': instance.hpSetting,
  'aft': instance.aft,
  'thermostat_setting': instance.thermostatSetting,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'service_items': instance.serviceItems,
  'user': instance.user,
};
