class ZakatParse {
  final String category;
  final String amount;
  final String colorVal;
  ZakatParse(this.category,this.amount,this.colorVal);

  ZakatParse.fromMap(Map<String, dynamic> map)
      : assert(map['category'] != null),
        assert(map['amount'] != null),
        assert(map['colorVal'] != null),
        category = map['category'],
        amount = map['amount'],
        colorVal = map['colorVal'];


  @override
  String toString() => "Record<$category:$amount:$colorVal>";
}