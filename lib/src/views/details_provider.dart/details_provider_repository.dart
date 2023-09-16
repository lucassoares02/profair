import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/repositories/products_provider_model.dart';
import 'package:dio/dio.dart';

class DetailsProviderRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getNegotiations(int codeBranch, int codeProvider) async {
    try {
      final response = await clientDio.get("${url}negotiationclient/$codeBranch/$codeProvider");
      List list = response.data as List;
      return list.map((json) => NegotiationModel.fromJson(json)).toList();
    } catch (e) {
      print("Error Find Negotiations: $e");
      return e;
    }
  }

  getMerchandises(int codeClient, int codeProvider) async {
    try {
      final response = await clientDio.get("${url}merchandiseperclient/$codeClient/$codeProvider");
      List list = response.data as List;
      return list.map((json) => ProductsProviderModel.fromJson(json)).toList();
    } catch (e) {
      print("Error Find Negotiations: $e");
      return e;
    }
  }
}
