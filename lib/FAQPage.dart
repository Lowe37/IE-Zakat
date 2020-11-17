import 'package:flutter/material.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('FAQ'),
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
                  child: Text('FAQ', style: TextStyle(fontSize: 50, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,),)
              ),
              SizedBox(height: 40,),
              Text('Who can receive your Zakat?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('8 categories that is eligible for Zakat according to Quran (At-Tawbah: 60):\n1. The poor.\n2. The needy.\n3. The collectors of Zakat.\n4. Those whose hearts to be won over.\n5. Captives.\n6. Those burdened with debt.\n7. In the cause of Allah.\n8. Travelers.'),
              /*Text('Zakat cannot paid to everyone. There are eight specific categories of people to whom Zakat can be given: "The alms are only for the Fuqara (the poor), Al-Masakin (the needy) and those employed to collect (the funds); and to attract the hearts of those who have been inclined (towards Islam); and to free the captives; and for those in debt; and for Allah Cause, and for the wayfarer (a traveller who is cut off from everything); a duty imposed by Allah. And Allah is All-Knower, All-Wise." [Al-Quran 9:60].',
              style: TextStyle(fontFamily: '' ),),*/
              SizedBox(height: 30,),
              Text('When to pay Zakat?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('Zakat Al-Mal is payed when the wealth has reached certain amount (Nisab) throughout the year. On the other hand, Zakat Al-Fitr is payed by the head of the family before Eid Al-Fitr prayer.'),
            ],
          ),
        ),
      ),
    );
  }
}
