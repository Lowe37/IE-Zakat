import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flushbar/flushbar.dart';
//import 'package:flutter_form_builder/flutter_form_builder.dart';

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
  final cropWeightController = new TextEditingController();
  final cropPriceController = new TextEditingController();

  @override
  void dispose() {
    cropWeightController.dispose();
    cropPriceController.dispose();
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
        print("plant");
        _enableCropWeight = true;
        _enableCropPrice = true;
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
      'cropWeight' : cropWeightController.text,
      'cropPrice' : cropPriceController.text,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('zakatTracker').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  void addZakatTrackerPlantation() async {
    ColourValue();
    Firestore.instance.collection('zakatTracker').add({
      'userID' : userID,
      'amount': nameController.text,
      'note' : noteController.text.isEmpty ? "No note added" : "No note added",
      'category' : categoryText,
      'type' : typeText,
      'date' : _date,
      'colorVal' : colorValText,
      'cropWeight' : cropWeightController.text,
      'cropPrice' : cropPriceController.text,

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

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

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
                      Text("Amount: "+nameController.text.replaceAllMapped(reg, mathFunc)),
                      SizedBox(height: 10,),
                      Text("Category: "+categoryText),
                      SizedBox(height: 10,),
                      Text("Type: "+typeText),
                      Divider(
                        height: 20,
                        thickness: 2,
                        color: Colors.cyan,
                      ),
                      SizedBox(height: 10,),
                      Text("Crop weight: "+cropWeightController.text.replaceAllMapped(reg, mathFunc)),
                      SizedBox(height: 10,),
                      Text("Crop price/Kg: "+cropPriceController.text.replaceAllMapped(reg, mathFunc)),
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
  bool _validateType = false;
  bool _validateCropWeight = false;
  bool _validateCropPrice = false;
  bool _enableCropWeight = false;
  bool _enableCropPrice = false;
  bool _enableAmount = true;

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
                  Text('Category', style: TextStyle(fontWeight: FontWeight.w400),),
                  SizedBox(height: 10,),
                  DropdownButtonFormField<String>(
                    items: [
                      DropdownMenuItem<String>(
                        value: "Business",
                        child: Text("Business"),
                      ),
                      DropdownMenuItem<String>(
                        value: "Salary",
                        child: Text("Salary"),
                      ),
                      DropdownMenuItem<String>(
                        value: "Savings",
                        child: Text("Savings"),
                      ),
                      DropdownMenuItem<String>(
                        value: "Plantation",
                        child: Text("Plantation"),
                      ),
                    ],
                    decoration: InputDecoration(
                        errorText: _validateCategory ? 'Select category' : null,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                    ),
                    hint: Text("Select category"),
                    onChanged: (value) async {
                      setState(() {
                        categoryText = value;

                        if(categoryText == "Business"){
                          _enableAmount = true;
                          _enableCropPrice = false;
                          _enableCropWeight = false;
                          _validateCropWeight = false;
                          _validateCropPrice = false;
                          cropWeightController.text = "0";
                          cropPriceController.text = "0";
                        }

                        if(categoryText == "Salary"){
                          _enableAmount = true;
                          _enableCropPrice = false;
                          _enableCropWeight = false;
                          _validateCropWeight = false;
                          _validateCropPrice = false;
                          cropWeightController.text = "0";
                          cropPriceController.text = "0";
                        }

                        if(categoryText == "Savings"){
                          _enableAmount = true;
                          _enableCropPrice = false;
                          _enableCropWeight = false;
                          _validateCropWeight = false;
                          _validateCropPrice = false;
                          cropWeightController.text = "0";
                          cropPriceController.text = "0";
                        }


                        if(categoryText == "Plantation"){
                          _enableCropWeight = true;
                          _enableCropPrice = true;
                          _enableAmount = false;
                        } else {
                          _enableAmount = true;
                          _enableCropWeight = false;
                          _enableCropPrice = false;
                        }
                      });
                    },
                    value: categoryText,
                  ),
                  SizedBox(height: 20,),
                  Text('Type', style: TextStyle(fontWeight: FontWeight.w400),),
                  SizedBox(height: 10,),
                  DropdownButtonFormField<String>(
                    items: [
                      DropdownMenuItem<String>(
                        value: "Income",
                        child: Text("Income"),
                      ),
                      DropdownMenuItem<String>(
                        value: "Expense",
                        child: Text("Expense"),
                      ),
                    ],
                    decoration: InputDecoration(
                        errorText: _validateType ? 'Select type' : null,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                    ),
                    hint: Text("Select type"),
                    onChanged: (value) async {
                      setState(() {
                        typeText = value;

                        if(categoryText == "Plantation"){
                          if(typeText == "Income"){
                            nameController.text = "0";
                            _enableCropWeight = true;
                            _enableCropPrice = true;
                            _enableAmount = false;
                          } else {
                            cropWeightController.text = "0";
                            cropPriceController.text = "0";
                            _enableAmount = true;
                            _enableCropWeight = false;
                            _enableCropPrice = false;
                          }
                        } else {
                          _enableAmount = true;
                          _enableCropWeight = false;
                          _enableCropPrice = false;
                        }
                      });
                    },
                    value: typeText,
                  ),
                  SizedBox(height: 20,),
                  Text('Amount', style: TextStyle(fontWeight: FontWeight.w400),),
                  SizedBox(height: 10,),
                  TextField(
                    enabled: _enableAmount,
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
                  Text('Crop weight for Plantation', style: TextStyle(fontWeight: FontWeight.w400),),
                  SizedBox(height: 10,),
                  TextField(
                    keyboardType: TextInputType.number,
                    enabled: _enableCropWeight,
                    controller: cropWeightController,
                    decoration: InputDecoration(
                        errorText: _validateCropWeight ? 'Crop weight is required' : null,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        hintText: '0'
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text('Crop price/Kg for Plantation', style: TextStyle(fontWeight: FontWeight.w400),),
                  SizedBox(height: 10,),
                  TextField(
                    keyboardType: TextInputType.number,
                    enabled: _enableCropPrice,
                    controller: cropPriceController,
                    decoration: InputDecoration(
                        errorText: _validateCropPrice ? 'Crop price is required' : null,
                        border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(10),
                        ),
                        hintText: '0'
                    ),
                  ),
                  SizedBox(height: 20,),
                  Builder(
                    builder: (context) => RaisedButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18)
                      ),
                      onPressed: () async {
                        //setState(() => _errorCategory = null);
                        /*if(_errorCategory ==  null){
                          setState(() => _errorCategory = 'Select category.');
                        }*/
                        setState(() {
                          nameController.text.isEmpty ? _validateAmount = true : _validateAmount = false;
                          categoryText == null ? _validateCategory = true : _validateCategory = false;
                          typeText == null ? _validateType = true : _validateType = false;
                          cropWeightController.text.isEmpty ? _validateCropWeight = true : _validateCropWeight = false;
                          cropPriceController.text.isEmpty ? _validateCropPrice = true : _validateCropPrice = false;
                          //noteController.text.isEmpty ?  _validateNote = true : _confirmDialog();
                          //_errorCategory == null ? _validateCategory = true : _validateCategory = false;
                          //_errorCategory == null ? _errorCategory = 'Select category.' : _errorCategory;
                          //_errorType == null ? _errorType = 'Select type.' : _errorType;
                          /*if(_errorCategory ==  null){
                            setState(() => _errorCategory = 'Select category.');
                          }
                          if(_errorType ==  null){
                            setState(() => _errorType = 'Select type.');
                          }*/

                          if(_validateAmount == false && _validateCategory == false && _validateType == false && _validateCropWeight == false && _validateCropPrice == false){
                            _confirmDialog();
                            /*_validateAmount = true;
                            _errorCategory = 'Select category.';
                            _errorType = 'Select type.';*/
                            //addBusinessRecord();
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
