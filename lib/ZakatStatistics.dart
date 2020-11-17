import 'package:flutter/material.dart';
import 'package:flutteriezakat/drawer.dart';
import 'package:fl_chart/fl_chart.dart';

class ZakatStatistics extends StatefulWidget {
  @override
  _ZakatStatisticsState createState() => _ZakatStatisticsState();
}

class _ZakatStatisticsState extends State<ZakatStatistics> {

  List<PieChartSectionData> _sections = List <PieChartSectionData>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    PieChartSectionData list1 = PieChartSectionData(
      color: Colors.yellow,
      value: 20,
      title: 'Business',
      radius: 50,
    );

    PieChartSectionData list2 = PieChartSectionData(
      color: Colors.red,
      value: 20,
      title: 'Income',
      radius: 50,
    );

    PieChartSectionData list3 = PieChartSectionData(
      color: Colors.green,
      value: 20,
      title: 'Plantation',
      radius: 50,
    );

    PieChartSectionData list4 = PieChartSectionData(
      color: Colors.blue,
      value: 20,
      title: 'Savings',
      radius: 50,
    );

    _sections = [list1, list2, list3, list4];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Statistics'),
        backgroundColor: Colors.cyan,
      ),
      drawer: CustomDrawer(),
      body: Container(
        child: PieChart(
          PieChartData(
            sections: _sections,
          ),
        ),
      ),
    );
  }
}
