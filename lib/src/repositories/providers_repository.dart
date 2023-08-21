import 'package:dio/dio.dart';
import 'package:profair/src/models/providers_model.dart';

class ProvidersRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getProviders(int? code, int? codeBuyer) async {
    Response? response;
    try {
      if (codeBuyer != 0) {
        response = await clientDio.get("${url}providerscategories/$codeBuyer");
      } else if (code == 0) {
        response = await clientDio.get("${url}suppliersinvoicing");
      } else {
        response = await clientDio.get("${url}requestproviderclient/$code");
      }
      List list = response.data as List;
      return list.map((json) => ProvidersModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
