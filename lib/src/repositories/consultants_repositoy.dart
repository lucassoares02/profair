import 'package:flutter/material.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/repositories/consultants_model.dart';
import 'package:profair/src/shared/http_service.dart';

class ConsultantsRepository {
  final clientDio = HttpService();

  findAllByProvider(String provider) async {
    ResponseModel? response;
    try {
      response = await clientDio.get('getwindownegotiationsbyprovider/$provider');
      List list = response.data as List;
      return list.map((json) => ConsultantsModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Get Request Stores (Details Balance Repository) Error: $e");
    }
  }
}
