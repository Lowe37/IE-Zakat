import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class treasure extends StatefulWidget {
  treasure({Key key}) : super(key: key);

  @override
  _treasureState createState() => _treasureState();
}

class _treasureState extends State<treasure> {

  final buriedTreasureController = TextEditingController();
  final valuableTreasureController = TextEditingController();

  @override
  //used for initial value such as null to 0
  void initState() {
    // TODO: implement initState
    setState(() {
      buriedZakatAmountText = '0';
      valuableZakatAmountText = '0';
    });
    super.initState();
  }

  @override
  void dispose(){
    buriedTreasureController.dispose();
    valuableTreasureController.dispose();
  }

  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  Future <Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: _date, firstDate: new DateTime(2000), lastDate: new DateTime.now());

    if(picked != null && picked != _date){
      print(new DateFormat("dd-MM-yyyy").format(_date));
      print('${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  String buriedZakatAmountText;
  String valuableZakatAmountText;

  Future<String> buriedTreasureCalculation()async{
    double treasureAmount = double.parse(buriedTreasureController.text);
    double zakatAmount = treasureAmount*20/100;
    buriedZakatAmountText = zakatAmount.toString();
  }

  Future<String> valuableTreasureCalculation()async{
    double treasureAmount = double.parse(buriedTreasureController.text);
    double zakatAmount = treasureAmount*2.5/100;
    valuableZakatAmountText = zakatAmount.toString();
  }

  Widget buriedTreasure (){
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
            Text('Amount of the treasure', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: buriedTreasureController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$buriedZakatAmountText', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 30,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    buriedTreasureCalculation();
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
                    buriedTreasureController.clear();
                    setState(() {
                      buriedZakatAmountText = '0';
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

  Widget valuableTreasure (){
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
            Text('Amount of the treasure', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: valuableTreasureController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text('$valuableZakatAmountText', style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 30,),
            Center(
              child: RaisedButton(
                onPressed: () {
                  setState(() {
                    valuableTreasureCalculation();
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
                    valuableTreasureController.clear();
                    setState(() {
                      valuableZakatAmountText = '0';
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
          title: Text('Treasure'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('Buried treasure'),
              ),
              Tab(
                child: Text('Valuable treasure'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            buriedTreasure(),
            valuableTreasure(),
          ],
        ),
      ),
    );
  }
}
