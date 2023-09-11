class PercentageClientsModel {
  int? total;
  int? parcial;
  String? percentage;

  PercentageClientsModel({this.total, this.parcial, this.percentage});

  PercentageClientsModel.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    parcial = json['realizados'];
    percentage = json['porcentagem'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['realizados'] = parcial;
    data['porcentagem'] = percentage;
    return data;
  }
}
