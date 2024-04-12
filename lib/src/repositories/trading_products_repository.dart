import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

class TradingProductsRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  getTradingProducts(int? codeBranch, int? codeProvider, int? codeTrading, int? codeClient) async {
    Response? response;
    try {
      if (codeClient == 0 && codeBranch == 0) {
        print("step 1");
        response = await clientDio.get("${url}merchandisenegotiationprovider/$codeProvider/$codeTrading");
      } else if (codeClient == 0) {
        print("step 2");
        response =
            await clientDio.get("${url}merchandiseclientprovidernegotiation/$codeBranch/$codeProvider/$codeTrading");
      } else {
        print("step 3");
        response = await clientDio.get("${url}merchandiseproviderifclient/$codeBranch/$codeProvider/$codeTrading");
      }
      List list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  exportDataProvider({int? codeProvider, int? codeBuyer, int? codeNegotiation, int? codeBranch}) async {
    Response? response;

    try {
      // Fazendo a solicitação com a opção de resposta para obter os bytes
      response = await clientDio.get(
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
        await tempFile.writeAsBytes(response.data);

        // Compartilhando o arquivo PDF
        await Share.shareXFiles(
          [XFile(tempFile.path)],
          text: 'Compartilhando Negociações Profair',
          subject: 'Arquivo de pedidos Profair',
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
