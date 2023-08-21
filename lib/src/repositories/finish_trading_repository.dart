import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class FinishTradingRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  postTrading({required List<ProductModel> products, required List<NegotiationModel> tradings, int? codeBranch, int? codeProvider, int? codeClient}) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      for (int i = 0; i < tradings.length; i++) {
        if (tradings[i].checked!) {
          for (int j = 0; j < products.length; j++) {
            if (int.parse(products[j].amount!) > 0) {
              Map<String?, String?> data = {
                "codMercadoria": products[j].codeProduct.toString(),
                "quantMercadoria": products[j].amount,
                "codFornecedor": codeProvider.toString(),
                "codAssociado": codeBranch.toString(),
                "codComprador": codeClient.toString(),
                "codNegociacao": tradings[i].negotiation.toString(),
                "codOrganizacao": "158"
              };
              await clientDio.post("${url}insertrequest", data: data);
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }
}
