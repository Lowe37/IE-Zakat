import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/services/auth.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:flutteriezakat/sign_in.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:flutteriezakat/zakat_tracker/zakat_tracker_home.dart';
import 'package:form_validator/form_validator.dart';

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
  String confirmPassword = '';
  String error = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  void testValidator (){
    final validate = ValidationBuilder().minLength(10).maxLength(50).build();

    print(validate('test'));        // Minimum length must be at least 10 characters
    print(validate('Hello World')); // n
  }

  final _emailValidator = ValidationBuilder().email().maxLength(50).build();

  bool _validatorEmail = false;
  bool _validatorPassword = false;
  bool _validatorConfirmPassword = false;

  bool _showHidePassword = true;
  bool _showHideConfirmPassword = true;

  void toggleShowHidePassword (){
    setState(() {
      _showHidePassword = !_showHidePassword;
      _showHideConfirmPassword = !_showHideConfirmPassword;
    });
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                  SizedBox(height: 50),
                  Text('Registration', style: TextStyle(
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                    color: Colors.indigo
                ),
                  ),
                  SizedBox(height: 40,),
                  TextFormField(
                  controller: emailController,
                  //validator: _emailValidator,
                  //validator: (val) => val.isEmpty ? 'Enter an email' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  decoration: InputDecoration(
                      errorText: _validatorEmail? 'Enter an email': null,
                      labelText: 'Email',
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(16)
                      )
                  ),
                ),
                  //emailTextField(),
                  SizedBox(height: 10,),
                  TextFormField(
                  controller: passwordController,
                  obscureText: _showHidePassword,
                  //validator: _emailValidator,
                  //validator: (val) => val.isEmpty ? 'Enter a password' : null,
                  onChanged: (val) {
                    setState(() => email = val);
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _showHidePassword = !_showHidePassword;
                          });
                        },
                        icon: Icon(
                          _showHidePassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      errorText: _validatorPassword? 'Enter a password': null,
                      labelText: 'Password',
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(16)
                      )
                  ),
                ),
                  //passwordTextField(),
                  SizedBox(height: 10,),
                  TextFormField(
                  controller: confirmPasswordController,
                  obscureText: _showHideConfirmPassword,
                  //validator: _emailValidator,
                  //validator: (val) => val.isEmpty ? 'Enter a password' : null,
                  onChanged: (val) {
                    setState(() => confirmPassword = val);
                  },
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: (){
                          setState(() {
                            _showHideConfirmPassword = !_showHideConfirmPassword;
                          });
                        },
                        icon: Icon(
                          _showHideConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        ),
                      ),
                      errorText: _validatorConfirmPassword? 'Enter to confirm password': null,
                      labelText: 'Confirm Password',
                      border: new OutlineInputBorder(
                          borderRadius: new BorderRadius.circular(16)
                      )
                  ),
                ),
                  //confirmPasswordTextField(),
                  SizedBox(height: 30,),
                  RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  color: Colors.amber,
                    child: Text(
                    'Register',
                    style: TextStyle(color: Colors.white, fontFamily: 'Nunito', ),
                  ),
                    onPressed: () {
                        signUp();
                      // testValidator();
                      setState(() {
                        emailController.text.isEmpty? _validatorEmail = true : _validatorEmail = false;
                        passwordController.text.isEmpty? _validatorPassword = true : _validatorPassword = false;
                        confirmPasswordController.text.isEmpty? _validatorConfirmPassword = true : _validatorConfirmPassword = false;
                      });
                  },
                ),
                 SizedBox(height: 30,),
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
                          color: Colors.teal,
                          fontWeight: FontWeight.bold
                      ),
                      ),
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
          MaterialPageRoute(builder: (context) => zakatTrackerHome()),
        );
      }).catchError((error){
        if(error == PlatformException){
          if(error.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
            /// `foo@bar.com` has alread been registered.
          }
        }
        print(error.message);
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(error.message, style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ));
      });
    } else {
     scaffoldKey.currentState.showSnackBar(SnackBar(
       content: Text("The password did not match.", style: TextStyle(color: Colors.white)),
       backgroundColor: Colors.red,
     ));
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
          setState(() => confirmPassword = val);
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