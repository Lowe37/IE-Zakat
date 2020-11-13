import 'package:flutter/material.dart';
import 'package:flutteriezakat/income_expense/balance.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:flutteriezakat/zakat_tracker/zakat_tracker_home.dart';

class CustomDrawer extends StatefulWidget {

  /*final FirebaseUser user;
  CustomDrawer(this.user, {Key key}) : super(key: key);*/

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
          DrawerHeader(
            decoration: BoxDecoration(
                color:  Colors.indigo
            ),
            child: Text('test', style: TextStyle(color: Colors.white, fontSize: 20),),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => balance()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.pie_chart),
            title: Text('Statistics'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => balance()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.monochrome_photos),
            title: Text('Zakat Tracker'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => zakatTrackerHome()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.monetization_on),
            title: Text('Zakat Calculator'),
            onTap: (){
              Navigator.push(context, new MaterialPageRoute(
                  builder: (context) => MyHomePage()
              ));
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('FAQ'),
          ),
          ListTile(
            onTap: (){
              showAboutDialog(
                context: context,
                applicationVersion: '1.0.1',
                applicationLegalese: 'testttt',
              );
            },
            leading: Icon(Icons.question_answer),
            title: Text('About Money Tracker'),
          ),
          SizedBox(height: 140,),
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
