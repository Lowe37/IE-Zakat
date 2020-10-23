import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:flutteriezakat/zakat_calculation.dart';
import 'package:flutteriezakat/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutteriezakat/zakat_types/business.dart';
import 'package:flutteriezakat/zakat_types/fitrah.dart';
import 'package:flutteriezakat/zakat_types/fitrah.dart';
import 'package:flutteriezakat/zakat_types/fitrah.dart';
import 'package:flutteriezakat/zakat_types/fitrah.dart';
import 'package:flutteriezakat/zakat_types/fitrah.dart';
import 'package:flutteriezakat/zakat_types/fitrah.dart';
import 'package:flutteriezakat/zakat_types/plantation.dart';

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
      home: plantationInfo(),
    );
  }
}

class plantationInfo extends StatefulWidget {
  @override
  _plantationInfoState createState() => _plantationInfoState();
}

class _plantationInfoState extends State<plantationInfo> {

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
              SizedBox(height: 40),
              Align(
                alignment: Alignment.topCenter,
                child: Text("Zakat on Plantation", style: TextStyle(fontWeight: FontWeight.w200, fontSize: 30),),
              ),
              //Text(AppLocalizations.of(context).translate("title")),
              SizedBox(height: 30,),
              Center(child: Text('بسم الله الرحمن الرحيم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),)),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: Text("In the name of Allah the Beneficent, the Merciful", style: TextStyle(fontWeight: FontWeight.w200),),
              ),
              /*Text('Conditions on the person:', style: TextStyle(fontWeight: FontWeight.w200),),
              SizedBox(height: 10,),
              Text('1. Islam', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('2. Merdeka', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('3. Between Ramadhan and Syawal', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('4. Have enough for himself and his family on Eid', style: TextStyle(fontWeight: FontWeight.bold),),
*/
              SizedBox(height: 40,),
              Text('Conditions on the business:', style: TextStyle(fontWeight: FontWeight.w200),),
              SizedBox(height: 10,),
              Text('1. Nisab = 652.8kg', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),

              SizedBox(height: 40,),
              Text('Rate of Zakat:', style: TextStyle(fontWeight: FontWeight.w200),),
              SizedBox(height: 10,),
              Text('1. Use only natural resource = 10%', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('2. Use machinery = 5%', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),

              SizedBox(height: 30,),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    //setState (() => loading = true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => plantation()),
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
