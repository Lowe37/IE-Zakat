import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutteriezakat/database.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutteriezakat/main.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/services/auth.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:flutteriezakat/sign_in.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:flutteriezakat/user_profile.dart';

void main () => runApp(MaterialApp(
  home: resetPasswordPage(),
));

class resetPasswordPage extends StatefulWidget {

  final Function toggleView;
  resetPasswordPage({this.toggleView});

  @override
  _resetPasswordPageState createState() => _resetPasswordPageState();
}

class _resetPasswordPageState extends State<resetPasswordPage> {

  final AuthService _auth = AuthService();
  FirebaseAuth _auth2 = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String name = '';
  String email = '';
  String password = '';
  String confirmpassword = '';
  String error = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      key: scaffoldKey,
      body: Padding(
        padding: EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 50),
                  Text('Reset Password', style: TextStyle(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                      color: Colors.indigo
                  ),
                  ),
                  SizedBox(height: 40,),
                  emailTextField(),
                  SizedBox(height: 20,),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)
                    ),
                    color: Colors.green,
                    child: Text(
                      'Submit',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    onPressed: (){
                      resetPassword();
                    },
                  ),
                  SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Back to ', style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold
                      ),),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return LoginPageTest();
                          }));
                        },
                        child: Text('Sign In', style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold
                        ),),
                      )
                    ],
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                  //RegisterButton(),
                ],
              )),
        ),

      ),
    );
  }

  ////////////////////////////////////FUNCTIONS//////////////////////////

  resetPassword(){
    String email = emailController.text.trim();
    _auth2.sendPasswordResetEmail(email: email);
    scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text('Reset password request sent to $email successfully',
      style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.green,
    ));
  }

  Container emailTextField(){
    return Container(
      child: TextFormField(
        controller: emailController,
        validator: (val) => val.isEmpty ? 'Enter an email' : null,
        onChanged: (val) {
          setState(() => email = val);
        },
        decoration: InputDecoration(
            labelText: 'Email',
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(16)
            )
        ),
      ),
    );
  }

  Container passwordTextField(){
    return Container(
      child: TextFormField(
        controller: passwordController,
        validator: (val) => val.length < 6 ? 'Enter a password with more than 6 characters' : null,
        onChanged: (val) {
          setState(() => password = val);
        },
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Password',
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(16)
            )
        ),
      ),
    );
  }

  Container confirmPasswordTextField(){
    return Container(
      child: TextFormField(
        controller: confirmPasswordController,
        validator: (val) => val.isEmpty ? 'Enter to confirm your password' : null,
        onChanged: (val) {
          setState(() => confirmpassword = val);
        },
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Confirm password',
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(16)
            )
        ),
      ),
    );
  }

}