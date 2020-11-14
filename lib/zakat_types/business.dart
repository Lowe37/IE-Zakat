import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutteriezakat/shared/loading.dart';

void main() {

  /*var annualProfit = double.parse(annualProfitController.text);
  var annualCost = double.parse(annualCostController.text);
  var netProfit = annualProfit-annualCost;
  var zakatAmount = netProfit*2.5/100;
  print(zakatAmount.toString());*/
}


class business extends StatefulWidget {
  //business({Key key}) : super(key: key);

  @override
  _businessState createState() => _businessState();
}

class _businessState extends State<business> {

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  //small business
  String smallBusinessZakatText;
  String netProfitText;
  String eligiblePriceText;
  String _nullValue;
  //medium business
  double totalAssetAmount;
  String totalAssetText;
  double totalCostAmount;
  String totalCostText;
  String mediumBusinessZakatText;
  String netAmountText;
  //large business
  String largeBusinessZakatText;

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
      String noZakatText = 'No zakat';
      smallBusinessZakatText = noZakatText;
    } else {
      //print('Have zakat');
      smallBusinessZakatText = zakatAmount.toString();
    }
  }

  Future<String> mediumBusinessCalculation() async {
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

    double costAndDeposit = double.parse(costAndDepositController.text);
    double debtAsset = double.parse(debtorController.text);
    double stockAsset = double.parse(stockController.text);
    double otherAsset = double.parse(otherAssetController.text);
    totalAssetAmount = costAndDeposit+debtAsset+stockAsset+otherAsset;
    totalAssetText = totalAssetAmount.toString();

    double debtOwner = double.parse(debtOwnerController.text);
    double operationCost = double.parse(operationCostController.text);
    double tax = double.parse(taxController.text);
    double otherDebts = double.parse(otherDebtController.text);
    totalCostAmount = debtOwner+operationCost+tax+otherDebts;
    totalCostText = totalCostAmount.toString();

    double netAmount = totalAssetAmount-totalCostAmount;
    netAmountText = netAmount.toString();

    if(totalAssetAmount >= eligiblePrice){
      double zakatAmount = totalAssetAmount*2.5/100;
      mediumBusinessZakatText = zakatAmount.toString();
    } else {
      mediumBusinessZakatText = 'No Zakat';
    }
  }

  Future<String> LargeBusinessCalculation() async {
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
    double testprice = goldPrice*5.58;
    //print(testprice);
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
      String noZakatText = 'No zakat';
      largeBusinessZakatText = noZakatText;
    } else {
      //print('Have zakat');
      largeBusinessZakatText = zakatAmount.toString();
    }
  }

  @override
  void initState(){
    super.initState();
    //small business
    netProfitText = '0.0';
    smallBusinessZakatText = '0.0';
    //medium business
    netAmountText = '0.0';
    mediumBusinessZakatText = '0.0';
    totalAssetAmount = 0;
    totalCostAmount = 0;
  }

  //to add value from user
  final businessNameController = TextEditingController();
  //small business
  final annualProfitController = TextEditingController();
  final annualCostController = TextEditingController();
  final smallBusinessNameController = TextEditingController();
  //medium business
  final costAndDepositController = TextEditingController();
  final debtorController = TextEditingController();
  final stockController = TextEditingController();
  final otherAssetController = TextEditingController();
  final debtOwnerController = TextEditingController();
  final operationCostController = TextEditingController();
  final taxController = TextEditingController();
  final otherDebtController = TextEditingController();
  final mediumBusinessNameController = TextEditingController();


  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //small business
    businessNameController.dispose();
    annualCostController.dispose();
    annualProfitController.dispose();
    smallBusinessNameController.dispose();
    //medium business
    costAndDepositController.dispose();
    debtorController.dispose();
    stockController.dispose();
    otherAssetController.dispose();
    debtOwnerController.dispose();
    operationCostController.dispose();
    taxController.dispose();
    otherDebtController.dispose();
    mediumBusinessNameController.dispose();
    super.dispose();
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

  //loading screen
  bool loading = false;

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
            Text('Business Name', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              controller: smallBusinessNameController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: 'Enter your business name'
              ),
            ),

            SizedBox(height: 20,),
            Text('Annual Profit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: annualProfitController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Annual Cost', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: annualCostController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),

            SizedBox(height: 20,),
            Text('Net Profit', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$netProfitText', style: TextStyle(
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
            Text('$smallBusinessZakatText', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),

            SizedBox(height: 30,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    smallBusinessCalculation();
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
                    annualCostController.clear();
                    annualProfitController.clear();
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

  Widget mediumBusiness(){
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
            Text('Business Name', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              controller: mediumBusinessNameController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: 'Enter your business name'
              ),
            ),
            SizedBox(height: 20,),
            Text('Cash and deposit assets', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: costAndDepositController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Debtor assets', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: debtorController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Stock assets', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: stockController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Other assets', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: otherAssetController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 40,),
            Text('Debt from debt debt owner', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: debtOwnerController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Pending operation cost', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: operationCostController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Pending tax', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: taxController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Other debts', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: otherDebtController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Total asset amount', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$totalAssetAmount', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Total cost amount', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$totalCostAmount', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Net amount', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$netAmountText', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$mediumBusinessZakatText', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),

            SizedBox(height: 30,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    mediumBusinessCalculation();
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
                    costAndDepositController.clear();
                    debtorController.clear();
                    stockController.clear();
                    otherAssetController.clear();
                    debtOwnerController.clear();
                    operationCostController.clear();
                    taxController.clear();
                    otherDebtController.clear();
                    setState(() {
                      totalCostAmount = 0;
                      totalAssetAmount = 0;
                      mediumBusinessZakatText = '0.0';
                      netAmountText = '0.0';
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
  }//completed

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Business'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('Small'),
              ),
              Tab(
                child: Text('Medium'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            smallBusiness(),
            mediumBusiness(),
          ],
        ),
      ),
    );
  }
}
