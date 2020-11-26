import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class income extends StatefulWidget {
  //business({Key key}) : super(key: key);

  @override
  _incomeState createState() => _incomeState();
}

class _incomeState extends State<income> {

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  //small business
  String smallBusinessZakatText;
  String netProfitText;
  String eligiblePriceText;
  bool wajibZakat = false;

  //add gold api
  Future<String> smallBusinessCalculation() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://www.thaigold.info/RealTimeDataV2/gtdata_.txt"),
        headers: {
          "Accept": "application/json"
        }
    );

    List data = json.decode(response.body);
    //print(data[4]["ask"]);
    var goldPrice = double.parse(data[4]["ask"]);
    //print(goldPrice);
    double eligiblePrice = goldPrice*5.58;
    double annualProfit = double.parse(annualProfitController.text);
    double annualCost = double.parse(annualCostController.text);
    double netProfit = annualProfit-annualCost;
    netProfitText = netProfit.toString();
    print(netProfitText);
    double zakatAmount = netProfit*2.5/100;
    print(zakatAmount);
    eligiblePriceText = eligiblePrice.toString();
    smallBusinessZakatText = zakatAmount.toString();

    if(netProfit < eligiblePrice){
      //print('No zakat');
      String noZakatText = '0';
      smallBusinessZakatText = noZakatText;
      wajibZakat = false;
    } else {
      //print('Have zakat');
      smallBusinessZakatText = zakatAmount.toString();
      wajibZakat = true;
    }
  }

  @override
  void initState(){
    super.initState();
    //retrieveIncome();
    //retrieveExpense();
    inputData();
    //small business
    netProfitText = '0.0';
    smallBusinessZakatText = '0.0';
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

  void retrieveIncome (){
    double total = 0.0;
    Firestore.instance.collection("zakatTracker").where('type', isEqualTo: 'Income').where('category', isEqualTo: 'Salary').where('userID', isEqualTo: userID).getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueIncome = double.parse(result.data['amount'].toString());
        print(newValueIncome);
        total += newValueIncome;
        //print(result.data['profit']);
      });
      totProfit = total;
    });
  }

  void retrieveExpense (){
    double total = 0.0;
    Firestore.instance.collection("zakatTracker").where('type', isEqualTo: 'Expense').where('category', isEqualTo: 'Income').where('userID', isEqualTo: userID).getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueExpense = double.parse(result.data['amount'].toString());
        print(newValueExpense);
        total += newValueExpense;
        //print(result.data['profit']);
      });
      totCost = total;
    });
  }

  void addBusinessRecord () async {
    Firestore.instance.collection('zakat').add({
      'category': 'Salary',
      'zakatAmount' : smallBusinessZakatText,
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
                    Text("Zakat amount: "+smallBusinessZakatText.replaceAllMapped(reg, mathFunc)),
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
                  annualCostController.clear();
                  annualProfitController.clear();
                  setState(() {
                    netProfitText = '0.0';
                    smallBusinessZakatText = '0.0';
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

  bool _validateProfit = false;
  bool _validateCost = false;

  Widget smallBusiness(){
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
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
                Spacer(),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: (){
                    retrieveIncome();
                    retrieveExpense();
                    annualProfitController.text = totProfit.toString();
                    annualCostController.text = totCost.toString();
                  },
                  child: Text('Retrieve Data', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  color: Colors.cyan,
                ),
              ],
            ),

            SizedBox(height: 20,),
            Text('Total Income', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: annualProfitController,
              decoration: InputDecoration(
                  errorText: _validateProfit? 'Enter income value': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Total Expense', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: annualCostController,
              decoration: InputDecoration(
                errorText: _validateCost? 'Enter expense value': null,
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
            Text('Net Total', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(netProfitText.replaceAllMapped(reg, mathFunc), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(smallBusinessZakatText.replaceAllMapped(reg, mathFunc), style: TextStyle(
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
                    annualCostController.clear();
                    annualProfitController.clear();
                    setState(() {
                      netProfitText = '0.0';
                      smallBusinessZakatText = '0.0';
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
                      smallBusinessCalculation();
                      annualProfitController.text.isEmpty ? _validateProfit = true : _validateProfit = false;
                      annualCostController.text.isEmpty ?  _validateCost = true : _validateCost = false;
                    });
                  },
                  color: Colors.green,
                  child: Text('Calculate now', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 10,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: () {
                    setState(() {
                      annualProfitController.text.isEmpty ? _validateProfit = true : _validateProfit = false;
                      annualCostController.text.isEmpty ?  _validateCost = true : _validateCost = false;
                      if(_validateProfit == false && _validateCost == false){
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
    retrieveIncome();
    retrieveExpense();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Salary'),
      ),
      body: smallBusiness(),
    );
  }
}
