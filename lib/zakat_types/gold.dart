import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

class gold extends StatefulWidget {
  //business({Key key}) : super(key: key);

  @override
  _goldState createState() => _goldState();
}

class _goldState extends State<gold> {

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  //variables
  double netTotal;
  String zakatDecision;
  double zakatAmount;
  //goldPrices
  double goldBarPrice;
  double goldBarWeight;
  double goldBarTotal;
  double goldBarNisab;
  //goldJewelry
  double goldJewelryPrice;
  double goldJewelryWeight;
  double goldJewelryTotal;
  double goldJewelryNisab;
  double goldJewelryWeightExceed;
  double goldJewelryExceed;
  //mortgage
  double pawnBefore;
  double pawnAfter;
  double pawnPrice;
  double pawnTotal;
  //silver
  double silverWeight;
  double silverPrice;
  double silverTotal;
  //total
  double totalPrice;

  //add gold api
  void goldAndSilverCalculation() {
    //goldBar
    goldBarWeight = double.parse(goldIngotController.text);
    goldBarPrice = double.parse(goldBarPriceController.text);
    goldBarTotal = goldBarWeight*goldBarPrice;
    goldBarNisab = goldBarPrice*5.58;

    if(goldBarTotal < goldBarNisab){
     goldBarTotal = 0;
     //print(goldBarTotal);
    }

    //goldJewelry
    goldJewelryWeight = double.parse(goldJewelryWeightController.text);
    goldJewelryPrice = double.parse(goldJewelryPriceController.text);
    goldJewelryTotal = goldJewelryWeight*goldJewelryPrice;
    goldJewelryNisab = goldJewelryPrice*5.58;
    goldJewelryWeightExceed = double.parse(goldJewelryWearExceedController.text);

    if(goldJewelryTotal < goldJewelryNisab){
      goldJewelryTotal = 0;
    }

    if(goldJewelryWeightExceed < 52.52){
      goldJewelryExceed = 0;
    } else {
      goldJewelryExceed = goldJewelryWeightExceed-52.52;
      goldJewelryExceed = goldJewelryPrice*goldJewelryExceed;
    }

    //mortgage
    pawnBefore = double.parse(goldMortgageBeforeController.text);
    pawnAfter = double.parse(goldMortgageAfterController.text);
    pawnPrice = double.parse(goldMortgagePriceController.text);
    pawnTotal = pawnBefore-pawnAfter-pawnPrice;
    //print(pawnTotal);

    //silver
    silverWeight = double.parse(silverWeightController.text);
    silverPrice = double.parse(silverPriceController.text);
    silverTotal = silverWeight*silverPrice;

    totalPrice = goldBarTotal+goldJewelryTotal+pawnTotal+silverTotal+goldJewelryExceed;
    print(totalPrice);
    zakatAmount = totalPrice*2.5/100;
    print(zakatAmount);

    if(zakatAmount < 0){
      wajibZakat = true;
    } else {
      wajibZakat = false;
    }

  }

  @override
  void initState(){
    super.initState();
    inputData();
    zakatDecision = '0.0';
    totalPrice = 0;
    zakatAmount = 0;
  }

