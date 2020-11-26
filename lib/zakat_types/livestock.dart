import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

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
    inputData();
    //selectedRadioTile = 0;
    totAmount = 0;
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

  String userID;

  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    userID = uid;
    print(userID);
    // here you write the codes to input the data into firestore
  }

  void addBusinessRecordCow () async {
    Firestore.instance.collection('zakat').add({
      'category': 'Livestock: Cow',
      'zakatAmount' : totAmount,
      'wajibZakat' : 'true',
      'date' : _date,
      'userID' : userID,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('zakat').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  void addBusinessRecordGoat () async {
    Firestore.instance.collection('zakat').add({
      'category': 'Livestock: Goat',
      'zakatAmount' : totAmountGoat,
      'wajibZakat' : 'true',
      'date' : _date,
      'userID' : userID,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('zakat').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  int maleCow;
  int femaleCow;
  int totAmount;
  bool maleCowToggle;
  bool femaleCowToggle;
  bool _validateCowAmount = false;
  bool _validateMaleCowPrice = false;
  bool _validateFemaleCowPrice = false;

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  Future<void> _confirmDialogCow() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: AlertDialog(
            title: Text('Confirm calculation?'),
            content: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Zakat amount: "+totAmount.toString().replaceAllMapped(reg, mathFunc)),
                  ],
                ),
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
              RaisedButton(
                onPressed: () {
                  inputData();
                  addBusinessRecordCow();
                  Navigator.pop(context);
                  Flushbar(
                    icon: Icon(MdiIcons.checkCircle, color: Colors.green,),
                    margin: EdgeInsets.all(8),
                    borderRadius: 8,
                    message:  "Your record has been added.",
                    duration:  Duration(seconds: 3),
                  )..show(context);
                  /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return MyHomePage();
                  }));*/
                  cowAmountController.clear();
                  maleCowController.clear();
                  femaleCowController.clear();
                  setState(() {
                    maleCow = 0;
                    femaleCow = 0;
                    totAmount = 0;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)
                ),
                child: Text('Confirm',style: TextStyle(fontWeight: FontWeight.bold),),
                color: Colors.teal,
              ),
            ],
          ),
        );
      },
    );
  }

  void cowCalculator (){
      int maleCowPrice = int.parse(maleCowController.text);
      int femaleCowPrice = int.parse(femaleCowController.text);
      int cowAmount = int.parse(cowAmountController.text);
      if(cowAmount >= 30 && cowAmount< 40){
        maleCow = 1;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 40 && cowAmount < 60){
        maleCow = 0;
        femaleCow = 1;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 60 && cowAmount < 70){
        maleCow = 2;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
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
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 90 && cowAmount < 100){
        maleCow = 3;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
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
        totAmount = maleCow*maleCowPrice;
        totAmount = totAmount+femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 120 && cowAmount < 130){
        maleCow = 4;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 130 && cowAmount < 170){
        maleCow = 5;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 170 && cowAmount < 180){
        maleCow = 0;
        femaleCow = 4;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 180 && cowAmount < 220){
        maleCow = 6;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 220 && cowAmount < 230){
        maleCow = 0;
        femaleCow = 5;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 230 && cowAmount < 270){
        maleCow = 7;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 270 && cowAmount < 280){
        maleCow = 0;
        femaleCow = 6;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 280 && cowAmount < 320){
        maleCow = 8;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 320 && cowAmount < 330){
        maleCow = 0;
        femaleCow = 7;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 330 && cowAmount < 370){
        maleCow = 9;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 370 && cowAmount < 380){
        maleCow = 0;
        femaleCow = 8;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 380 && cowAmount < 420){
        maleCow = 10;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 420 && cowAmount < 430){
        maleCow = 0;
        femaleCow = 9;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 430 && cowAmount < 470){
        maleCow = 11;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 470 && cowAmount < 480){
        maleCow = 0;
        femaleCow = 10;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      } else if(cowAmount >= 480 && cowAmount < 520){
        maleCow = 12;
        femaleCow = 0;
        totAmount = maleCow*maleCowPrice;
        if(maleCow != null){
          maleCowToggle = true;
        }
        if(femaleCow != null){
          femaleCowToggle = false;
        }
      } else if(cowAmount >= 520 && cowAmount < 530){
        maleCow = 0;
        femaleCow = 11;
        totAmount = femaleCow*femaleCowPrice;
        if(maleCow != null){
          maleCowToggle = false;
        }
        if(femaleCow != null){
          femaleCowToggle = true;
        }
      }
  }

  Widget cowTab (){
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
            Text('Amount of cows or buffalos'),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: cowAmountController,
              decoration: InputDecoration(
                  errorText: _validateCowAmount? 'Enter cow amount': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Price of male cow or buffalo'),
            SizedBox(height: 10,),
            TextFormField(
              //enabled: maleCowToggle,
              controller: maleCowController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  errorText: _validateMaleCowPrice? 'Enter male cow price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Price of female cow or buffalo'),
            SizedBox(height: 10,),
            TextFormField(
              //enabled: femaleCowToggle,
              controller: femaleCowController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  errorText: _validateFemaleCowPrice? 'Enter female cow price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),

            Divider(
              height: 20,
              thickness: 2,
              color: Colors.cyan,
            ),

            SizedBox(height: 10,),
            Text('Male cow for Zakat', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(maleCow.toString(), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Female cow for Zakat', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(femaleCow.toString(), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(totAmount.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(
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
                    setState(() {
                      cowAmountController.clear();
                      maleCowController.clear();
                      femaleCowController.clear();
                      totAmount = 0;
                      maleCow = 0;
                      femaleCow = 0;
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
                      //cowCalculator();
                      cowAmountController.text.isEmpty ? _validateCowAmount = true : _validateCowAmount = false;
                      maleCowController.text.isEmpty ? _validateMaleCowPrice = true : _validateMaleCowPrice = false;
                      femaleCowController.text.isEmpty ? _validateFemaleCowPrice = true : _validateFemaleCowPrice = false;
                    });
                    cowCalculator();
                  },
                  color: Colors.green,
                  child: Text('Calculate now', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 10,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: () {
                    setState(() {
                      cowAmountController.text.isEmpty ? _validateCowAmount = true : _validateCowAmount = false;
                      maleCowController.text.isEmpty ? _validateMaleCowPrice = true : _validateMaleCowPrice = false;
                      femaleCowController.text.isEmpty ? _validateFemaleCowPrice = true : _validateFemaleCowPrice = false;
                      if(_validateCowAmount == false && _validateMaleCowPrice == false && _validateFemaleCowPrice == false) {
                        _confirmDialogCow();
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
  } //cannot remove non related textfield

  int femaleGoat;
  int totAmountGoat;
  bool goatToggle;
  bool _validateGoatAmount = false;
  bool _validateGoatPrice = false;

  void goatCalculator (){
      int goatAmount = int.parse(goatAmountController.text);
      int goatPrice = int.parse(goatPriceController.text);
      if(goatAmount > 40 && goatAmount < 121){
        femaleGoat = 1;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 121 && goatAmount < 201){
        femaleGoat = 2;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 201 && goatAmount < 400){
        femaleGoat = 3;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 400 && goatAmount < 500){
        femaleGoat = 4;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 500 && goatAmount < 600){
        femaleGoat = 5;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 600 && goatAmount < 700){
        femaleGoat = 6;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 700 && goatAmount < 800){
        femaleGoat = 7;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 800 && goatAmount < 900){
        femaleGoat = 8;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 900 && goatAmount < 1000){
        femaleGoat = 9;
        totAmountGoat = femaleGoat*goatPrice;
      } else if(goatAmount >= 1000 && goatAmount < 1100){
        femaleGoat = 10;
        totAmountGoat = femaleGoat*goatPrice;
      }
  }

  Future<void> _confirmDialogGoat() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: AlertDialog(
            title: Text('Confirm calculation?'),
            content: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Zakat amount: "+totAmountGoat.toString().replaceAllMapped(reg, mathFunc)),
                  ],
                ),
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
              RaisedButton(
                onPressed: () {
                  inputData();
                  addBusinessRecordGoat();
                  Navigator.pop(context);
                  Flushbar(
                    icon: Icon(MdiIcons.checkCircle, color: Colors.green,),
                    margin: EdgeInsets.all(8),
                    borderRadius: 8,
                    message:  "Your record has been added.",
                    duration:  Duration(seconds: 3),
                  )..show(context);
                  /*Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return MyHomePage();
                  }));*/
                  goatAmountController.clear();
                  goatPriceController.clear();
                  setState(() {
                    femaleGoat = 0;
                    totAmountGoat = 0;
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)
                ),
                child: Text('Confirm',style: TextStyle(fontWeight: FontWeight.bold),),
                color: Colors.teal,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget goatTab (){
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
            Text('Amount of goat or sheep'),
            SizedBox(height: 10,),
            TextField(
              keyboardType: TextInputType.number,
              controller: goatAmountController,
              decoration: InputDecoration(
                  errorText: _validateGoatAmount? 'Enter goat amount': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),
            Text('Price of female goat or sheep for Zakat'),
            SizedBox(height: 10,),
            TextFormField(
              //enabled: maleCowToggle,
              controller: goatPriceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  errorText: _validateGoatPrice? 'Enter price': null,
                  border: new OutlineInputBorder(
                    borderRadius: new BorderRadius.circular(10),
                  ),
                  hintText: '0'
              ),
            ),
            SizedBox(height: 20,),

            Divider(
              height: 20,
              thickness: 2,
              color: Colors.cyan,
            ),

            SizedBox(height: 10,),
            Text('Female goat or sheep', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(femaleGoat.toString(), style: TextStyle(
                fontWeight: FontWeight.w100, fontSize: 20),),
            SizedBox(height: 20,),
            Text('Zakat you have to pay', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            Text(totAmountGoat.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(
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
                    setState(() {
                      goatAmountController.clear();
                      goatPriceController.clear();
                      totAmountGoat = 0;
                      femaleGoat = 0;
                    });
                  },
                  color: Colors.red,
                  child: Text('Reset', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: () {
                    setState(() {
                      //goatCalculator();
                      goatAmountController.text.isEmpty ? _validateGoatAmount = true : _validateGoatAmount = false;
                      goatPriceController.text.isEmpty ? _validateGoatPrice = true : _validateGoatPrice = false;
                    });
                    goatCalculator();
                  },
                  color: Colors.green,
                  child: Text('Calculate now', style: TextStyle(color: Colors.white),),
                ),
                SizedBox(width: 20,),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  onPressed: () {
                    setState(() {
                      goatAmountController.text.isEmpty ? _validateGoatAmount = true : _validateGoatAmount = false;
                      goatPriceController.text.isEmpty ? _validateGoatPrice = true : _validateGoatPrice = false;
                      if(_validateGoatAmount == false && _validateGoatPrice == false){
                        _confirmDialogGoat();
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
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
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
            cowTab(),
            goatTab(),
          ],
        ),
      ),
    );
  }
}
