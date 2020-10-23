import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/income_expense/expense_tile.dart';
import 'package:flutteriezakat/income_expense/expense.dart';

class ExpenseList extends StatefulWidget {
  @override
  _ExpenseListState createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  @override
  Widget build(BuildContext context) {
    final expense = Provider.of<List<Expense>>(context) ?? [];

    return ListView.builder(
      itemCount: expense.length,
      itemBuilder: (context, index){
          return ExpenseTile(expenseResult: expense[index]);
        },
    );
  }
}

