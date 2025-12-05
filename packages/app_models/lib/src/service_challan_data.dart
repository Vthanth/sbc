import 'package:app_models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'service_challan_data.g.dart';

@JsonSerializable(includeIfNull: false)
class ServiceChallanData {
  @JsonKey(name: 'service_type')
  final String? serviceType;

  @JsonKey(name: 'start_date_time')
  final DateTime? startDateTime;

  @JsonKey(name: 'start_location_lat')
  final double? startLocationLat;

  @JsonKey(name: 'start_location_long')
  final double? startLocationLong;

  @JsonKey(name: 'start_location_name')
  final String? startLocationName;

  @JsonKey(name: 'end_date_time')
  final DateTime? endDateTime;

  @JsonKey(name: 'end_location_lat')
  final double? endLocationLat;

  @JsonKey(name: 'end_location_long')
  final double? endLocationLong;

  @JsonKey(name: 'end_location_name')
  final String? endLocationName;

  @JsonKey(name: 'contact_person_name')
  final String? contactPersonName;

  @JsonKey(name: 'payment_type')
  final String? paymentType;

  @JsonKey(name: 'payment_status')
  final String? paymentStatus;

  @JsonKey(name: 'payment')
  final String? paymentMode;

  @JsonKey(name: 'unit_model_number')
  final String? unitModelNumber;

  @JsonKey(name: 'unit_sr_no')
  final String? unitSrNo;

  @JsonKey(name: 'service_description')
  final String? serviceDescription;

  @JsonKey(name: 'refrigerant')
  final String? refrigerant;

  @JsonKey(name: 'voltage')
  final double? voltage;

  @JsonKey(name: 'amp_r')
  final double? ampR;

  @JsonKey(name: 'amp_y')
  final double? ampY;

  @JsonKey(name: 'amp_b')
  final double? ampB;

  @JsonKey(name: 'standing_pressure')
  final double? standingPressure;

  @JsonKey(name: 'suction_pressure')
  final double? suctionPressure;

  @JsonKey(name: 'discharge_pressure')
  final double? dischargePressure;

  @JsonKey(name: 'suction_temp')
  final double? suctionTemp;

  @JsonKey(name: 'dischage_temp')
  final double? dischargeTemp;

  @JsonKey(name: 'exv_opening')
  final double? exvOpening;

  @JsonKey(name: 'chilled_water_in')
  final double? chilledWaterIn;

  @JsonKey(name: 'chilled_water_out')
  final double? chilledWaterOut;

  @JsonKey(name: 'con_water_in')
  final double? conWaterIn;

  @JsonKey(name: 'con_water_out')
  final double? conWaterOut;

  @JsonKey(name: 'water_tank_temp')
  final double? waterTankTemp;

  @JsonKey(name: 'cabinet_temp')
  final double? cabinetTemp;

  @JsonKey(name: 'room_temp')
  final double? roomTemp;

  @JsonKey(name: 'room_supply_air_temp')
  final double? roomSupplyAirTemp;

  @JsonKey(name: 'room_return_air_temp')
  final double? roomReturnAirTemp;

  @JsonKey(name: 'lp_setting')
  final double? lpSetting;

  @JsonKey(name: 'hp_setting')
  final double? hpSetting;

  @JsonKey(name: 'aft')
  final double? aft;

  @JsonKey(name: 'thermostat_setting')
  final double? thermostatSetting;

  @JsonKey(name: 'log')
  final String? log;

  @JsonKey(name: 'items')
  final List<Item>? items;

  ServiceChallanData({
    this.serviceType,
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
    this.paymentStatus,
    this.paymentMode,
    this.unitModelNumber,
    this.unitSrNo,
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
    this.log,
    this.items,
  });

  factory ServiceChallanData.fromJson(Map<String, dynamic> json) => _$ServiceChallanDataFromJson(json);
  Map<String, dynamic> toJson() => _$ServiceChallanDataToJson(this);

