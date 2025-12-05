// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactPerson _$ContactPersonFromJson(Map<String, dynamic> json) =>
    ContactPerson(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      customerId: (json['customer_id'] as num).toInt(),
      name: json['name'] as String?,
      email: json['email'] as String?,
      phoneNumber: json['phone_number'] as String?,
      alternatePhoneNumber: json['alternate_phone_number'] as String?,
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$ContactPersonToJson(ContactPerson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'customer_id': instance.customerId,
      'name': instance.name,
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'alternate_phone_number': instance.alternatePhoneNumber,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
