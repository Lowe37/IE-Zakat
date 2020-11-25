import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flutteriezakat/block/navigation_bloc.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:flutteriezakat/goldprice.dart';
import 'package:flutteriezakat/income_expense/balance.dart';
import 'package:flutteriezakat/pages/AddZakat.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:flutteriezakat/shared/loading.dart';
import 'package:flutteriezakat/zakat_records/view_zakat_list.dart';
import 'package:flutteriezakat/zakat_types/business.dart';
import 'package:flutteriezakat/zakat_types/fitrah.dart';
import 'package:flutteriezakat/zakat_types/gold.dart';
import 'package:flutteriezakat/zakat_types/income.dart';
import 'package:flutteriezakat/zakat_types/livestock.dart';
import 'package:flutteriezakat/zakat_types/plantation.dart';
import 'package:flutteriezakat/zakat_types/savings.dart';
import 'package:flutteriezakat/zakat_types/treasure.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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

  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    inputData();
    totCost = 0;
  }

  String userID;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    userID = uid;
    print(userID);
    // here you write the codes to input the data into firestore
  }

  double totCost;
  double newValueZakatAmount;

  void retrieveZakatAmount (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueZakatAmount = double.parse(result.data['zakatAmount'].toString());
        print(newValueZakatAmount);
        total += newValueZakatAmount;
        //print(result.data['profit']);
      });
      totCost = total;
    });
  }

  var selected = 'BURGER';
  bool loading = false;

  final snackBar = SnackBar(
    content: Row(
      children: [
        Text("Your record has been saved."),
        Spacer(),
        Icon(MdiIcons.checkCircle, color: Colors.green,),
      ],
    ),
  );

  void deleteZakatTrackerDocuments() async {
    Firestore.instance.collection('zakatTracker').where('userID', isEqualTo: userID).getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
    }
    }
    );
  }

  void deleteZakatDocuments() async {
    Firestore.instance.collection('zakat').where('userID', isEqualTo: userID).getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    }
    );
  }

  Future<void> _confirmDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: AlertDialog(
            title: Text('Reset all information?'),
            content: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                  ],
                ),
              ),
            ),
            actions: <Widget>[
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)
                ),
                child: Text('Cancel', style: TextStyle(color: Colors.grey),),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              RaisedButton(
                onPressed: () {
                  inputData();
                  deleteZakatTrackerDocuments();
                  deleteZakatDocuments();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return MyHomePage();
                  }));
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)
                ),
                child: Text('Reset',style: TextStyle(fontWeight: FontWeight.bold),),
                color: Colors.red,
              ),
            ],
          ),
        );
      },
    );
  }

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  Widget zakatType(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Column(
        children: <Widget>[
          Row(
            children: [
              Spacer(),
              IconButton(
                icon: Icon(MdiIcons.deleteEmptyOutline),
                onPressed: (){
                  _confirmDialog();
                },
              ),
            ],
          ),
          SizedBox(
            height: 150,
            child: Stack(
              children: <Widget>[
                Container(
                  height: 150.0,
                ),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text('ZAKAT',
                          style: TextStyle(
                            fontFamily: 'Oswald',
                            fontSize: 25.0,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45,
                          )
                      ),
                      Row(
                        children: <Widget>[
                          Text('CALCU',
                              style: TextStyle(
                                  fontFamily: 'Oswald',
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.cyan)),
                          SizedBox(height: 10,),
                          Text('LATOR',
                              style: TextStyle(
                                  fontFamily: 'Oswald',
                                  fontSize: 35.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 320,
            width: 330,
            child: GridView.count(crossAxisCount: 3,
            children: <Widget>[
              FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return business();
                    }));
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Icon(MdiIcons.store, size: 40,),
                        SizedBox(height: 10,),
                        Text('Business'),
                      ],
                    ),
                  ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return gold();
                  }));
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(MdiIcons.gold, size: 40,),
                      SizedBox(height: 10,),
                      Text('Gold'),
                    ],
                  ),
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return income();
                  }));
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(MdiIcons.cash100, size: 40,),
                      SizedBox(height: 10,),
                      Text('Salary'),
                    ],
                  ),
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Savings();
                  }));
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(MdiIcons.piggyBank, size: 40,),
                      SizedBox(height: 10,),
                      Text('Savings'),
                    ],
                  ),
                ),
              ),
              FlatButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return plantation();
                  }));
                },
                child: Container(
                  child: Column(
                    children: [
                      Icon(MdiIcons.treeOutline, size: 40,),
                      SizedBox(height: 10,),
                      Text('Plantation'),
                    ],
                  ),
                ),
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Treasure();
                    }));
                  },
                  child: Container(
                    child: Column(
                      children: [
                      Icon(MdiIcons.treasureChest, size: 40,),
                        SizedBox(height: 10,),
                      Text('Treasure'),
                    ],
                  ),
                ),
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return livestock();
                    }));
                  },
                child: Container(
                  child: Column(
                    children: [
                      Icon(MdiIcons.cow, size: 40,),
                      SizedBox(height: 10,),
                      Text('Livestock'),
                    ],
                  ),
                ),
              ),
              FlatButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return Fitrah();
                    }));
                  },
                child: Container(
                  child: Column(
                    children: [
                      Icon(MdiIcons.giftOutline, size: 40,),
                      SizedBox(height: 10,),
                      Text('Fitrah'),
                    ],
                  ),
                ),
              ),
            ],),
          ),
          StreamBuilder<Object>(
            stream: Firestore.instance.collection('zakat').where('userID', isEqualTo: userID).snapshots(),
            builder: (context, snapshot) {
              if(snapshot == null) return
                Center(child: Text("Your records are empty\nPress '+' to add records.",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'Nunito'),));
              return Column(
                children: [
                  InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return viewZakatList();
                        }));
                      },
                      child: Text('Total Zakat: '+totCost.toString().replaceAllMapped(reg, mathFunc)+' THB', style: TextStyle(fontWeight: FontWeight.w200,fontFamily: 'Nunito', fontSize: 20),)),
                  SizedBox(height: 10),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18)
                    ),
                    onPressed: (){
                      setState(() {
                        retrieveZakatAmount();
                      });
                    },
                    color: Colors.teal,
                    child: Text('Refresh', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ],
              );
            }
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Zakat Calculator'),
        ),
        drawer: CustomDrawer(),
        body: zakatType(context),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return AddZakatPage();
              }));
              //_addDialog();
            },
            backgroundColor: Colors.cyan,
            child: Icon(Icons.add),
          )
      ),
    );
  }

}