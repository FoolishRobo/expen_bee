// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Expense _$ExpenseFromJson(Map<String, dynamic> json) {
  return Expense(
    category: json['category'] as String,
    list: (json['list'] as List)
        ?.map((e) =>
            e == null ? null : ExpenseItem.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    color: json['color'] as String,
  );
}

Map<String, dynamic> _$ExpenseToJson(Expense instance) => <String, dynamic>{
      'category': instance.category,
      'list': instance.list,
      'color': instance.color,
    };

ExpenseItem _$ExpenseItemFromJson(Map<String, dynamic> json) {
  return ExpenseItem(
    id: json['id'] as String,
    remark: json['remark'] as String,
    value: (json['value'] as num)?.toDouble(),
    time: ExpenseItem._fromJson(json['time'] as int),
  );
}

Map<String, dynamic> _$ExpenseItemToJson(ExpenseItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remark': instance.remark,
      'value': instance.value,
      'time': ExpenseItem._toJson(instance.time),
    };
