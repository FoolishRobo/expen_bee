import 'package:json_annotation/json_annotation.dart';
import 'package:uuid/uuid.dart';
part 'expense.g.dart';

@JsonSerializable()
class Expense{
  String category;
  List<ExpenseItem> list;
  String color;

  Expense({this.category, this.list, this.color});

  factory Expense.fromJson(Map<String, dynamic> json) =>
      _$ExpenseFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseToJson(this);

}

@JsonSerializable()
class ExpenseItem{
  String id;
  String remark;
  double value;
  @JsonKey(fromJson: _fromJson, toJson: _toJson)
  DateTime time;

  ExpenseItem({this.id, this.remark, this.value, this.time}){
   id ??= Uuid().v4();
  }

  factory ExpenseItem.fromJson(Map<String, dynamic> json) =>
      _$ExpenseItemFromJson(json);

  Map<String, dynamic> toJson() => _$ExpenseItemToJson(this);

  static DateTime _fromJson(int val) =>
      DateTime.fromMillisecondsSinceEpoch(val, isUtc: false);
  static int _toJson(DateTime time) => time.millisecondsSinceEpoch;
}