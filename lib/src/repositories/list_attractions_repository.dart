import 'package:profair/src/repositories/list_attractions_model.dart';
import 'package:profair/src/shared/http_service.dart';

class ListAttractionsRepository {
  final clientDio = HttpService();

  getRequestsStores() async {
    final response = await clientDio.get("schedule");

    try {
      List list = response.data as List;
      return list.map((json) => ListAttractionsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
