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
}
