// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProduct _$OrderProductFromJson(Map<String, dynamic> json) => OrderProduct(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String,
  orderId: (json['order_id'] as num).toInt(),
  productId: (json['product_id'] as num).toInt(),
  serialNumber: json['serial_number'] as String,
  modelNumber: json['model_number'] as String?,
  configurations: json['configurations'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  updatedAt: DateTime.parse(json['updated_at'] as String),
  product: Product.fromJson(json['product'] as Map<String, dynamic>),
  tickets:
      (json['tickets'] as List<dynamic>?)
          ?.map((e) => Ticket.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$OrderProductToJson(OrderProduct instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'serial_number': instance.serialNumber,
      'model_number': instance.modelNumber,
      'configurations': instance.configurations,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'product': instance.product,
      'tickets': instance.tickets,
    };
