import 'package:profair/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class TradingProductsRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getTradingProducts(int? codeBranch, int? codeProvider, int? codeTrading, int? codeClient) async {
    Response? response;
    try {
      if (codeClient == 0 && codeBranch == 0) {
        response = await clientDio.get("${url}merchandisenegotiationprovider/$codeProvider/$codeTrading");
      } else if (codeClient == 0) {
        response =
            await clientDio.get("${url}merchandiseclientprovidernegotiation/$codeBranch/$codeProvider/$codeTrading");
      } else {
        response = await clientDio.get("${url}merchandiseproviderifclient/$codeBranch/$codeProvider/$codeTrading");
      }
      List list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }
}
