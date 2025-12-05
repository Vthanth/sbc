// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challan_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChallanService _$ChallanServiceFromJson(Map<String, dynamic> json) =>
    ChallanService(
      serviceUuid: json['service_uuid'] as String,
      customerName: json['customer_name'] as String,
      productSerialNo: json['product_serial_no'] as String,
      productModelNo: json['product_model_no'] as String,
      ticketSubject: json['ticket_subject'] as String,
      ticketCreatedAt: json['ticket_created_at'] as String,
      serviceStartTime: json['service_start_time'] as String?,
      serviceEndTime: json['service_end_time'] as String?,
    );

Map<String, dynamic> _$ChallanServiceToJson(
  ChallanService instance,
) => <String, dynamic>{
  'service_uuid': instance.serviceUuid,
  'customer_name': instance.customerName,
  'product_serial_no': instance.productSerialNo,
  'product_model_no': instance.productModelNo,
  'ticket_subject': instance.ticketSubject,
  'ticket_created_at': instance.ticketCreatedAt,
  if (instance.serviceStartTime case final value?) 'service_start_time': value,
  if (instance.serviceEndTime case final value?) 'service_end_time': value,
};
