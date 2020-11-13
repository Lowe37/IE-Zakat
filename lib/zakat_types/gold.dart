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

  //add gold api
  Future<String> goldAndSilverCalculation() async {
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

    if(netTotal < eligiblePrice){
      //print('No zakat');
      String noZakatText = 'No zakat';
      zakatDecision = noZakatText;
    } else {
      //print('Have zakat');
      zakatDecision = zakatAmount.toString();
    }
  }

  @override
  void initState(){
    zakatDecision = '0.0';
    netTotal = 0;
    super.initState();
  }

  //to add value from user
  final goldIngotController = TextEditingController();
  final goldJewelryController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //small business
    goldIngotController.dispose();
    goldJewelryController.dispose();
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
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Gold jewelry weight in Baht', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goldJewelryController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Total amount', style: TextStyle(fontWeight: FontWeight.w400),),
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
                    goldAndSilverCalculation();
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
                    goldAndSilverCalculation();
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
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Gold and Silver'),
        ),
        body: goldAndSilverPage(),
      ),
    );
  }
}
