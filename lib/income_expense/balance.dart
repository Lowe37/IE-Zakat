import 'package:flutter/material.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:flutteriezakat/income_expense/select_category.dart';
import 'package:flutteriezakat/block/navigation_bloc.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:async/async.dart';
import 'package:fluttertoast/fluttertoast.dart';

/*extension ListUtils<T> on List<T> {
  num sumBy(num f(T element)) {
    num sum = 0;
    for(var item in this) {
      sum += f(item);
    }
    return sum;
  }
}*/

/*class balanceHome extends StatelessWidget with NavigationStates {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: balance(),
      debugShowCheckedModeBanner: false,
    );
  }
}*/

class balance extends StatefulWidget {

  final GlobalKey<balanceChildState> _key = GlobalKey();

  /*final Widget body;
  balance({this.body});*/
  /*final FirebaseUser user;
  balance(this.user, {Key key}) : super(key: key);*/

  @override
  _balanceState createState() => _balanceState();
}

//functions

void signOut(BuildContext context){
  FirebaseAuth.instance.signOut();
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => LoginPageTest()),
    ModalRoute.withName('/'),
  );
}

void deleteExpense(docID) async {
  Firestore.instance.collection('expenses')
      .document(docID)
      .delete();
}

void deleteIncome(docID) async {
  Firestore.instance.collection('income')
      .document(docID)
      .delete();
}

double totalExpense;
String expenseText;
double newValue;
double resultValue;
double totExpense;

expenseCal (){
  //double totExpense = 0.
  double total = 0.0;
  Firestore.instance.collection('expenses').getDocuments().then((querySnapshot){
    querySnapshot.documents.forEach((result){
//        expenseText = result.data['amount'].toString();
//        newValue = double.parse(expenseText);
//        print(newValue);
//        totExpense = totExpense + newValue;
      newValue = double.parse(result.data['amount'].toString());
      print(newValue);
      total += newValue;
    });
    totExpense = total;
  });
}

double totIncome; // why outside the function? because global variable

incomeCal (){
  //double totExpense = 0.
  double total = 0.0;
  Firestore.instance.collection('income').getDocuments().then((querySnapshot){
    querySnapshot.documents.forEach((result){
//        expenseText = result.data['amount'].toString();
//        newValue = double.parse(expenseText);
//        print(newValue);
//        totExpense = totExpense + newValue;
      newValue = double.parse(result.data['amount'].toString());
      total += newValue;
    });
    totIncome = total;
  });
}

double totBalance; // why outside the function? because global variable

balanceCal (){
  totBalance = totIncome-totExpense;
}

class _balanceState extends State<balance> {

  @override
  void initState() {
    // TODO: implement initState
    //expenseList();
    super.initState();
  }

