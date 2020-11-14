import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dropdown/flutter_dropdown.dart';

class OpenList extends StatefulWidget {
  @override
  _OpenListState createState() => _OpenListState();
}

class _OpenListState extends State<OpenList> {

  List <Widget> eligibleList (AsyncSnapshot snapshot){
    return snapshot.data.documents.map<Widget>((document){
      return Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.circular(2)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(document['name']),
            SizedBox(width: 5,),
            Text(document['type']),
            SizedBox(width: 5,),
            Spacer(),
            RaisedButton(
              color: Colors.white,
              child: Text('Select'),
              onPressed: (){
                Firestore.instance.collection("zakatTracker").getDocuments().then((querySnapshot) {
                  querySnapshot.documents.forEach((result) {
                    Firestore.instance
                        .collection("zakatTracker")
                        .document(result.documentID)
                        .collection("profitSub")
                        .getDocuments()
                        .then((querySnapshot) {
                      querySnapshot.documents.forEach((result) {
                        print(result.data['profit']);
                      });
                    });
                  });
                });
              },
            ),
            SizedBox(width: 5,),
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
        title: Text('Select list'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: StreamBuilder(
                stream: Firestore.instance.collection('zakatTracker').snapshots(),
                builder: (context, snapshot){
                  if(snapshot.data == null) return CircularProgressIndicator();
                  return Column(
                    children: eligibleList(snapshot),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
