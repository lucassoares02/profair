class ProductsProviderModel {
  int? codeProvider;
  String? nameProvider;
  int? codeProduct;
  String? nameProduct;
  String? packing;
  int? coefficient;
  double? productPrice;
  double? unitPrice;
  double? totalValue;
  String? totalVolume;

  ProductsProviderModel({
    this.codeProvider,
    this.nameProvider,
    this.codeProduct,
    this.nameProduct,
    this.packing,
    this.coefficient,
    this.productPrice,
    this.unitPrice,
    this.totalValue,
    this.totalVolume,
  });

  ProductsProviderModel.fromJson(Map<String, dynamic> json) {
    codeProvider = json['codForn'];
    nameProvider = json['nomeForn'];
    codeProduct = json['codMercadoria'];
    nameProduct = json['nomeMercadoria'];
    packing = json['embMercadoria'];
    coefficient = json['fatorMerc'];
    productPrice = double.parse(json['precoMercadoria'].toString());
    unitPrice = json['precoUnit'];
    totalValue = double.parse(json['valorTotal'].toString());
    totalVolume = json['volumeTotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['codForn'] = codeProvider;
    data['nomeForn'] = nameProvider;
    data['codMercadoria'] = codeProduct;
    data['nomeMercadoria'] = nameProduct;
    data['embMercadoria'] = packing;
    data['fatorMerc'] = coefficient;
    data['precoMercadoria'] = productPrice;
    data['precoUnit'] = unitPrice;
    data['valorTotal'] = totalValue;
    data['volumeTotal'] = totalVolume;
    return data;
  }
}
