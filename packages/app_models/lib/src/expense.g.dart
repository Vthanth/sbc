// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) => Expense(
  id: (json['id'] as num).toInt(),
  expenseDate: json['expense_date'] as String?,
  amount: json['amount'] as String,
  details: json['details'] as String?,
  isApproved: json['is_approved'] as bool,
  // receiptImage: json['receipt_image'] as String?,
  editEnabled: json['edit_enabled'] as bool?,
);

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
  'id': instance.id,
  'expense_date': instance.expenseDate,
  'amount': instance.amount,
  'details': instance.details,
  // 'receipt_image': instance.receiptImage,
  'is_approved': instance.isApproved,
  'edit_enabled': instance.editEnabled,
};