  Future<void> _deleteDialogExpense(docID) async {
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
                deleteExpense(docID);
                setState(() {
                  expenseCal();
                });
                Navigator.of(context).pop();
              },
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteDialogIncome(docID) async {
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
                deleteIncome(docID);
                setState(() {
                  incomeCal();
                });
                //deleteDoc();
                //getDocID();
                //deleteExpenseRecord();
//                setState(() {
//                  readData(docID);
//                });
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

  List <Widget> expenseRecordList (AsyncSnapshot snapshot){
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
                  //print(totalExpense);
                  _deleteDialogExpense(document['id']);
                  //readData(document['id']);
                },
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget>incomeRecordList (AsyncSnapshot snapshot){
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
            Icon(MdiIcons.arrowUpCircle, color: Colors.green,),
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
                  _deleteDialogIncome(document['id']);
                  //readData(document['id']);
                },
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  List<Widget>combinedRecordList (AsyncSnapshot snapshot){
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
            Icon(MdiIcons.arrowUpCircle, color: Colors.green,),
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
                  //_deleteDialog(document['id']);
                  //readData(document['id']);
                },
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Stream <List<QuerySnapshot>> combinedStream (){
    Stream expenseStream = Firestore.instance.collection('expenses').snapshots();
    Stream incomeStream = Firestore.instance.collection('income').snapshots();
    return StreamZip([expenseStream, incomeStream]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Personal Tracker'),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.fromLTRB(50, 30, 50, 0),
              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
              decoration: BoxDecoration(
                gradient: new LinearGradient(colors: [Colors.cyan, Colors.indigo]),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  IconButton(
                    onPressed: (){

                    },
                    icon: Icon(MdiIcons.menuLeft,),
                    color: Colors.white,
                  ),
                  Column(
                    children: <Widget>[
                      Text('Expense'),
                      SizedBox(height: 10,),
                      Text(totExpense.toString()),
                    ],
                  ),
                  IconButton(
                    onPressed: (){

                    },
                    icon: Icon(MdiIcons.menuRight,),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50,),
            Text('Income'),
            Text(totIncome.toString()),
            Text('Balance'),
            Text(totBalance.toString()),
            RaisedButton(
              child: Text('test'),
              onPressed: (){
                setState(() {
                  expenseCal();
                  incomeCal();
                  balanceCal();
                  //totalExpense = totalExpense;
                });
              },
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: Firestore.instance.collection('expenses').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.data == null) return CircularProgressIndicator();
                  return Column(
                    children: expenseRecordList(snapshot),
                  );
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: Firestore.instance.collection('income').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.data == null) return CircularProgressIndicator();
                  return Column(
                    children: incomeRecordList(snapshot),
                  );
                },
              ),
            ),
            /*Flexible(
              child: Container(
                child: expenseChart(),
              ),
            ),
            Flexible(
              child: Container(
                child: incomeChart(),
              ),
            ),*/
          ],
        ),
      ),
      /*body: Padding(
        padding: EdgeInsets.fromLTRB(0,30,0,0),
        child: SingleChildScrollView(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ////////////////////////////expenses
                SizedBox(height: 5,),
                Container(
                  padding: EdgeInsets.fromLTRB(0,10,0,10),
                  margin: EdgeInsets.fromLTRB(45,10,45,10),
                  decoration: BoxDecoration(
                    color: Colors.cyan,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(width: 10,),
                        Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text("Expenses", style: TextStyle(
                                  fontSize: 18, color: Colors.white),),
                            ),
                            SizedBox(height: 10,),
                            Center(
                              child: Text('0.00', style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),),
                            ),
                          ],
                        ),
                        SizedBox(width: 10,),
                        VerticalDivider(
                          color: Colors.white,
                          width: 1,
                          thickness: 1,
                        ),
                        SizedBox(width: 10,),
                        Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text("Income", style: TextStyle(
                                   fontSize: 18, color: Colors.white),),
                            ),
                            SizedBox(height: 10,),
                            Center(
                              child: Text('0.00', style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),),
                            ),
                          ],
                        ),
                        SizedBox(width: 10,),
                        VerticalDivider(
                          color: Colors.white,
                          width: 1,
                          thickness: 1,
                        ),
                        SizedBox(width: 10,),
                        Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topCenter,
                              child: Text("Balance", style: TextStyle(
                                   fontSize: 18, color: Colors.white),),
                            ),
                            SizedBox(height: 10,),
                            Center(
                              child: Text("0.00", style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 40, color: Colors.white),),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                //Center(child: Text('Expense list', style: TextStyle(fontWeight: FontWeight.w200),)),
                RaisedButton(
                  onPressed: (){
                    getData();
                    //getTotExpense();
                  },
                  color: Colors.cyan,
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: expenseChart(),
                      ),
                      //Center(child: Text('Income list', style: TextStyle(fontWeight: FontWeight.w200),)),
                      SizedBox(
                          width: 500,
                          height: 800,
                          child: incomeChart()),
                    ],
                  ),
                ),
                /*Align(
                  alignment: Alignment.topCenter,
                  child: Text("Note: Tap on the number to add records", style: TextStyle(
                      fontWeight: FontWeight.w100, fontSize: 15),),
                ),*/
              ]
          ),
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return dropDownMenu();
          }));
        },
        backgroundColor: Colors.cyan,
        child: Icon(Icons.add),
      ),
    );
  }
}

class balanceChild extends StatefulWidget {
  final Function function;

  balanceChild({Key key, this.function}) : super(key: key);

  @override
  balanceChildState createState() => balanceChildState();
}

class balanceChildState extends State<balanceChild> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.teal,
      width: double.infinity,
      alignment: Alignment.center,
      child: RaisedButton(
        child: Text("Call method in parent"),
        onPressed: () => widget.function(), // calls method in parent
      ),
    );
  }
  methodInChild() => Fluttertoast.showToast(msg: "Method called in child");
}
