import 'package:json_annotation/json_annotation.dart';

part 'item.g.dart';

@JsonSerializable()
class Item {
  @JsonKey(name: 'item')
  final String? item;

  @JsonKey(name: 'qty')
  final int? qty;

  @JsonKey(name: 'rate')
  final int? rate;

  @JsonKey(name: 'amount')
  final int? amount;

  Item({this.item, this.qty, this.rate, this.amount});

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}
