import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:share_plus/share_plus.dart';
import 'package:profair/src/shared/http_service.dart';
import 'package:profair/src/shared/http_service_history.dart';

class TradingProductsRepository {
  final Dio clientDioRequest = Dio();
  final String url = "https://profair.click/";
  final clientDio = HttpService();
  final clientDioHistory = HttpServiceHistory();

  getTradingProducts(int? codeBranch, int? codeProvider, int? codeTrading, int? codeClient) async {
    ResponseModel? response;
    try {
      if (codeClient == 0 && codeBranch == 0) {
        print("etapa 1");
        response = await clientDio.get("merchandisenegotiationprovider/$codeProvider/$codeTrading");
      } else if (codeClient == 0) {
        print("etapa 2");
        print("codeBranch: $codeBranch, codeProvider: $codeProvider, codeTrading: $codeTrading");
        response = await clientDio.get("merchandiseclientprovidernegotiation/$codeBranch/$codeProvider/$codeTrading");
      } else {
        print("etapa 3");
        response = await clientDio.get("merchandiseproviderifclient/$codeBranch/$codeProvider/$codeTrading");
      }
      List list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  findTradingProductsHistory(int? codeBranch, int? codeProvider, int? codeTrading) async {
    ResponseModel? response;
    try {
      response = await clientDioHistory.get("history/details/negotiation/$codeProvider/$codeBranch/$codeTrading");
      List list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  exportDataProvider({int? codeProvider, int? codeBuyer, int? codeNegotiation, int? codeBranch, BuildContext? context}) async {
    Response? response;

    final box = context?.findRenderObject() as RenderBox?;
    try {
      // Fazendo a solicitação com a opção de resposta para obter os bytes
      response = await clientDioRequest.get(
        '${url}exportpdf/$codeProvider/$codeNegotiation/$codeBranch',
        options: Options(responseType: ResponseType.bytes),
      );

      // Verificando se a solicitação foi bem-sucedida
      if (response.statusCode == 200) {
        // Obtendo o diretório temporário do dispositivo
        Directory tempDir = await getTemporaryDirectory();

        // Criando um arquivo temporário com a extensão .pdf
        File tempFile = File('${tempDir.path}/${DateTime.now().toString().replaceAll(RegExp("[.: -]"), "_")}.pdf');

        // Gravando os bytes diretamente no arquivo
        await tempFile.writeAsBytes(List<int>.from(response.data));

        // Compartilhando o arquivo PDF
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: 'Compartilhando Negociações Profair',
          subject: 'Arquivo de pedidos Profair',
          sharePositionOrigin: box != null ? box.localToGlobal(Offset.zero) & box.size : const Rect.fromLTWH(0, 0, 100, 100), // fallback
        );

        return response;
      } else {
        print('Erro ao fazer a solicitação: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Erro: $e');
      return null;
    }
  }
}
