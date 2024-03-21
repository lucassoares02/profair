import 'package:flutter/material.dart';
import 'package:profair/src/repositories/order_details_model.dart';
import 'package:dio/dio.dart';

class OrderDetailsRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getOrderDetails(int? codeClient, int? codeProvider, int? codeNegotiation) async {
    Response response;
    try {
      response =
          await clientDio.get("${url}merchandiseclientprovidernegotiation/$codeClient/$codeProvider/$codeNegotiation");
      List list = response.data as List;

      return list.map((json) => OrderDetailsModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Order Details (Order Details Repository) Error: $e");
    }
  }
}
