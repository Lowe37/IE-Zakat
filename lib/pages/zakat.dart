import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:flutteriezakat/zakat_calculation.dart';
import 'package:flutteriezakat/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main () => runApp(MaterialApp(
));

class changeLang extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      supportedLocales: [
        Locale('en', 'US'),
        Locale('th', ''),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: zakatPage(),
    );
  }
}

class zakatPage extends StatefulWidget {
  @override
  _zakatPageState createState() => _zakatPageState();
}

class _zakatPageState extends State<zakatPage> {

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20),
              Align(
                alignment: Alignment.topCenter,
                //child: Text("Obligations of Zakat", style: TextStyle(fontWeight: FontWeight.w200, fontSize: 30),),
              ),
              Text(AppLocalizations.of(context).translate("title")),
              SizedBox(height: 10,),
              Center(child: Text('بسم الله الرحمن الرحيم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),)),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: Text("In the name of Allah the Beneficent, the Merciful", style: TextStyle(fontWeight: FontWeight.w200),),
              ),
              SizedBox(height: 50,),
              //Quran
              Text('Quran', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),
              SizedBox(height: 20,),
              Center(child: Text("وَأَقِيمُوا الصَّلَاةَ وَآتُوا الزَّكَاةَ وَارْكَعُوا مَعَ الرَّاكِعِينَ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),)),
              SizedBox(height: 15,),
              Text('Translation :', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),),
              SizedBox(height: 10,),
              Text('And establish prayer and give zakah and bow with those who bow [in worship and obedience]. (Al-Baqarah : 43)', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),),
              SizedBox(height: 40,),
              //Hadith
              Text('Hadith', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 20),),
              SizedBox(height: 20,),
              Center(child: Text('حَدَّثَنَا مُسْلِمُ بْنُ إِبْرَاهِيمَ، حَدَّثَنَا شُعْبَةُ، حَدَّثَنَا سَعِيدُ بْنُ أَبِي بُرْدَةَ، عَنْ أَبِيهِ، عَنْ جَدِّهِ، عَنِ النَّبِيِّ صلى الله عليه وسلم قَالَ ‏"‏ عَلَى كُلِّ مُسْلِمٍ صَدَقَةٌ ‏"‏‏.‏ فَقَالُوا يَا نَبِيَّ اللَّهِ فَمَنْ لَمْ يَجِدْ قَالَ ‏"‏ يَعْمَلُ بِيَدِهِ فَيَنْفَعُ نَفْسَهُ وَيَتَصَدَّقُ ‏"‏‏.‏ قَالُوا فَإِنْ لَمْ يَجِدْ قَالَ ‏"‏ يُعِينُ ذَا الْحَاجَةِ الْمَلْهُوفَ ‏"‏‏.‏ قَالُوا فَإِنْ لَمْ يَجِدْ‏.‏ قَالَ ‏"‏ فَلْيَعْمَلْ بِالْمَعْرُوفِ، وَلْيُمْسِكْ عَنِ الشَّرِّ فَإِنَّهَا لَهُ صَدَقَةٌ ‏"‏‏.‏',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),)),
              SizedBox(height: 15,),
              Text('Translation : ', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w300),),
              SizedBox(height: 10,),
              Text('Narrated by Abu Burda', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200),),
              SizedBox(height: 5,),
              Text('From his father from his grandfather that the Prophet (pbuh) said, “Every Muslim has to give in charity.” The people asked, “O Allah’s Prophet! If someone has nothing to give, what will he do?” He said, “He should work with his hands and benefit himself and also give in charity (from what he earns).” The people further asked, “If he cannot find even that?” He replied, “He should help the needy who appeal for help.” Then the people asked, “If he cannot do that?” He replied, “Then he should perform good deeds and keep away from evil deeds and this will be regarded as charitable deeds.”',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w200,),
                textAlign: TextAlign.justify,),
              SizedBox(height: 30,),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    setState (() => loading = true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => zakatCalculate()),
                    );
                  },
                  color: Colors.green,
                  child: Text('Go to Zakat calculation', style: TextStyle(color: Colors.white),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
