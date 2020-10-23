import 'package:flutteriezakat/signin_and_registration/register_user.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: LoginPage(),
    );
  }
}
