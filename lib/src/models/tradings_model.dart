class TradingsModel {
  int? code;
  String? title;
  int? provider;
  String? totalValue;
  String? observation;
  String? term;
  String? totalVolume;
  int? sortOrder;

  TradingsModel({this.code, this.title, this.provider, this.totalValue, this.totalVolume, this.observation, this.term, this.sortOrder});

  TradingsModel.fromJson(Map<String, dynamic> json) {
    code = json['codNegociacao'];
    title = json['descNegociacao'];
    provider = json['codFornNegociacao'];
    observation = json['observacao'];
    term = json['prazo'];
    totalValue = json['valorTotal'];
    totalVolume = json['volumeTotal'].toString();
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codNegociacao'] = code;
    data['descNegociacao'] = title;
    data['codFornNegociacao'] = provider;
    data['valorTotal'] = totalValue;
    data['volumeTotal'] = totalVolume;
    data['sort_order'] = sortOrder;
    return data;
  }
}
