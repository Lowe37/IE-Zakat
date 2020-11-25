import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/ZakatStats/Zakat.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutteriezakat/drawer.dart';

class ZakatStatistics extends StatefulWidget {
  ZakatStatistics({Key key}) : super(key: key);

  @override
  _ZakatStatisticsState createState() => _ZakatStatisticsState();
}

class _ZakatStatisticsState extends State<ZakatStatistics> {


  @override
  void initState() {
    super.initState();
    inputData();
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

  List<charts.Series<ZakatParse, String>> _seriesPieData;
  List<ZakatParse> myData;
  _generateData(myData){
    _seriesPieData = List<charts.Series<ZakatParse, String>>();
    _seriesPieData.add(
      charts.Series(
        domainFn: (ZakatParse zakat,_)=> zakat.category.toString(),
        measureFn: (ZakatParse zakat,_)=> int.parse(zakat.amount),
        colorFn: (ZakatParse zakat,_)=> charts.ColorUtil.fromDartColor(Color(int.parse(zakat.colorVal))),
        id: 'Zakat',
        data: myData,
        labelAccessorFn: (ZakatParse row,_)=> "${row.category}"
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your statistics'),
        backgroundColor: Colors.cyan,
      ),
      drawer: CustomDrawer(),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(context){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('zakatTracker').where('userID', isEqualTo: userID).snapshots(),
      builder: (context, snapshot){
        if(!snapshot.hasData){
          return Text('Loading...');
        }
        else {
          List<ZakatParse> zakat = snapshot.data.documents.map((documentSnapshot) => ZakatParse.fromMap(documentSnapshot.data)).toList();
          return _buildChart(context, zakat);
        }
      }
    );
}

Widget _buildChart(BuildContext context, List<ZakatParse> zakat){
    myData = zakat;
    _generateData(myData);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: charts.BarChart(_seriesPieData,
              animate: true,
                animationDuration: Duration(seconds: 2),
                behaviors: [
                  charts.DatumLegend(
                    entryTextStyle: charts.TextStyleSpec(
                      color: charts.MaterialPalette.cyan.shadeDefault,
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
