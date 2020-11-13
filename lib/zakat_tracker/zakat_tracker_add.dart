import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class zakatTrackerAdd extends StatefulWidget {
  @override
  _zakatTrackerAddState createState() => _zakatTrackerAddState();
}

class _zakatTrackerAddState extends State<zakatTrackerAdd> {

  DateTime _date = new DateTime.now();
  String totNum;
  String noteText;
  String nameText;

  Future <Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: _date, firstDate: new DateTime(2015), lastDate: _date);

    if(picked != null && picked != _date){
      print(new DateFormat("dd/MM").format(_date));
      print('${_date}');
      //dateText = _date;
      setState(() {
        _date = picked;
      });
    }
  }

  void addZakatTracker() async {
    DocumentReference documentReference = await Firestore.instance.collection('expenses').document();
    Firestore.instance.collection('expenses').add({
      'amount': totNum,
      'note' : noteText,
      'type' : nameText,
      'date' : _date,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('expenses').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text('Select menu'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            //padding: EdgeInsets.all(10),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('List name', style: TextStyle(fontWeight: FontWeight.w400),),
              SizedBox(height: 10,),
              TextField(
                //controller: smallBusinessNameController,
                decoration: InputDecoration(
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(10),
                    ),
                    hintText: 'Enter name'
                ),
              ),
              SizedBox(height: 20,),
              Text('Type', style: TextStyle(fontWeight: FontWeight.w400),),
              DropDown(
                items: ["Business", "Gold", "Income", "Shares", "Plantation", "Livestock"],
                hint: Text('Business'),
                isExpanded: true,
              ),
              /*Expanded(
                child: GridView.count(
                  crossAxisCount: 3,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      color: Colors.cyan,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.cashUsdOutline),
                          Text('Business')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      color: Colors.cyan,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.cashUsdOutline),
                          Text('Gold')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      color: Colors.cyan,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.cashUsdOutline),
                          Text('Income')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      color: Colors.cyan,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.cashUsdOutline),
                          Text('Shares')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      color: Colors.cyan,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.cashUsdOutline),
                          Text('Plantation')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.all(20),
                      color: Colors.cyan,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(MdiIcons.cashUsdOutline),
                          Text('Livestock')
                        ],
                      ),
                    ),
                  ],
                ),
              ),*/
            ],
          ),
        ),
      ),
    );
  }
}
