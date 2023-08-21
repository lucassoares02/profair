import 'package:profair/src/models/clients_model.dart';
import 'package:dio/dio.dart';

class StoresRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getStores(String? userCode) async {
    final response = await clientDio.get("${url}stores/$userCode");

    try {
      List list = response.data as List;
      return list.map((json) => ClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
