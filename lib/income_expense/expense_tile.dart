import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/income_expense/addExpense.dart';
import 'package:flutteriezakat/income_expense/expense.dart';
import 'package:flutteriezakat/income_expense/expense_chart.dart';
import 'package:flutteriezakat/income_expense/income_chart.dart';


class ExpenseTile extends StatelessWidget {

  final Expense expenseResult;
  ExpenseTile({this.expenseResult});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30),
      child: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              ////////////////////////////expenses
              SizedBox(height: 50,),
              Align(
                alignment: Alignment.topCenter,
                child: Text("Expenses", style: TextStyle(
                    fontWeight: FontWeight.w200, fontSize: 20),),
              ),
              SizedBox(height: 10,),
              /*Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return addExpenseItem();
                    }));
                  },
                  child: Text(expenseResult.totalExpense.toString(), style: TextStyle(
                      fontWeight: FontWeight.w100, fontSize: 50),),
                ),
              ),*/
              SizedBox(height: 50 ,),

              //////////////////////////////income
              Align(
                alignment: Alignment.topCenter,
                child: Text("Income", style: TextStyle(
                    fontWeight: FontWeight.w200, fontSize: 20),),
              ),
              SizedBox(height: 10,),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return incomeChart();
                    }));
                  },
                  child: Text('0.00', style: TextStyle(
                      fontWeight: FontWeight.w100, fontSize: 50),),
                ),
              ),
              SizedBox(height: 50 ,),
              //balance
              Align(
                alignment: Alignment.topCenter,
                child: Text("Balance", style: TextStyle(
                    fontWeight: FontWeight.w200, fontSize: 20),),
              ),
              SizedBox(height: 10,),
              Center(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //return LoginPage();
                    }));
                  },
                  child: Text("0.00", style: TextStyle(
                      fontWeight: FontWeight.w100, fontSize: 50),),
                ),
              ),
              SizedBox(height: 60,),
              Align(
                alignment: Alignment.topCenter,
                child: Text("Note: Tap '+' to add records", style: TextStyle(
                    fontWeight: FontWeight.w100, fontSize: 15),),
              ),
            ]),
      ),
    );
  }
}
