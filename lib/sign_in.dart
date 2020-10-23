import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutteriezakat/home.dart';
import 'package:flutteriezakat/main.dart';
import 'package:flutteriezakat/pages/homepage.dart';
import 'package:flutteriezakat/signin_and_registration/register_user.dart';
import 'package:flutteriezakat/services/auth.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:google_sign_in/google_sign_in.dart';


void main () => runApp(MaterialApp(
  home: LoginPage(),
));

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseAuth _auth2 = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
                  SizedBox(height: 40,),
                  Center(child: GoogleSignInButton()),
                  Center(child: FacebookSignInButton()),
                  SizedBox(height: 20,),
                  Align(
                    alignment: Alignment.center,
                    child: RaisedButton(
                      color: Colors.white,
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.green,),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                          setState (() => loading = true);
                          dynamic result = await _auth.signinWithEmailAndPassword(email, password);
                          if(result == null){
                            setState (() => error = 'Could not sign in');
                            loading = false;
                          }
                        }
                      },
                    ),
                  ),
                  SizedBox(height: 20,),
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

    await _auth2.signInWithCredential(GoogleAuthProvider.getCredential(idToken: userAuth.idToken, accessToken: userAuth.accessToken));
    setState (() => loading = true);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
    );
  }

  Container FacebookSignInButton(){
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
  }

Future<FirebaseUser> SignIn() async{
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
    ).then((user) {
      print("Signed in with ${user.email}");
      LoginCheck(context);  // add here
    }).catchError((error) {
      print(error.message);
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(error.message, style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ));
    });
  }

  Future LoginCheck(BuildContext context) async {
    FirebaseUser user = await _auth.currentUser();
    if(user!=null) {
      print("Logged in with");
      //Navigator.push(context, MaterialPageRoute(builder: (context)=> register_user()));
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        //return register_user();
      }));
    }
  }

}

class Home extends StatefulWidget {
  final FirebaseUser user;

  Home(this.user, {Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            color: Colors.white,
            onPressed: () {
              LogOut(context);
            },
          )
        ],
      ),
      body: Container(
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min,children: <Widget>[
            Text('Welcome'),
            Text(widget.user.email),
          ],),
        ),
      ),
    );
  }

  void LogOut(BuildContext context){
    _auth.signOut();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginPage()), ModalRoute.withName('/'));
  }*/
}
