class BuyersModel {
  int? codeBuyer;
  String? nameBuyer;
  String? category;
  double? total;
  String? volume;

  BuyersModel({
    this.codeBuyer,
    this.nameBuyer,
    this.category,
    this.total,
    this.volume,
  });

  BuyersModel.fromJson(Map<String, dynamic> json) {
    codeBuyer = json['codCompr'];
    nameBuyer = json['nomeCompr'];
    category = json['descCatComprador'];
    total = json['valorTotal'].toDouble();
    volume = json['volumeTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codCompr'] = codeBuyer;
    data['nomeCompr'] = nameBuyer;
    data['descCatComprador'] = category;
    data['valorTotal'] = total;
    data['volumeTotal'] = volume;
    return data;
  }
}
