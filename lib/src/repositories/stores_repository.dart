import 'package:dio/dio.dart';
import 'package:profair/src/models/clients_select_stores_model.dart';

class StoresRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getStores(String? userCode) async {
    final response = await clientDio.get("${url}stores/$userCode");

    try {
      List list = response.data as List;
      return list.map((json) => ClientsSelectStoreModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
