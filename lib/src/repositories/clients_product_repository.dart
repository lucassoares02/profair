import 'package:profair/src/models/clients_product_model.dart';
import 'package:profair/src/shared/http_service.dart';

class ClientsProductRepository {
  final clientDio = HttpService();

  getClientProduct(int codeProduct) async {
    try {
      final response = await clientDio.get("clientmerchandise/$codeProduct");
      List list = response.data as List;
      return list.map((json) => ClientsProductModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
