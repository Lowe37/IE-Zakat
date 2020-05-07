import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  theme: ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.green,
      accentColor: Colors.greenAccent,
      fontFamily: 'Nunito-Regular',
      textTheme: TextTheme(
        headline: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
        title: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
        body1: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      )
  ),
  home: Login(),
));

////////////////////////////////////////////LOGIN PAGE//////////////////////////////////////////////////////////
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    LoginCheck(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('IE Zakat'),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Container(
        color: Colors.blueGrey,
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            margin: EdgeInsets.all(32),
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                EmailTextField(),
                PasswordTextfield(),
                SignInButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container EmailTextField(){
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        //borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          labelText: 'Email',
        ),
        controller: emailController,
      )
    );
  }

  Container  PasswordTextfield(){
    return Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          //borderRadius: BorderRadius.circular(16),
        ),
        child: TextField(
          obscureText: true,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Password',
          ),
          controller: passwordController,
        )
    );
  }

  Widget  SignInButton(){
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


///////////////////////////////////////////////FUNCTIONS/////////////////////////////////////////

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
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home(user)));
    }
  }
}


////////////////////////////////////////////HOME PAGE/////////////////////////////////////////////////////

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
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), ModalRoute.withName('/'));
  }
}


