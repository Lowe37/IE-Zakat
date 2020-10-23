import 'package:flutter/material.dart';
import 'package:flutteriezakat/business_tracker/business_expense.dart';
import 'package:flutteriezakat/income_expense/addExpense.dart';
import 'package:flutteriezakat/income_expense/expense_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutteriezakat/income_expense/expense_type.dart';
import 'package:flutteriezakat/income_expense/income_type.dart';

class businessCategory extends StatefulWidget {
  @override
  _businessCategoryState createState() => _businessCategoryState();
}

class _businessCategoryState extends State<businessCategory> {

  @override
  Widget build(BuildContext context) {
    String Name;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: selectCategory(),
          iconTheme: IconThemeData(
              color: Colors.grey
          ),
        ),
        body: businessExpenseMenu()
    );
  }
}

class selectCategory extends StatefulWidget {
  @override
  _selectCategoryState createState() => _selectCategoryState();
}

class _selectCategoryState extends State<selectCategory> {

  String dropdownValue = 'Expense ';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.green, fontSize: 20, fontWeight: FontWeight.bold),
      underline: Container(
        height: 0,
        color: Colors.white,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;

          switch (dropdownValue){
            case "Expense ":{
              print(dropdownValue);
            }
            break;

            case "Income":{

              print(dropdownValue);
            }
          }

          //print(dropdownValue);
        });
      },
      items: <String>['Expense ', 'Income']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}
