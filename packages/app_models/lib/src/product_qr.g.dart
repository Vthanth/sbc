// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_qr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductQr _$ProductQrFromJson(Map<String, dynamic> json) => ProductQr(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String,
  title: json['title'] as String,
  customerId: (json['customer_id'] as num?)?.toInt(),
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
  customer:
      json['customer'] == null
          ? null
          : Customer.fromJson(json['customer'] as Map<String, dynamic>),
  images:
      (json['images'] as List<dynamic>?)
          ?.map((e) => OrderImage.fromJson(e as Map<String, dynamic>))
          .toList(),
  orderProducts:
      (json['order_products'] as List<dynamic>?)
          ?.map((e) => OrderProductQr.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$ProductQrToJson(ProductQr instance) => <String, dynamic>{
  'id': instance.id,
  'uuid': instance.uuid,
  'title': instance.title,
  'customer_id': instance.customerId,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'customer': instance.customer,
  'images': instance.images,
  'order_products': instance.orderProducts,
};

OrderImage _$OrderImageFromJson(Map<String, dynamic> json) => OrderImage(
  id: (json['id'] as num).toInt(),
  orderId: (json['order_id'] as num?)?.toInt(),
  imagePath: json['image_path'] as String?,
  imageName: json['image_name'] as String?,
  imageSize: (json['image_size'] as num?)?.toInt(),
  imageType: json['image_type'] as String?,
  sortOrder: (json['sort_order'] as num?)?.toInt(),
  description: json['description'] as String?,
  createdAt:
      json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
  updatedAt:
      json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$OrderImageToJson(OrderImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'image_path': instance.imagePath,
      'image_name': instance.imageName,
      'image_size': instance.imageSize,
      'image_type': instance.imageType,
      'sort_order': instance.sortOrder,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };

OrderProductQr _$OrderProductQrFromJson(Map<String, dynamic> json) =>
    OrderProductQr(
      id: (json['id'] as num).toInt(),
      uuid: json['uuid'] as String,
      orderId: (json['order_id'] as num?)?.toInt(),
      productId: (json['product_id'] as num?)?.toInt(),
      serialNumber: json['serial_number'] as String?,
      modelNumber: json['model_number'] as String?,
      configurations: json['configurations'] as String?,
      createdAt:
          json['created_at'] == null
              ? null
              : DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] == null
              ? null
              : DateTime.parse(json['updated_at'] as String),
      product:
          json['product'] == null
              ? null
              : Product.fromJson(json['product'] as Map<String, dynamic>),
      tickets:
          (json['tickets'] as List<dynamic>?)
              ?.map((e) => Ticket.fromJson(e as Map<String, dynamic>))
              .toList(),
    );

Map<String, dynamic> _$OrderProductQrToJson(OrderProductQr instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'order_id': instance.orderId,
      'product_id': instance.productId,
      'serial_number': instance.serialNumber,
      'model_number': instance.modelNumber,
      'configurations': instance.configurations,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'product': instance.product,
      'tickets': instance.tickets,
    };
