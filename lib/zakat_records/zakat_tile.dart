import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/zakat_records/zakat.dart';

class ZakatTile extends StatelessWidget {

  final Zakat zakatResult;
  ZakatTile({this.zakatResult});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20, 6, 20, 0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.green[zakatResult.zakatAmount],
          ),
          title: Text(zakatResult.name),
        ),
      ),
    );
  }
}
