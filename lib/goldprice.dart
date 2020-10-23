import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String _goldPrice;
String get goldPrice5x => _goldPrice;

Future<String> getGoldPrice() async {
  http.Response response = await http.get(
      Uri.encodeFull("http://www.thaigold.info/RealTimeDataV2/gtdata_.txt"),
      headers: {
        "Accept": "application/json"
      }
  );

  List data = json.decode(response.body);
  //print(data[4]["ask"]);
  var goldPrice = (data[4]["ask"]);
  print(goldPrice);
}