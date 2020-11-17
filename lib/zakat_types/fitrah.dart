import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Fitrah extends StatefulWidget {
  //business({Key key}) : super(key: key);

  @override
  _FitrahState createState() => _FitrahState();
}

class _FitrahState extends State<Fitrah> {

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  //small business
  String smallBusinessZakatText;
  String netProfitText;
  String eligiblePriceText;
  bool wajibZakat = false;

  @override
  void initState(){
    super.initState();
    inputData();
    zakatAmount = 0;
    //small business
  }

  //to add value from user
  final businessNameController = TextEditingController();
  //small business
  final annualProfitController = TextEditingController();
  final annualCostController = TextEditingController();
  final smallBusinessNameController = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //small business
    super.dispose();
    businessNameController.dispose();
    annualCostController.dispose();
    annualProfitController.dispose();
    smallBusinessNameController.dispose();
  }

  //select date
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

  double totProfit;
  double newValueIncome;
  double totCost;
  double newValueExpense;

  void addBusinessRecord () async {
    Firestore.instance.collection('zakat').add({
      'category': 'Fitrah',
      'zakatAmount' : smallBusinessZakatText,
      'wajibZakat' : wajibZakat,
      'date' : _date,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('zakat').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
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

  bool _validateProfit = false;
  bool _validateCost = false;
  double zakatAmount;

  void calculateFitrah (){
    double ricePrice = double.parse(annualProfitController.text);
    double familyNum = double.parse(annualCostController.text);
    zakatAmount = ricePrice*familyNum;
  }

  Widget smallBusiness(){
    return Container(
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
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
              ],
            ),

            SizedBox(height: 20,),
            Text('2.7 Kg price of rice or sticky rice', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: annualProfitController,
              decoration: InputDecoration(
                  errorText: _validateProfit? 'Price is required': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Number of family members', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: annualCostController,
              decoration: InputDecoration(
                  errorText: _validateCost? 'Number of family members is required': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$zakatAmount', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),

            SizedBox(height: 30,),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: (){
                    annualCostController.clear();
                    annualProfitController.clear();
                    setState(() {
                      netProfitText = '0.0';
                      zakatAmount = 0;
                    });
                  },
                  color: Colors.red,
                  child: Text('Reset', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: () {
                    setState(() {
                      calculateFitrah();
                      annualProfitController.text.isEmpty ? _validateProfit = true : _validateProfit = false;
                      annualCostController.text.isEmpty ?  _validateCost = true : _validateCost = false;
                    });
                  },
                  color: Colors.green,
                  child: Text('Calculate now', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: () {
                    addBusinessRecord();
                  },
                  color: Colors.blue,
                  child: Text('Save', style: TextStyle(color: Colors.white),),
                ),
              ],
            )
          ],
        ),
      ),
    );
  } //completed

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Fitrah'),
      ),
      body: smallBusiness(),
    );
  }
}
