import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:flutteriezakat/home.dart';
import 'package:flutteriezakat/income_expense/balance.dart';
import 'package:flutteriezakat/main.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/signin_and_registration/register_user.dart';
import 'package:flutteriezakat/services/auth.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:flutteriezakat/sidebar/sidebar.dart';
import 'package:flutteriezakat/signin_and_registration/reset_password.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main () => runApp(MaterialApp(
  home: LoginPageTest(),
));

class LoginPageTest extends StatefulWidget {

  @override
  _LoginPageTestState createState() => _LoginPageTestState();
}

class _LoginPageTestState extends State<LoginPageTest> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GoogleSignIn googleAuth = new GoogleSignIn();

  @override
  initState() {
    super.initState();
    loginCheck(context);
  }

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  String email = '';
  String password = '';
  String error = '';

  Future loginCheck(BuildContext context) async {
    FirebaseUser user = await _auth.currentUser();
    if (user != null) {
      print("Already singed-in with");
      /*Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CustomDrawer(user)));*/
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => balance()));
    }
  }

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 80),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text("Sign In", style: TextStyle(color:Colors.grey, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w200, fontSize: 30),),
                  ),
                  SizedBox(height: 50,),
                  emailTextField(),
                  SizedBox(height: 20,),
                  passwordTextField(),
                  SizedBox(height: 30,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(width: 5,),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return resetPasswordPage();
                          }));
                        },
                        child: Text('Forgot Password ?', style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold
                        ),),
                      )
                    ],
                  ),
                  SizedBox(height: 40,),
                  Center(child: GoogleSignInButton()),
                  Center(child: FacebookSignInButton()),
                  SizedBox(height: 30,),
                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.white,
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.green,),
                      ),
                      onPressed: () {
                        signIn();
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Do not have an account ?',
                      ),
                      SizedBox(width: 5,),
                      InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return registerPage();
                          }));
                        },
                        child: Text('Register', style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold
                        ),),
                      )
                    ],
                  ),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  )
                  //SignInButton(),
                ],
              ),
            ),
          )
      ),
    );
  }

  ////////////////////////////////////FUNCTIONS//////////////////////////
  /*Container EmailTextField(){
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
  }*/

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

  /*Container PasswordTextField(){
    return Container(
      child: TextFormField(
        obscureText: true,
        decoration: InputDecoration(
            labelText: 'Enter your password',
            border: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(16)
            )
        ),
        controller: passwordController,
      ),
    );
  }*/

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

  Container GoogleSignInButton(){
    return Container(
      child: RaisedButton.icon(
        onPressed: () {

          googleSignIn(context);
        },
        icon: Image.asset(''),
        textColor: Colors.white,
        color: Colors.red,
        label: Text('Continue with Google'),
        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future googleSignIn(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/contacts.readonly',
      ]
    );
    GoogleSignInAccount user = await _googleSignIn.signIn();
    GoogleSignInAuthentication userAuth = await user.authentication;

    await _auth.signInWithCredential(GoogleAuthProvider.getCredential(idToken: userAuth.idToken, accessToken: userAuth.accessToken));
    setState (() => loading = true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => balance()),
    );
  }

  Container FacebookSignInButton(){
    return Container(
      child: RaisedButton.icon(
        onPressed: (

            ) {},
        icon: Image.asset(''),
        textColor: Colors.white,
        color: Color(0xff3b5998),
        label: Text('Continue with Facebook'),
        shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }


  /*Widget  SignInButton(){
    return InkWell(

      child: Container(
        constraints: BoxConstraints.expand(height: 50),
        child: Text('Sign In',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
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
        SignIn();
      },
    );
  }*/

Future<FirebaseUser> signIn() async{
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((user) {
      //print("Signed in with ${user.email}");
      loginCheck(context);  // add here
    }).catchError((error) {
      print(error.message);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ));
    });
  }

}