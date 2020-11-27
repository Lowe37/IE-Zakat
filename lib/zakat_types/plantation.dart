import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class plantation extends StatefulWidget {
  plantation({Key key}) : super(key: key);

  @override
  _plantationState createState() => _plantationState();
}


class _plantationState extends State<plantation> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    inputData();
    //natural water 10%
    naturalNetProfit = '0';
    naturalZakatText = '0';

    //animation
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  //10%
  final totWeightController = new TextEditingController();
  final yieldPerKgController = new TextEditingController();
  final totCostController = new TextEditingController();
  final debtController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    //10%
    totWeightController.dispose();
    totCostController.dispose();
    yieldPerKgController.dispose();
    debtController.dispose();
  }

  DateTime _date = new DateTime.now();

  Future <Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: _date, firstDate: new DateTime(2015), lastDate: new DateTime(2030));
    
    if(picked != null && picked != _date){
      print(new DateFormat("dd-MM-yyyy").format(_date));
      print('${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
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

  double totCost;
  double newValueExpense;

  void addPlantationRecord () async {
    Firestore.instance.collection('zakat').add({
      'category': 'Plantation',
      'zakatAmount' : naturalZakatText,
      'wajibZakat' : naturalWajibZakat,
      'date' : _date,
      'userID' : userID,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('zakat').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  double totWeight;
  double totPrice;
  double newValueIncome;
  double cropWeightVal;
  double cropPriceVal;

  void retrieveIncome (){
    double totalWeight = 0.0;
    double totalPrice = 0.0;
    Firestore.instance.collection("zakatTracker").where('type', isEqualTo: 'Income').where('category', isEqualTo: 'Plantation').where('userID', isEqualTo: userID).getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        //newValueIncome = double.parse(result.data['amount'].toString());
        cropWeightVal = double.parse(result.data['cropWeight'].toString());
        cropPriceVal = double.parse(result.data['cropPrice'].toString());
        //print(newValueIncome);
        totalWeight += cropWeightVal;
        totalPrice += cropPriceVal;
        //print(result.data['profit']);
      });
      totWeight = totalWeight;
      totPrice = totalPrice;
    });
  }

  void retrieveExpense (){
    double total = 0.0;
    Firestore.instance.collection("zakatTracker").where('type', isEqualTo: 'Expense').where('category', isEqualTo: 'Plantation').where('userID', isEqualTo: userID).getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueExpense = double.parse(result.data['amount'].toString());
        //print(newValueExpense);
        total += newValueExpense;
        //print(result.data['profit']);
      });
      totCost = total;
    });
  }

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: AlertDialog(
            title: Text('Confirm calculation?'),
            content: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Zakat amount: "+naturalZakatText.replaceAllMapped(reg, mathFunc)),
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
                  addPlantationRecord();
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
                  totWeightController.clear();
                  yieldPerKgController.clear();
                  totCostController.clear();
                  setState(() {
                    naturalNetProfit = '0';
                    naturalZakatText = '0';
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)
                ),
                child: Text('Confirm',style: TextStyle(fontWeight: FontWeight.bold),),
                color: Colors.teal,
              ),
            ],
          ),
        );
      },
    );
  }

  void calculateButton (){
    switch(percentageText){
      case "10%": {
        double totWeight = double.parse(totWeightController.text);
        double yieldPerKg = double.parse(yieldPerKgController.text);
        double totCost = double.parse(totCostController.text);
        double resultSt = totWeight*yieldPerKg;
        double resultNd = resultSt-totCost;
        naturalNetProfit = resultNd.toString();
        double _zakatAmount = resultNd*10/100;
        if(totWeight >= 652.8){
          naturalZakatText = _zakatAmount.toString();
          naturalWajibZakat = true;
          if(_zakatAmount < 0){
            naturalZakatText = '0';
          }
        } else {
          naturalZakatText = '0';
          naturalWajibZakat = false;
        }
      }
      break;
      case "5%":{
        double totWeight = double.parse(totWeightController.text);
        double yieldPerKg = double.parse(yieldPerKgController.text);
        double totCost = double.parse(totCostController.text);
        double resultSt = totWeight*yieldPerKg;
        double resultNd = resultSt-totCost;
        naturalNetProfit = resultNd.toString();
        double _zakatAmount = resultNd*5/100;

        if(totWeight >= 652.8){
          naturalZakatText = _zakatAmount.toString();
          naturalWajibZakat = true;
          if(_zakatAmount < 0){
            naturalZakatText = 'No Zakat';
          }
        } else {
          naturalZakatText = 'No Zakat';
          naturalWajibZakat = false;
        }
      }
      break;
      case "7.5%": {
        double totWeight = double.parse(totWeightController.text);
        double yieldPerKg = double.parse(yieldPerKgController.text);
        double totCost = double.parse(totCostController.text);
        double resultSt = totWeight*yieldPerKg;
        double resultNd = resultSt-totCost;
        naturalNetProfit = resultNd.toString();
        double _zakatAmount = resultNd*7.5/100;

        if(totWeight >= 652.8){
          naturalZakatText = _zakatAmount.toString();
          naturalWajibZakat = true;
          if(_zakatAmount < 0){
            naturalZakatText = 'No Zakat';
          }
        } else {
          naturalZakatText = 'No Zakat';
          naturalWajibZakat = false;
        }
      }
    }
  }

  //natural water 10%
  String naturalZakatText;
  String naturalNetProfit;
  bool naturalWajibZakat = false; //condition to pay zakat or not
  String percentageText;
  bool _validateCost = false;
  bool _validateWeight = false;
  bool _validatePrice= false;
  bool _validatePercentage = false;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  Widget naturalWater(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: (){
                    _selectDate(context);
                  },
                ),
                Text('${(new DateFormat("dd-MM-yyyy").format(_date))}', style: TextStyle(fontSize: 20),),
                Spacer(),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: (){
                    retrieveExpense();
                    retrieveIncome();
                    totWeightController.text = totWeight.toString();
                    yieldPerKgController.text = totPrice.toString();
                    totCostController.text = totCost.toString();
                  },
                  child: Text('Retrieve Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  color: Colors.cyan,
                ),
              ],
            ),
            SizedBox(height: 20,),
            Text('Total weight of yield per harvesting season', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: totWeightController,
              decoration: InputDecoration(
                  errorText: _validateWeight? 'Enter weight': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Price of yield per kilogram', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: yieldPerKgController,
              decoration: InputDecoration(
                  errorText: _validatePrice? 'Enter price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Total expense', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: totCostController,
              decoration: InputDecoration(
                  errorText: _validateCost? 'Enter expense value': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Percentage'),
            SizedBox(height: 10,),
            DropdownButtonFormField<String>(
                items: [
                  DropdownMenuItem<String>(
                    value: "10%",
                    child: Text("10%"),
                  ),
                  DropdownMenuItem<String>(
                    value: "5%",
                    child: Text("5%"),
                  ),
                  DropdownMenuItem<String>(
                    value: "7.5%",
                    child: Text("7.5%"),
                  ),
                ],
                decoration: InputDecoration(
                  errorText: _validatePercentage ? 'Select percentage' : null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                ),
                hint: Text('Select percentage'),
                isExpanded: true,
                value: percentageText,
                onChanged: (val) {
                  percentageText = val.toString();
                }
            ),
            SizedBox(height: 10,),

            Divider(
              height: 20,
              thickness: 2,
              color: Colors.cyan,
            ),

            SizedBox(height: 10,),
            Text('Net Profit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(naturalNetProfit.replaceAllMapped(reg, mathFunc), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(naturalZakatText.replaceAllMapped(reg, mathFunc), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: (){
                    totWeightController.clear();
                    totCostController.clear();
                    debtController.clear();
                    yieldPerKgController.clear();
                    setState(() {
                      naturalNetProfit = '0';
                      naturalZakatText = '0';
                    });
                  },
                  color: Colors.red,
                  child: Text('Reset', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 10,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: () {
                    setState(() {
                      calculateButton();
                      totWeightController.text.isEmpty ? _validateWeight = true : _validateWeight = false;
                      yieldPerKgController.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                      totCostController.text.isEmpty ? _validateCost = true : _validateCost = false;
                      percentageText == null ? _validatePercentage = true : _validatePercentage = false;
                    });
                  },
                  color: Colors.green,
                  child: Text('Calculate now', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 10),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: () {
                    setState(() {
                      totWeightController.text.isEmpty ? _validateWeight = true : _validateWeight = false;
                      yieldPerKgController.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                      totCostController.text.isEmpty ? _validateCost = true : _validateCost = false;
                      percentageText == null ? _validatePercentage = true : _validatePercentage = false;
                      if(_validateWeight == false && _validateCost == false && _validatePrice == false && _validatePercentage == false){
                        _confirmDialog();
                      }
                    });
                  },
                  color: Colors.blue,
                  child: Text('Save', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }//completed

  @override
  Widget build(BuildContext context) {
    retrieveExpense();
    retrieveIncome();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Plantation'),
      ),
      body: naturalWater(),
      );
  }
}
