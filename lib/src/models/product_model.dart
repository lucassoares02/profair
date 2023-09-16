class ProductModel {
  int? codeProduct;
  String? title;
  String? packing;
  int? coefficient;
  double? price;
  String? amount;
  String? complement;
  String? brand;
  double? total;
  double? unitPrice;

  ProductModel({this.codeProduct, this.title, this.packing, this.coefficient, this.price, this.amount, this.total, this.unitPrice, this.brand, this.complement});

  ProductModel.fromJson(Map<String, dynamic> json) {
    codeProduct = json["codMercadoria"];
    title = json["nomeMercadoria"];
    packing = json["embMercadoria"];
    coefficient = json["fatorMerc"];
    complement = json["complemento"];
    brand = json["marca"];
    price = double.parse(json["precoMercadoria"].toString());
    amount = json["quantMercadoria"].toString();
    unitPrice = json["precoUnit"];
    total = json["valorTotal"] != null ? double.parse(json["valorTotal"].toString()) : json["valorTotal"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["codMercadoria"] = codeProduct;
    data["nomeMercadoria"] = title;
    data["embMercadoria"] = packing;
    data["fatorMerc"] = coefficient;
    data["complemento"] = complement;
    data["marca"] = brand;
    data["precoMercadoria"] = price;
    data["precoUnit"] = unitPrice;
    data["quantMercadoria"] = amount;
    data["valorTotal"] = total;
    return data;
  }
}
