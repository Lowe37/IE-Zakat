import 'package:flutter/material.dart';
import 'package:flutteriezakat/income_expense/addExpense.dart';
import 'package:flutteriezakat/income_expense/expense_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutteriezakat/income_expense/expense_type.dart';
import 'package:flutteriezakat/income_expense/income_type.dart';

class dropDownMenu extends StatefulWidget {
  @override
  _dropDownMenuState createState() => _dropDownMenuState();
}

class _dropDownMenuState extends State<dropDownMenu> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Select category'),
          backgroundColor: Colors.indigo,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(
                child: Text('Expense'),
              ),
              Tab(
                child: Text('Income'),
              ),
            ],
          ),
          //title: selectCategory(),
          iconTheme: IconThemeData(
            color: Colors.grey
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            expenseMenu(),
            incomeMenu(),
          ],
        ),
      ),
    );
  }
}

/*class selectCategory extends StatefulWidget {
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
              /*setState(() {
                Scaffold(
                  body: incomeMenu(),
                );
              });*/
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return incomeMenu();
              }));
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
}*/
