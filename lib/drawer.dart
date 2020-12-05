import 'package:flutter/material.dart';
import 'package:flutteriezakat/FAQPage.dart';
import 'package:flutteriezakat/HowToUse.dart';
import 'package:flutteriezakat/ZakatInformation.dart';
import 'package:flutteriezakat/ZakatStats/ZakatStatPage.dart';
import 'package:flutteriezakat/ZakatStats/ZakatStatistics.dart';
import 'package:flutteriezakat/income_expense/balance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:flutteriezakat/zakat_tracker/zakat_tracker_home.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class CustomDrawer extends StatefulWidget {

  /*final FirebaseUser user;
  CustomDrawer(this.user, {Key key}) : super(key: key);*/

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  @override
  void initState() {
    setState(() {
      retrieveEmail();
    });
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /*void getCurrentUserEmail() async {
    final user = await _auth.currentUser().then((value) => userEmail = value.email.toString());
  }*/
  String userEmail;
  void retrieveEmail() async {
    final FirebaseUser user = await _auth.currentUser();
    final uEmail = user.email;
    setState(() {
      userEmail = uEmail.toString();
      print(userEmail);
    });
    // here you write the codes to input the data into firestore
  }

  void signOut(BuildContext context){
    _auth.signOut();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPageTest()),
      ModalRoute.withName('/'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            height: 80,
            child: DrawerHeader(
              decoration: BoxDecoration(
                  color:  Colors.teal,
              ),
              child: Text('Email: '+userEmail??'Could not display email', style: TextStyle(color: Colors.white, fontSize: 20),),
            ),
          ),
          ListTile(
            leading: Icon(MdiIcons.calculator),
            title: Text('Zakat Calculator'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => MyHomePage()
              ));
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.chartBar),
            title: Text('Statistics'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => ZakatStatistics()
              ));
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.bookOpenVariant),
            title: Text('Zakat Information'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => ZakatInformation()
              ));
            },
          ),
          ListTile(
            leading: Icon(MdiIcons.helpCircleOutline),
            title: Text('How to use'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => HowToUsePage()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('FAQ'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => FAQPage()
              ));
            },
          ),
          ListTile(
            onTap: (){
              showAboutDialog(
                context: context,
                applicationVersion: '1.0.1',
                applicationLegalese: 'Money Tracker for Zakat Calcualtion',
              );
            },
            leading: Icon(MdiIcons.informationOutline),
            title: Text('About Money Tracker'),
          ),
          SizedBox(height: 260,),
          ListTile(
            leading: Icon(Icons.clear),
            title: Text('Sign out'),
            onTap: (){
              signOut(context);
            },
          ),
        ],
      ),
    );
  }
}
