import 'package:flutter/material.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/shared/http_service.dart';

class TradingsProviderRepository {
  final clientDio = HttpService();

  getTradingProvider(int codeBranch, int codeProvider) async {
    try {
      final response = await clientDio.get("negotiationproviderclient/$codeBranch/$codeProvider");
      List list = response.data as List;
      return list.map((json) => NegotiationModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  postTradingNew({
    required List<dynamic> products,
    required int tradings,
    int? codeBranch,
    int? codeProvider,
    int? codeClient,
    required List<ClientsSelectStoreModel> listBranchs,
    int? codeConsult,
  }) async {
    try {
      for (int h = 0; h < listBranchs.length; h++) {
        if (listBranchs[h].checked!) {
          Object data = {
            "codAssociado": listBranchs[h].relationshipCode.toString(),
            "codFornecedor": codeProvider.toString(),
            "codComprador": codeClient.toString(),
            "codNegociacao": tradings.toString(),
            "codeConsult": codeConsult,
            "codOrganizacao": "158",
            "items": products
          };
          await clientDio.post("insertrequestnew", data);
        }
      }
      return;
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper ====: $e");
      rethrow;
    }
  }
}
