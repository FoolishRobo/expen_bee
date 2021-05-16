import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expen_bee/enum/login_status.dart';
import 'package:expen_bee/model/customer.dart';
import 'package:expen_bee/model/expense.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginService{
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  LOGIN_STATUS checkLoginStatus(){
    if(_auth.currentUser == null) {
      return LOGIN_STATUS.LoggedOut;
    }
    return LOGIN_STATUS.LoggedIn;
  }

  Future checkIfUserAlreadyPresent()async{
    QuerySnapshot query = await _firestore.collection("users").where("user_id", isEqualTo: _auth.currentUser.uid).get();
    Customer customer = Customer(
      userId: _auth.currentUser.uid,
      expenses: <Expense>[
        Expense(category: "Travel", color: "0xff0d26e0", list: []),
        Expense(category: "Food", color: "0xffdc7e38", list: []),
        Expense(category: "Entertainment", color: "0xfff33119", list: [])
      ]
    );
    if(query.docs.isEmpty){
      await _firestore.collection('users').doc(_auth.currentUser.uid).set(jsonDecode(jsonEncode(customer)));
    }
  }
}