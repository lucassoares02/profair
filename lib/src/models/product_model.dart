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
  String? barcode;
  String? negotiation;
  bool? highlight;
  String? tag;

  ProductModel({
    this.codeProduct,
    this.title,
    this.packing,
    this.coefficient,
    this.price,
    this.amount,
    this.total,
    this.unitPrice,
    this.negotiation,
    this.brand,
    this.complement,
    this.barcode,
    this.highlight,
    this.tag,
  });

  ProductModel.fromJson(Map<String, dynamic> json) {
    codeProduct = json["codMercadoria"];
    title = json["nomeMercadoria"];
    barcode = json["codBarras"];
    packing = json["embMercadoria"];
    coefficient = json["fatorMerc"];
    complement = json["complemento"];
    negotiation = json["nego"];
    brand = json["marca"];
    price = double.parse(json["precoMercadoria"].toString());
    amount = json["quantMercadoria"].toString();
    unitPrice = double.parse(json["precoUnit"].toString());
    total = json["valorTotal"] != null ? double.parse(json["valorTotal"].toString()) : json["valorTotal"];
    highlight = json["highlight"] == null ? false : (json["highlight"] == 1 || json["highlight"] == true);
    tag = json["tag"];
  }

  factory ProductModel.clone(ProductModel product) {
    return ProductModel(
      amount: product.amount,
      brand: product.brand,
      codeProduct: product.codeProduct,
      coefficient: product.coefficient,
      negotiation: product.negotiation,
      barcode: product.barcode,
      complement: product.complement,
      packing: product.packing,
      price: product.price,
      title: product.title,
      total: product.total,
      unitPrice: product.unitPrice,
      highlight: product.highlight,
      tag: product.tag,
    );
  }

  ProductModel clone() {
    return ProductModel(
      amount: amount,
      brand: brand,
      codeProduct: codeProduct,
      barcode: barcode,
      coefficient: coefficient,
      complement: complement,
      negotiation: negotiation,
      packing: packing,
      price: price,
      title: title,
      total: total,
      unitPrice: unitPrice,
      highlight: highlight,
      tag: tag,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["codMercadoria"] = codeProduct;
    data["nomeMercadoria"] = title;
    data["codBarras"] = barcode;
    data["embMercadoria"] = packing;
    data["fatorMerc"] = coefficient;
    data["nego"] = negotiation;
    data["complemento"] = complement;
    data["marca"] = brand;
    data["precoMercadoria"] = price;
    data["precoUnit"] = unitPrice;
    data["quantMercadoria"] = amount;
    data["valorTotal"] = total;
    data["highlight"] = highlight;
    data["tag"] = tag;
    return data;
  }
}
