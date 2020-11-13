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


class shares extends StatefulWidget {
  //business({Key key}) : super(key: key);

  @override
  _sharesState createState() => _sharesState();
}

class _sharesState extends State<shares> {

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
    double eligiblePrice = goldPrice*5.58;
    double saving = double.parse(savingDepositController.text);
    double fixed = double.parse(fixedDepositController.text);
    double takaful = double.parse(takafulDepositController.text);
    double cash = double.parse(cashController.text);
    double debtCash = double.parse(debtCashController.text);
    double digitalWallet = double.parse(digitalWalletController.text);
    double crypto = double.parse(digitalCurrenyController.text);
    netTotal = saving + fixed + takaful + cash + debtCash + digitalWallet + crypto;
    zakatAmount = netTotal*2.5/100;
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
  final savingDepositController = TextEditingController();
  final fixedDepositController = TextEditingController();
  final takafulDepositController = TextEditingController();
  final cashController = TextEditingController();
  final debtCashController = TextEditingController();
  final digitalWalletController = TextEditingController();
  final digitalCurrenyController = TextEditingController();

  @override
  void dispose() {
   savingDepositController.dispose();
   fixedDepositController.dispose();
   takafulDepositController.dispose();
   cashController.dispose();
   debtCashController.dispose();
   digitalWalletController.dispose();
   digitalCurrenyController.dispose();
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

  Widget savingsPage(){
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
            Text('Savings deposit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: savingDepositController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Fixed deposit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: fixedDepositController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Takaful deposit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: takafulDepositController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Cash', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: cashController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Cash from debtors', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: debtCashController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Digital wallet money', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: digitalWalletController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Cryptocurrency approved by Bank of Thailand', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: digitalCurrenyController,
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
                    savingDepositController.clear();
                    fixedDepositController.clear();
                    takafulDepositController.clear();
                    cashController.clear();
                    debtCashController.clear();
                    digitalWalletController.clear();
                    digitalCurrenyController.clear();
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

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Savings'),
        ),
        body: savingsPage(),
      ),
    );
  }
}
