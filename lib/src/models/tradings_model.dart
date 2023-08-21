class TradingsModel {
  int? code;
  String? title;
  int? provider;
  String? totalValue;
  String? totalVolume;

  TradingsModel({this.code, this.title, this.provider, this.totalValue, this.totalVolume});

  TradingsModel.fromJson(Map<String, dynamic> json) {
    code = json['codNegociacao'];
    title = json['descNegociacao'];
    provider = json['codFornNegociacao'];
    totalValue = json['valorTotal'];
    totalVolume = json['volumeTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codNegociacao'] = code;
    data['descNegociacao'] = title;
    data['codFornNegociacao'] = provider;
    data['valorTotal'] = totalValue;
    data['volumeTotal'] = totalVolume;
    return data;
  }
}
