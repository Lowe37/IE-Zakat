import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';

class AddZakatPage extends StatefulWidget {
  @override
  _AddZakatPageState createState() => _AddZakatPageState();
}

class _AddZakatPageState extends State<AddZakatPage> with SingleTickerProviderStateMixin {

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
      case "Salary" : {
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

  DateTime _date = new DateTime.now();

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

  final snackBar = SnackBar(
    content: Row(
      children: [
        Text("Your record has been saved."),
        Spacer(),
        Icon(MdiIcons.checkCircle, color: Colors.green,),
      ],
    ),
  );

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: AlertDialog(
              title: Text('Confirm addition?'),
              content: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Amount: "+nameController.text),
                      SizedBox(height: 10,),
                      Text("Note: "+noteController.text),
                      SizedBox(height: 10,),
                      Text("Category: "+categoryText),
                      SizedBox(height: 10,),
                      Text("Type: "+typeText),
                    ],
                  ),
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
                  },
                ),
                RaisedButton(
                  onPressed: () {
                    inputData();
                    ColourValue();
                    addZakatTracker();
                    Navigator.pop(context);
                    Flushbar(
                      icon: Icon(MdiIcons.checkCircle, color: Colors.green,),
                      margin: EdgeInsets.all(8),
                      borderRadius: 8,
                      message:  "Your record has been added.",
                      duration:  Duration(seconds: 3),
                    )..show(context);
                    /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return MyHomePage();
                    }));*/
                    _validateAmount = false;
                    nameController.clear();
                    profitController.clear();
                    costController.clear();
                    noteController.clear();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Text('Confirm',style: TextStyle(fontWeight: FontWeight.bold),),
                  color: Colors.teal,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String typeText;
  String categoryText;
  String colorValText;
  bool _validateAmount = false;
  bool _validateNote = false;
  bool _validateCategory = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text("Add Zakat"),
        backgroundColor: Colors.cyan,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Column(
            children: [
              ListBody(
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
                        errorText: _validateNote ? 'Note is required' : null,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        hintText: 'Note'
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('Category', style: TextStyle(fontWeight: FontWeight.w400),),
                  DropDown(
                      items: ["Business", "Salary", "Savings", "Plantation"],
                      hint: Text("Select category"),
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
                    items: ["Income", "Expense"],
                    hint: Text("Select type"),
                    isExpanded: true,
                    onChanged: (val){
                      typeText = val.toString();
                      print(typeText);
                    },
                  ),
                  SizedBox(height: 20,),
                  Builder(
                    builder: (context) => RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)
                      ),
                      onPressed: () {
                        setState(() {
                          //nameController.text.isEmpty ? _validateAmount = true : _confirmDialog();
                          //noteController.text.isEmpty ?  _validateNote = true : _confirmDialog();
                          if(nameController.text.isEmpty){
                            _validateAmount = true;
                            //addBusinessRecord();
                          } else{
                            _confirmDialog();
                          }
                        });
                        //addBusinessRecord()
                        //_confirmDialog();
                      },
                      color: Colors.green,
                      child: Text('Add', style: TextStyle(color: Colors.white),),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
