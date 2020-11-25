import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutteriezakat/zakat_tracker/SubCategory.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

extension ListUtils<T> on List<T> {
  num sumBy(num f(T element)) {
    num sum = 0;
    for(var item in this) {
      sum += f(item);
    }
    return sum;
  }
}

class zakatTrackerHome extends StatefulWidget {

  @override
  _zakatTrackerHomeState createState() => _zakatTrackerHomeState();
}

class _zakatTrackerHomeState extends State<zakatTrackerHome> with SingleTickerProviderStateMixin{

  final nameController = new TextEditingController();
  final costOrProfitController = new TextEditingController();
  final profitController = new TextEditingController();
  final costController = new TextEditingController();
  final noteController = new TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    nameController.dispose();
    costOrProfitController.dispose();
    profitController.dispose();
    costController.dispose();
    super.dispose();
  }

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    inputData();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  String userID;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    userID = uid;
    print(userID);
    // here you write the codes to input the data into firestore
  }

  void ColourValue (){
    switch(categoryText){
      case "Business" : {
        colorValText = "0xFFFDD835";
        //print(colorValText);
      }
      break;
      case "Income" : {
        colorValText = "0xFF1E88E5";
      }
      break;
      case "Savings" : {
        colorValText = "0xFF43A047";
      }
      break;
      case "Plantation" : {
        colorValText = "0xFFE53935";
      }
      break;
    }
  }

  String typeText;
  String categoryText;
  String colorValText;

  void addZakatTracker() async {
    ColourValue();
    Firestore.instance.collection('zakatTracker').add({
      'userID' : userID,
      'amount': nameController.text,
      'note' : noteController.text.isEmpty ? "No note added" : "No note added",
      'category' : categoryText,
      'type' : typeText,
      'date' : _date,
      'colorVal' : colorValText,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('zakatTracker').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  String costOrProfit;
  double newValue;
  double totalValue;

  /*void addCostOrProfit(docID) async {
    switch(costOrProfit){
      case 'Profit': {
        double total = 0.0;
        Firestore.instance.collection('zakatTracker').getDocuments().then((querySnapshot){
          querySnapshot.documents.forEach((result){
            newValue = double.parse(result.data['profit'].toString());
            //print(newValue);
            total += newValue;
          });
          totalValue = total;
          print(totalValue);
        });
      }
      break;
      case 'Cost': {
        Firestore.instance.collection('zakatTracker').document(docID).updateData({
          'cost' : double.parse(costOrProfitController.text),
        });
      }
      break;
    }
  }*/

  DateTime _date = new DateTime.now();

  void deleteList(docID) async {
    Firestore.instance.collection('zakatTracker')
        .document(docID)
        .delete();
  }

  bool _validateAmount = false;
  bool _validateNote = false;

  Future<void> _addDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: AlertDialog(
              title: Text('Add information'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Amount', style: TextStyle(fontWeight: FontWeight.w400),),
                    SizedBox(height: 10,),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: nameController,
                      decoration: InputDecoration(
                        errorText: _validateAmount ? 'Amount is required' : null,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          hintText: '0'
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text('Note', style: TextStyle(fontWeight: FontWeight.w400),),
                    SizedBox(height: 10,),
                    TextField(
                      controller: noteController,
                      decoration: InputDecoration(
                          //errorText: _validateNote ? 'Note is required' : null,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          hintText: 'Note'
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text('Category', style: TextStyle(fontWeight: FontWeight.w400),),
                    DropDown(
                      items: ["Business", "Income", "Savings", "Plantation"],
                      hint: Text('Select category'),
                      isExpanded: true,
                      onChanged: (val) {
                        categoryText = val.toString();
                      }
                    ),
                    SizedBox(height: 20,),
                    Text('Instruction'),
                    SizedBox(height: 10,),
                    Text('- Please select type Expense only for category Plantation.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                    SizedBox(height: 5,),
                    Text('- Please select type Income only for category Savings.', style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),),
                    SizedBox(height: 20,),
                    Text('Type', style: TextStyle(fontWeight: FontWeight.w400),),
                    DropDown(
                      items: ["Expense", "Income"],
                      hint: Text('Select type'),
                      isExpanded: true,
                      onChanged: (val){
                        typeText = val.toString();
                        print(typeText);
                      },
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
              actions: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey),),
                  onPressed: () {
                    Navigator.of(context).pop();
                    nameController.clear();
                    profitController.clear();
                    costController.clear();
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    setState(() {
                      nameController.text.isEmpty ? _validateAmount = true : addZakatTracker();
                      //noteController.text.isEmpty ?  _validateNote = true : addZakatTracker();
                    });
                    inputData();
                    ColourValue();
                    Navigator.of(context).pop();
                    _validateAmount = false;
                    nameController.clear();
                    profitController.clear();
                    costController.clear();
                    noteController.clear();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Text('Add',style: TextStyle(fontWeight: FontWeight.bold),),
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final f = new DateFormat('yyyy-MM-dd');

  List<DataRow> _createRows(QuerySnapshot snapshot) {
    List<DataRow> newList = snapshot.documents.map((DocumentSnapshot documentSnapshot) {
      /*return new DataRow(cells: _createCellsForElement(documentSnapshot["amount"]));*/
      return new DataRow(cells: [
        DataCell(Text(documentSnapshot.data['category'].toString())),
        DataCell(Text(documentSnapshot.data['amount'].toString())),
        DataCell(Text(documentSnapshot.data['type'].toString())),
        DataCell(Text(f.format(documentSnapshot.data['date'].toDate()))),
      ]);
    }).toList();
    return newList;
  }

  void deleteExpense(docID) async {
    Firestore.instance.collection('zakatTracker')
        .document(docID)
        .delete();
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

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  List <Widget> zakatTrackerList (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return Container(
        height: 150,
        width: 700,
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan, width: 2),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(document['category'], style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 25),),
                Spacer(),
                Text(DateFormat("dd/MM/yyyy").format(document['date'].toDate())),
              ],
            ),
            SizedBox(height: 10,),
            Text('Amount: '+document['amount'].toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 15),),
            SizedBox(height: 10,),
            Text('Type: '+document['type'].toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 15),),
            SizedBox(height: 10,),
            Row(
              children: [
                Text('Note: '+document['note'], style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 15),),
                Spacer(),
                InkWell(
                  child: Icon(MdiIcons.deleteOutline),
                  onTap: (){
                    _deleteDialogExpense(document['id']);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Zakat Tracker'),
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10,),
              Text('Your records:', style: TextStyle(fontFamily: 'Nunito'), ),
              SizedBox(height: 10,),
              StreamBuilder(
                stream: Firestore.instance.collection('zakatTracker').where('userID', isEqualTo: userID).snapshots(),
                builder: (context, snapshot){
                  if(snapshot == null){
                    return Text('Loading...');
                  }
                  return Column(
                    children: zakatTrackerList(snapshot),
                  );
                },
              ),
            ],
          ),
        ),
      ),

      /*Padding(
        padding: const EdgeInsets.all(0.0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('zakatTracker').where('userID', isEqualTo: userID).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return new DataTable(
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Date')),
                ],
                rows: _createRows(snapshot.data),
              );
                  } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),*/
      floatingActionButton: FloatingActionButton(
        onPressed: () {
      _addDialog();
    },
    backgroundColor: Colors.cyan,
    child: Icon(Icons.add),
      )
    );
  }
}