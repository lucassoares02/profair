import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';

class DetailsBalanceRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getRequestsStores(int? codeProvider, int? userCode) async {
    Response? response;
    try {
      response = await clientDio.get('${url}requestsnegotiationbyclient/$codeProvider');
      List list = response.data as List;
      return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Request Stores (Details Balance Repository) Error: $e");
    }
  }
}
