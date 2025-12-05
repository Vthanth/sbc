// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Item _$ItemFromJson(Map<String, dynamic> json) => Item(
  item: json['item'] as String?,
  qty: (json['qty'] as num?)?.toInt(),
  rate: (json['rate'] as num?)?.toInt(),
  amount: (json['amount'] as num?)?.toInt(),
);

Map<String, dynamic> _$ItemToJson(Item instance) => <String, dynamic>{
  'item': instance.item,
  'qty': instance.qty,
  'rate': instance.rate,
  'amount': instance.amount,
};
