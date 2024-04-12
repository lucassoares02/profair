import 'dart:developer';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

class RequestsStoresRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  getRequestsStores(int? codeProvider, int? userCode, int? codeNegotiation) async {
    Response? response;
    try {
      if (codeNegotiation != null) {
        print("step 1");
        response = await clientDio.get("${url}requestsprovidernegotiation/$codeNegotiation");
      } else if (codeProvider == 0 && userCode == 0) {
        print("step 2");
        response = await clientDio.get("${url}allrequestclients");
      } else if (codeProvider == 0 && userCode != 0) {
        print("step 3");
        response = await clientDio.get("${url}stores/$userCode");
      } else {
        print("step 4");
        response = await clientDio.get("${url}requestsprovider/$codeProvider");
      }
      List list = response.data as List;
      print(list);
      return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }
}
