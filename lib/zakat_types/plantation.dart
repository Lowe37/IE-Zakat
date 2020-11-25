import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
            DropDown(
                items: ["10%", "5%", "7.5%"],
                hint: Text('Select percentage'),
                isExpanded: true,
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
                    addPlantationRecord();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                      return MyHomePage();
                    }));
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Plantation'),
      ),
      body: naturalWater(),
      );
  }
}
