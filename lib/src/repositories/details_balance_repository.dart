import 'package:flutter/material.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/shared/http_service.dart';

class DetailsBalanceRepository {
  final clientDio = HttpService();

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
}
