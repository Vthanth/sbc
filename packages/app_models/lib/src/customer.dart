import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer {
  final int id;
  final String uuid;
  final String name;
  @JsonKey(name: 'company_name')
  final String companyName;
  final String email;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String address;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Customer(
    this.id,
    this.uuid,
    this.name,
    this.companyName,
    this.email,
    this.phoneNumber,
    this.address,
    this.createdAt,
    this.updatedAt,
  );

  factory Customer.fromJson(Map<String, dynamic> json) => _$CustomerFromJson(json);
  Map<String, dynamic> toJson() => _$CustomerToJson(this);
}
