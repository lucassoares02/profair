import 'package:dio/dio.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';

class StoresRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  getStores(String? userCode) async {
    print(userCode);
    final response = await clientDio.get("${url}stores/$userCode");

    try {
      List list = response.data as List;
      print(list);
      return list.map((json) => ClientsSelectStoreModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
