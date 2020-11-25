import 'package:flutter/material.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class ZakatInformation extends StatefulWidget {
  @override
  _ZakatInformationState createState() => _ZakatInformationState();
}

class _ZakatInformationState extends State<ZakatInformation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Zakat Information'),
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
                  child: Text('Zakat Information', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,),)
              ),
              SizedBox(height: 40,),
              Text('What is Zakat?', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('Obligation that requires a person to give out certain amount of their wealth to an eligible group once in a year or when amount of the wealth has reached certain level.'),
              SizedBox(height: 30,),

              Text('Quran verse on obligatory of Zakat', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('Translation:\n"Establish prayer, pay alms-tax,1 and bow down with those who bow down." [Al-Baqarah: 43].'),


              SizedBox(height: 30,),
              Text('Conditions of the person', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Muslim.\n2. Independent.\n3. Has reached age of puberty.\n4. Available financially.\n5. The wealth has reached Nisab.'),

              SizedBox(height: 30,),
              Text('Conditions of the wealth', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Full ownership.\n2. Can bring revenue.\n3. Has reached Nisab.\n4. Has reached Haul.\n5. The wealth has exceed living cost such as food, shelter or cloths .'),
              SizedBox(height: 40,),

              Align(
                  alignment: Alignment.center,
                  child: Text('Zakat Category Conditions', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,),)
              ),

              SizedBox(height: 30,),
              Text('Business', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Nisab of 5.58 Baht of gold.\n2. Haul of 1 year.\n3. Rate of 2.5%.'),

              /*SizedBox(height: 30,),
              Text('Gold', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Nisab of 5.58 Baht of gold.\n2. 1 year duration.\n3. Rate of 2.5%.'),*/

              SizedBox(height: 30,),
              Text('Income', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Nisab of 5.58 Baht of gold.\n2. 1 year duration or monthly.\n3. Rate of 2.5%.'),

              SizedBox(height: 30,),
              Text('Savings', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Nisab of 5.58 Baht of gold.\n2. 1 year duration.\n3. Rate of 2.5%.'),

              SizedBox(height: 30,),
              Text('Treasure', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. No Nisab.\n2. Pay Zakat immediately when found.\n3. Rate of 20% for buried treasure (not lost treasure). Rate of 2.5% for valuable treasure.'),

              SizedBox(height: 30,),
              Text('Plantation', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Nisab of 652.8 Kg.\n2. Pay when the Nisab is met.\n3. Rate of 10% for using natural resources with no water cost. Rate of 5% for using water that has cost. Rate of 7.5% for using natural resources that has cost.'),

              SizedBox(height: 30,),
              Text('Livestock', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Nisab for 30 cows or buffalo. Nisab for 40 goats or sheep.\n2. 1 year duration.\n3. Rate is according to the amount of livestock.'),

              SizedBox(height: 30,),
              Text('Fitrah', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,fontFamily: 'Nunito', color: Colors.cyan,)),
              SizedBox(height: 10,),
              Text('1. Nisab of 2.7 Kg of rice or sticky rice.\n2. Before Eid Al-Fitr prayer.'),

            ],
          ),
        ),
      ),
    );
  }
}
