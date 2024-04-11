import 'package:profair/src/repositories/list_attractions_model.dart';
import 'package:dio/dio.dart';

class ListAttractionsRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  getRequestsStores() async {
    final response = await clientDio.get("${url}schedule");

    try {
      List list = response.data as List;
      return list.map((json) => ListAttractionsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
