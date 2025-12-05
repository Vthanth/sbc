import 'package:app_models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service.g.dart';

@JsonSerializable()
class Service {
  final int id;
  final String uuid;
  @JsonKey(name: 'ticket_id')
  final int ticketId;
  @JsonKey(name: 'user_id')
  final int userId;
  @JsonKey(name: 'service_type')
  final String serviceType;
  @JsonKey(name: 'start_date_time')
  final DateTime? startDateTime;
  @JsonKey(name: 'start_location_lat')
  final String? startLocationLat;
  @JsonKey(name: 'start_location_long')
  final String? startLocationLong;
  @JsonKey(name: 'start_location_name')
  final String? startLocationName;
  @JsonKey(name: 'end_date_time')
  final DateTime? endDateTime;
  @JsonKey(name: 'end_location_lat')
  final String? endLocationLat;
  @JsonKey(name: 'end_location_long')
  final String? endLocationLong;
  @JsonKey(name: 'end_location_name')
  final String? endLocationName;
  @JsonKey(name: 'contact_person_name')
  final String? contactPersonName;
  @JsonKey(name: 'payment_type')
  final String? paymentType;
  final String? log;
  @JsonKey(name: 'unit_model_number')
  final String? unitModelNumber;
  @JsonKey(name: 'unit_sr_no')
  final String? unitSrNo;
  @JsonKey(name: 'payment_status')
  final String? paymentStatus;
  @JsonKey(name: 'service_description')
  final String? serviceDescription;
  final String? refrigerant;
  final String? voltage;
  @JsonKey(name: 'amp_r')
  final String? ampR;
  @JsonKey(name: 'amp_y')
  final String? ampY;
  @JsonKey(name: 'amp_b')
  final String? ampB;
  @JsonKey(name: 'standing_pressure')
  final String? standingPressure;
  @JsonKey(name: 'suction_pressure')
  final String? suctionPressure;
  @JsonKey(name: 'discharge_pressure')
  final String? dischargePressure;
  @JsonKey(name: 'suction_temp')
  final String? suctionTemp;
  @JsonKey(name: 'discharge_temp')
  final String? dischargeTemp;
  @JsonKey(name: 'exv_opening')
  final String? exvOpening;
  @JsonKey(name: 'chilled_water_in')
  final String? chilledWaterIn;
  @JsonKey(name: 'chilled_water_out')
  final String? chilledWaterOut;
  @JsonKey(name: 'con_water_in')
  final String? conWaterIn;
  @JsonKey(name: 'con_water_out')
  final String? conWaterOut;
  @JsonKey(name: 'water_tank_temp')
  final String? waterTankTemp;
  @JsonKey(name: 'cabinet_temp')
  final String? cabinetTemp;
  @JsonKey(name: 'room_temp')
  final String? roomTemp;
  @JsonKey(name: 'room_supply_air_temp')
  final String? roomSupplyAirTemp;
  @JsonKey(name: 'room_return_air_temp')
  final String? roomReturnAirTemp;
  @JsonKey(name: 'lp_setting')
  final String? lpSetting;
  @JsonKey(name: 'hp_setting')
  final String? hpSetting;
  final String? aft;
  @JsonKey(name: 'thermostat_setting')
  final String? thermostatSetting;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  @JsonKey(name: 'service_items')
  final List<dynamic>? serviceItems;
  final User? user;

  Service({
    required this.id,
    required this.uuid,
    required this.ticketId,
    required this.userId,
    required this.serviceType,
    this.startDateTime,
    this.startLocationLat,
    this.startLocationLong,
    this.startLocationName,
    this.endDateTime,
    this.endLocationLat,
    this.endLocationLong,
    this.endLocationName,
    this.contactPersonName,
    this.paymentType,
    this.log,
    this.unitModelNumber,
    this.unitSrNo,
    this.paymentStatus,
    this.serviceDescription,
    this.refrigerant,
    this.voltage,
    this.ampR,
    this.ampY,
    this.ampB,
    this.standingPressure,
    this.suctionPressure,
    this.dischargePressure,
    this.suctionTemp,
    this.dischargeTemp,
    this.exvOpening,
    this.chilledWaterIn,
    this.chilledWaterOut,
    this.conWaterIn,
    this.conWaterOut,
    this.waterTankTemp,
    this.cabinetTemp,
    this.roomTemp,
    this.roomSupplyAirTemp,
    this.roomReturnAirTemp,
    this.lpSetting,
    this.hpSetting,
    this.aft,
    this.thermostatSetting,
    this.createdAt,
    this.updatedAt,
    this.serviceItems,
    this.user,
  });

  factory Service.fromJson(Map<String, dynamic> json) => _$ServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceToJson(this);
}
