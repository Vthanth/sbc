import 'package:json_annotation/json_annotation.dart';

part 'challan_service.g.dart';

@JsonSerializable(includeIfNull: false)
class ChallanService {
  @JsonKey(name: 'service_uuid')
  final String serviceUuid;

  @JsonKey(name: 'customer_name')
  final String customerName;

  @JsonKey(name: 'product_serial_no')
  final String productSerialNo;

  @JsonKey(name: 'product_model_no')
  final String productModelNo;

  @JsonKey(name: 'ticket_subject')
  final String ticketSubject;

  @JsonKey(name: 'ticket_created_at')
  final String ticketCreatedAt;

  @JsonKey(name: 'service_start_time')
  final String? serviceStartTime;

  @JsonKey(name: 'service_end_time')
  final String? serviceEndTime;

  ChallanService({
    required this.serviceUuid,
    required this.customerName,
    required this.productSerialNo,
    required this.productModelNo,
    required this.ticketSubject,
    required this.ticketCreatedAt,
    this.serviceStartTime,
    this.serviceEndTime,
  });

  factory ChallanService.fromJson(Map<String, dynamic> json) => _$ChallanServiceFromJson(json);
  Map<String, dynamic> toJson() => _$ChallanServiceToJson(this);

  ChallanService copyWith({
    String? serviceUuid,
    String? customerName,
    String? productSerialNo,
    String? productModelNo,
    String? ticketSubject,
    String? ticketCreatedAt,
    String? serviceStartTime,
    String? serviceEndTime,
  }) {
    return ChallanService(
      serviceUuid: serviceUuid ?? this.serviceUuid,
      customerName: customerName ?? this.customerName,
      productSerialNo: productSerialNo ?? this.productSerialNo,
      productModelNo: productModelNo ?? this.productModelNo,
      ticketSubject: ticketSubject ?? this.ticketSubject,
      ticketCreatedAt: ticketCreatedAt ?? this.ticketCreatedAt,
      serviceStartTime: serviceStartTime ?? this.serviceStartTime,
      serviceEndTime: serviceEndTime ?? this.serviceEndTime,
    );
  }
}
