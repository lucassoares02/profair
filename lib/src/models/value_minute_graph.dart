class ValueMinutesGraph {
  String? hour;
  double? value;
  double? totalValue;

  ValueMinutesGraph({this.hour, this.value, this.totalValue});

  ValueMinutesGraph.fromJson(Map<String, dynamic> json) {
    // codeBranch = json['codAssocRelaciona'];
    hour = json['hour'];
    value = json['value'];
    totalValue = json['total_value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['codAssocRelaciona'] = codeBranch;
    data['hour'] = hour;
    data['value'] = value;
    data['total_value'] = totalValue;
    return data;
  }
}
