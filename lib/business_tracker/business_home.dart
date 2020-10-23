import 'package:flutter/material.dart';
import 'package:flutteriezakat/business_tracker/business_category.dart';
import 'package:flutteriezakat/business_tracker/business_list.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:flutteriezakat/income_expense/addExpense.dart';
import 'package:flutteriezakat/income_expense/addIncome.dart';
import 'package:flutteriezakat/income_expense/income_chart.dart';
import 'package:flutteriezakat/income_expense/expense_chart.dart';
import 'package:flutteriezakat/income_expense/select_category.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/sidebar/sidebar_layout.dart';
import 'package:flutteriezakat/block/navigation_bloc.dart';
import 'package:flutteriezakat/database.dart';

import 'package:flutteriezakat/income_expense/expense_list.dart';
import 'package:flutteriezakat/income_expense/expense.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:provider/provider.dart';
//import 'package:flutteriezakat/income_expense/expense_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';


class balanceHome extends StatelessWidget with NavigationStates {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //home: balance(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class balanceBusiness extends StatefulWidget {

  /*final Widget body;
  balance({this.body});*/
  /*final FirebaseUser user;
  balance(this.user, {Key key}) : super(key: key);*/

  @override
  _balanceBusinessState createState() => _balanceBusinessState();
}

class _balanceBusinessState extends State<balanceBusiness> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  double getRadiansFromDegree(double degree) {
    double unitRadian = 57.295779513;
    return degree / unitRadian;
  }

  void signOut(BuildContext context){
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPageTest()),
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {

    //SideBarLayout();

    Size size = MediaQuery
        .of(context)
        .size;
    return StreamProvider<List<Expense>>.value(
      value: DBservice().expense,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Business Tracker'),
        ),
        /*drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                    color:  Colors.green
                ),
                child: Text('Balance Tracker', style: TextStyle(color: Colors.white, fontSize: 20),),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('Zakat Calculation'),
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => MyHomePage()
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.attach_money),
                title: Text('Balance Tracker'),
                selected: true,
                onTap: (){
                  Navigator.push(context, new MaterialPageRoute(
                      builder: (context) => balance()
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.question_answer),
                title: Text('FAQ'),
              ),
              SizedBox(height: 240,),
              ListTile(
                leading: Icon(Icons.clear),
                title: Text('Sign out'),
                onTap: (){
                  signOut(context);
                },
              ),
            ],
          ),
        ),*/
        drawer: CustomDrawer(),
        /*body: ExpenseList(),*/
        body: Padding(
          padding: EdgeInsets.fromLTRB(0,30,0,0),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  ////////////////////////////expenses
                  SizedBox(height: 5,),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 10,),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text("Expenses", style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 18),),
                          ),
                          SizedBox(height: 10,),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return addExpenseItem();
                                }));
                              },
                              child: Text('0.00', style: TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 40),),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 30,),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text("Income", style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 18),),
                          ),
                          SizedBox(height: 10,),
                          Center(
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) {
                                  return addIncomeItem();
                                }));
                              },
                              child: Text('0.00', style: TextStyle(
                                  fontWeight: FontWeight.w100, fontSize: 40),),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 30,),
                      Column(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topCenter,
                            child: Text("Balance", style: TextStyle(
                                fontWeight: FontWeight.w200, fontSize: 18),),
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
                                  fontWeight: FontWeight.w100, fontSize: 40),),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Divider(
                    indent: 60,
                    endIndent: 60,
                  ),
                  Center(child: Text('Your list', style: TextStyle(fontWeight: FontWeight.w200),)),
                  SizedBox(
                      width: 500,
                      height: 800,
                      child: businessList()),

                  /*Align(
                    alignment: Alignment.topCenter,
                    child: Text("Note: Tap on the number to add records", style: TextStyle(
                        fontWeight: FontWeight.w100, fontSize: 15),),
                  ),*/
                ]
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return businessCategory();
            }));
          },
          backgroundColor: Colors.green,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}