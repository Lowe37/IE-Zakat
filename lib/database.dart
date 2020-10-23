import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutteriezakat/income_expense/expense.dart';
import 'package:flutteriezakat/pages/Zakat1.dart';
import 'package:flutteriezakat/zakat_records/zakat.dart';

class DBservice{

  final String uid;
  DBservice({ this.uid });

  ///////////user collection
  final CollectionReference userCollection = Firestore.instance.collection('users');

  Future updateUserData(String name, String email, String password, String confirmpassword) async {
    return await userCollection.document(uid).setData({
      'Name' : name,
      'Email' : email,
      'Password': password,
      'Confirm Password': confirmpassword,
    });
  }

//get user data
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  /////////expenses collection
  final CollectionReference expenseCollection = Firestore.instance.collection('expenses');

  Future updateExpenses(int totalExpense) async {
    return await expenseCollection.document(uid).setData({
      'totalExpense' : totalExpense,
    });
  }

  List<Expense> _expenseListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Expense(
        totalExpense: doc.data['totalExpense'] ?? '',
      );
    }).toList();
  }

  Stream<List<Expense>> get expense {
    return expenseCollection.snapshots()
        .map(_expenseListFromSnapshot);
  }

  /////////add expense
  /*int totalExpense;
  String id;
  void addExpense() async {
    DocumentReference ref = await expenseCollection.add({'totalExpense': '$totalExpense'});
    setState(() => id = ref.documentID);
  }*/

  /////////zakat collection
  final CollectionReference zakatCollection = Firestore.instance.collection('zakat');

  Future updateZakat(String name, int zakatAmount) async {
    return await zakatCollection.document(uid).setData({
      'name' : name,
      'zakatAmount' : zakatAmount,
    });
  }

  //zakat list from snapshot
  List<Zakat> _zakatListFromSnapshot(QuerySnapshot snapshot){
    return snapshot.documents.map((doc){
      return Zakat(
        name: doc.data['name'] ?? '',
        zakatAmount: doc.data['zakatAmount'] ?? 0,
      );
    }).toList();
  }

  Stream<List<Zakat>> get zakat {
    return zakatCollection.snapshots()
        .map(_zakatListFromSnapshot);

  }

}