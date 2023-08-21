class ProductModel {
  int? codeProduct;
  String? title;
  String? packing;
  int? coefficient;
  double? price;
  String? amount;
  double? total;

  ProductModel({this.codeProduct, this.title, this.packing, this.coefficient, this.price, this.amount, this.total});

  ProductModel.fromJson(Map<String, dynamic> json) {
    codeProduct = json["codMercadoria"];
    title = json["nomeMercadoria"];
    packing = json["embMercadoria"];
    coefficient = json["fatorMerc"];
    price = json["precoMercadoria"].toDouble();
    amount = json["quantMercadoria"];
    total = json["valorTotal"] != null ? json["valorTotal"].toDouble() : json["valorTotal"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["codMercadoria"] = codeProduct;
    data["nomeMercadoria"] = title;
    data["embMercadoria"] = packing;
    data["fatorMerc"] = coefficient;
    data["precoMercadoria"] = price;
    data["quantMercadoria"] = amount;
    data["valorTotal"] = total;
    return data;
  }
}
