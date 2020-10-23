import 'package:flutter/material.dart';
import 'package:flutteriezakat/shared/loading.dart';

void main () => runApp(MaterialApp(
  home: zakatCalculate(),
));

class zakatCalculate extends StatefulWidget {
  @override
  _zakatCalculateState createState() => _zakatCalculateState();
}

class zakatType {
  int id;
  String typeName;

  zakatType(this.id, this.typeName);

  static List<zakatType> getType () {
    return <zakatType>[
      zakatType(1, 'Business'),
      zakatType(2, 'Shares'),
      zakatType(3, 'Savings'),
      zakatType(4, 'Livestock'),
      zakatType(5, 'Gold and Silver'),
      zakatType(6, 'Vegetation'),
    ];
  }
}

class _zakatCalculateState extends State<zakatCalculate> {

  bool loading = false;

  List<zakatType> _types = zakatType.getType();
  List<DropdownMenuItem<zakatType>> _dropdownMenuItems;
  zakatType _selectedType;

  @override
  void initState(){
    _dropdownMenuItems = buildDropdownMenuItems(_types);
    _selectedType = _dropdownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<zakatType>> buildDropdownMenuItems(List types){
    List<DropdownMenuItem<zakatType>> items = List();
    for (zakatType type in types){
      items.add(
          DropdownMenuItem(
            value: type,
            child: Text(type.typeName),
          )
      );
    }
    return items;
  }

  onChangeDropdownItem(zakatType selectedType){
    setState(() {
      _selectedType = selectedType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      body: Container(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            SizedBox(height: 20),
        Align(
          alignment: Alignment.topCenter,
          child: Text("Zakat Calculation", style: TextStyle(fontWeight: FontWeight.w200, fontSize: 30),),
        ),
        SizedBox(height: 50,),
        Text('Select your Zakat category', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),),
        SizedBox(height: 30,),
        DropdownButton(
          value: _selectedType,
          items: _dropdownMenuItems,
          onChanged: onChangeDropdownItem,
        ),
     ] ),
    )
    );
  }
}
