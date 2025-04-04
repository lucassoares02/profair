import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/models/users_model.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/shared/http_service.dart';

class DetailsProviderRepository {
  final clientDio = HttpService();

  getNegotiations(int codeBranch, int codeProvider) async {
    try {
      final response = await clientDio.get("negotiationclient/$codeBranch/$codeProvider");
      List list = response.data as List;

      return list.map((json) => NegotiationModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Negotiation (Details Provider Repository) Error: $e");
      return e;
    }
  }

  getMerchandises(int codeClient, int codeProvider, int codeNegotiation) async {
    try {
      final response = await clientDio.get("merchandiseperclient/$codeClient/$codeProvider/$codeNegotiation");
      List list = response.data as List;
      return list.map((json) => ProductsProviderModel.fromJson(json)).toList();
    } catch (e) {
      print("Error Find Negotiations: $e");
      return e;
    }
  }

  getTopMerchandises(int codeProvider) async {
    try {
      final response = await clientDio.get("merchandisetoptenprovider/$codeProvider");
      // final response = await clientDio.get("merchandiseprovider/$codeProvider");
      List list = response.data as List;
      inspect(list);
      // return list.map((json) => ProductsProviderModel.fromJson(json)).toList();
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      print("Error Find Top Merchandises: $e");
      return e;
    }
  }

  getRequestsStores(int? codeProvider, int? userCode) async {
    ResponseModel? response;
    try {
      response = await clientDio.get('requestsnegotiationbyclient/$codeProvider');
      List list = response.data as List;
      return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Request Stores (Details Balance Repository) Error: $e");
    }
  }

  getNegotiationPerClient(int provider, int? client) async {
    ResponseModel? response;
    try {
      response = await clientDio.get('requestsnegotiationclientororg/$client/$provider');
      List list = response.data as List;
      return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Request Stores (Details Balance Repository) Error: $e");
    }
  }

  getConsults(int provider) async {
    ResponseModel? response;
    try {
      response = await clientDio.get('getconsultsprovider/$provider');
      List list = response.data as List;
      return list.map((json) => UsersModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Request Stores (Details Balance Repository) Error: $e");
    }
  }
}
