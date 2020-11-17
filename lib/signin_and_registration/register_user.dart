import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/services/auth.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:flutteriezakat/sign_in.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';

void main () => runApp(MaterialApp(
  home: registerPage(),
));

class registerPage extends StatefulWidget {

  final Function toggleView;
  registerPage({this.toggleView});

  @override
  _registerPageState createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {

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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 50),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text("Registration", style: TextStyle(color:Colors.grey, fontFamily: 'Nunito-Regular', fontWeight: FontWeight.w200, fontSize: 30),),
                ),
                SizedBox(height: 40,),
                emailTextField(),
                SizedBox(height: 10,),
                passwordTextField(),
                SizedBox(height: 10,),
                confirmPasswordTextField(),
                SizedBox(height: 50,),
                Align(
                  alignment: Alignment.center,
                  child: RaisedButton(
                    color: Colors.white,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.green,),
                    ),
                    onPressed: (){
                      signUp();
                    },
                    /*onPressed: () async {
                      if(_formKey.currentState.validate()){
                        setState (() => loading = true);
                        dynamic result = await _auth.registerWithEmailAndPassword(name, email, password, confirmpassword);
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyHomePage()),
                        );*/
                        if(result is PlatformException){
                          if(result.code == 'ERROR_EMAIL_ALREADY_IN_USE')
                          setState (() => error = 'Please enter a valid email');
                          loading = false;
                        }
                      }
                    },*/
                  ),
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'Already have an account ?',
                    ),
                    SizedBox(width: 5,),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return LoginPageTest();
                        }));
                      },
                      child: Text('Sign In', style: TextStyle(
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
                //RegisterButton(),
              ],
            )),
          ),

      ),
    );
  }

  ////////////////////////////////////FUNCTIONS//////////////////////////

  signUp(){
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String confirmPassword = confirmPasswordController.text.trim();

    bool emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(email);
    print(emailValid);

    if(password == confirmPassword && password.length >= 6){
      _auth2
      .createUserWithEmailAndPassword(email: email, password: password)
      .then((user){
        print('registered successfully');
        setState(() {
          loading = true;
        });
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      }).catchError((error){
        /*if(error == PlatformException){
          if(error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
            /// `foo@bar.com` has alread been registered.
          }
        }*/
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(error.message, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ));
        print(error.message);

      });
    } else {
      print('Fail to confirm password');
    }
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