import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutteriezakat/income_expense/addIncome.dart';
import 'package:flutteriezakat/income_expense/expense_chart.dart';
import 'package:flutteriezakat/income_expense/income_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MaterialApp());
}

class gridViewItem extends StatelessWidget {

  final IconData _iconData;
  final bool _isSelected;

  gridViewItem(this._iconData, this._isSelected);

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        _iconData,
        color: Colors.white,
      ),
      shape: CircleBorder(),
      fillColor: _isSelected ? Colors.green : Colors.black,
      onPressed: null,
    );
  }
}

class addExpenseItem extends StatefulWidget {

  addExpenseItem ({Key key}) : super(key: key);

  @override
  _addExpenseItemState createState() => _addExpenseItemState();
}

class _addExpenseItemState extends State<addExpenseItem> {

  final CollectionReference expenseCollection = Firestore.instance.collection('expenses');

  Future addExpenseRecord (int amount, String note, int totalExpense, String type) async {
    return await expenseCollection.document().setData({
      'Amount' : amount,
      'Note' : note,
      'Total Expense': totalExpense,
      'Type': type,
    });
  }

  String id;
  int totalExpense;
  final db = Firestore.instance;

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

  ////variables
  String amountText;
  String noteText;
  String nameText;

  /////////controller for inputs
  //final typeController = new TextEditingController();
  final amountController = new TextEditingController();
  final noteController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    //typeController.dispose();
    amountController.dispose();
    noteController.dispose();
    super.dispose();
  }

  var selected = 'Options';

  final List<IconData> _icons = [
    Icons.offline_bolt,
    Icons.print,
    Icons.business,
    Icons.dashboard
  ];

  List<IconData> _selectedIcon = [];

  @override
  Widget build(BuildContext context) {

    /*Widget gridViewSelection = GridView.count(
      childAspectRatio: 2.0,
      crossAxisCount: 3,
      mainAxisSpacing: 20.0,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      children: _icons.map((iconData) {
        return GestureDetector(
          onTap: () {
            _selectedIcon.clear();

            setState(() {
              _selectedIcon.add(iconData);
            });
          },
          child: gridViewItem(iconData, _selectedIcon.contains(iconData)),
        );
      }).toList(),
    );*/
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: <Widget>[
          SizedBox(height: 25),
          Padding(
            padding: EdgeInsets.fromLTRB(70, 0, 70, 0),
          ),

          SizedBox(height: 30,),
          Center(
            child: Text('Select expense category', style: TextStyle(
              fontSize: 20,
            ),),
          ),
          SizedBox(height: 50,),
          Row(
            children: <Widget>[
              SizedBox(width: 30,),
              Text('Daily', style: TextStyle(),),
            ],
          ),
          Divider(
            height: 15,
            thickness: 0.5,
            color: Colors.green.withOpacity(1),
            indent: 30,
            endIndent: 32,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    onPressed: (){

                    },
                    child: _buildMenuItem('Electric', Icons.power)),
                FlatButton(
                    onPressed: (){

                    },
                    child: _buildMenuItem('Food', Icons.fastfood)),
                FlatButton(
                    onPressed: (){

                    },
                    child: _buildMenuItem('Internet', Icons.cloud)),
              ]),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  onPressed: () {

                  },
                  child: _buildMenuItem('Entertainment', Icons.ondemand_video)),
              FlatButton(
                  onPressed: () {

                  },
                  child: _buildMenuItem('Transport', Icons.directions_car)),
              FlatButton(
                  onPressed: (){

                  },
                  child: _buildMenuItem('Gift', Icons.card_giftcard)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  onPressed: () {

                  },
                  child: _buildMenuItem('Travel', Icons.landscape)),
              FlatButton(
                  onPressed: () {

                  },
                  child: _buildMenuItem('Test', Icons.attach_money)),
              FlatButton(
                  onPressed: (){

                  },
                  child: _buildMenuItem('Gift', Icons.card_giftcard)),
            ],
          ),

          SizedBox(height: 30,),
          Row(
            children: <Widget>[
              SizedBox(width: 30,),
              Text('Business', style: TextStyle(),),
            ],
          ),
          Divider(
            height: 15,
            thickness: 0.5,
            color: Colors.green.withOpacity(1),
            indent: 30,
            endIndent: 32,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              FlatButton(
                  onPressed: () {

                  },
                  child: _buildMenuItem('Shop', Icons.business_center)),
              FlatButton(
                  onPressed: () {

                  },
                  child: _buildMenuItem('Livestock', Icons.shopping_cart)),
              FlatButton(
                  onPressed: (){

                  },
                  child: _buildMenuItem('Plantation', Icons.dashboard)),
            ],
          ),
        ],
      ),
    );
  }

  void addExpense() async {
    DocumentReference documentReference = await Firestore.instance.collection('expenses').document();
    db.collection('expenses').add({
      'expenseID' : documentReference.documentID,
      'amount': amountText,
      'note' : noteText,
      'totalExpense' : 20,
      'type' : nameText,

    }).then((value){
      print(value.documentID);
    });
  }
  
  void readData() async {
    DocumentSnapshot snapshot = await db.collection('expenses').document(id).get();
    print(snapshot.data['expenses']);
  }

  Widget _buildMenuItem(String Name, iconData) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          selectMenuOption(Name);
          //expenseInputDialog(context);
          void _buttomDialogInput(context){
            showModalBottomSheet(context: context, builder: (BuildContext bc){
              return SingleChildScrollView(
                child: Container(
                    height: MediaQuery.of(context).size.height * .60,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              SizedBox(width: 20,),
                              Text('Category / หมวดหมู่', style: TextStyle(fontSize: 15),),
                              SizedBox(width: 20,),
                              Spacer(),
                              IconButton(
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 25,
                                ),
                                onPressed: (){
                                  Navigator.of(context).pop();
                                  amountController.clear();
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  SizedBox(width: 20,),
                                  Column(
                                    children: <Widget>[
                                      //SizedBox(height: 20,),
                                      Row(
                                        children: <Widget>[
                                          Text('${(new DateFormat("dd-MM-yyyy").format(_date))}', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200),),
                                          IconButton(onPressed: () {_selectDate(context);}, icon: Icon(Icons.calendar_today)),
                                        ],
                                      ),
                                      Text('$Name', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ],
                              ),
                              Spacer(),
                              Column(
                                children: <Widget>[
                                  SizedBox(height: 10,),
                                  Text('Amount / จำนวน', style: TextStyle(fontSize: 15),),
                                  Container(
                                      width: 110,
                                      child: TextField(
                                        controller: amountController,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: '0'
                                        ),
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 50,),
                          Row(
                            children: <Widget>[
                              SizedBox(width: 20,),
                              Text('Note / จดบันทึก', style: TextStyle(fontSize: 15),),
                            ],
                          ),
                          Container(
                            width: 357,
                            child: TextField(
                              controller: noteController,
                              decoration: InputDecoration(
                                  hintText: 'Optional / ให้เลือกได้'
                              ),
                            ),
                          ),
                          SizedBox(height: 50,),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: MaterialButton(
                              elevation: 5.0,
                              color: Colors.green,
                              child: Text('Save', style: TextStyle(color: Colors.white),),
                              onPressed: (){
                                double amount = double.parse(amountController.text);
                                amountText = amount.toString();
                                noteText = noteController.text;
                                nameText = Name.toString();
                                print(amountText);
                                print(noteText);
                                print(nameText);

                                addExpense();

                                Navigator.of(context).pop();
                                final snackbar = SnackBar(
                                  content: Text('Your expense has been saved'),
                                  action: SnackBarAction(
                                    label: 'Undo',
                                    onPressed: (){

                                    },
                                  ),
                                );
                                //Scaffold.of(context).showSnackBar(snackbar);
                              },
                            ),
                          )
                        ],
                      ),
                    )
                ),
              );
            });
          }
          print('You selected $Name');
          switch(Name){
            case "Food":{
              _buttomDialogInput(context);
            }
            break;

            case "Electric":{
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
            height: selected == Name ? 100.0 : 75.0,
            width: selected == Name ? 100.0 : 75.0,
            color: selected == Name ? Colors.green : Colors.transparent,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                iconData,
                color: selected == Name ? Colors.white : Colors.black,
                size: 25.0,
              ),
              SizedBox(height: 12.0),
              Text(Name,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: selected == Name ? Colors.white : Colors.black,
                      fontSize: 10.0))
            ])));
  }

  selectMenuOption(String Name) {
    setState(() {
      selected = Name;
    });
  }

  ////////////////////widgets/////////
void _buttomDialogInput(context){
    showModalBottomSheet(context: context, builder: (BuildContext bc){
      return Container(
        height: MediaQuery.of(context).size.height * .60,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  SizedBox(width: 20,),
                  Text('Your expense category', style: TextStyle(fontSize: 15),),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.amber,
                      size: 25,
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  //Text('$Name')
                ],
              ),
            ],
          ),
        )
      );
    });
}

}


