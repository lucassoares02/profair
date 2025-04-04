import 'package:profair/src/models/clients_model.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/shared/http_service.dart';

class ClientsRepository {
  final clientDio = HttpService();

  getClients(String? codeProvider, int accessTargenting, int merchandise, int? trading) async {
    ResponseModel? response;
    try {
      if (merchandise != 0 && trading != 0) {
        response = await clientDio.get("clientmerchandisetrading/$merchandise/$trading");
      } else if (accessTargenting == 3) {
        response = await clientDio.get("stores");
      } else {
        response = await clientDio.get("storesbyprovider/$codeProvider");
      }
      List list = response.data as List;

      return list.map((json) => ClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
