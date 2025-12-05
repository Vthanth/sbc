import 'package:json_annotation/json_annotation.dart';

part 'challan_service_detail.g.dart';

@JsonSerializable(includeIfNull: false)
class ChallanServiceDetail {
  @JsonKey(name: 'service_uuid')
  final String serviceUuid;

  @JsonKey(name: 'ticket_subject')
  final String ticketSubject;

  @JsonKey(name: 'customer_name')
  final String customerName;

  @JsonKey(name: 'product_serial_no')
  final String productSerialNo;

  @JsonKey(name: 'product_model_no')
  final String productModelNo;

  @JsonKey(name: 'service_start_time')
  final String? serviceStartTime;

  @JsonKey(name: 'service_end_time')
  final String? serviceEndTime;

  @JsonKey(name: 'ticket_created_at')
  final String ticketCreatedAt;

  @JsonKey(name: 'additional_staff')
  final List<AdditionalStaff> additionalStaff;

  final List<String> images;

  @JsonKey(name: 'challan_pdf_link')
  final String? challanPdfLink;

  ChallanServiceDetail({
    required this.serviceUuid,
    required this.ticketSubject,
    required this.customerName,
    required this.productSerialNo,
    required this.productModelNo,
    this.serviceStartTime,
    this.serviceEndTime,
    required this.ticketCreatedAt,
    required this.additionalStaff,
    required this.images,
    this.challanPdfLink,
  });

  factory ChallanServiceDetail.fromJson(Map<String, dynamic> json) => _$ChallanServiceDetailFromJson(json);
  Map<String, dynamic> toJson() => _$ChallanServiceDetailToJson(this);

  ChallanServiceDetail copyWith({
    String? serviceUuid,
    String? ticketSubject,
    String? customerName,
    String? productSerialNo,
    String? productModelNo,
    String? serviceStartTime,
    String? serviceEndTime,
    String? ticketCreatedAt,
    List<AdditionalStaff>? additionalStaff,
    List<String>? images,
    String? challanPdfLink,
  }) {
    return ChallanServiceDetail(
      serviceUuid: serviceUuid ?? this.serviceUuid,
      ticketSubject: ticketSubject ?? this.ticketSubject,
      customerName: customerName ?? this.customerName,
      productSerialNo: productSerialNo ?? this.productSerialNo,
      productModelNo: productModelNo ?? this.productModelNo,
      serviceStartTime: serviceStartTime ?? this.serviceStartTime,
      serviceEndTime: serviceEndTime ?? this.serviceEndTime,
      ticketCreatedAt: ticketCreatedAt ?? this.ticketCreatedAt,
      additionalStaff: additionalStaff ?? this.additionalStaff,
      images: images ?? this.images,
      challanPdfLink: challanPdfLink ?? this.challanPdfLink,
    );
  }
}

@JsonSerializable(includeIfNull: false)
class AdditionalStaff {
  final int id;
  final String name;

  AdditionalStaff({required this.id, required this.name});

  factory AdditionalStaff.fromJson(Map<String, dynamic> json) => _$AdditionalStaffFromJson(json);
  Map<String, dynamic> toJson() => _$AdditionalStaffToJson(this);

  AdditionalStaff copyWith({int? id, String? name}) {
    return AdditionalStaff(id: id ?? this.id, name: name ?? this.name);
  }
}
