import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class viewZakatList extends StatefulWidget {
  @override
  _viewZakatListState createState() => _viewZakatListState();
}

class _viewZakatListState extends State<viewZakatList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Zakat lists'),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('zakat').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var doc = snapshot.data.documents;
              return new ListView.builder(
                  itemCount: doc.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Type: '+doc[index].data['type']),
                              SizedBox(height: 10.0,),
                              Text('Amount: '+doc[index].data['zakatAmount']),
                              SizedBox(height: 10.0,),
                              Text('Have to pay Zakat: '+doc[index].data['wajibZakat'].toString()),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return LinearProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}
