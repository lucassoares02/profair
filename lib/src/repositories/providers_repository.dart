import 'dart:developer';

import 'package:profair/src/models/providers_model.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/shared/http_service.dart';

class ProvidersRepository {
  final clientDio = HttpService();

  getProviders(int? codeClient, int? codeBuyer, int? codeBranch) async {
    ResponseModel? response;
    try {
      if (codeBuyer != 0) {
        response = await clientDio.get("providerscategories/$codeBuyer");
      } else if (codeClient == 0 && codeBranch == 0) {
        response = await clientDio.get("suppliersinvoicing");
      } else if (codeClient != 0) {
        response = await clientDio.get("providersconsult/$codeClient");
      } else {
        response = await clientDio.get("requestproviderclient/$codeBranch");
      }
      List list = response.data as List;
      return list.map((json) => ProvidersModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  getProvidersByGroup(int? codeClient) async {
    ResponseModel? response;
    try {
      response = await clientDio.get("providersconsult/$codeClient");
      List list = response.data as List;
      return list.map((json) => ProvidersModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  Future<String> getMap() async {
    ResponseModel? response;
    try {
      response = await clientDio.get("find-map");
      return response.data[0]["mapa"].toString();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
      rethrow;
    }
  }

  /// Retorna a URL do mapa e o código da organização.
  Future<Map<String, dynamic>> getMapData() async {
    ResponseModel? response;
    try {
      response = await clientDio.get("find-map");
      final row = response.data[0];
      return {
        "map": row["mapa"]?.toString(),
        "codOrg": row["codOrg"] is num ? (row["codOrg"] as num).toInt() : int.tryParse("${row["codOrg"]}"),
      };
    } catch (e) {
      print("Error getMapData: $e");
      rethrow;
    }
  }
}
