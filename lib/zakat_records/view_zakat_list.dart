import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:flutteriezakat/signin_and_registration/sign_in_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutteriezakat/zakat_tracker/SubCategory.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';
import 'package:flushbar/flushbar.dart';

extension ListUtils<T> on List<T> {
  num sumBy(num f(T element)) {
    num sum = 0;
    for(var item in this) {
      sum += f(item);
    }
    return sum;
  }
}

class viewZakatList extends StatefulWidget {

  @override
  _viewZakatListState createState() => _viewZakatListState();
}

class _viewZakatListState extends State<viewZakatList> with SingleTickerProviderStateMixin{

  final nameController = new TextEditingController();
  final costOrProfitController = new TextEditingController();
  final profitController = new TextEditingController();
  final costController = new TextEditingController();
  final noteController = new TextEditingController();

  @override
  void dispose() {
    noteController.dispose();
    nameController.dispose();
    costOrProfitController.dispose();
    profitController.dispose();
    costController.dispose();
    super.dispose();
  }

  AnimationController controller;
  Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    inputData();

    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });
    controller.forward();
  }

  final snackBar = SnackBar(
    content: Row(
      children: [
        Text("Your record has been saved."),
        Spacer(),
        Icon(MdiIcons.checkCircle, color: Colors.green,),
      ],
    ),
  );

  String userID;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void inputData() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    userID = uid;
    print(userID);
    // here you write the codes to input the data into firestore
  }

  String typeText;
  String categoryText;

  void addZakatTracker() async {
    Firestore.instance.collection('zakatTracker').add({
      'userID' : userID,
      'amount': nameController.text,
      'note' : noteController.text,
      'category' : categoryText,
      'type' : typeText,
      'date' : _date,

    }).then((value){
      print(value.documentID);
      Firestore.instance.collection('zakatTracker').document(value.documentID).updateData({
        'id' : value.documentID,
      });
    });
  }

  String costOrProfit;
  double newValue;
  double totalValue;

  void addCostOrProfit(docID) async {
    switch(costOrProfit){
      case 'Profit': {
        double total = 0.0;
        Firestore.instance.collection('zakatTracker').getDocuments().then((querySnapshot){
          querySnapshot.documents.forEach((result){
            newValue = double.parse(result.data['profit'].toString());
            //print(newValue);
            total += newValue;
          });
          totalValue = total;
          print(totalValue);
        });
      }
      break;
      case 'Cost': {
        Firestore.instance.collection('zakatTracker').document(docID).updateData({
          'cost' : double.parse(costOrProfitController.text),
        });
      }
      break;
    }
  }

  DateTime _date = new DateTime.now();

  void deleteList(docID) async {
    Firestore.instance.collection('zakat')
        .document(docID)
        .delete();
  }

  bool _validateAmount = false;
  bool _validateNote = false;

  final f = new DateFormat('yyyy-MM-dd');

  Future<void> _deleteDialogExpense(docID) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete record ?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[

              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancel', style: TextStyle(color: Colors.grey),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('Delete'),
              onPressed: () {
                deleteList(docID);
                setState(() {
                });
                Navigator.of(context).pop();
                Flushbar(
                  icon: Icon(MdiIcons.checkCircle, color: Colors.green,),
                  margin: EdgeInsets.all(8),
                  borderRadius: 8,
                  message:  "Your Zakat record has been deleted.",
                  duration:  Duration(seconds: 3),
                )..show(context);
              },
              color: Colors.red,
            ),
          ],
        );
      },
    );
  }

  RegExp reg = new RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  Function mathFunc = (Match match) => '${match[1]},';

  List <Widget> zakatTrackerList (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return Container(
        height: 120,
        width: 700,
        padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
        margin: EdgeInsets.all(3),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.cyan, width: 2),
            borderRadius: BorderRadius.circular(10)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(document['category'], style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 25),),
                Spacer(),
                Text(DateFormat("dd/MM/yyyy").format(document['date'].toDate())),
              ],
            ),
            SizedBox(height: 10,),
            Text('Zakat amount: '+document['zakatAmount'].toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 15),),
            SizedBox(height: 10,),
            Row(
              children: [
                Text('Wajib: '+document['wajibZakat'].toString(), style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 15),),
                Spacer(),
                InkWell(
                  child: Icon(MdiIcons.deleteOutline),
                  onTap: (){
                    _deleteDialogExpense(document['id']);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.cyan,
          title: Text('Summary'),
        ),
        //drawer: CustomDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StreamBuilder(
                  stream: Firestore.instance.collection('zakat').where('userID', isEqualTo: userID).snapshots(),
                  builder: (context, snapshot){
                    if(snapshot == null) return
                      Center(child: Text("Your records are empty\nPress '+' to add records.",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400, fontFamily: 'Nunito'),));
                    return Column(
                      children: zakatTrackerList(snapshot),
                    );
                  },
                ),
              ],
            ),
          ),
        ),

        /*Padding(
        padding: const EdgeInsets.all(0.0),
        child: StreamBuilder(
          stream: Firestore.instance.collection('zakatTracker').where('userID', isEqualTo: userID).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return new DataTable(
                columnSpacing: 20,
                columns: [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Date')),
                ],
                rows: _createRows(snapshot.data),
              );
                  } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),*/
    );
  }
}