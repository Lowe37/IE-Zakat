import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/models/user.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutteriezakat/zakat_types/plantation_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class plantation extends StatefulWidget {
  plantation({Key key}) : super(key: key);

  @override
  _plantationState createState() => _plantationState();
}


class _plantationState extends State<plantation> {

  @override
  void initState() {
    super.initState();
    //natural water 10%
    naturalNetProfit = '0';
    naturalZakatText = '0';
    //machine water 5%
    machineNetProfit = '0';
    machineZakatText = '0';
    //cost water 7.5%
    costNetProfit = '0';
    costZakatText = '0';
  }

  /*setSelectedRadio (int val) {
    setState(() {
      selectedRadio = val;
    });
  }*/

  //10%
  final totWeightController = new TextEditingController();
  final yieldPerKgController = new TextEditingController();
  final totCostController = new TextEditingController();
  final debtController = new TextEditingController();
  //5%
  final totWeightMachineController = new TextEditingController();
  final yieldPerKgMachineController = new TextEditingController();
  final totCostMachineController = new TextEditingController();
  final debtMachineController = new TextEditingController();
  //7.5%
  final totWeightCostController = new TextEditingController();
  final yieldPerKgCostController = new TextEditingController();
  final totCostCostController = new TextEditingController();
  final debtCostController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //10%
    totWeightController.dispose();
    totCostController.dispose();
    yieldPerKgController.dispose();
    debtController.dispose();
    //5%
    totWeightMachineController.dispose();
    totCostMachineController.dispose();
    yieldPerKgMachineController.dispose();
    debtMachineController.dispose();
    //7.5%
    totWeightCostController.dispose();
    totCostCostController.dispose();
    yieldPerKgCostController.dispose();
    debtCostController.dispose();
    super.dispose();
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

  //natural water 10%
  String naturalZakatText;
  String naturalNetProfit;
  //machine water 5%
  String machineZakatText;
  String machineNetProfit;
  //cost water 7.5%
  String costZakatText;
  String costNetProfit;

  Widget naturalWater(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
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
                  onPressed: (){
                    StreamBuilder(
                      stream: Firestore.instance.collection('zakatTracker').snapshots(),
                      builder: (context, snapshot){
                        if(!snapshot.hasData) return const Text('Add some Zakat Tracker list');
                        return Column(
                          //children: zakatTrackerList(snapshot),
                        );
                      },
                    );
                  },
                  child: Text('Open lists', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                  color: Colors.green,
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
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Total cost per harvesting season (except water cost)', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: totCostController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Debt per harvesting season', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: debtController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Net profit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$naturalNetProfit', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$naturalZakatText', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    double totWeight = double.parse(totWeightController.text);
                    double yieldPerKg = double.parse(yieldPerKgController.text);
                    double totCost = double.parse(totCostController.text);
                    double debt = double.parse(debtController.text);
                    double resultSt = totWeight*yieldPerKg;
                    double resultNd = resultSt-totCost-debt;

                    naturalNetProfit = resultNd.toString();
                    double _zakatAmount = resultNd*10/100;

                    if(totWeight >= 652.8){
                      naturalZakatText = _zakatAmount.toString();
                    } else {
                      naturalZakatText = 'No Zakat';
                    }
                  });
                },
                color: Colors.green,
                child: Text('Calculate now', style: TextStyle(color: Colors.white),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
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
                SizedBox(width: 20,),
                RaisedButton(
                  onPressed: () {

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

  Widget machineWater(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
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
            Text('Total weight of yield per harvesting season', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: totWeightMachineController,
              decoration: InputDecoration(
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
              controller: yieldPerKgMachineController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Total cost per harvesting season (except water cost)', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: totCostMachineController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Debt per harvesting season', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: debtMachineController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Net profit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$machineNetProfit', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$machineZakatText', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    double totWeight = double.parse(totWeightMachineController.text);
                    double yieldPerKg = double.parse(yieldPerKgMachineController.text);
                    double totCost = double.parse(totCostMachineController.text);
                    double debt = double.parse(debtMachineController.text);
                    double resultSt = totWeight*yieldPerKg;
                    double resultNd = resultSt-totCost-debt;
                    machineNetProfit = resultNd.toString();
                    double _zakatAmount = resultNd*5/100;
                    machineZakatText = _zakatAmount.toString();
                    if(totWeight >= 652.8){
                      machineZakatText = _zakatAmount.toString();
                    } else {
                      machineZakatText = 'No Zakat';
                    }

                  });
                },
                color: Colors.green,
                child: Text('Calculate now', style: TextStyle(color: Colors.white),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    totWeightMachineController.clear();
                    totCostMachineController.clear();
                    debtMachineController.clear();
                    yieldPerKgMachineController.clear();
                    setState(() {
                      machineNetProfit = '0';
                      machineZakatText = '0';
                    });
                  },
                  color: Colors.red,
                  child: Text('Reset', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  onPressed: () {

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

  Widget costWater(){
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(10),
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
            Text('Total weight of yield per harvesting season', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: totWeightCostController,
              decoration: InputDecoration(
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
              controller: yieldPerKgCostController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Total cost per harvesting season (except water cost)', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: totCostCostController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Debt per harvesting season', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: debtCostController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Net profit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$costNetProfit', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$costZakatText', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    double totWeight = double.parse(totWeightCostController.text);
                    double yieldPerKg = double.parse(yieldPerKgCostController.text);
                    double totCost = double.parse(totCostCostController.text);
                    double debt = double.parse(debtCostController.text);
                    double resultSt = totWeight*yieldPerKg;
                    double resultNd = resultSt-totCost-debt;
                    costNetProfit = resultNd.toString();
                    double _zakatAmount = resultNd*7.5/100;
                    costZakatText = _zakatAmount.toString();
                    if(totWeight >= 652.8){
                      costZakatText = _zakatAmount.toString();
                    } else {
                      costZakatText = 'No Zakat';
                    }
                  });
                },
                color: Colors.green,
                child: Text('Calculate now', style: TextStyle(color: Colors.white),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    totWeightCostController.clear();
                    totCostCostController.clear();
                    debtCostController.clear();
                    yieldPerKgCostController.clear();
                    setState(() {
                      costNetProfit = '0';
                      costZakatText = '0';
                    });
                  },
                  color: Colors.red,
                  child: Text('Reset', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  onPressed: () {

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Plantation'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('10%'),
              ),
              Tab(
                child: Text('5%'),
              ),
              Tab(
                child: Text('7.5%'),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            naturalWater(),
            machineWater(),
            costWater(),
          ],
        ),
      ),
    );
  }
}
