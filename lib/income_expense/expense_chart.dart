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
import 'package:intl/intl.dart';


void main () => runApp(MaterialApp(
  home: expenseChart(),
));

class balanceChart{
  final String year;
  final int expense;
  final charts.Color color;

  balanceChart(this.year, this.expense, Color color)
      : this.color = new charts.Color(
      r: color.red, g: color.green, b: color.blue, a: color.alpha);
}

class expenseChart extends StatefulWidget {
  @override
  _expenseChartState createState() => _expenseChartState();
}

class _expenseChartState extends State<expenseChart> {

  final CollectionReference expenseCollection = Firestore.instance.collection('expenses');

  Future addExpenseRecord (int amount, String note, int totalExpense, String type) async {
    return await expenseCollection.document().setData({
      'Amount' : amount,
      'Note' : note,
      'Total Expense': totalExpense,
      'Type': type,
    });
  }

  final db = Firestore.instance;
  final AuthService _auth = AuthService();
  String id;
  double totExpense;
  String expenseText;

  void readData(docID) async {
    Firestore.instance.collection('expenses').getDocuments().then((querySnapshot){
      querySnapshot.documents.forEach((result){
        print(result.data['amount']);
        /*expenseText = result.data['amount'].toString();
        totExpense = double.parse(expenseText);
        totExpense = totExpense + totExpense;
        print(totExpense);*/
      });
    });
    db.collection('expenses')
        .document(docID)
        .delete();
  }

  void readDocument() async {
    var val = [];
    Firestore.instance.collection("expenses").document('documentID').updateData({
      'id':FieldValue.arrayRemove(val),
    });
  }

  void getDocID() async {
    DocumentReference expenseID = Firestore.instance.collection('expenses').document();
    expenseID.setData({
      'id': expenseID.documentID
    }).then(((value){
      print('success');
    }));
  }

  void deleteExpenseRecord() async {
    var result = await Firestore.instance.collection("expenses")
        .where("type", isEqualTo: "Food")
        .getDocuments();
    result.documents.forEach((res) {
      print(res.data);
    });
  }

  Future<void> _deleteDialog(docID) async {
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
                readData(docID);
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
      return Container(
        padding: EdgeInsets.all(3),
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(MdiIcons.arrowDownCircle, color: Colors.red,),
            Text(document['type']),
            SizedBox(width: 5,),
            Text(document['amount']),
            SizedBox(width: 5,),
            Text(document['note']),
            SizedBox(width: 5,),
            Text(DateFormat("dd/MM").format(document['date'].toDate())),
            SizedBox(width: 5,),
            /*RaisedButton.icon(onPressed: (){
              //_deleteDialog(document['id']);
              readData(document['id']);
            }, icon: Icon(Icons.delete, color: Colors.white,), label: Text('', style: TextStyle(color: Colors.white),), color: Colors.red,),*/
            //Spacer(),
            Container(
              padding: EdgeInsets.all(0.1),
              margin: EdgeInsets.all(0.1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(Icons.delete, color: Colors.black54,),
                onPressed: (){
                  _deleteDialog(document['id']);
                  //readData(document['id']);
                },
              ),
            ),
          ],
        ),
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
          padding: EdgeInsets.all(10),
          child: StreamBuilder(
            stream: Firestore.instance.collection('expenses').snapshots(),
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
