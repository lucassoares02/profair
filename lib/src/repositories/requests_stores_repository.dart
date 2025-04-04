import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:profair/src/shared/http_service.dart';

class RequestsStoresRepository {
  final clientDio = HttpService();

  getRequestsStores(int? codeProvider, int? userCode, int? codeNegotiation) async {
    ResponseModel? response;
    try {
      if (codeNegotiation != null) {
        response = await clientDio.get("requestsprovidernegotiation/$codeNegotiation");
      } else if (codeProvider == 0 && userCode == 0) {
        response = await clientDio.get("allrequestclients");
      } else if (codeProvider == 0 && userCode != 0) {
        response = await clientDio.get("stores/$userCode");
      } else {
        response = await clientDio.get("requestsprovider/$codeProvider");
      }
      List list = response.data as List;
      return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
