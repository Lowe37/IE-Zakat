import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/income_expense/addExpense.dart';
import 'package:flutteriezakat/income_expense/expense_tile.dart';
import 'package:flutteriezakat/income_expense/income_chart.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutteriezakat/services/auth.dart';


void main () => runApp(MaterialApp(
  home: zakatList(),
));

class zakatList extends StatefulWidget {

  @override
  _zakatListState createState() => _zakatListState();
}

class _zakatListState extends State<zakatList> {

  final CollectionReference expenseCollection = Firestore.instance.collection('zakat');

  Future addExpenseRecord (int zakatAmount, String type, String purchase) async {
    return await expenseCollection.document().setData({
      'ZakatAmount' : zakatAmount,
      'Type' : type,
      'Purchase': purchase,
    });
  }

  final db = Firestore.instance;
  final AuthService _auth = AuthService();
  String id;
  double totExpense;
  String expenseText;

  void readData() async {
    Firestore.instance.collection('zakat').getDocuments().then((querySnapshot){
      querySnapshot.documents.forEach((result){
        //print(result.data['id']);
        expenseText = result.data['amount'].toString();
        totExpense = double.parse(expenseText);
        totExpense = totExpense + totExpense;
        print(totExpense);
        /*db.collection('expenses')
        .document(result.data['id'])
            .delete();*/
      });
    });
  }

  void readDocument() async {
    var firebaseUser = await FirebaseAuth.instance.currentUser();
    Firestore.instance.collection('zakat').document(firebaseUser.uid).get().then((value){
      print(value.data);
    });
  }

  void getDocID() async {
    DocumentReference expenseID = Firestore.instance.collection('zakat').document();
    expenseID.setData({
      'id': expenseID.documentID
    }).then(((value){
      db.collection('zakat')
          .document(expenseID.documentID)
          .delete();
    }));
  }

  void deleteExpenseRecord() async {
    DocumentReference expenseID = Firestore.instance.collection('zakat').document();
    db.collection('zakat')
        .document(expenseID.documentID)
        .delete()
        .then((value) {
      //print(expenseID.documentID);
    });
  }

  Future<void> rejectJob(String expenseID){
    return db.collection('zakat').document(expenseID).delete();
  }

  Future<void> _deleteDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete record ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                //deleteDoc();
                //getDocID();
                //deleteExpenseRecord();
                readData();
                //readDocument();
                Navigator.of(context).pop();
              },
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  List<Widget>expenseRecordList (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return ListTile(
        leading: IconButton(
          icon: Icon(Icons.clear),
          onPressed: (){
            _deleteDialog();
          },
          color: Colors.red,
        ),
        title: Text(document['type']),
        subtitle: Text(document['note']),
        trailing: Text(document['amount']),
      );

    }).toList();
  }

  var selected = 'BURGER';

  @override
  Widget build(BuildContext context) {
    var data = [
      new balanceChart('2020', 25, Colors.green),
      new balanceChart('2018', 25, Colors.amber),
      new balanceChart('2019', 25, Colors.blue),
      new balanceChart('2017', 25, Colors.red),
    ];

    var series = [
      new charts.Series(
        id: 'Expense',
        domainFn: (balanceChart clickData, _) => clickData.year,
        measureFn: (balanceChart clickData, _) => clickData.expense,
        colorFn: (balanceChart clickData, _) => clickData.color,
        data: data,
      ),
    ];

    var chart = new charts.PieChart(
      series,
      animate: true,
    );
    var chartWidget = new Padding(
      padding: new EdgeInsets.all(32.0),
      child: new SizedBox(
        height: 200.0,
        child: chart,
      ),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(50),
          child: StreamBuilder(
            stream: Firestore.instance.collection('zakat').snapshots(),
            builder: (context, snapshot){
              switch(snapshot.connectionState){
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                default:
                  return Column(
                      children: expenseRecordList(snapshot)
                  );
              }
            },
          ),



        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return addExpenseItem();
          }));
          /*return showDialog(
              context: context,
              builder: (context){
                return AlertDialog(
                  content: addExpenseItem(),
                );
              }
          );*/
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),*/
    );
  }
}
