import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/ZakatStats/Zakat.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutteriezakat/drawer.dart';
/*
class ZakatStatPage extends StatefulWidget {
  ZakatStatPage({Key key}) : super(key: key);

  @override
  _ZakatStatPageState createState() {
    return _ZakatStatPageState();
  }
}

class _ZakatStatPageState extends State<ZakatStatPage> {

  @override
  void initState(){
    super.initState();
    inputData();
    _buildBody(context);
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

  List<charts.Series<ZakatParse,String>> _seriesBarData;
  List<ZakatParse> myData;
  _generateData(myData){
    _seriesBarData = List<charts.Series<ZakatParse, String>>();
    _seriesBarData.add(
      charts.Series(
        domainFn: (ZakatParse zakat,_) => zakat.category.toString(),
        measureFn: (ZakatParse zakat,_) => int.parse(zakat.amount.toString()),
        colorFn: (ZakatParse zakat,_) => charts.ColorUtil.fromDartColor(Color(int.parse(zakat.colorVal))),
        id: 'Zakat',
        data: myData,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Statistics'),
      backgroundColor: Colors.cyan,
      ),
      drawer: CustomDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('zakatTracker').where('userID', isEqualTo: userID).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return LinearProgressIndicator();
        } else {
          List<ZakatParse> zakat = snapshot.data.documents.map((documentSnapshot) => ZakatParse.fromMap(documentSnapshot.data)).toList();
          return _buildChart(context, zakat);
        }
      },
    );
  }

  Widget _buildChart(BuildContext context, List<ZakatParse> zakatData){
    myData = zakatData;
    _generateData(myData);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Your statistics', style: TextStyle(fontSize: 20, fontFamily: 'Nunito'),),
            Expanded(
              child: charts.PieChart(_seriesBarData,
              animate: true,
                animationDuration: Duration(seconds: 2),
                behaviors: [
                  new charts.DatumLegend(
                    entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.purple.shadeDefault,
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

 */