import 'package:app_models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'delivery_challan_data.g.dart';

@JsonSerializable(includeIfNull: false)
class DeliveryChallanData {
  @JsonKey(name: 'challan_no')
  final String? challanNo;

  @JsonKey(name: 'vehical_no')
  final String? vehicleNo;

  @JsonKey(name: 'delivered_by')
  final String? deliveredBy;

  @JsonKey(name: 'log')
  final String? log;

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

  @JsonKey(name: 'items')
  final List<Item>? items;

  DeliveryChallanData({
    this.challanNo,
    this.vehicleNo,
    this.deliveredBy,
    this.log,
    this.startDateTime,
    this.startLocationLat,
    this.startLocationLong,
    this.startLocationName,
    this.endDateTime,
    this.endLocationLat,
    this.endLocationLong,
    this.endLocationName,
    this.items,
  });

  factory DeliveryChallanData.fromJson(Map<String, dynamic> json) => _$DeliveryChallanDataFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryChallanDataToJson(this);

  DeliveryChallanData copyWith({
    String? challanNo,
    String? vehicleNo,
    String? deliveredBy,
    String? log,
    DateTime? startDateTime,
    double? startLocationLat,
    double? startLocationLong,
    String? startLocationName,
    DateTime? endDateTime,
    double? endLocationLat,
    double? endLocationLong,
    String? endLocationName,
    List<Item>? items,
  }) {
    return DeliveryChallanData(
      challanNo: challanNo ?? this.challanNo,
      vehicleNo: vehicleNo ?? this.vehicleNo,
      deliveredBy: deliveredBy ?? this.deliveredBy,
      log: log ?? this.log,
      startDateTime: startDateTime ?? this.startDateTime,
      startLocationLat: startLocationLat ?? this.startLocationLat,
      startLocationLong: startLocationLong ?? this.startLocationLong,
      startLocationName: startLocationName ?? this.startLocationName,
      endDateTime: endDateTime ?? this.endDateTime,
      endLocationLat: endLocationLat ?? this.endLocationLat,
      endLocationLong: endLocationLong ?? this.endLocationLong,
      endLocationName: endLocationName ?? this.endLocationName,
      items: items ?? this.items,
    );
  }
}
