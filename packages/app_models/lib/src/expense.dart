import 'package:json_annotation/json_annotation.dart';

// YE LINE SABSE IMPORTANT HAI: file name expense.dart hai toh part expense.g.dart hoga
part 'expense.g.dart';

@JsonSerializable()
class Expense {
  final int id;

  @JsonKey(name: 'expense_date')
  final String? expenseDate;

  final String amount;
  final String? details;

  // @JsonKey(name: 'receipt_image')
  // final String? receiptImage;

  @JsonKey(name: 'is_approved')
  final bool isApproved;

  @JsonKey(name: 'edit_enabled')
  final bool? editEnabled;

  Expense({
    required this.id,
    this.expenseDate,
    required this.amount,
    this.details,
    required this.isApproved,
    // this.receiptImage,
    this.editEnabled,
  });

  // Auto-generation ke liye ye factory methods zaroori hain
  factory Expense.fromJson(Map<String, dynamic> json) => _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);
}