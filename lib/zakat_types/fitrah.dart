import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class fitrah extends StatefulWidget {
  fitrah({Key key}) : super(key: key);

  @override
  _fitrahState createState() => _fitrahState();
}

class _fitrahState extends State<fitrah> {

  String zakatText;
  /*var _priceNum;
  var _familyNum;
  var _zakatAmount;*/

  final priceController = new TextEditingController();
  final familyController = new TextEditingController();
  final zakatController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    priceController.dispose();
    familyController.dispose();
    zakatController.dispose();
    super.dispose();
  }

  var _businessType = ['Small Business', 'Large Business'];
  var _businessDefault = 'Small Business';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.fromLTRB(70, 50, 50, 50),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20,),
              Center(child: Text('Zakat Fitrah', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200), )),
              SizedBox(height: 30,),
              Text('Pick a date', style: TextStyle(fontWeight: FontWeight.w400),),
              Row(
                children: <Widget>[
                  Text('${(new DateFormat("dd-MM-yyyy").format(_date))}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),),
                  IconButton(onPressed: () {_selectDate(context);}, icon: Icon(Icons.calendar_today))
                ],
              ),

              SizedBox(height: 30,),
              Text('Price of rice/sticky rice per 2.7 kg', style: TextStyle(fontWeight: FontWeight.w400),),
              SizedBox(height: 10,),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (_zakatAmount) {
                  setState(() {
                    zakatText = 0.00.toString();
                    double _priceNum = double.parse(priceController.text);
                    double _familyNum = double.parse(familyController.text);
                    double _zakatAmount = _priceNum*_familyNum;
                    zakatText = _zakatAmount.toString();
                  });
                },
                controller: priceController,
                decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: 'Enter the price'
                ),
              ),

              SizedBox(height: 30,),
              Text('Number of family members', style: TextStyle(fontWeight: FontWeight.w400),),
              SizedBox(height: 10,),
              TextField(
                keyboardType: TextInputType.number,
                onChanged: (_zakatAmount) {
                  setState(() {
                    double _priceNum = double.parse(priceController.text);
                    double _familyNum = double.parse(familyController.text);
                    double _zakatAmount = _priceNum*_familyNum;
                    zakatText = _zakatAmount.toString();
                  });
                },
                controller: familyController,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    hintText: 'Enter amount'
                ),
              ),

              SizedBox(height: 30,),
              Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
              SizedBox(height: 10,),
              Text('$zakatText', style: TextStyle(
                  fontWeight: FontWeight.w100, fontSize: 50),),

              /*Center(
                child: RaisedButton(
                  onPressed: () {
                    double _priceNum = double.parse(priceController.text);
                    double _familyNum = double.parse(familyController.text);
                    double _zakatAmount = _priceNum*_familyNum;
                    print(_zakatAmount);
                  },
                  color: Colors.green,
                  child: Text('Calculate now', style: TextStyle(color: Colors.white),),
                ),
              ),*/
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: (){
                      priceController.clear();
                      familyController.clear();
                      zakatController.clear();
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
      ),
    );
  }
}
