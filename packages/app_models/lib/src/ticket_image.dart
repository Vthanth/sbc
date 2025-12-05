import 'package:json_annotation/json_annotation.dart';

part 'ticket_image.g.dart';

@JsonSerializable()
class TicketImage {
  final int id;
  final String uuid;
  @JsonKey(name: 'ticket_id')
  final int ticketId;
  @JsonKey(name: 'uploaded_by')
  final int uploadedBy;
  @JsonKey(name: 'image_path')
  final String? imagePath;
  @JsonKey(name: 'original_filename')
  final String? originalFilename;
  @JsonKey(name: 'mime_type')
  final String? mimeType;
  @JsonKey(name: 'file_size')
  final int? fileSize;
  final String? description;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  TicketImage({
    required this.id,
    required this.uuid,
    required this.ticketId,
    required this.uploadedBy,
    this.imagePath,
    this.originalFilename,
    this.mimeType,
    this.fileSize,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  factory TicketImage.fromJson(Map<String, dynamic> json) => _$TicketImageFromJson(json);
  Map<String, dynamic> toJson() => _$TicketImageToJson(this);
}
