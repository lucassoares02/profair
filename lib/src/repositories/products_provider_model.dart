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
    this.totalValue,
    this.totalVolume,
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
      brand = json['marca'];
      coefficient = json['fatorMerc'];
      productPrice =
          json['precoMercadoria'] != null ? double.parse(json["precoMercadoria"].toString()) : json["precoMercadoria"];
      unitPrice = json['precoUnit'] != null ? double.parse(json['precoUnit'].toString()) : json['precoUnit'];
      totalValue = json['precoMercadoria'] * double.parse(json["volumeTotal"].toString());
      totalVolume = json['volumeTotal'].toString();
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
    data['precoMercadoria'] = productPrice;
    data['volumeTotal'] = totalVolume;
    data['complemento'] = complement;
    data['brand'] = brand;
    data['valorTotal'] = totalValue;
    data['precoUnit'] = unitPrice;
    data['codForn'] = codeProvider;
    data['nomeForn'] = nameProvider;
    return data;
  }
}
