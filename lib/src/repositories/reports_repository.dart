import 'package:profair/src/models/product_model.dart';
import 'package:profair/src/models/response_model.dart';
import 'package:profair/src/models/total_value_clients.dart';
import 'package:profair/src/models/value_minute_graph.dart';
import 'package:profair/src/repositories/percentage_clients_model.dart';
import 'package:profair/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:profair/src/shared/http_service.dart';

class ReportsRepository {
  final clientDio = HttpService();

  getPercentageClients(int? codeProvider, int? accessTargenting) async {
    ResponseModel? response;
    if (accessTargenting == 3) {
      response = await clientDio.get("percentageclientsorganization");
    } else if (accessTargenting == 1) {
      response = await clientDio.get("percentageclients/$codeProvider");
    } else {
      response = await clientDio.get("percentageproviderbyclients/$codeProvider");
    }
    try {
      List list = response.data as List;
      return list.map((json) => PercentageClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  getPercentageProviders() async {
    ResponseModel? response;
    try {
      response = await clientDio.get("percentageprovidersorganization");
      List list = response.data as List;
      return list.map((json) => PercentageClientsModel.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  getTotalValueClients(int? codeProvider, int? accessTargeting) async {
    ResponseModel? response;
    if (accessTargeting == 3) {
      response = await clientDio.get("stores");
    } else if (accessTargeting == 1) {
      response = await clientDio.get("storesbyprovider/$codeProvider");
    } else {
      response = await clientDio.get("providersconsult/$codeProvider");
    }
    try {
      List list = response.data as List;

      return list.map((json) => TotalValueClients.fromJson(json)).toList();
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  getTotalValueProducts(int? codeProvider, int? accessTargeting) async {
    ResponseModel? response;
    try {
      if (accessTargeting == 3) {
        response = await clientDio.get("suppliersinvoicing");
        List list = response.data as List;
        return list.map((json) => TotalValueClients.fromJson(json)).toList();
      } else {
        response = await clientDio.get("merchandiseprovider/$codeProvider");
        List list = response.data as List;
        return list.map((json) => ProductModel.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error return Stores Model Mapper: $e");
    }
  }

  getTotalSellProvider(int? codeProvider) async {
    ResponseModel? response;
    try {
      response = await clientDio.get("valueminutegraphprovider/$codeProvider");
      List list = response.data as List;
      return list.map((json) => ValueMinutesGraph.fromJson(json)).toList();
    } catch (e) {
      print("Get Total Sell Provider (Reports Repository) Error: $e");
    }
  }

  LinearGradient get _barsGradient => const LinearGradient(
        colors: [
          colorPrimary,
          colorSecondary,
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );
}
