import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import '../models/clients_select_stores_model.dart';

class FinishTradingRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  postTrading(
      {required List<ProductModel> products,
      required List<NegotiationModel> tradings,
      int? codeBranch,
      int? codeProvider,
      int? codeClient,
      required List<ClientsSelectStoreModel> listBranchs}) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      for (int h = 0; h < listBranchs.length; h++) {
        if (listBranchs[h].checked!) {
          for (int i = 0; i < tradings.length; i++) {
            if (tradings[i].checked!) {
              for (int j = 0; j < products.length; j++) {
                if (int.parse(products[j].amount!) > 0) {
                  Map<String?, String?> data = {
                    "codMercadoria": products[j].codeProduct.toString(),
                    "quantMercadoria": products[j].amount,
                    "codFornecedor": codeProvider.toString(),
                    "codAssociado": listBranchs[h].relationshipCode.toString(),
                    "codComprador": codeClient.toString(),
                    "codNegociacao": tradings[i].negotiation.toString(),
                    "codOrganizacao": "158"
                  };
                  await clientDio.post("${url}insertrequestnew", data: data);
                }
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  postTradingNew({
    required List<dynamic> products,
    required List<NegotiationModel> tradings,
    int? codeBranch,
    int? codeProvider,
    int? codeClient,
    required List<ClientsSelectStoreModel> listBranchs,
    int? codeConsult,
  }) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      for (int h = 0; h < listBranchs.length; h++) {
        if (listBranchs[h].checked!) {
          for (int i = 0; i < tradings.length; i++) {
            if (tradings[i].checked!) {
              Map<String?, dynamic> data = {
                "codAssociado": listBranchs[h].relationshipCode.toString(),
                "codFornecedor": codeProvider.toString(),
                "codComprador": codeClient.toString(),
                "codNegociacao": tradings[i].negotiation.toString(),
                "codeConsult": codeConsult,
                "codOrganizacao": "158",
                "items": products
              };
              final response = await clientDio.post("${url}insertrequestnew", data: data);
            }
          }
        }
      }
      return;
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }
}
