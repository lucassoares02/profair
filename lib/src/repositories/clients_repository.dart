import 'package:profair/src/models/clients_model.dart';
import 'package:dio/dio.dart';

class ClientsRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getClients(String? codeProvider, int accessTargenting, int merchandise, int? trading) async {
    Response? response;
    try {
      if (merchandise != 0 && trading != 0) {
        response = await clientDio.get("${url}clientmerchandisetrading/$merchandise/$trading");
      } else if (accessTargenting == 3) {
        response = await clientDio.get("${url}stores");
      } else {
        response = await clientDio.get("${url}storesbyprovider/$codeProvider");
      }
      List list = response.data as List;

      return list.map((json) => ClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
