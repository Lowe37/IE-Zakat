import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class livestock extends StatefulWidget {
  livestock({Key key}) : super(key: key);

  @override
  _livestockState createState() => _livestockState();
}

class _livestockState extends State<livestock> {

  int selectedRadioTile;

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
    maleCow = 0;
    femaleCow = 0;
    femaleGoat = 0;
    totAmountGoat = 0;
  }

  final cowAmountController = new TextEditingController();
  final maleCowController = new TextEditingController();
  final femaleCowController = new TextEditingController();
  final goatPriceController = new TextEditingController();
  final goatAmountController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    cowAmountController.clear();
    maleCowController.clear();
    femaleCowController.clear();
    goatPriceController.clear();
    goatAmountController.clear();
    super.dispose();
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
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

  int maleCow;
  int femaleCow;
  int totAmount;
  bool maleCowToggle;
  bool femaleCowToggle;

  Widget cowCalculator (){
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
            TextField(
              keyboardType: TextInputType.number,
              controller: cowAmountController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: 'จำนวนวัวหรือควายที่เลี้ยงไว้'
              ),
              onChanged: (val){
                setState(() {
                  int cowAmount = int.parse(cowAmountController.text);
                  if(cowAmount >= 30 && cowAmount< 40){
                    maleCow = 1;
                    femaleCow = 0;
                    if(maleCow != null){
                      maleCowToggle = true;
                    }
                    if(femaleCow != null){
                      femaleCowToggle = false;
                    }
                  } else if(cowAmount >= 40 && cowAmount < 60){
                  maleCow = 0;
                  femaleCow = 1;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 60 && cowAmount < 70){
                  maleCow = 2;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 70 && cowAmount < 80){
                  maleCow = 1;
                  femaleCow = 1;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 80 && cowAmount < 90){
                  maleCow = 0;
                  femaleCow = 2;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 90 && cowAmount < 100){
                  maleCow = 3;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 100 && cowAmount < 110){
                  maleCow = 2;
                  femaleCow = 1;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 110 && cowAmount < 120){
                  maleCow = 1;
                  femaleCow = 2;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 120 && cowAmount < 130){
                  maleCow = 4;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 130 && cowAmount < 170){
                  maleCow = 5;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 170 && cowAmount < 180){
                  maleCow = 0;
                  femaleCow = 4;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 180 && cowAmount < 220){
                  maleCow = 6;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 220 && cowAmount < 230){
                  maleCow = 0;
                  femaleCow = 5;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 230 && cowAmount < 270){
                  maleCow = 7;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 270 && cowAmount < 280){
                  maleCow = 0;
                  femaleCow = 6;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 280 && cowAmount < 320){
                  maleCow = 8;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 320 && cowAmount < 330){
                  maleCow = 0;
                  femaleCow = 7;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 330 && cowAmount < 370){
                  maleCow = 9;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 370 && cowAmount < 380){
                  maleCow = 0;
                  femaleCow = 8;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 380 && cowAmount < 420){
                  maleCow = 10;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 420 && cowAmount < 430){
                  maleCow = 0;
                  femaleCow = 9;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 430 && cowAmount < 470){
                  maleCow = 11;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 470 && cowAmount < 480){
                  maleCow = 0;
                  femaleCow = 10;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  } else if(cowAmount >= 480 && cowAmount < 520){
                  maleCow = 12;
                  femaleCow = 0;
                  if(maleCow != null){
                    maleCowToggle = true;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = false;
                  }
                  } else if(cowAmount >= 520 && cowAmount < 530){
                  maleCow = 0;
                  femaleCow = 11;
                  if(maleCow != null){
                    maleCowToggle = false;
                  }
                  if(femaleCow != null){
                    femaleCowToggle = true;
                  }
                  }
                });
              },
            ),
            SizedBox(height: 20,),
            Text('Male cow $maleCow'),
            SizedBox(height: 10,),
            Text('Female cow $femaleCow'),
            SizedBox(height: 20,),
            TextFormField(
              enabled: maleCowToggle,
              controller: maleCowController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: 'ราคาวัวหรือควายตัวผู้'
              ),
            ),
            SizedBox(height: 20,),
            TextFormField(
              enabled: femaleCowToggle,
              controller: femaleCowController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: 'ราคาวัวหรือควายตัวเมีย'
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: RaisedButton(
                onPressed: (){
                  int maleCowPrice = int.parse(maleCowController.text);
                  int femaleCowPrice = int.parse(femaleCowController.text);
                  totAmount = maleCow*maleCowPrice;
                  totAmount = totAmount+femaleCowPrice;
                  print(totAmount);
                },
                color: Colors.cyan,
                child: Text('คำณวณ', style: TextStyle(color: Colors.white),),
              ),
            ),
          ],
        ),
      ),
    );
  } //cannot remove non related textfield

  /*void cowAnalyzer(){
    setState(() {
      int cowAmount = int.parse(cowAmountController.text);
      int maleCowAmount = int.parse(maleCowController.text) ?? 0;
      int femaleCowAmount = int.parse(femaleCowController.text) ?? 0;
      if(cowAmount >= 30 && cowAmount< 40){
        maleCow = 1;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 40 && cowAmount < 60){
        maleCow = 0;
        femaleCow = 1;
      } else if(cowAmount >= 60 && cowAmount < 70){
        maleCow = 2;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 70 && cowAmount < 80){
        maleCow = 1;
        femaleCow = 1;
      } else if(cowAmount >= 80 && cowAmount < 90){
        maleCow = 0;
        femaleCow = 2;
      } else if(cowAmount >= 90 && cowAmount < 100){
        maleCow = 3;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 100 && cowAmount < 110){
        maleCow = 2;
        femaleCow = 1;
      } else if(cowAmount >= 110 && cowAmount < 120){
        maleCow = 1;
        femaleCow = 2;
      } else if(cowAmount >= 120 && cowAmount < 130){
        maleCow = 4;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 130 && cowAmount < 170){
        maleCow = 5;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 170 && cowAmount < 180){
        maleCow = 0;
        femaleCow = 4;
      } else if(cowAmount >= 180 && cowAmount < 220){
        maleCow = 6;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 220 && cowAmount < 230){
        maleCow = 0;
        femaleCow = 5;
      } else if(cowAmount >= 230 && cowAmount < 270){
        maleCow = 7;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 270 && cowAmount < 280){
        maleCow = 0;
        femaleCow = 6;
      } else if(cowAmount >= 280 && cowAmount < 320){
        maleCow = 8;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 320 && cowAmount < 330){
        maleCow = 0;
        femaleCow = 7;
      } else if(cowAmount >= 330 && cowAmount < 370){
        maleCow = 9;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 370 && cowAmount < 380){
        maleCow = 0;
        femaleCow = 8;
      } else if(cowAmount >= 380 && cowAmount < 420){
        maleCow = 10;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 420 && cowAmount < 430){
        maleCow = 0;
        femaleCow = 9;
      } else if(cowAmount >= 430 && cowAmount < 470){
        maleCow = 11;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 470 && cowAmount < 480){
        maleCow = 0;
        femaleCow = 10;
      } else if(cowAmount >= 480 && cowAmount < 520){
        maleCow = 12;
        femaleCow = 0;
        totAmount = maleCow*maleCowAmount;
      } else if(cowAmount >= 520 && cowAmount < 530){
        maleCow = 0;
        femaleCow = 11;
      }
    });
  }*/

  int femaleGoat;
  int totAmountGoat;
  bool goatToggle;

  Widget goatCalculator (){
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
            TextField(
              keyboardType: TextInputType.number,
              controller: goatAmountController,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: 'จำนวนวัวหรือควายที่เลี้ยงไว้'
              ),
              onChanged: (val){
                setState(() {
                  int goatAmount = int.parse(goatAmountController.text);
                  int goatPrice = int.parse(goatPriceController.text);
                  if(goatAmount > 40 && goatAmount < 121){
                    femaleGoat = 1;
                  } else if(goatAmount >= 121 && goatAmount < 201){
                    femaleGoat = 2;
                  } else if(goatAmount >= 201 && goatAmount < 400){
                    femaleGoat = 3;
                  } else if(goatAmount >= 400 && goatAmount < 500){
                    femaleGoat = 4;
                  } else if(goatAmount >= 500 && goatAmount < 600){
                    femaleGoat = 5;
                  } else if(goatAmount >= 600 && goatAmount < 700){
                    femaleGoat = 6;
                  } else if(goatAmount >= 700 && goatAmount < 800){
                    femaleGoat = 7;
                  } else if(goatAmount >= 800 && goatAmount < 900){
                    femaleGoat = 8;
                  } else if(goatAmount >= 900 && goatAmount < 1000){
                    femaleGoat = 9;
                  } else if(goatAmount >= 1000 && goatAmount < 1100){
                    femaleGoat = 10;
                  }
                });
              },
            ),
            SizedBox(height: 20,),
            Text('Femalge Goat $femaleGoat'),
            SizedBox(height: 20,),
            TextFormField(
              enabled: goatToggle,
              controller: goatPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: 'ราคาแพะหรือคแกะัวเมียที่เลี้ยงไว้'
              ),
            ),
            SizedBox(height: 20,),
            Text('Zakat amount $totAmountGoat'),
            SizedBox(height: 20,),
            Center(
              child: RaisedButton(
                onPressed: (){
                  setState(() {
                    int goatPrice = int.parse(goatPriceController.text);
                    totAmountGoat = goatPrice*femaleGoat;
                    print(totAmountGoat);
                  });
                },
                color: Colors.cyan,
                child: Text('คำณวณ', style: TextStyle(color: Colors.white),),
              ),
            ),
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
          backgroundColor: Colors.indigo,
          title: Text('Livestock'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('Cow'),
              ),
              Tab(
                child: Text('Goat'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            cowCalculator(),
            goatCalculator(),
          ],
        ),
      ),
    );
  }
}
