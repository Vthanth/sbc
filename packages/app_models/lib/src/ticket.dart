import 'package:app_models/models.dart';
import 'package:flutter/material.dart' show Color, Colors;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket.g.dart';

enum TicketState {
  start,
  inProgress,
  finished,
  unknown;

  String get displayName {
    switch (this) {
      case TicketState.start:
        return 'Not Started';
      case TicketState.inProgress:
        return 'In Progress';
      case TicketState.finished:
        return 'Finished';
      case TicketState.unknown:
        return 'Unknown';
    }
  }

  Color get color {
    switch (this) {
      case TicketState.start:
        return Colors.orange;
      case TicketState.inProgress:
        return Colors.blue;
      case TicketState.finished:
        return Colors.green;
      case TicketState.unknown:
        return Colors.grey;
    }
  }
}

@JsonSerializable()
class Ticket {
  final int id;
  final String uuid;
  final String? subject;
  final String? name;
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;
  @JsonKey(name: 'customer_id')
  final int customerId;
  @JsonKey(name: 'order_product_id')
  final int? orderProductId;
  @JsonKey(name: 'customer_contact_person_id')
  final int? customerContactPersonId;
  @JsonKey(name: 'attended_by')
  final User? attendedBy;
  @JsonKey(name: 'type')
  final String type;
  @JsonKey(name: 'assigned_to')
  final User? assignedTo;
  @JsonKey(name: 'start')
  final DateTime? start;
  @JsonKey(name: 'end')
  final DateTime? end;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @JsonKey(name: 'customer')
  final Customer? customer;
  @JsonKey(name: 'order_product')
  final OrderProduct? orderProduct;
  @JsonKey(name: 'contact_person')
  final ContactPerson? contactPerson;
  @JsonKey(name: 'additional_staff')
  final List<User>? additionalStaff;
  final List<TicketImage>? images;
  final List<Service>? services;

  Ticket(
    this.id,
    this.uuid,
    this.subject,
    this.name,
    this.phoneNumber,
    this.customerId,
    this.orderProductId,
    this.customerContactPersonId,
    this.attendedBy,
    this.type,
    this.assignedTo,
    this.start,
    this.end,
    this.createdAt,
    this.updatedAt,
    this.customer,
    this.orderProduct,
    this.contactPerson,
    this.additionalStaff,
    this.images,
    this.services,
  );

  factory Ticket.fromJson(Map<String, dynamic> json) {
    try {
      return _$TicketFromJson(json);
    } catch (e, s) {
      print(" =======ERROR -> $e");
      print(" =======STACK TRACE -> $s");
      throw Exception("Invalid response format or order not found");
    }
  }
  Map<String, dynamic> toJson() => _$TicketToJson(this);

  TicketState get state {
    if (start == null && end == null) return TicketState.start;
    if (start != null && end == null) return TicketState.inProgress;
    if (start != null && end != null) return TicketState.finished;
    return TicketState.unknown;
  }
}
