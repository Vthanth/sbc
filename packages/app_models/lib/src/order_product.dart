import 'package:app_models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_product.g.dart';

@JsonSerializable()
class OrderProduct {
  final int id;
  final String uuid;
  @JsonKey(name: 'order_id')
  final int orderId;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'serial_number')
  final String serialNumber;
  @JsonKey(name: 'model_number')
  final String? modelNumber;
  final String configurations;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  final Product product;
  final List<Ticket>? tickets;

  OrderProduct({
    required this.id,
    required this.uuid,
    required this.orderId,
    required this.productId,
    required this.serialNumber,
    this.modelNumber,
    required this.configurations,
    required this.createdAt,
    required this.updatedAt,
    required this.product,
    this.tickets,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) => _$OrderProductFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductToJson(this);
}
