import 'dart:convert';

import 'package:profair/src/models/tradings_model.dart';
import 'package:profair/src/shared/http_service.dart';

class TradingsRepository {
  final httpService = HttpService();

  getTradings(String? codeProvider) async {
    final response = await httpService.get("negotiationprovider/$codeProvider");
    try {
      List list = response.data as List;

      return list.map((json) => TradingsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  Future<bool> updateOrder(List<Map<String, dynamic>> orders) async {
    try {
      final response = await httpService.post("negotiationsorder", {"orders": jsonEncode(orders)});
      return response.success;
    } catch (e) {
      print("Error updating negotiations order: $e");
      return false;
    }
  }
}
