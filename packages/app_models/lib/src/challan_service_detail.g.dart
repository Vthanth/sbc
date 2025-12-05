// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challan_service_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallanServiceDetail _$ChallanServiceDetailFromJson(
  Map<String, dynamic> json,
) => ChallanServiceDetail(
  serviceUuid: json['service_uuid'] as String,
  ticketSubject: json['ticket_subject'] as String,
  customerName: json['customer_name'] as String,
  productSerialNo: json['product_serial_no'] as String,
  productModelNo: json['product_model_no'] as String,
  serviceStartTime: json['service_start_time'] as String?,
  serviceEndTime: json['service_end_time'] as String?,
  ticketCreatedAt: json['ticket_created_at'] as String,
  additionalStaff:
      (json['additional_staff'] as List<dynamic>)
          .map((e) => AdditionalStaff.fromJson(e as Map<String, dynamic>))
          .toList(),
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  challanPdfLink: json['challan_pdf_link'] as String?,
);

Map<String, dynamic> _$ChallanServiceDetailToJson(
  ChallanServiceDetail instance,
) => <String, dynamic>{
  'service_uuid': instance.serviceUuid,
  'ticket_subject': instance.ticketSubject,
  'customer_name': instance.customerName,
  'product_serial_no': instance.productSerialNo,
  'product_model_no': instance.productModelNo,
  if (instance.serviceStartTime case final value?) 'service_start_time': value,
  if (instance.serviceEndTime case final value?) 'service_end_time': value,
  'ticket_created_at': instance.ticketCreatedAt,
  'additional_staff': instance.additionalStaff,
  'images': instance.images,
  if (instance.challanPdfLink case final value?) 'challan_pdf_link': value,
};

AdditionalStaff _$AdditionalStaffFromJson(Map<String, dynamic> json) =>
    AdditionalStaff(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$AdditionalStaffToJson(AdditionalStaff instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
