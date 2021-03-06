import 'package:flutter/material.dart';
import 'package:flutteriezakat/income_expense/addExpense.dart';
import 'package:flutteriezakat/income_expense/balance.dart';
import 'package:flutteriezakat/income_expense/expense_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutteriezakat/income_expense/expense_type.dart';
import 'package:flutteriezakat/income_expense/income_type.dart';
import 'package:intl/intl.dart';

class incomeMenu extends StatefulWidget {
  @override
  _incomeMenuState createState() => _incomeMenuState();
}

class _incomeMenuState extends State<incomeMenu> {

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
              child: _buildMenuItem('TEst', Icons.fastfood)
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
  }

  Widget expense(BuildContext context) {
    String Name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
  }

  Widget income(BuildContext context) {
    String Name;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
  }

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

  void addIncome() async {
    DocumentReference documentReference = await Firestore.instance.collection('income').document();
    Firestore.instance.collection('income').add({
      'amount': totNum,
      'note' : noteText,
      'type' : nameText,
      'date' : _date,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('income').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  result (String calText) {
    if (calText == 'Undo') {
      _totNum = '0';
    } else if(calText == '${(new DateFormat("dd/MM").format(_date))}') {
      _selectDate(context);
    } else if(calText == 'Add'){
      noteText = noteController.text;
      addIncome();
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
        /*setState(() {
          switch(calText){
            case 'Undo': {
              totNum = '0';
              operand = '';
              noteController.clear();
            } break;
          }
        });*/
      },
    ));
  }


  ///////////////////POP UP MENU////////////////
  Widget _buildMenuItem(String Name, iconData) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          selectMenuOption(Name);
          //expenseInputDialog(context);
          void _buttomDialogInput(context){
            showModalBottomSheet(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)
                ),
                context: context,
                builder: (builder){
                  return StatefulBuilder(
                      builder: (BuildContext context, myState /*You can rename this!*/){
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
                                      SizedBox(height: 15,),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text('Note'),
                                      ),
                                      TextField(
                                        controller: noteController,
                                        decoration: InputDecoration(
                                          //border: InputBorder.none,
                                            hintText: 'Enter your note'
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
            color: selected == Name ? Colors.green : Colors.transparent,
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

  String dropdownValue = 'Income';
  bool expenseSelected;
  bool incomeSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      style: TextStyle(color: Colors.indigo, fontSize: 20, fontWeight: FontWeight.bold),
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
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return expenseMenu();
              }));
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
