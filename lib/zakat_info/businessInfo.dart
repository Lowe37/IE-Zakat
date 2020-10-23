import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:flutteriezakat/zakat_calculation.dart';
import 'package:flutteriezakat/localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutteriezakat/zakat_types/business.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

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
      home: businessInfo(),
    );
  }
}

class businessInfo extends StatefulWidget {
  @override
  _businessInfoState createState() => _businessInfoState();
}

class _businessInfoState extends State<businessInfo> {

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
                child: Text("Zakat on Business", style: TextStyle(fontWeight: FontWeight.w200, fontSize: 30),),
              ),
              //Text(AppLocalizations.of(context).translate("title")),
              SizedBox(height: 30,),
              Center(child: Text('بسم الله الرحمن الرحيم', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),)),
              SizedBox(height: 10,),
              Align(
                alignment: Alignment.center,
                child: Text("In the name of Allah the Beneficent, the Merciful", style: TextStyle(fontWeight: FontWeight.w200),),
              ),
              SizedBox(height: 40,),
              Text('Conditions on the person:', style: TextStyle(fontWeight: FontWeight.w200),),
              SizedBox(height: 10,),
              Text('1. Muslim', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('2. Merdeka', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('3. Berakal dan baligh', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('4. Harta memenuhi nisab', style: TextStyle(fontWeight: FontWeight.bold),),

              SizedBox(height: 40,),
              Text('Conditions on the business:', style: TextStyle(fontWeight: FontWeight.w200),),
              SizedBox(height: 10,),
              Text('1. Nisab = 5.58 Baht of Gold', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text('2. Haul = 1 year', style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),

              SizedBox(height: 30,),
              Center(
                child: RaisedButton(
                  onPressed: () {
                    //setState (() => loading = true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => business()),
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
