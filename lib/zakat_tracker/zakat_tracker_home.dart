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

  /*final Widget body;
  balance({this.body});*/
  /*final FirebaseUser user;
  balance(this.user, {Key key}) : super(key: key);*/

  @override
  _zakatTrackerHomeState createState() => _zakatTrackerHomeState();
}

class _zakatTrackerHomeState extends State<zakatTrackerHome> with SingleTickerProviderStateMixin{

  final nameController = new TextEditingController();
  final costOrProfitController = new TextEditingController();
  final profitController = new TextEditingController();
  final costController = new TextEditingController();

  @override
  void dispose() {
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
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  void signOut(BuildContext context){
    FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPageTest()),
      ModalRoute.withName('/'),
    );
  }

  String typeText;

  void addZakatTracker() async {
    Firestore.instance.collection('zakatTracker').add({
      'name': nameController.text,
      'type' : typeText,
      'date' : _date,

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

  void addCostOrProfit(docID) async {
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
        /*Firestore.instance.collection('zakatTracker').document(docID).updateData({
          'profit' : totalValue,
        });*/
      }
      break;
      case 'Cost': {
        Firestore.instance.collection('zakatTracker').document(docID).updateData({
          'cost' : double.parse(costOrProfitController.text),
        });
      }
      break;
    }
  }

  DateTime _date = new DateTime.now();

  void deleteList(docID) async {
    Firestore.instance.collection('zakatTracker')
        .document(docID)
        .delete();
  }

  Future<void> _deleteDialog(docID) async {
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
                    DropDown(
                      items: ["Profit", "Cost"],
                      hint: Text('Select type'),
                      isExpanded: true,
                      onChanged: (val){
                        costOrProfit = val.toString();
                        print(costOrProfit);
                      },
                    ),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: costOrProfitController,
                      decoration: InputDecoration(
                        //errorText: errorValidate ? 'List name is required' : null,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          hintText: 'Amount'
                      ),
                    ),
                    SizedBox(height: 10),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18)
                        ),
                        onPressed: (){
                          deleteList(docID);
                          Navigator.of(context).pop();
                        },
                        color: Colors.red,
                        child: Text('Delete list', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ),
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
                    costOrProfitController.clear();
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Text('Update',style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: () {
                    addCostOrProfit(docID);
                    Navigator.of(context).pop();
                    costOrProfitController.clear();
                  },
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                    Text('List name', style: TextStyle(fontWeight: FontWeight.w400),),
                    SizedBox(height: 10,),
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        //errorText: errorValidate ? 'List name is required' : null,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          hintText: 'Enter name'
                      ),
                    ),
                    SizedBox(height: 20,),
                    Text('Zakat category', style: TextStyle(fontWeight: FontWeight.w400),),
                    DropDown(
                      items: ["Business", "Income", "Savings", "Plantation"],
                      hint: Text('Select category'),
                      isExpanded: true,
                      onChanged: (val){
                        typeText = val.toString();
                        print(typeText);
                      },
                    ),
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
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Text('Add',style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: () {
                    addZakatTracker();
                    Navigator.of(context).pop();
                    nameController.clear();
                    profitController.clear();
                    costController.clear();
                  },
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List <Widget> zakatTrackerList (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return Container(
        padding: EdgeInsets.fromLTRB(10,3,3,3),
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(document['name']),
            SizedBox(width: 5,),
            Text(document['type']),
            SizedBox(width: 5,),
            SizedBox(
              height: 35,
              width: 35,
              child: IconButton(
                icon: Icon(MdiIcons.dotsVertical),
                //iconSize: 20,
                onPressed: (){
                  //print(totalExpense);
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

  bool errorValidate = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Zakat Tracker'),
      ),
      drawer: CustomDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('zakatTracker').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var doc = snapshot.data.documents;
              return new ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    SubCategory(doc[index].documentID)),
                          );
                        },
                        child: Card(
                          child: Column(
                            children: <Widget>[
                              Text('Name: '+doc[index].data['name']),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Type: '+doc[index].data['type']),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
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