import 'package:json_annotation/json_annotation.dart';

part 'contact_person.g.dart';

@JsonSerializable()
class ContactPerson {
  final int id;
  final String uuid;
  @JsonKey(name: 'customer_id')
  final int customerId;
  final String? name;
  final String? email;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'alternate_phone_number')
  final String? alternatePhoneNumber;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  ContactPerson({
    required this.id,
    required this.uuid,
    required this.customerId,
    this.name,
    this.email,
    this.phoneNumber,
    this.alternatePhoneNumber,
    this.createdAt,
    this.updatedAt,
  });

  factory ContactPerson.fromJson(Map<String, dynamic> json) => _$ContactPersonFromJson(json);
  Map<String, dynamic> toJson() => _$ContactPersonToJson(this);
}
