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
    totBusiness = 0;
    totGold = 0;
    totSalary = 0;
    totSavings = 0;
    totPlant = 0;
    totTreasure = 0;
    totLivestock = 0;
    totLivestockGoat = 0;

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
            border: Border.all(color: Colors.teal, width: 2),
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

  double totBusiness;
  double newValueBusiness;

  void retrieveZakatBusiness (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).where('category', isEqualTo: 'Business').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueBusiness = double.parse(result.data['zakatAmount'].toString());
        print(newValueBusiness);
        total += newValueBusiness;
        //print(result.data['profit']);
      });
      totBusiness = total;
    });
  }

  double totGold;
  double newValueGold;

  void retrieveZakatGold (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).where('category', isEqualTo: 'Gold').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueGold = double.parse(result.data['zakatAmount'].toString());
        print(newValueGold);
        total += newValueGold;
        //print(result.data['profit']);
      });
      totGold = total;
    });
  }

  double totSalary;
  double newValueSalary;

  void retrieveZakatSalary (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).where('category', isEqualTo: 'Salary').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueSalary = double.parse(result.data['zakatAmount'].toString());
        print(newValueSalary);
        total += newValueSalary;
        //print(result.data['profit']);
      });
      totSalary = total;
    });
  }

  double totSavings;
  double newValueSavings;

  void retrieveZakatSavings (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).where('category', isEqualTo: 'Savings').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueSavings = double.parse(result.data['zakatAmount'].toString());
        print(newValueSavings);
        total += newValueSavings;
        //print(result.data['profit']);
      });
      totSavings = total;
    });
  }

  double totPlant;
  double newValuePlant;

  void retrieveZakatPlant (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).where('category', isEqualTo: 'Plantation').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValuePlant = double.parse(result.data['zakatAmount'].toString());
        print(newValuePlant);
        total += newValuePlant;
        //print(result.data['profit']);
      });
      totPlant = total;
    });
  }

  double totTreasure;
  double newValueTreasure;

  void retrieveZakatTreasure (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).where('category', isEqualTo: 'Treasure').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueTreasure = double.parse(result.data['zakatAmount'].toString());
        print(newValueTreasure);
        total += newValueTreasure;
        //print(result.data['profit']);
      });
      totTreasure = total;
    });
  }

  double totLivestock;
  double newValueLivestock;

  void retrieveZakatLivestock (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).where('category', isEqualTo: 'Livestock: Cow').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueLivestock = double.parse(result.data['zakatAmount'].toString());
        print(newValueLivestock);
        total += newValueLivestock;
        //print(result.data['profit']);
      });
      totLivestock = total;
    });
  }

  double totLivestockGoat;
  double newValueLivestockGoat;

  void retrieveZakatLivestockGoat (){
    double total = 0.0;
    Firestore.instance.collection("zakat").where('userID', isEqualTo: userID).where('category', isEqualTo: 'Livestock: Goat').getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((result) {
        print(result.documentID);
        newValueLivestockGoat = double.parse(result.data['zakatAmount'].toString());
        print(newValueLivestockGoat);
        total += newValueLivestockGoat;
        //print(result.data['profit']);
      });
      totLivestockGoat = total;
    });
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
                    return Container(
                      height: 540,
                      width: 700,
                      padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      margin: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.teal, width: 2),
                          borderRadius: BorderRadius.circular(10)
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Total', style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.bold, fontSize: 35),),
                          SizedBox(height: 20,),
                          Row(
                            children: [
                              Text('Business', style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                              Spacer(),
                              Text(totBusiness.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Gold', style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                              Spacer(),
                              Text(totGold.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Salary', style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                              Spacer(),
                              Text(totSalary.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Savings', style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                              Spacer(),
                              Text(totSavings.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Plantation', style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                              Spacer(),
                              Text(totPlant.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Treasure', style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                              Spacer(),
                              Text(totTreasure.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Livestock: Cow', style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                              Spacer(),
                              Text(totLivestock.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Text('Livestock: Goat', style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                              Spacer(),
                              Text(totLivestockGoat.toString().replaceAllMapped(reg, mathFunc), style: TextStyle(fontFamily: 'Nunito', fontSize: 20),),
                            ],
                          ),
                          SizedBox(height: 50,),
                          Align(
                            alignment: Alignment.center,
                            child: RaisedButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18)
                              ),
                              onPressed: (){
                                setState(() {
                                  retrieveZakatBusiness();
                                  retrieveZakatGold();
                                  retrieveZakatSalary();
                                  retrieveZakatSavings();
                                  retrieveZakatPlant();
                                  retrieveZakatTreasure();
                                  retrieveZakatLivestock();
                                  retrieveZakatLivestockGoat();
                                });
                              },
                              color: Colors.teal,
                              child: Text('Refresh', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                            ),
                          ),
                        ],
                      ),
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