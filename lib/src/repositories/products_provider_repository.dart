import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:profair/src/shared/http_service.dart';

class ProductsProviderRepository {
  final clientDio = HttpService();

  getProductsProvider(int? codeProvider, int? codeClient) async {
    ResponseModel response;
    try {
      if (codeClient != 0) {
        // response = await clientDio.get("${url}merchandisepercustomer/$codeClient/$codeProvider");
        response = await clientDio.get("merchandiseperclient/$codeClient/$codeProvider");
      } else {
        response = await clientDio.get("merchandiseprovider/$codeProvider");
      }
      List list = response.data as List;
      print(list);
      return list.map((json) => ProductsProviderModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
