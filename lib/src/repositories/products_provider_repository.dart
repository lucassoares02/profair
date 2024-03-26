import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:dio/dio.dart';

class ProductsProviderRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getProductsProvider(int? codeProvider, int? codeClient) async {
    Response response;
    try {
      if (codeClient != 0) {
        // response = await clientDio.get("${url}merchandisepercustomer/$codeClient/$codeProvider");
        response = await clientDio.get("${url}merchandiseperclient/$codeClient/$codeProvider");
      } else {
        response = await clientDio.get("${url}merchandiseprovider/$codeProvider");
      }
      List list = response.data as List;
      print(list);
      return list.map((json) => ProductsProviderModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
