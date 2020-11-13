import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutteriezakat/database.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutteriezakat/services/auth.dart';

void main () => runApp(MaterialApp(
  home: homePage(),
));

class homePage extends StatefulWidget {

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String email = '';
  String password = '';
  String confirmpassword = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
        padding: EdgeInsets.all(30),
    child: Form(
    key: _formKey,
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
    SizedBox(height: 50),
    Align(
    alignment: Alignment.topCenter,
    child: Text("Home", style: TextStyle(color:Colors.grey, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w200, fontSize: 30),),
    )]))));
  }
}
