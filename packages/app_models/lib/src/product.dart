import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class Product {
  final int id;
  final String uuid;
  final String name;
  final String image;
  @JsonKey(name: 'model_number')
  final String modelNumber;
  final String description;
  @JsonKey(name: 'created_by')
  final int createdBy;
  @JsonKey(name: 'updated_by')
  final int? updatedBy;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  Product({
    required this.id,
    required this.uuid,
    required this.name,
    required this.image,
    required this.modelNumber,
    required this.description,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return _$ProductFromJson(json);
  }

  Map<String, dynamic> toJson() => _$ProductToJson(this);
}
