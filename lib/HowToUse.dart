import 'package:flutter/material.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HowToUsePage extends StatefulWidget {
  @override
  _HowToUsePageState createState() => _HowToUsePageState();
}

class _HowToUsePageState extends State<HowToUsePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('How to use'),
        backgroundColor: Colors.cyan,
      ),
      drawer: CustomDrawer(),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Text('How to?', style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,),)
              ),
              SizedBox(height: 40,),
              Text('Steps:', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              /*Text('Zakat cannot paid to everyone. There are eight specific categories of people to whom Zakat can be given: "The alms are only for the Fuqara (the poor), Al-Masakin (the needy) and those employed to collect (the funds); and to attract the hearts of those who have been inclined (towards Islam); and to free the captives; and for those in debt; and for Allah Cause, and for the wayfarer (a traveller who is cut off from everything); a duty imposed by Allah. And Allah is All-Knower, All-Wise." [Al-Quran 9:60].',
              style: TextStyle(fontFamily: '' ),),*/
              SizedBox(height: 10,),
              Text("1. Add records by tapping '+' in Zakat Calculator page.\n2. Select Zakat category to calculate your Zakat.\n3. Retrieve information or insert information manually.\n4. Calculate and save your Zakat information.\n5. Tap the 'Refresh' button to refresh the total amount of Zakat you have to pay."),
              SizedBox(height: 30,),
              Text('How to reset?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. If the Zakat is paid, you can press the bin icon in Zakat Calculator page to reset.\n2. Confirm reset.'),
            ],
          ),
        ),
      ),
    );
  }
}
