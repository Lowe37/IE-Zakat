import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutteriezakat/income_expense/addExpense.dart';
import 'package:flutteriezakat/income_expense/income_chart.dart';

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

class addIncomeItem extends StatefulWidget {

  addIncomeItem ({Key key}) : super(key: key);

  @override
  _addIncomeItemState createState() => _addIncomeItemState();
}

class _addIncomeItemState extends State<addIncomeItem> {

  var selected = 'BURGER';

  final List<IconData> _icons = [
    Icons.offline_bolt,
    Icons.print,
    Icons.business,
    Icons.dashboard
  ];

  List<IconData> _selectedIcon = [];

  @override
  Widget build(BuildContext context) {
    Widget gridViewSelection = GridView.count(
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
    );
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
            child: Text('Select income category', style: TextStyle(
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

  Widget _buildMenuItem(String Name, iconData) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          selectMenuOption(Name);
          print('You selected');
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

}


