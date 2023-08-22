import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:dio/dio.dart';

class RequestsStoresRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getRequestsStores(int? codeProvider, int? userCode) async {
    Response? response;
    try {
      if (codeProvider == 0 && userCode == 0) {
        response = await clientDio.get("${url}allrequestclients");
      } else if (codeProvider == 0 && userCode != 0) {
        response = await clientDio.get("${url}stores/$userCode");
        print("Passando pelo request ");
        print(response);
        print("Passando pelo request ");
      } else {
        response = await clientDio.get("${url}requestsprovider/$codeProvider");
      }
      List list = response.data as List;
      return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
