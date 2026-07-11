import 'dart:convert';
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

  getTradingProducts(int? codeBranch, int? codeProvider, int? codeTrading,
      int? codeClient) async {
    ResponseModel? response;
    try {
      if (codeClient == 0 && codeBranch == 0) {
        print("etapa 1");
        response = await clientDio
            .get("merchandisenegotiationprovider/$codeProvider/$codeTrading");
      } else if (codeClient == 0) {
        print("etapa 2");
        print(
            "codeBranch: $codeBranch, codeProvider: $codeProvider, codeTrading: $codeTrading");
        response = await clientDio.get(
            "merchandiseclientprovidernegotiation/$codeBranch/$codeProvider/$codeTrading");
      } else {
        print("etapa 3");
        response = await clientDio.get(
            "merchandiseproviderifclient/$codeBranch/$codeProvider/$codeTrading");
      }
      List list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  Future<bool> updateHighlight(List<int> codes, bool highlight) async {
    try {
      final response = await clientDio.post("merchandisehighlight", {
        "codes": jsonEncode(codes),
        "highlight": highlight ? 1 : 0,
      });
      return response.success;
    } catch (e) {
      debugPrint("Error updating merchandise highlight: $e");
      return false;
    }
  }

  Future<bool> updateTag(List<int> codes, String? tag) async {
    try {
      final response = await clientDio.post("merchandisetag", {
        "codes": jsonEncode(codes),
        "tag": tag ?? "",
      });
      return response.success;
    } catch (e) {
      debugPrint("Error updating merchandise tag: $e");
      return false;
    }
  }

  findTradingProductsHistory(
      int? codeBranch, int? codeProvider, int? codeTrading) async {
    ResponseModel? response;
    try {
      response = await clientDioHistory.get(
          "history/details/negotiation/$codeProvider/$codeBranch/$codeTrading");
      List list = response.data as List;
      return list.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      debugPrint("Error return Negotiation Model Mapper: $e");
    }
  }

  Rect? _sharePositionOrigin(BuildContext? context) {
    if (!Platform.isIOS || context == null) return null;

    final renderObject = context.findRenderObject();
    final screenSize = MediaQuery.maybeOf(context)?.size;
    var center = screenSize?.center(Offset.zero) ?? const Offset(1, 1);

    if (renderObject is RenderBox && renderObject.hasSize) {
      center =
          renderObject.localToGlobal(renderObject.size.center(Offset.zero));
    }

    if (screenSize != null) {
      center = Offset(
        _clampShareCoordinate(center.dx, screenSize.width),
        _clampShareCoordinate(center.dy, screenSize.height),
      );
    }

    return Rect.fromCenter(center: center, width: 1, height: 1);
  }

  double _clampShareCoordinate(double value, double max) {
    if (max <= 1) return max / 2;
    return value.clamp(0.5, max - 0.5).toDouble();
  }

  exportDataProvider(
      {int? codeProvider,
      int? codeBuyer,
      int? codeNegotiation,
      int? codeBranch,
      BuildContext? context}) async {
    Response? response;
    final shareOrigin = _sharePositionOrigin(context);

    try {
      response = await clientDioRequest.get(
        '${url}exportpdf/$codeProvider/$codeNegotiation/$codeBranch',
        options: Options(responseType: ResponseType.bytes),
      );

      if (response.statusCode == 200) {
        Directory tempDir = await getTemporaryDirectory();
        final fileName =
            'negociacao_profair_${DateTime.now().millisecondsSinceEpoch}.pdf';
        File tempFile = File('${tempDir.path}/$fileName');
        await tempFile.writeAsBytes(List<int>.from(response.data));

        final xFile =
            XFile(tempFile.path, mimeType: 'application/pdf', name: fileName);

        await Share.shareXFiles(
          [xFile],
          subject: 'Negociações Profair',
          sharePositionOrigin: shareOrigin,
        );

        return response;
      } else {
        debugPrint('Erro ao exportar PDF: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      debugPrint('Erro exportDataProvider: $e');
      return null;
    }
  }
}
