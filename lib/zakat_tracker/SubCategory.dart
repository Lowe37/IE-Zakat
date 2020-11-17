import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

class SubCategory extends StatefulWidget {
  final doc;
  SubCategory(this.doc);

  @override
  _SubCategoryClassState createState() => _SubCategoryClassState();
}

class _SubCategoryClassState extends State<SubCategory> with SingleTickerProviderStateMixin {

  final costOrProfitController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
    costOrProfitController.dispose();
  }

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  DateTime _date = new DateTime.now();

  Future <Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(context: context, initialDate: _date, firstDate: new DateTime(2015), lastDate: new DateTime(2030));

    if(picked != null && picked != _date){
      print(new DateFormat("dd-MM-yyyy").format(_date));
      print('${_date.toString()}');
      setState(() {
        _date = picked;
      });
    }
  }

  Widget profitData (){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('zakatTracker')
          .document(widget.doc)
          .collection('profitSub')
          .snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return const Text("Press '+' to add data to your list");
        if (snapshot.hasData) {
          var doc = snapshot.data.documents;
          return new ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(height: 10,),
                              Text("Profit: "+doc[index].data['profit'].toString()),
                              SizedBox(
                                height: 10.0,
                              ),
                              //Text(doc[index].data['cost'].toString()),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  Widget costData (){
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('zakatTracker')
          .document(widget.doc)
          .collection('costSub')
          .snapshots(),
      builder: (context, snapshot) {
        if(!snapshot.hasData) return const Text("Press '+' to add data to your list");
        if (snapshot.hasData) {
          var doc = snapshot.data.documents;
          return new ListView.builder(
              itemCount: doc.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Card(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10,),
                            Text("Cost: "+doc[index].data['cost'].toString()),
                            SizedBox(
                              height: 10.0,
                            ),
                            //Text(doc[index].data['cost'].toString()),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else {
          return LinearProgressIndicator();
        }
      },
    );
  }

  AnimationController controller;
  Animation<double> scaleAnimation;
  String costOrProfit;

  Future<void> addTrackerDataDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: AlertDialog(
              title: Text('Add information'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    DropDown(
                      items: ["Profit", "Cost"],
                      hint: Text('Select type'),
                      isExpanded: true,
                      onChanged: (val){
                        costOrProfit = val.toString();
                        print(costOrProfit);
                      },
                    ),
                    SizedBox(height: 20,),
                    Text('Amount', style: TextStyle(fontWeight: FontWeight.w400),),
                    SizedBox(height: 10,),
                    TextField(
                      keyboardType: TextInputType.number,
                      controller: costOrProfitController,
                      decoration: InputDecoration(
                        //errorText: errorValidate ? 'List name is required' : null,
                          border: new OutlineInputBorder(
                            borderRadius: new BorderRadius.circular(10),
                          ),
                          hintText: 'Enter amount'
                      ),
                    ),
                  ],
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
                    costOrProfitController.clear();
                  },
                ),
                RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)
                  ),
                  child: Text('Add',style: TextStyle(fontWeight: FontWeight.bold),),
                  onPressed: () {
                    addTrackerData();
                    Navigator.of(context).pop();
                    costOrProfitController.clear();
                  },
                  color: Colors.green,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void addTrackerData () async {
    switch(costOrProfit){
      case 'Profit': {
        Firestore.instance.collection('zakatTracker').document(widget.doc).collection('profitSub').add({
          'profit': double.parse(costOrProfitController.text),
          'date' : _date,
        }).then((value){
          print(value.documentID);
          Firestore.instance.collection('zakatTracker').document(value.documentID).updateData({
            'id' : value.documentID,
          });
        });
      }
      break;
      case 'Cost': {
        Firestore.instance.collection('zakatTracker').document(widget.doc).collection('costSub').add({
          'cost': double.parse(costOrProfitController.text),
          'date' : _date,
        }).then((value){
          print(value.documentID);
          Firestore.instance.
          collection('costSub').
          document(value.documentID).
          setData({"id": value.documentID}, merge: true);
        });
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add records"),
          backgroundColor: Colors.cyan,
          bottom: TabBar(
            tabs: [
              Tab(
                child: Text('Profit'),
              ),
              Tab(
                child: Text('Cost'),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            profitData(),
            costData(),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTrackerDataDialog();
          },
          backgroundColor: Colors.cyan,
          child: Icon(Icons.add),
      ),
      ),
    );
  }
}