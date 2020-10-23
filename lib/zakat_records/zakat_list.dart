import 'package:flutteriezakat/zakat_records/zakat.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutteriezakat/zakat_records/zakat_tile.dart';

class ZakatList extends StatefulWidget {
  @override
  _ZakatListState createState() => _ZakatListState();
}

class _ZakatListState extends State<ZakatList> {
  @override
  Widget build(BuildContext context) {
    final zakat = Provider.of<List<Zakat>>(context) ?? [];

    return ListView.builder(
      itemCount: zakat.length,
      itemBuilder: (context, index){
          return ZakatTile(zakatResult: zakat[index]);
        },
    );
  }
}

