class BuyersModel {
  int? codeBuyer;
  String? nameBuyer;
  String? category;
  double? total;
  String? volume;
  String? color;
  // Somente teste de conexão com github

  BuyersModel({
    this.codeBuyer,
    this.nameBuyer,
    this.category,
    this.total,
    this.volume,
    this.color,
  });

  BuyersModel.fromJson(Map<String, dynamic> json) {
    codeBuyer = json['codCompr'];
    nameBuyer = json['nomeCompr'];
    category = json['descCatComprador'];
    color = json['color'];
    total = json['valorTotal'].toDouble();
    volume = json['volumeTotal'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codCompr'] = codeBuyer;
    data['nomeCompr'] = nameBuyer;
    data['descCatComprador'] = category;
    data['valorTotal'] = total;
    data['color'] = color;
    data['volumeTotal'] = volume;
    return data;
  }
}
