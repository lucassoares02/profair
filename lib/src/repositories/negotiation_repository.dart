import 'package:profair/src/models/nogotiation_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class NegotiationRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  getNegotiations(int? codeBranch, int? codeProvider) async {
    try {
      final response = await clientDio.get("${url}negotiationclient/$codeBranch/$codeProvider");

      List list = response.data as List;
      return list.map((json) => NegotiationModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }
}
