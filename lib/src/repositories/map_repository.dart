import 'package:flutter/material.dart';
import 'package:profair/src/models/stand_model.dart';
import 'package:profair/src/shared/http_service.dart';

class MapRepository {
  final HttpService _http = HttpService();

  /// Busca os stands do mapa de uma organização.
  Future<List<StandModel>> getStands(int codOrg) async {
    try {
      final response = await _http.get("stands/$codOrg");
      final List list = response.data as List;
      return list.map((json) => StandModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error getStands (MapRepository): $e");
      rethrow;
    }
  }
}
