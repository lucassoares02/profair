import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:profair/src/repositories/requests_stores_model.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

class RequestsStoresRepository {
  final Dio clientDio = Dio();
  final String url = "https://seller-backend.onrender.com/";

  getRequestsStores(int? codeProvider, int? userCode, int? codeNegotiation) async {
    Response? response;
    try {
      if (codeNegotiation != null) {
        response = await clientDio.get("${url}requestsprovidernegotiation/$codeNegotiation");
      } else if (codeProvider == 0 && userCode == 0) {
        response = await clientDio.get("${url}allrequestclients");
      } else if (codeProvider == 0 && userCode != 0) {
        response = await clientDio.get("${url}stores/$userCode");
      } else {
        response = await clientDio.get("${url}requestsprovider/$codeProvider");
      }
      List list = response.data as List;
      print(list);
      return list.map((json) => RequestsStoresModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  exportDataProvider({int? codeProvider, int? codeBuyer, int? codeNegotiation}) async {
    Response? response;
    response = await clientDio.get('${url}exportnegotiationsprovider/$codeProvider/$codeBuyer/$codeNegotiation');

    Directory tempDir = await getTemporaryDirectory();

    File tempFile = File('${tempDir.path}/${(DateTime.now().toString().replaceAll(RegExp("[.: -]"), "_"))}.csv');

    await tempFile.writeAsString(response.data);

    await Share.shareXFiles([XFile(tempFile.path)],
        text: 'Compartilhando Negociações Profair', subject: 'Arquivo de pedidos Profair');

    return response;
  }
}
