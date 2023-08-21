import 'package:profair/src/models/clients_product_model.dart';
import 'package:dio/dio.dart';

class ClientsProductRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getClientProduct(int codeProduct) async {
    try {
      final response = await clientDio.get("${url}clientmerchandise/$codeProduct");
      List list = response.data as List;
      return list.map((json) => ClientsProductModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
