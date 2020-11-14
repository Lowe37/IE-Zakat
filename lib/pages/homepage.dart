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
import 'package:flutteriezakat/zakat_info/treasureInfo.dart';
import 'package:flutteriezakat/zakat_records/view_zakat_list.dart';
import 'package:flutteriezakat/zakat_types/treasure.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'Notepage.dart';


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

  Widget zakatType(BuildContext context) {
    String Name;
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
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
                        return viewZakatList();
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
          ),
          Expanded(
            child: GridView.count(crossAxisCount: 4,
            children: <Widget>[
              FlatButton(
                  onPressed: (){},
                  child: _buildMenuItem('Business', Icons.attach_money)
              ),
              FlatButton(
                onPressed: (){},
                child: _buildMenuItem('Gold', Icons.attach_money),
              ),
              FlatButton(
                  onPressed: (){},
                  child: _buildMenuItem('Income', Icons.attach_money)
              ),
              FlatButton(
                  onPressed: (){},
                  child: _buildMenuItem('Treasure', Icons.attach_money)
              ),
              FlatButton(
                  onPressed: (){},
                  child: _buildMenuItem('Savings', Icons.attach_money)
              ),
              FlatButton(
                  onPressed: (){},
                  child: _buildMenuItem('Plantation', Icons.attach_money)
              ),
              FlatButton(
                  onPressed: (){},
                  child: _buildMenuItem('Livestock', Icons.attach_money)
              ),
              FlatButton(
                  onPressed: (){},
                  child: _buildMenuItem('Fitrah', Icons.attach_money)
              ),
            ],),
          )
        ],
      ),
    );
  }

  Widget _buildMenuItem(String Name, iconData) {
    return InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          selectMenuOption(Name);
          //expenseInputDialog(context);
          print('You selected $Name');
          switch(Name){
            case "Business":{
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return businessInfo();
              }));
              getGoldPrice();
            }
            break;

            case "Gold":{
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return goldInfo();
              }));
            }
            break;

            case "Income":{
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return incomeInfo();
              }));
            }
            break;

            case "Treasure":{
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return treasureInfo();
              }));
            }
            break;

            case "Savings":{
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return sharesInfo();
              }));
            }
            break;

            case "Plantation":{
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return plantationInfo();
              }));
            }
            break;

            case "Livestock":{
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return livestockInfo();
              }));
            }
            break;

            case "Fitrah":{
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return fitrahInfo();
              }));
            }
            break;
          }
        },
        child: AnimatedContainer(
            curve: Curves.easeIn,
            duration: Duration(milliseconds: 300),
            height: selected == Name ? 75.0 : 75.0,
            width: selected == Name ? 100.0 : 75.0,
            color: selected == Name ? Colors.green : Colors.transparent,
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(
                iconData,
                color: selected == Name ? Colors.white : Colors.black,
                size: 30.0,
              ),
              SizedBox(height: 12.0),
              Text(Name,
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      color: selected == Name ? Colors.white : Colors.black,
                      fontSize: 15.0))
            ])));

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
        body: zakatType(context),
        /*body: ListView(
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
          ],
        ),*/
        floatingActionButton: FloatingActionButton(
          onPressed: () {

          },
          backgroundColor: Colors.green,
          child: Icon(Icons.info_outline),
        ),
      ),
    );
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