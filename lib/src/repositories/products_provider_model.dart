import 'package:flutter/material.dart';

class ProductsProviderModel {
  int? codeProvider;
  String? nameProvider;
  int? codeProduct;
  String? nameProduct;
  String? packing;
  String? complement;
  String? brand;
  int? coefficient;
  double? productPrice;
  double? unitPrice;
  double? totalValue;
  String? totalVolume;
  String? barcode;
  bool? highlight;
  String? tag;

  ProductsProviderModel({
    this.codeProvider,
    this.nameProvider,
    this.codeProduct,
    this.nameProduct,
    this.packing,
    this.coefficient,
    this.productPrice,
    this.unitPrice,
    this.brand,
    this.complement,
    this.barcode,
    this.totalValue,
    this.totalVolume,
    this.highlight,
    this.tag,
  });

  ProductsProviderModel.fromJson(Map<String, dynamic> json) {
    print(json);
    try {
      codeProvider = json['codForn'];
      nameProvider = json['nomeForn'];
      codeProduct = json['codMercadoria'];
      nameProduct = json['nomeMercadoria'];
      packing = json['embMercadoria'];
      complement = json['complemento'];
      barcode = json['barcode'];
      brand = json['marca'];
      coefficient = json['fatorMerc'];
      productPrice = json['precoMercadoria'] != null ? double.parse(json["precoMercadoria"].toString()) : json["precoMercadoria"];
      unitPrice = json['precoUnit'] != null ? double.parse(json['precoUnit'].toString()) : json['precoUnit'];
      totalValue = json['precoMercadoria'] * double.parse(json["volumeTotal"].toString());
      totalVolume = json['volumeTotal'].toString();
      highlight = json['highlight'] == null ? false : (json['highlight'] == 1 || json['highlight'] == true);
      tag = json['tag'];
    } catch (e) {
      debugPrint("Error (Products Provider Model) Error: $e");
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['codMercadoria'] = codeProduct;
    data['nomeMercadoria'] = nameProduct;
    data['embMercadoria'] = packing;
    data['fatorMerc'] = coefficient;
    data['barcode'] = barcode;
    data['precoMercadoria'] = productPrice;
    data['volumeTotal'] = totalVolume;
    data['complemento'] = complement;
    data['brand'] = brand;
    data['valorTotal'] = totalValue;
    data['precoUnit'] = unitPrice;
    data['codForn'] = codeProvider;
    data['nomeForn'] = nameProvider;
    data['highlight'] = highlight;
    data['tag'] = tag;
    return data;
  }
}
