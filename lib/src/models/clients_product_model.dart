class ClientsProductModel {
  int? code;
  int? provider;
  String? nameProduct;
  String? packing;
  String? nameClient;
  int? codeClient;
  double? price;
  String? coefficient;
  double? totalValue;

  ClientsProductModel({this.code, this.provider, this.nameProduct, this.packing, this.nameClient, this.codeClient, this.price, this.coefficient, this.totalValue});

  ClientsProductModel.fromJson(Map<String, dynamic> json) {
    print(json);
    code = json['codMercadoria'];
    provider = json['codFornMerc'];
    nameProduct = json['nomeMercadoria'];
    packing = json['embMercadoria'];
    nameClient = json['razao'];
    codeClient = json['codAssociado'];
    price = json['precoMercadoria'].toDouble();
    coefficient = json['fatorMerc'];
    totalValue = json['valorTotal'].toDouble();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codMercadoria'] = code;
    data['codFornMerc'] = provider;
    data['nomeMercadoria'] = nameProduct;
    data['embMercadoria'] = packing;
    data['razao'] = nameClient;
    data['codAssociado'] = codeClient;
    data['precoMercadoria'] = price;
    data['fatorMerc'] = coefficient;
    data['valorTotal'] = totalValue;
    return data;
  }
}
