import 'package:flutter/material.dart';
import 'package:flutteriezakat/income_expense/addExpense.dart';
import 'package:flutteriezakat/income_expense/balance.dart';
import 'package:flutteriezakat/income_expense/expense_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutteriezakat/income_expense/income_type.dart';
import 'package:intl/intl.dart';

class expenseMenu extends StatefulWidget {
  @override
  _expenseMenuState createState() => _expenseMenuState();
}

class _expenseMenuState extends State<expenseMenu> {

  String expenseType = 'Food';
  var selected = 'Options';
  String totNum = '0';
  String _totNum = '0';
  String operand ='';
  double num1 = 0.0;
  double num2 = 0.0;

  final noteController = new TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String Name;
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 4,
        children: <Widget>[
          FlatButton(
              onPressed: (){},
              child: _buildMenuItem('Food', Icons.fastfood)
          ),
          FlatButton(
            onPressed: (){},
            child: _buildMenuItem('Electric', Icons.offline_bolt),
          ),
        ],
      ),
    );
  }

  /*Widget expense(BuildContext context) {
    String Name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: selectCategory(),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: <Widget>[
          FlatButton(
              onPressed: (){},
              child: _buildMenuItem('Food', Icons.fastfood)
            /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.fastfood),
                SizedBox(height: 10,),
                Text('Food'),
              ],
            ),*/
          ),
          FlatButton(
            onPressed: (){},
            child: _buildMenuItem('Electric', Icons.offline_bolt),
          ),
        ],
      ),
    );
  }*/

  /*Widget income(BuildContext context) {
    String Name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: selectCategory(),
      ),
      body: GridView.count(
        crossAxisCount: 4,
        children: <Widget>[
          FlatButton(
              onPressed: (){},
              child: _buildMenuItem('Test income', Icons.fastfood)
            /*Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.fastfood),
                SizedBox(height: 10,),
                Text('Food'),
              ],
            ),*/
          ),
          FlatButton(
            onPressed: (){},
            child: _buildMenuItem('Electric', Icons.offline_bolt),
          ),
        ],
      ),
    );
  }*/

  selectExpenseType(String Name) {
    setState(() {
      expenseType = Name;
    });
  }

  String caltext = '0';
  String noteText;
  String nameText;
  DateTime selectDate;
  String dateText;

  DateTime _date = new DateTime.now();

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

  void addExpense() async {
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

  result (String calText) {

    /*var date = new DateTime.now();
    var formatter = new DateFormat('dd/MM');
    String formattedDate = formatter.format(date);*/

    if (calText == 'Undo') {
      _totNum = '0';
    } else if(calText == '${(new DateFormat("dd/MM").format(_date))}'){
      _selectDate(context);
     /* showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(), //user cannot add Zakat records for the future
      );*/
    } else if(calText == 'Add'){
      Future.delayed(const Duration(seconds: 1), (){
        setState(() {
          Navigator.pop(context);
          _totNum = '0';
        });
      });

      final snackbar = SnackBar(
        content: Text('Record added'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View records',
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return balance();
            }));
          },
        ),
      );
      Scaffold.of(context).showSnackBar(snackbar);
      noteText = noteController.text;
      addExpense();
    }else if(calText == '.'){
      if(_totNum.contains('.')){
        return;
      } else {
        _totNum = _totNum + calText;
      }


    }else {
      _totNum = _totNum + calText;
    }

    //print(_totNum);

    setState(() {
      totNum = double.parse(_totNum).toStringAsFixed(2);
      print(totNum);
    });
  }

  Widget calculatorButton(String calText){
    return new Expanded(child: OutlineButton(
      padding: EdgeInsets.all(15),
      child: Text(calText),
      onPressed: (){
        result(calText);
        setState(() {

        });
      },
    ));
  }


  ///////////////////POP UP MENU////////////////
  Widget _buildMenuItem(String Name, iconData) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          selectMenuOption(Name);
          /*var date = new DateTime.now();
          var formatter = new DateFormat('dd/MM');
          String formattedDate = formatter.format(date);
          print(formattedDate); // 2016-01-25*/
          //expenseInputDialog(context);
          void _buttomDialogInput(context){
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
                context: context,
                builder: (builder){
                  return StatefulBuilder(
                      builder: (BuildContext context, myState){
                        return new Container(
                          height: 390.0,
                          color: Colors.transparent, //could change this to Color(0xFF737373),
                          //so you don't have to change MaterialApp canvasColor
                          child: new Container(

                              decoration: new BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: new BorderRadius.only(
                                      topLeft: const Radius.circular(10.0),
                                      topRight: const Radius.circular(10.0))),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: new Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text('$Name', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.indigo),),
                                          Spacer(),
                                          Text(totNum, style: TextStyle(fontWeight: FontWeight.w200, fontSize: 25),),
                                          SizedBox(width: 20,),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      TextField(
                                        controller: noteController,
                                        decoration: InputDecoration(
                                          //border: InputBorder.none,
                                            hintText: 'Note'
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      Row(
                                        children: <Widget>[
                                          calculatorButton('7'),
                                          calculatorButton('8'),
                                          calculatorButton('9'),
                                          SizedBox(width: 20,),
                                          calculatorButton('${(new DateFormat("dd/MM").format(_date))}'),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: <Widget>[
                                          calculatorButton('4'),
                                          calculatorButton('5'),
                                          calculatorButton('6'),
                                          SizedBox(width: 20,),
                                          calculatorButton('Add'),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: <Widget>[
                                          calculatorButton('1'),
                                          calculatorButton('2'),
                                          calculatorButton('3'),
                                          SizedBox(width: 20,),
                                          calculatorButton('Del'),
                                        ],
                                      ),
                                      SizedBox(height: 5,),
                                      Row(
                                        children: <Widget>[
                                          calculatorButton(''),
                                          calculatorButton('0'),
                                          calculatorButton('.'),
                                          SizedBox(width: 20,),
                                          calculatorButton('Clear'),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                        );
                      }
                  );
                }
            );
          }
          print('You selected $Name');
          switch(Name){
            case "Food":{
              nameText = Name.toString();
              _buttomDialogInput(context);
            }
            break;

            case "Electric":{
              nameText = Name.toString();
              _buttomDialogInput(context);
            }
            break;

            case "Internet":{
              _buttomDialogInput(context);
            }
            break;

            case "Entertainment":{
              _buttomDialogInput(context);
            }
            break;

          }
        },
        child: AnimatedContainer(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 300),
            height: selected == Name ? 75.0 : 75.0,
            width: selected == Name ? 100.0 : 75.0,
            color: selected == Name ? Colors.indigo : Colors.transparent,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                iconData,
                color: selected == Name ? Colors.white : Colors.black,
                size: 30.0,
              ),
              SizedBox(height: 12.0),
              Text(Name,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: selected == Name ? Colors.white : Colors.black,
                      fontSize: 15.0))
            ])));

  }

  Widget _buildExpenseType(String Name, iconData){
    return InkWell(
      splashColor: Colors.transparent,
      onTap: (){
        selectExpenseType(Name);
        void _modalBottomSheetMenu(context){
          showModalBottomSheet(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0)
              ),
              context: context,
              builder: (builder){
                return new Container(
                  height: 200.0,
                  color: Colors.transparent, //could change this to Color(0xFF737373),
                  //so you don't have to change MaterialApp canvasColor
                  child: new Container(
                      decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(10.0),
                              topRight: const Radius.circular(10.0))),
                      child: new Column(
                        children: <Widget>[
                          SizedBox(height: 20,),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 20,),
                              Text('Expense'),
                              Text('$Name'),
                            ],
                          )
                        ],
                      )),
                );
              }
          );
        }
      },
    );
  }

  selectMenuOption(String Name) {
    setState(() {
      selected = Name;
    });
  }

}

class selectCategory extends StatefulWidget {
  @override
  _selectCategoryState createState() => _selectCategoryState();
}

class _selectCategoryState extends State<selectCategory> {

  String dropdownValue = 'Expense ';
  bool expenseSelected;
  bool incomeSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
}
