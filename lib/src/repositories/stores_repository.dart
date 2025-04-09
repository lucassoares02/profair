import 'package:profair/src/models/clients_select_stores_model.dart';
import 'package:profair/src/shared/http_service.dart';

class StoresRepository {
  final httpService = HttpService();

  getStores(String? userCode, int consultant, int supplier) async {
    // final response = await httpService.get("stores/$userCode");
    final response = await httpService.get("stores/$userCode/$consultant/$supplier");

    try {
      List list = response.data as List;
      return list.map((json) => ClientsSelectStoreModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
