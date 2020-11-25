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

class Treasure extends StatefulWidget {

  @override
  _TreasureState createState() => _TreasureState();
}


class _TreasureState extends State<Treasure> with SingleTickerProviderStateMixin {

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
      'category': 'Treasure',
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

  void calculateButton (){
    switch(percentageText){
      case "Buried 20%": {
        double totWeight = double.parse(totWeightController.text);
        double _zakatAmount = totWeight*20/100;
        naturalZakatText = _zakatAmount.toString();
        naturalWajibZakat = true;
      }
      break;
      case "Valuable 2.5%":{
        double totWeight = double.parse(totWeightController.text);
        double _zakatAmount = totWeight*2.5/100;
        naturalZakatText = _zakatAmount.toString();
        naturalWajibZakat = true;
      }
      break;
    }
  }

  //natural water 10%
  String naturalZakatText;
  String naturalNetProfit;
  bool naturalWajibZakat = false; //condition to pay zakat or not
  String percentageText;
  bool _validateProfit = false;

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
              ],
            ),
            SizedBox(height: 20,),
            Text('Value of the treasure', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: totWeightController,
              decoration: InputDecoration(
                  errorText: _validateProfit? 'Enter value of the treasure': null,
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
                items: ["Buried 20%", "Valuable 2.5%"],
                hint: Text('Select type'),
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
                      totWeightController.text.isEmpty ? _validateProfit = true : _validateProfit = false;
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
                      //annualProfitController.text.isEmpty ? _validateProfit = true : _validateProfit = false;
                      //annualCostController.text.isEmpty ?  _validateCost = true : _validateCost = false;
                      if(totWeightController.text.isEmpty){
                        _validateProfit = true;
                        //addBusinessRecord();
                      } else {
                        addPlantationRecord();
                        Flushbar(
                          icon: Icon(MdiIcons.checkCircle, color: Colors.green,),
                          margin: EdgeInsets.all(8),
                          borderRadius: 8,
                          message:  "Your Zakat record has been added.",
                          duration:  Duration(seconds: 3),
                        )..show(context);
                        /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return MyHomePage();
                        }));*/
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Treasure'),
      ),
      body: naturalWater(),
    );
  }
}
