// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_image.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketImage _$TicketImageFromJson(Map<String, dynamic> json) => TicketImage(
  id: (json['id'] as num).toInt(),
  uuid: json['uuid'] as String,
  ticketId: (json['ticket_id'] as num).toInt(),
  uploadedBy: (json['uploaded_by'] as num).toInt(),
  imagePath: json['image_path'] as String?,
  originalFilename: json['original_filename'] as String?,
  mimeType: json['mime_type'] as String?,
  fileSize: (json['file_size'] as num?)?.toInt(),
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

Map<String, dynamic> _$TicketImageToJson(TicketImage instance) =>
    <String, dynamic>{
      'id': instance.id,
      'uuid': instance.uuid,
      'ticket_id': instance.ticketId,
      'uploaded_by': instance.uploadedBy,
      'image_path': instance.imagePath,
      'original_filename': instance.originalFilename,
      'mime_type': instance.mimeType,
      'file_size': instance.fileSize,
      'description': instance.description,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
