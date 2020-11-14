import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/models/user.dart';
import 'package:flutteriezakat/zakat_types/openList.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutteriezakat/zakat_types/plantation_type.dart';
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
    //natural water 10%
    naturalNetProfit = '0';
    naturalZakatText = '0';
    //machine water 5%
    machineNetProfit = '0';
    machineZakatText = '0';
    //cost water 7.5%
    costNetProfit = '0';
    costZakatText = '0';

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
    super.dispose();
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

  double newValue;
  double totCost;

  //natural
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
              title: Text('Select list'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      child: StreamBuilder(
                        stream: Firestore.instance.collection('zakatTracker').where('type', isEqualTo: 'Plantation').snapshots(),
                        builder: (context, snapshot){
                          if(snapshot.data == null) return CircularProgressIndicator();
                          return Column(
                            children: eligibleList(snapshot),
                          );
                        },
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
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List <Widget> eligibleList (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(document['name']),
            SizedBox(width: 5,),
            Text(document['type']),
            SizedBox(width: 5,),
            Spacer(),
            RaisedButton(
              color: Colors.white,
              child: Text('Select'),
              onPressed: () async {
                Navigator.of(context).pop();
                totCostController.text = totCost.toString();
                //Navigator.of(context).pop();
                setState(() {
                  double total = 0.0;
                  Firestore.instance.collection("zakatTracker").getDocuments().then((querySnapshot) {
                    querySnapshot.documents.forEach((result) {
                      Firestore.instance.collection("zakatTracker").document(result.documentID).collection("costSub").getDocuments().then((querySnapshot) {
                        querySnapshot.documents.forEach((result) {
                          newValue = double.parse(result.data['cost'].toString());
                          print(newValue);
                          total += newValue;
                          //print(result.data['profit']);
                        });
                        totCost = total;
                      });
                    });
                  });
                });
              },
            ),
            SizedBox(width: 5,),
          ],
        ),
      );
    }).toList();
  }

  //machine
  Future<void> _addDialogMachine() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: AlertDialog(
              title: Text('Select list'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      child: StreamBuilder(
                        stream: Firestore.instance.collection('zakatTracker').where('type', isEqualTo: 'Plantation').snapshots(),
                        builder: (context, snapshot){
                          if(snapshot.data == null) return CircularProgressIndicator();
                          return Column(
                            children: eligibleListMachine(snapshot),
                          );
                        },
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
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List <Widget> eligibleListMachine (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(document['name']),
            SizedBox(width: 5,),
            Text(document['type']),
            SizedBox(width: 5,),
            Spacer(),
            RaisedButton(
              color: Colors.white,
              child: Text('Select'),
              onPressed: () async {
                Navigator.of(context).pop();
                totCostMachineController.text = totCost.toString();
                //Navigator.of(context).pop();
                setState(() {
                  double total = 0.0;
                  Firestore.instance.collection("zakatTracker").getDocuments().then((querySnapshot) {
                    querySnapshot.documents.forEach((result) {
                      Firestore.instance.collection("zakatTracker").document(result.documentID).collection("costSub").getDocuments().then((querySnapshot) {
                        querySnapshot.documents.forEach((result) {
                          newValue = double.parse(result.data['cost'].toString());
                          print(newValue);
                          total += newValue;
                          //print(result.data['profit']);
                        });
                        totCost = total;
                      });
                    });
                  });
                });
              },
            ),
            SizedBox(width: 5,),
          ],
        ),
      );
    }).toList();
  }

  //cost
  Future<void> _addDialogCost() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: AlertDialog(
              title: Text('Select list'),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.all(0),
                      child: StreamBuilder(
                        stream: Firestore.instance.collection('zakatTracker').where('type', isEqualTo: 'Plantation').snapshots(),
                        builder: (context, snapshot){
                          if(snapshot.data == null) return CircularProgressIndicator();
                          return Column(
                            children: eligibleListCost(snapshot),
                          );
                        },
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
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List <Widget> eligibleListCost (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(document['name']),
            SizedBox(width: 5,),
            Text(document['type']),
            SizedBox(width: 5,),
            Spacer(),
            RaisedButton(
              color: Colors.white,
              child: Text('Select'),
              onPressed: () async {
                Navigator.of(context).pop();
                totCostCostController.text = totCost.toString();
                //Navigator.of(context).pop();
                setState(() {
                  double total = 0.0;
                  Firestore.instance.collection("zakatTracker").getDocuments().then((querySnapshot) {
                    querySnapshot.documents.forEach((result) {
                      Firestore.instance.collection("zakatTracker").document(result.documentID).collection("costSub").getDocuments().then((querySnapshot) {
                        querySnapshot.documents.forEach((result) {
                          newValue = double.parse(result.data['cost'].toString());
                          print(newValue);
                          total += newValue;
                          //print(result.data['profit']);
                        });
                        totCost = total;
                      });
                    });
                  });
                });
              },
            ),
            SizedBox(width: 5,),
          ],
        ),
      );
    }).toList();
  }

  //natural water 10%
  String naturalZakatText;
  String naturalNetProfit;
  bool naturalWajibZakat = false; //condition to pay zakat or not
  //machine water 5%
  String machineZakatText;
  String machineNetProfit;
  bool machineWajibZakat = false;
  //cost water 7.5%
  String costZakatText;
  String costNetProfit;
  bool costWajibZakat = false;

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
                    //getData(docID);
                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return OpenList();
                    }));*/
                    _addDialog();
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
              onChanged: (text){
                totCostController.text = totCost.toString();
              },
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
                      naturalWajibZakat = true;
                    } else {
                      naturalZakatText = 'No Zakat';
                      naturalWajibZakat = false;
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
                  onPressed: () async  {
                      Firestore.instance.collection('zakat').add({
                        'type': 'Plantation 10%',
                        'zakatAmount' : naturalZakatText,
                        'wajibZakat' : naturalWajibZakat,
                        'date' : _date,

                      }).then((value){
                        print(value.documentID);
                        Firestore.instance.collection('zakat').document(value.documentID).updateData({
                          'id' : value.documentID,
                        });
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
                Spacer(),
                RaisedButton(
                  onPressed: (){
                    //getData(docID);
                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return OpenList();
                    }));*/
                    _addDialogMachine();
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
                      machineWajibZakat = true;
                    } else {
                      machineZakatText = 'No Zakat';
                      machineWajibZakat = false;
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
                    Firestore.instance.collection('zakat').add({
                      'type': 'Plantation 5%',
                      'zakatAmount' : machineZakatText,
                      'wajibZakat' : machineWajibZakat,
                      'date' : _date,

                    }).then((value){
                      print(value.documentID);
                      Firestore.instance.collection('zakat').document(value.documentID).updateData({
                        'id' : value.documentID,
                      });
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
                Spacer(),
                RaisedButton(
                  onPressed: (){
                    //getData(docID);
                    /*Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return OpenList();
                    }));*/
                    _addDialogCost();
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
                      costWajibZakat = true;
                    } else {
                      costZakatText = 'No Zakat';
                      costWajibZakat = false;
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
                    Firestore.instance.collection('zakat').add({
                      'type': 'Plantation 7.5%',
                      'zakatAmount' : costZakatText,
                      'wajibZakat' : costWajibZakat,
                      'date' : _date,

                    }).then((value){
                      print(value.documentID);
                      Firestore.instance.collection('zakat').document(value.documentID).updateData({
                        'id' : value.documentID,
                      });
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
