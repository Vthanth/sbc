import 'package:app_models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_qr.g.dart';

@JsonSerializable()
class ProductQr {
  final int id;
  final String uuid;
  final String title;
  @JsonKey(name: 'customer_id')
  final int? customerId;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final Customer? customer;
  final List<OrderImage>? images;
  @JsonKey(name: 'order_products')
  final List<OrderProductQr>? orderProducts;

  ProductQr({
    required this.id,
    required this.uuid,
    required this.title,
    this.customerId,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.images,
    this.orderProducts,
  });

  factory ProductQr.fromJson(Map<String, dynamic> json) => _$ProductQrFromJson(json);
  Map<String, dynamic> toJson() => _$ProductQrToJson(this);
}

@JsonSerializable()
class OrderImage {
  final int id;
  @JsonKey(name: 'order_id')
  final int? orderId;
  @JsonKey(name: 'image_path')
  final String? imagePath;
  @JsonKey(name: 'image_name')
  final String? imageName;
  @JsonKey(name: 'image_size')
  final int? imageSize;
  @JsonKey(name: 'image_type')
  final String? imageType;
  @JsonKey(name: 'sort_order')
  final int? sortOrder;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  OrderImage({
    required this.id,
    this.orderId,
    this.imagePath,
    this.imageName,
    this.imageSize,
    this.imageType,
    this.sortOrder,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory OrderImage.fromJson(Map<String, dynamic> json) => _$OrderImageFromJson(json);
  Map<String, dynamic> toJson() => _$OrderImageToJson(this);
}

@JsonSerializable()
class OrderProductQr {
  final int id;
  final String uuid;
  @JsonKey(name: 'order_id')
  final int? orderId;
  @JsonKey(name: 'product_id')
  final int? productId;
  @JsonKey(name: 'serial_number')
  final String? serialNumber;
  @JsonKey(name: 'model_number')
  final String? modelNumber;
  final String? configurations;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;
  final Product? product;
  final List<Ticket>? tickets;

  OrderProductQr({
    required this.id,
    required this.uuid,
    this.orderId,
    this.productId,
    this.serialNumber,
    this.modelNumber,
    this.configurations,
    this.createdAt,
    this.updatedAt,
    this.product,
    this.tickets,
  });

  factory OrderProductQr.fromJson(Map<String, dynamic> json) => _$OrderProductQrFromJson(json);
  Map<String, dynamic> toJson() => _$OrderProductQrToJson(this);
}