  ServiceChallanData copyWith({
    String? serviceType,
    DateTime? startDateTime,
    double? startLocationLat,
    double? startLocationLong,
    String? startLocationName,
    DateTime? endDateTime,
    double? endLocationLat,
    double? endLocationLong,
    String? endLocationName,
    String? contactPersonName,
    String? paymentType,
    String? paymentStatus,
    String? paymentMode,
    String? unitModelNumber,
    String? unitSrNo,
    String? serviceDescription,
    String? refrigerant,
    double? voltage,
    double? ampR,
    double? ampY,
    double? ampB,
    double? standingPressure,
    double? suctionPressure,
    double? dischargePressure,
    double? suctionTemp,
    double? dischargeTemp,
    double? exvOpening,
    double? chilledWaterIn,
    double? chilledWaterOut,
    double? conWaterIn,
    double? conWaterOut,
    double? waterTankTemp,
    double? cabinetTemp,
    double? roomTemp,
    double? roomSupplyAirTemp,
    double? roomReturnAirTemp,
    double? lpSetting,
    double? hpSetting,
    double? aft,
    double? thermostatSetting,
    String? log,
    List<Item>? items,
  }) {
    return ServiceChallanData(
      serviceType: serviceType ?? this.serviceType,
      startDateTime: startDateTime ?? this.startDateTime,
      startLocationLat: startLocationLat ?? this.startLocationLat,
      startLocationLong: startLocationLong ?? this.startLocationLong,
      startLocationName: startLocationName ?? this.startLocationName,
      endDateTime: endDateTime ?? this.endDateTime,
      endLocationLat: endLocationLat ?? this.endLocationLat,
      endLocationLong: endLocationLong ?? this.endLocationLong,
      endLocationName: endLocationName ?? this.endLocationName,
      contactPersonName: contactPersonName ?? this.contactPersonName,
      paymentType: paymentType ?? this.paymentType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMode: paymentMode ?? this.paymentMode,
      unitModelNumber: unitModelNumber ?? this.unitModelNumber,
      unitSrNo: unitSrNo ?? this.unitSrNo,
      serviceDescription: serviceDescription ?? this.serviceDescription,
      refrigerant: refrigerant ?? this.refrigerant,
      voltage: voltage ?? this.voltage,
      ampR: ampR ?? this.ampR,
      ampY: ampY ?? this.ampY,
      ampB: ampB ?? this.ampB,
      standingPressure: standingPressure ?? this.standingPressure,
      suctionPressure: suctionPressure ?? this.suctionPressure,
      dischargePressure: dischargePressure ?? this.dischargePressure,
      suctionTemp: suctionTemp ?? this.suctionTemp,
      dischargeTemp: dischargeTemp ?? this.dischargeTemp,
      exvOpening: exvOpening ?? this.exvOpening,
      chilledWaterIn: chilledWaterIn ?? this.chilledWaterIn,
      chilledWaterOut: chilledWaterOut ?? this.chilledWaterOut,
      conWaterIn: conWaterIn ?? this.conWaterIn,
      conWaterOut: conWaterOut ?? this.conWaterOut,
      waterTankTemp: waterTankTemp ?? this.waterTankTemp,
      cabinetTemp: cabinetTemp ?? this.cabinetTemp,
      roomTemp: roomTemp ?? this.roomTemp,
      roomSupplyAirTemp: roomSupplyAirTemp ?? this.roomSupplyAirTemp,
      roomReturnAirTemp: roomReturnAirTemp ?? this.roomReturnAirTemp,
      lpSetting: lpSetting ?? this.lpSetting,
      hpSetting: hpSetting ?? this.hpSetting,
      aft: aft ?? this.aft,
      thermostatSetting: thermostatSetting ?? this.thermostatSetting,
      log: log ?? this.log,
      items: items ?? this.items,
    );
  }
}
