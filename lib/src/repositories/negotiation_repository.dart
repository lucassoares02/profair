import 'package:profair/src/models/nogotiation_model.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/shared/http_service.dart';

class NegotiationRepository {
  final clientDio = HttpService();

  getNegotiations(int? codeBranch, int? codeProvider) async {
    try {
      final response = await clientDio.get("negotiationclient/$codeBranch/$codeProvider");

      List list = response.data as List;
      return list.map((json) => NegotiationModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  findNegotiationsGroup(int? codeGroup, int? codeProvider) async {
    print("codeGroup: $codeGroup, codeProvider: $codeProvider");
    try {
      final response = await clientDio.get("negotiationgroup/$codeGroup/$codeProvider");

      List list = response.data as List;
      return list.map((json) => NegotiationModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }
}
