// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Customer _$CustomerFromJson(Map<String, dynamic> json) {
  return Customer(
    userId: json['userId'] as String,
    expenses: (json['expenses'] as List)
        ?.map((e) =>
            e == null ? null : Expense.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$CustomerToJson(Customer instance) => <String, dynamic>{
      'userId': instance.userId,
      'expenses': instance.expenses,
    };
