import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expen_bee/model/expense.dart';
import 'package:json_annotation/json_annotation.dart';

part 'customer.g.dart';

@JsonSerializable()
class Customer{
  String userId;
  List<Expense> expenses;
  Customer({this.userId, this.expenses});

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);

  Map<String, dynamic> toJson() => _$CustomerToJson(this);

  factory Customer.fromFirestore(DocumentSnapshot doc) {
    return Customer.fromJson(doc?.data() ?? {});
  }
}