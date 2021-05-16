import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expen_bee/model/customer.dart';
import 'package:expen_bee/model/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BillService{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future uploadBill(Customer customer, String category, ExpenseItem item, String color)async{
    bool itemAdded = false;
    customer.expenses.forEach((element) {
      if(element.category == category){
        element.list.add(item);
        itemAdded = true;
      }
    });
    if(!itemAdded){
      customer.expenses.add(
        Expense(
          category: category,
          color: color,
          list: [item],
        )
      );
    }
    await _firestore.collection("users").doc(customer.userId).update(jsonDecode(jsonEncode(customer)));
  }

  Future deleteBill(Customer customer, String category, String id)async{
    customer.expenses.firstWhere((element) => element.category==category).list.remove(customer.expenses.firstWhere((element) => element.category == category).list.firstWhere((element) => element.id == id));
    print(jsonDecode(jsonEncode(customer)));
    await _firestore.collection("users").doc(_auth.currentUser.uid).update(jsonDecode(jsonEncode(customer)));
  }

  Future editBill(Customer customer, String category, ExpenseItem item)async{
    customer.expenses.firstWhere((element) => element.category==category).list.remove(customer.expenses.firstWhere((element) => element.category == category).list.firstWhere((element) => element.id == item.id));
    customer.expenses.firstWhere((element) => element.category==category).list.add(item);
    print(jsonDecode(jsonEncode(customer)));
    await _firestore.collection("users").doc(_auth.currentUser.uid).update(jsonDecode(jsonEncode(customer)));
  }
}