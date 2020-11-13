import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {

  /*var annualProfit = double.parse(annualProfitController.text);
  var annualCost = double.parse(annualCostController.text);
  var netProfit = annualProfit-annualCost;
  var zakatAmount = netProfit*2.5/100;
  print(zakatAmount.toString());*/
}


class income extends StatefulWidget {
  //business({Key key}) : super(key: key);

  @override
  _incomeState createState() => _incomeState();
}

class _incomeState extends State<income> {

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  //variables
  double goldPrice;
  //monthly
  double netTotal;
  String zakatDecision;
  double zakatAmount;
  //yearly
  double netTotalY;
  String zakatDecisionY;
  double zakatAmountY;

  //monthly calculation
  Future<String> goldPriceFunction() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://www.thaigold.info/RealTimeDataV2/gtdata_.txt"),
        headers: {
          "Accept": "application/json"
        }
    );
    List data = json.decode(response.body);
    //print(data[4]["ask"]);
    goldPrice = double.parse(data[4]["ask"]);
  }

  void monthlyCalculation() {
    //double eligiblePrice = goldPrice*5.58;
    double salaryVal = double.parse(salaryController.text);
    double assetVal = double.parse(assetController.text);
    double otherVal = double.parse(otherSourcesController.text);
    netTotal = salaryVal + assetVal + otherVal;
    print(netTotal);
    zakatAmount = netTotal*2.5/100;
    print(zakatAmount);
    zakatDecision = zakatAmount.toString();

    /*if(netTotal < eligiblePrice){
      //print('No zakat');
      String noZakatText = 'No zakat';
      zakatDecision = noZakatText;
    } else {
      //print('Have zakat');
      zakatDecision = zakatAmount.toString();
    }*/
  }

  Future<String> yearlyCalculation() async {
    http.Response response = await http.get(
        Uri.encodeFull("http://www.thaigold.info/RealTimeDataV2/gtdata_.txt"),
        headers: {
          "Accept": "application/json"
        }
    );

    List data = json.decode(response.body);
    //print(data[4]["ask"]);
    var goldPrice = double.parse(data[4]["ask"]);
    print(goldPrice);
    double eligiblePrice = goldPrice*5.58;
    double salaryVal = double.parse(salaryControllerY.text);
    double assetVal = double.parse(assetControllerY.text);
    double otherVal = double.parse(otherSourcesControllerY.text);
    netTotalY = salaryVal + assetVal + otherVal;
    netTotalY = netTotalY*12;
    zakatAmount = netTotalY*2.5/100;

    if(netTotalY < eligiblePrice){
      //print('No zakat');
      String noZakatText = 'No zakat';
      zakatDecisionY = noZakatText;
    } else {
      //print('Have zakat');
      zakatDecisionY = zakatAmount.toString();
    }
  }

  @override
  void initState(){
    zakatDecision = '0.0';
    netTotal = 0;
    zakatDecisionY = '0.0';
    netTotalY = 0;
    super.initState();
  }

  //to add value from user
  //monthly controllers
  final salaryController = TextEditingController();
  final assetController = TextEditingController();
  final otherSourcesController = TextEditingController();

  //yearly controllers
  final salaryControllerY = TextEditingController();
  final assetControllerY = TextEditingController();
  final otherSourcesControllerY = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //monthly controllers
    salaryController.dispose();
    assetController.dispose();
    otherSourcesController.dispose();
    //yearly controllers
    salaryControllerY.dispose();
    assetControllerY.dispose();
    otherSourcesControllerY.dispose();
    super.dispose();
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

  //loading screen
  bool loading = false;

  Widget monthlyIncome(){
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
            Text('Salary or bonuses', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: salaryController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Profit from assets', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: assetController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Profit from other sources', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: otherSourcesController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Net total', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(netTotal.toString(), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            /*Text('Zakat amount', style: TextStyle(fontWeight: FontWeight.w400),),
                SizedBox(height: 10,),
                TextField(

                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      hintText: 'Amount of Zakat'
                  ),
                ),*/
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(zakatDecision.toString(), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),

            SizedBox(height: 30,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    monthlyCalculation();
                  });
                },
                color: Colors.green,
                child: Text('Calculate now', style: TextStyle(color: Colors.white),),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    salaryController.clear();
                    assetController.clear();
                    otherSourcesController.clear();
                    setState(() {
                      netTotal = 0;
                      zakatDecision = '0.0';
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
            )
          ],
        ),
      ),
    );
  } //completed

  Widget yearlyIncome(){
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
            Text('Salary or bonuses', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: salaryControllerY,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Profit from assets', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: assetControllerY,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Profit from other sources', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: otherSourcesControllerY,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Net total', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(netTotalY.toString(), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            /*Text('Zakat amount', style: TextStyle(fontWeight: FontWeight.w400),),
                SizedBox(height: 10,),
                TextField(

                  decoration: InputDecoration(
                      border: new OutlineInputBorder(
                        borderRadius: new BorderRadius.circular(10),
                      ),
                      hintText: 'Amount of Zakat'
                  ),
                ),*/
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(zakatDecisionY.toString(), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),

            SizedBox(height: 30,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    yearlyCalculation();
                  });
                },
                color: Colors.green,
                child: Text('Calculate now', style: TextStyle(color: Colors.white),),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RaisedButton(
                  onPressed: (){
                    salaryControllerY.clear();
                    assetControllerY.clear();
                    otherSourcesControllerY.clear();
                    setState(() {
                      netTotalY = 0;
                      zakatDecisionY = '0.0';
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
            )
          ],
        ),
      ),
    );
  } //completed

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Income'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('Monthly'),
              ),
              Tab(
                child: Text('Yearly'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            monthlyIncome(),
            yearlyIncome(),
          ],
        ),
      ),
    );
  }
}
