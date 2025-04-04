import 'package:flutter/material.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/repositories/order_details_model.dart';
import 'package:profair/src/shared/http_service.dart';

class OrderDetailsRepository {
  final clientDio = HttpService();

  getOrderDetails(int? codeClient, int? codeProvider, int? codeNegotiation) async {
    ResponseModel response;
    try {
      response = await clientDio.get("merchandiseclientprovidernegotiation/$codeClient/$codeProvider/$codeNegotiation");
      List list = response.data as List;

      return list.map((json) => OrderDetailsModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Order Details (Order Details Repository) Error: $e");
    }
  }
}
