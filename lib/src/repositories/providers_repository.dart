import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:profair/src/models/providers_model.dart';

class ProvidersRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getProviders(int? codeClient, int? codeBuyer, int? codeBranch) async {
    Response? response;
    try {
      if (codeBuyer != 0) {
        print("step 1");
        response = await clientDio.get("${url}providerscategories/$codeBuyer");
      } else if (codeClient == 0 && codeBranch == 0) {
        print("step 2");
        response = await clientDio.get("${url}suppliersinvoicing");
      } else if (codeClient != 0) {
        print("step 3");
        response = await clientDio.get("${url}providersconsult/$codeClient");
      } else {
        print("step 4");
        response = await clientDio.get("${url}requestproviderclient/$codeBranch");
        inspect(response);
      }
      List list = response.data as List;
      return list.map((json) => ProvidersModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  getProvidersByGroup(int? codeClient) async {
    Response? response;
    try {
      response = await clientDio.get("${url}providersconsult/$codeClient");
      List list = response.data as List;
      return list.map((json) => ProvidersModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
