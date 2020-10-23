import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class income extends StatefulWidget {
  income({Key key}) : super(key: key);

  @override
  _incomeState createState() => _incomeState();
}

class _incomeState extends State<income> {

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 30,),
            Text('Business Name', style: TextStyle(fontWeight: FontWeight.w400),),
            SizedBox(height: 10,),
            TextField(
              decoration: InputDecoration(
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10),
                ),
                hintText: 'Enter your business name'
              ),
            ),

            SizedBox(height: 30,),
            Text('Business Type', style: TextStyle(fontWeight: FontWeight.w400),),
            DropdownButton<String>(items: _businessType.map((String dropDownItem){
              return DropdownMenuItem<String>(
                value: dropDownItem,
                child: Text(dropDownItem),
              );
            }).toList(),
                onChanged: (String valueSelected){
              setState(() {
                this._businessDefault = valueSelected;
              });
                }
            ),

            SizedBox(height: 30,),
            Text('Haul End Date', style: TextStyle(fontWeight: FontWeight.w400),),
            Row(
              children: <Widget>[
                Text('${(new DateFormat("dd-MM-yyyy").format(_date))}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),),
                IconButton(onPressed: () {_selectDate(context);}, icon: Icon(Icons.calendar_today))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
