import 'package:profair/src/models/tradings_model.dart';
import 'package:dio/dio.dart';

class TradingsRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  getTradings(String? codeProvider) async {
    final response = await clientDio.get("${url}negotiationprovider/$codeProvider");
    try {
      List list = response.data as List;

      return list.map((json) => TradingsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
