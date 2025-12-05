// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) => Ticket(
  (json['id'] as num).toInt(),
  json['uuid'] as String,
  json['subject'] as String?,
  json['name'] as String?,
  json['phone_number'] as String?,
  (json['customer_id'] as num).toInt(),
  (json['order_product_id'] as num?)?.toInt(),
  (json['customer_contact_person_id'] as num?)?.toInt(),
  json['attended_by'] == null
      ? null
      : User.fromJson(json['attended_by'] as Map<String, dynamic>),
  json['type'] as String,
  json['assigned_to'] == null
      ? null
      : User.fromJson(json['assigned_to'] as Map<String, dynamic>),
  json['start'] == null ? null : DateTime.parse(json['start'] as String),
  json['end'] == null ? null : DateTime.parse(json['end'] as String),
  DateTime.parse(json['created_at'] as String),
  DateTime.parse(json['updated_at'] as String),
  json['customer'] == null
      ? null
      : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  json['order_product'] == null
      ? null
      : OrderProduct.fromJson(json['order_product'] as Map<String, dynamic>),
  json['contact_person'] == null
      ? null
      : ContactPerson.fromJson(json['contact_person'] as Map<String, dynamic>),
  (json['additional_staff'] as List<dynamic>?)
      ?.map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['images'] as List<dynamic>?)
      ?.map((e) => TicketImage.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['services'] as List<dynamic>?)
      ?.map((e) => Service.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'uuid': instance.uuid,
  'subject': instance.subject,
  'name': instance.name,
  'phone_number': instance.phoneNumber,
  'customer_id': instance.customerId,
  'order_product_id': instance.orderProductId,
  'customer_contact_person_id': instance.customerContactPersonId,
  'attended_by': instance.attendedBy,
  'type': instance.type,
  'assigned_to': instance.assignedTo,
  'start': instance.start?.toIso8601String(),
  'end': instance.end?.toIso8601String(),
  'created_at': instance.createdAt.toIso8601String(),
  'updated_at': instance.updatedAt.toIso8601String(),
  'customer': instance.customer,
  'order_product': instance.orderProduct,
  'contact_person': instance.contactPerson,
  'additional_staff': instance.additionalStaff,
  'images': instance.images,
  'services': instance.services,
};
