import 'package:flutter/material.dart';
import 'package:flutteriezakat/block/navigation_bloc.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:flutteriezakat/goldprice.dart';
import 'package:flutteriezakat/income_expense/balance.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:flutteriezakat/zakat_info/businessInfo.dart';
import 'package:flutteriezakat/zakat_info/fitrahInfo.dart';
import 'package:flutteriezakat/zakat_info/goldInfo.dart';
import 'package:flutteriezakat/zakat_info/incomeInfo.dart';
import 'package:flutteriezakat/zakat_info/livestockInfo.dart';
import 'package:flutteriezakat/zakat_info/plantationInfo.dart';
import 'package:flutteriezakat/zakat_info/sharesInfo.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutteriezakat/database.dart';
import 'package:flutteriezakat/zakat_records/view_zakat_list.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';


class HomePage extends StatelessWidget with NavigationStates {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      //home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

////////////////////////homepage//////////////////////////

class MyHomePage extends StatefulWidget {

  /*final FirebaseUser user;
  MyHomePage(this.user, {Key key}) : super(key: key);*/

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  var selected = 'BURGER';
  bool loading = false;

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
    return loading ? Loading() : WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text('Zakat Calculator'),
        ),
        drawer: CustomDrawer(),
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  height: 200.0,
                ),
                ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black, Colors.transparent])
                          .createShader(
                          Rect.fromLTRB(0, 0, rect.width, rect.height));
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset('..',
                        height: 280.0, fit: BoxFit.cover)
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(250, 20, 10, 0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return zakatList();
                      }));
                    },
                    child: Text('View your Zakat records', style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                    ),),
                  ),
                ),
                Positioned(
                    top: 200.0,
                    left: 40.0,
                    child: Column(
                      children: <Widget>[
                        Text('ZAKAT FOR',
                            style: TextStyle(
                              fontFamily: 'Oswald',
                              fontSize: 25.0,
                              fontWeight: FontWeight.w400,
                              color: Colors.black45,
                            )
                        )
                      ],
                    )

                ),
                Positioned(
                    top: 220.0,
                    left: 40.0,
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text('MUSLIM',
                                style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                            Text(',',
                                style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontSize: 50.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                            SizedBox(width: 0.0),
                            Text('THAI',
                                style: TextStyle(
                                    fontFamily: 'Oswald',
                                    fontSize: 35.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black)),
                          ],
                        )
                      ],
                    )),
              ],
            ),
            //Get out of the stack for the options
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return businessInfo();
                        }));
                        getGoldPrice();
                      },
                      child: _buildMenuItem('Business', Icons.business_center)),
                  FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return incomeInfo();
                        }));
                      },
                      child: _buildMenuItem('Income', Icons.attach_money)),
                  FlatButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return sharesInfo();
                        }));
                      },
                      child: _buildMenuItem('Shares', Icons.attach_money)),
                ]),
            Divider(
              height: 50,
              thickness: 0.5,
              color: Colors.green.withOpacity(1),
              indent: 32,
              endIndent: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return goldInfo();
                      }));
                    },
                    child: _buildMenuItem('Gold', Icons.attach_money)),
                FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return livestockInfo();
                      }));
                    },
                    child: _buildMenuItem('Livestock', Icons.attach_money)),
                FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return plantationInfo();
                      }));
                    },
                    child: _buildMenuItem('Plantation', Icons.attach_money)),
              ],
            ),
            Divider(
              height: 50,
              thickness: 0.5,
              color: Colors.green.withOpacity(1),
              indent: 32,
              endIndent: 32,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                FlatButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return fitrahInfo();
                      }));
                    },
                    child: _buildMenuItem('Fitrah', Icons.attach_money)),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          backgroundColor: Colors.green,
          child: Icon(Icons.info_outline),
        ),
      ),
    );
  }



  Widget _buildMenuItem(String Name, iconData) {
    return InkWell(
        splashColor: Colors.transparent,
        /*onTap: () {
          selectMenuOption(Name);
        },*/
        child: AnimatedContainer(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 300),
            height: selected == Name ? 100.0 : 75.0,
            width: selected == Name ? 100.0 : 75.0,
            color: selected == Name ? Colors.black45 : Colors.transparent,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                iconData,
                color: selected == Name ? Colors.white : Colors.black,
                size: 25.0,
              ),
              SizedBox(height: 12.0),
              Text(Name,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: selected == Name ? Colors.white : Colors.black,
                      fontSize: 10.0))
            ])));
  }

  selectMenuOption(String Name) {
    setState(() {
      selected = Name;
    });
  }

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => new AlertDialog(
        title: new Text('Are you sure?'),
        content: new Text('Do you want to exit from Zakat me?'),
        actions: <Widget>[
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(false),
            child: Text("NO"),
          ),
          SizedBox(height: 16),
          new GestureDetector(
            onTap: () => Navigator.of(context).pop(true),
            child: Text("YES"),
          ),
        ],
      ),
    ) ??
        false;
  }

}