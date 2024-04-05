import 'package:flutter/material.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:dio/dio.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';

class DetailsProviderRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getNegotiations(int codeBranch, int codeProvider) async {
    print("codebranch ${codeBranch}");
    try {
      final response = await clientDio.get("${url}negotiationclient/$codeBranch/$codeProvider");
      List list = response.data as List;

      return list.map((json) => NegotiationModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Negotiation (Details Provider Repository) Error: $e");
      return e;
    }
  }

  getMerchandises(int codeClient, int codeProvider, int codeNegotiation) async {
    try {
      final response = await clientDio.get("${url}merchandiseperclient/$codeClient/$codeProvider/$codeNegotiation");
      List list = response.data as List;
      return list.map((json) => ProductsProviderModel.fromJson(json)).toList();
    } catch (e) {
      print("Error Find Negotiations: $e");
      return e;
    }
  }

  getRequestsStores(int? codeProvider, int? userCode) async {
    Response? response;
    try {
      response = await clientDio.get('${url}requestsnegotiationbyclient/$codeProvider');
      List list = response.data as List;
      print(list);
      return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Request Stores (Details Balance Repository) Error: $e");
    }
  }
}
