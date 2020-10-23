class percentType {
  int typeId;
  String name;

  percentType({this.typeId, this.name});

  static List<percentType> getPercentType(){
    return<percentType>[
      percentType(typeId: 1, name: "Use only natural resources"),
      percentType(typeId: 2, name: "Use animal or machinery"),
      percentType(typeId: 3, name: "Use both"),
    ];
  }
}