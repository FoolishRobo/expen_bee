import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expen_bee/model/customer.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomerService {

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<Customer> getCustomerStream(){
    Stream<DocumentSnapshot> _doc = _firestore.collection('users').doc(_auth.currentUser.uid).snapshots();
    return _doc.map((event) => Customer.fromFirestore(event));
  }
}
