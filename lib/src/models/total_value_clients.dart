class TotalValueClients {
  String? client;
  double? total;

  TotalValueClients({this.client, this.total});

  TotalValueClients.fromJson(Map<String, dynamic> json) {
    // codeBranch = json['codAssocRelaciona'];
    client = json['razao'];
    total = json['valorTotal'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    // data['codAssocRelaciona'] = codeBranch;
    data['razao'] = client;
    data['valorTotal'] = total;
    return data;
  }
}
