import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


void main () => runApp(MaterialApp(
  theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.green,
      accentColor: Colors.greenAccent,
      fontFamily: 'Nunito-Regular',
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 26, fontWeight: FontWeight.w400),
        body1: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
      )
  ),
  home: LoginPage(),
));

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 80),
              Align(
                alignment: Alignment.topCenter,
                child: Text("Sign In", style: TextStyle(color:Colors.grey, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w200, fontSize: 30),),
              ),
              SizedBox(height: 50,),
              EmailTextField(),
              SizedBox(height: 20,),
              PasswordTextField(),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.center,
                child: Text("Do not have an account? Register here",),
              ),
              //SizedBox(height: 40,),
              GoogleSignIn(),
              FacebookSignIn(),
              SignInButton(),
            ],
          )
      ),
    );
  }

  ////////////////////////////////////FUNCTIONS//////////////////////////
  Container EmailTextField(){
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Enter your Email',
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(16)
            )
        ),
        controller: emailController,
      ),
    );
  }

  Container PasswordTextField(){
    return Container(
      child: TextFormField(
        decoration: InputDecoration(
            labelText: 'Enter your password',
            border: new OutlineInputBorder(
                borderRadius: new BorderRadius.circular(16)
            )
        ),
        controller: passwordController,
      ),
    );
  }

  Container GoogleSignIn(){
    return Container(
      child: RaisedButton.icon(
        onPressed: () {},
        icon: Image.asset(''),
        textColor: Colors.white,
        color: Colors.red,
        label: Text('Continue with Google'),
        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Container FacebookSignIn(){
    return Container(
      child: RaisedButton.icon(
        onPressed: () {},
        icon: Image.asset(''),
        textColor: Colors.white,
        color: Color(0xff3b5998),
        label: Text('Continue with Facebook'),
        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }


  Widget  SignInButton(){
    return InkWell(

      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text('Register',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.blueAccent,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
      ),
      onTap: () {
        RegisterUser();
      },
    );
  }

  Future<FirebaseUser> RegisterUser() async{
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((user) {
      print("Signed in with ${user.email}");
      //LoginCheck(context);  // add here
    }).catchError((error) {
      print(error.message);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ));
    });
  }
}