  //to add value from user
  //golBar
  final goldIngotController = TextEditingController();
  final goldBarPriceController = TextEditingController();
  //goldJewelry
  final goldJewelryWearController = TextEditingController();
  final goldJewelryWeightController = TextEditingController();
  final goldJewelryWearExceedController = TextEditingController();
  final goldJewelryPriceController = TextEditingController();
  //goldMortgage
  final goldMortgageBeforeController = TextEditingController();
  final goldMortgageAfterController = TextEditingController();
  final goldMortgagePriceController = TextEditingController();
  //silver
  final silverWeightController = TextEditingController();
  final silverPriceController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    //goldBar
    goldIngotController.dispose();
    goldBarPriceController.dispose();
    //jewelry
    goldJewelryWearController.dispose();
    goldJewelryWeightController.dispose();
    goldJewelryWearExceedController.dispose();
    goldJewelryPriceController.dispose();
    //mortgage
    goldMortgageBeforeController.dispose();
    goldMortgageAfterController.dispose();
    goldMortgagePriceController.dispose();
    //silver
    silverWeightController.dispose();
    silverPriceController.dispose();
  }

  //select date
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

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
                    Text("Zakat amount: "+zakatAmount.toStringAsFixed(2).replaceAllMapped(reg, mathFunc)),
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
                  addBusinessRecord();
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
                  goldIngotController.clear();
                  goldBarPriceController.clear();
                  //goldJewelry
                  goldJewelryWearController.clear();
                  goldJewelryWeightController.clear();
                  goldJewelryWearExceedController.clear();
                  goldJewelryPriceController.clear();
                  //goldMortgage
                  goldMortgageBeforeController.clear();
                  goldMortgageAfterController.clear();
                  goldMortgagePriceController.clear();
                  //silver
                  silverWeightController.clear();
                  silverPriceController.clear();
                  setState(() {
                    totalPrice = 0;
                    zakatAmount = 0;
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

  void addBusinessRecord () async {
    Firestore.instance.collection('zakat').add({
      'category': 'Gold',
      'zakatAmount' : zakatAmount.toStringAsFixed(2),
      'wajibZakat' : wajibZakat,
      'date' : _date,
      'userID' : userID,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('zakat').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  //loading screen
  bool loading = false;
  //gold
  bool _validateGoldBar = false;
  bool _validateGoldBarPrice = false;
  bool _validateGoldJewelry = false;
  bool _validateGoldJewelryPrice = false;
  bool _validateGoldJewelryExceed = false;
  //mortgage
  bool _validateBefore = false;
  bool _validateAfter = false;
  bool _validatePrice = false;
  //silver
  bool _validateSilver = false;
  bool _validateSilverPrice = false;
  //wajibZakat
  bool wajibZakat = false;


  Widget goldAndSilverPage(){
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
            Text('Gold ingot weight in Baht', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldIngotController,
              decoration: InputDecoration(
                  errorText: _validateGoldBar? 'Enter gold ingot weight': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Price of gold ingot/Baht', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldBarPriceController,
              decoration: InputDecoration(
                  errorText: _validateGoldBarPrice? 'Enter gold ingot price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Gold jewelry weight in Baht (not wear)', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldJewelryWeightController,
              decoration: InputDecoration(
                  errorText: _validateGoldJewelry? 'Enter gold jewelry weight': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Price of gold jewelry/Baht', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldJewelryPriceController,
              decoration: InputDecoration(
              errorText: _validateGoldJewelryPrice? 'Enter gold jewelry price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Gold jewelry weight in Baht wearing exceed 52.52 Baht', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldJewelryWearExceedController,
              decoration: InputDecoration(
                  errorText: _validateGoldJewelryExceed? 'Enter gold jewelry weight': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),

            Divider(
              height: 20,
              thickness: 2,
              color: Colors.cyan,
            ),

            SizedBox(height: 10),
            Text('Mortgage assets'),
            SizedBox(height: 20,),
            Text('Price of gold before pawn', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldMortgageBeforeController,
              decoration: InputDecoration(
                  errorText: _validateBefore? 'Enter price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Price of gold after pawn', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldMortgageAfterController,
              decoration: InputDecoration(
                  errorText: _validateAfter? 'Enter price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Price of gold keeping', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldMortgagePriceController,
              decoration: InputDecoration(
                  errorText: _validatePrice? 'Enter price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),

            Divider(
              height: 20,
              thickness: 2,
              color: Colors.cyan,
            ),

            SizedBox(height: 10),
            Text('Silver assets'),
            SizedBox(height: 20,),
            Text('Silver weight in Baht (not wear)', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: silverWeightController,
              decoration: InputDecoration(
                  errorText: _validateSilver? 'Enter silver weight': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Price of silver/Baht', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: silverPriceController,
              decoration: InputDecoration(
                  errorText: _validateSilverPrice? 'Enter silver price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),

            Divider(
              height: 20,
              thickness: 2,
              color: Colors.cyan,
            ),

            SizedBox(height: 10,),
            Text('Total amount', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(totalPrice.toStringAsFixed(2).replaceAllMapped(reg, mathFunc), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(zakatAmount.toStringAsFixed(2).replaceAllMapped(reg, mathFunc), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),

            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: (){
                    //goldbar
                    setState(() {
                      /*goldIngotController.text.isEmpty ? _validateGoldBar = true : _validateGoldBar = false;
                      goldBarPriceController.text.isEmpty ? _validateGoldBarPrice = true : _validateGoldBarPrice = false;
                      goldJewelryWeightController.text.isEmpty ? _validateGoldJewelry = true : _validateGoldJewelry = false;
                      goldJewelryPriceController.text.isEmpty ? _validateGoldJewelryPrice = true : _validateGoldJewelryPrice = false;
                      goldJewelryWearExceedController.text.isEmpty ? _validateGoldJewelryExceed = true : _validateGoldJewelryExceed = false;
                      goldMortgageBeforeController.text.isEmpty ? _validateBefore = true : _validateBefore = false;
                      goldMortgageAfterController.text.isEmpty ? _validateAfter = true : _validateAfter = false;
                      goldMortgagePriceController.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                      silverWeightController.text.isEmpty ? _validateSilver = true : _validateSilver = false;
                      silverPriceController.text.isEmpty ? _validateSilverPrice = true : _validateSilverPrice = false;*/


                      goldIngotController.clear();
                      goldBarPriceController.clear();
                      goldJewelryWeightController.clear();
                      goldJewelryPriceController.clear();
                      goldJewelryWearExceedController.clear();
                      goldMortgageBeforeController.clear();
                      goldMortgagePriceController.clear();
                      goldMortgageAfterController.clear();
                      silverPriceController.clear();
                      silverWeightController.clear();
                      totalPrice = 0;
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
                  onPressed: (){
                    setState(() {
                      goldIngotController.text.isEmpty ? _validateGoldBar = true : _validateGoldBar = false;
                      goldBarPriceController.text.isEmpty ? _validateGoldBarPrice = true : _validateGoldBarPrice = false;
                      goldJewelryWeightController.text.isEmpty ? _validateGoldJewelry = true : _validateGoldJewelry = false;
                      goldJewelryPriceController.text.isEmpty ? _validateGoldJewelryPrice = true : _validateGoldJewelryPrice = false;
                      goldJewelryWearExceedController.text.isEmpty ? _validateGoldJewelryExceed = true : _validateGoldJewelryExceed = false;
                      goldMortgageBeforeController.text.isEmpty ? _validateBefore = true : _validateBefore = false;
                      goldMortgageAfterController.text.isEmpty ? _validateAfter = true : _validateAfter = false;
                      goldMortgagePriceController.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                      silverWeightController.text.isEmpty ? _validateSilver = true : _validateSilver = false;
                      silverPriceController.text.isEmpty ? _validateSilverPrice = true : _validateSilverPrice = false;
                    });
                    goldAndSilverCalculation();
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
                    //addBusinessRecord();
                    setState(() {
                      goldIngotController.text.isEmpty ? _validateGoldBar = true : _validateGoldBar = false;
                      goldBarPriceController.text.isEmpty ? _validateGoldBarPrice = true : _validateGoldBarPrice = false;
                      goldJewelryWeightController.text.isEmpty ? _validateGoldJewelry = true : _validateGoldJewelry = false;
                      goldJewelryPriceController.text.isEmpty ? _validateGoldJewelryPrice = true : _validateGoldJewelryPrice = false;
                      goldJewelryWearExceedController.text.isEmpty ? _validateGoldJewelryExceed = true : _validateGoldJewelryExceed = false;
                      goldMortgageBeforeController.text.isEmpty ? _validateBefore = true : _validateBefore = false;
                      goldMortgageAfterController.text.isEmpty ? _validateAfter = true : _validateAfter = false;
                      goldMortgagePriceController.text.isEmpty ? _validatePrice = true : _validatePrice = false;
                      silverWeightController.text.isEmpty ? _validateSilver = true : _validateSilver = false;
                      silverPriceController.text.isEmpty ? _validateSilverPrice = true : _validateSilverPrice = false;

                      if(_validateGoldBar == false && _validateGoldBarPrice == false && _validateGoldJewelry == false
                          && _validateGoldJewelryPrice == false && _validateGoldJewelryExceed == false && _validateBefore == false
                          && _validateAfter == false && _validatePrice == false && _validateSilver == false && _validateSilverPrice == false){
                        _confirmDialog();
                      }
                    });
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
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Gold'),
        ),
        body: goldAndSilverPage(),
      ),
    );
  }
}
