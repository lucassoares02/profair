import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:profair/src/models/login_model.dart';
import 'package:profair/src/models/nogotiation_model.dart';
import 'package:profair/src/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:share_plus/share_plus.dart';

import '../models/clients_select_stores_model.dart';

class FinishTradingRepository {
  final Dio clientDio = Dio();
  final String url = "https://profair.click/";

  postTrading(
      {required List<ProductModel> products,
      required List<NegotiationModel> tradings,
      int? codeBranch,
      int? codeProvider,
      int? codeClient,
      required List<ClientsSelectStoreModel> listBranchs}) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      for (int h = 0; h < listBranchs.length; h++) {
        if (listBranchs[h].checked!) {
          for (int i = 0; i < tradings.length; i++) {
            if (tradings[i].checked!) {
              for (int j = 0; j < products.length; j++) {
                if (int.parse(products[j].amount!) > 0) {
                  Map<String?, String?> data = {
                    "codMercadoria": products[j].codeProduct.toString(),
                    "quantMercadoria": products[j].amount,
                    "codFornecedor": codeProvider.toString(),
                    "codAssociado": listBranchs[h].relationshipCode.toString(),
                    "codComprador": codeClient.toString(),
                    "codNegociacao": tradings[i].negotiation.toString(),
                    "codOrganizacao": "158"
                  };
                  await clientDio.post("${url}insertrequestnew", data: data);
                }
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  postTradingNew({
    required List<dynamic> products,
    required List<NegotiationModel> tradings,
    int? codeBranch,
    int? codeProvider,
    int? codeClient,
    required List<ClientsSelectStoreModel> listBranchs,
    int? codeConsult,
  }) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;

    try {
      for (int h = 0; h < listBranchs.length; h++) {
        if (listBranchs[h].checked!) {
          for (int i = 0; i < tradings.length; i++) {
            if (tradings[i].checked!) {
              Map<String?, dynamic> data = {
                "codAssociado": listBranchs[h].relationshipCode.toString(),
                "codFornecedor": codeProvider.toString(),
                "codComprador": codeClient.toString(),
                "codNegociacao": tradings[i].negotiation.toString(),
                "codeConsult": codeConsult,
                "codOrganizacao": "158",
                "items": products
              };
              final response = await clientDio.post("${url}insertrequestnew", data: data);
            }
          }
        }
      }
      return;
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

  Future<LoginModel> getClient(String id) async {
    clientDio.options.contentType = Headers.formUrlEncodedContentType;
    final response = await clientDio.get("${url}client/$id");
    final item = response.data[0];
    return LoginModel.fromJson(item);
  }
}
