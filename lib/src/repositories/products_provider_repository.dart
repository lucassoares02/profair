import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:dio/dio.dart';

class ProductsProviderRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getProductsProvider(String? codeProvider) async {
    final response = await clientDio.get("${url}merchandiseprovider/$codeProvider");
    try {
      List list = response.data as List;

      return list.map((json) => ProductsProviderModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
